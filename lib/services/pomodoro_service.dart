import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pomodoro_settings.dart';
import 'notification_service.dart';

class PomodoroService extends ChangeNotifier {
  static final PomodoroService _instance = PomodoroService._internal();
  factory PomodoroService() => _instance;
  PomodoroService._internal();

  PomodoroSettings _settings = const PomodoroSettings();
  PomodoroState _state = const PomodoroState(
    phase: PomodoroPhase.work,
    remainingSeconds: 25 * 60,
    completedWorkSessions: 0,
    isRunning: false,
  );

  Timer? _timer;
  final NotificationService _notificationService = NotificationService();

  PomodoroSettings get settings => _settings;
  PomodoroState get state => _state;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final workMinutes = prefs.getInt('pomodoro_work_minutes') ?? 25;
    final breakMinutes = prefs.getInt('pomodoro_break_minutes') ?? 5;
    final restMinutes = prefs.getInt('pomodoro_rest_minutes') ?? 15;

    _settings = PomodoroSettings(
      workMinutes: workMinutes,
      breakMinutes: breakMinutes,
      restMinutes: restMinutes,
    );

    _state = _state.copyWith(remainingSeconds: workMinutes * 60);
    notifyListeners();
  }

  Future<void> saveSettings(PomodoroSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pomodoro_work_minutes', settings.workMinutes);
    await prefs.setInt('pomodoro_break_minutes', settings.breakMinutes);
    await prefs.setInt('pomodoro_rest_minutes', settings.restMinutes);

    _settings = settings;

    // Reset timer with new settings if not running
    if (!_state.isRunning) {
      _state = _state.copyWith(remainingSeconds: _getCurrentPhaseDuration());
    }
    notifyListeners();
  }

  void startTimer() {
    if (_state.isRunning) return;

    _state = _state.copyWith(isRunning: true);
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.remainingSeconds > 0) {
        _state = _state.copyWith(remainingSeconds: _state.remainingSeconds - 1);
        notifyListeners();
      } else {
        _onPhaseComplete();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _state = _state.copyWith(isRunning: false);
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _state = PomodoroState(
      phase: PomodoroPhase.work,
      remainingSeconds: _settings.workMinutes * 60,
      completedWorkSessions: 0,
      isRunning: false,
    );
    notifyListeners();
  }

  void skipPhase() {
    _onPhaseComplete();
  }

  int _getCurrentPhaseDuration() {
    switch (_state.phase) {
      case PomodoroPhase.work:
        return _settings.workMinutes * 60;
      case PomodoroPhase.break_:
        return _settings.breakMinutes * 60;
      case PomodoroPhase.rest:
        return _settings.restMinutes * 60;
    }
  }

  void _onPhaseComplete() {
    _timer?.cancel();

    // Send notification
    _sendPhaseCompleteNotification();

    // Determine next phase
    PomodoroPhase nextPhase;
    int completedSessions = _state.completedWorkSessions;

    if (_state.phase == PomodoroPhase.work) {
      completedSessions++;
      // After 3 work sessions (breaks), do a long rest
      if (completedSessions % 3 == 0) {
        nextPhase = PomodoroPhase.rest;
      } else {
        nextPhase = PomodoroPhase.break_;
      }
    } else {
      // After break or rest, go back to work
      nextPhase = PomodoroPhase.work;
    }

    _state = PomodoroState(
      phase: nextPhase,
      remainingSeconds: _getDurationForPhase(nextPhase),
      completedWorkSessions: completedSessions,
      isRunning: false,
    );
    notifyListeners();
  }

  int _getDurationForPhase(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return _settings.workMinutes * 60;
      case PomodoroPhase.break_:
        return _settings.breakMinutes * 60;
      case PomodoroPhase.rest:
        return _settings.restMinutes * 60;
    }
  }

  Future<void> _sendPhaseCompleteNotification() async {
    String title;
    String body;

    switch (_state.phase) {
      case PomodoroPhase.work:
        title = '🎯 Hoàn thành Work Session!';
        body = _state.completedWorkSessions % 3 == 2
            ? 'Tuyệt vời! Đã đến lúc nghỉ dài 🌟'
            : 'Tốt lắm! Nghỉ ngơi một chút nhé ☕';
        break;
      case PomodoroPhase.break_:
        title = '☕ Hết giờ nghỉ!';
        body = 'Sẵn sàng cho session tiếp theo chưa? 💪';
        break;
      case PomodoroPhase.rest:
        title = '🌟 Hết giờ nghỉ dài!';
        body = 'Bắt đầu chu kỳ mới thôi! 🚀';
        break;
    }

    try {
      await _notificationService.showImmediateNotification(
        id: 999,
        title: title,
        body: body,
      );
    } catch (e) {
      print('Lỗi gửi thông báo Pomodoro: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
