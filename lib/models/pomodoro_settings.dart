class PomodoroSettings {
  final int workMinutes;
  final int breakMinutes;
  final int restMinutes;

  const PomodoroSettings({
    this.workMinutes = 25,
    this.breakMinutes = 5,
    this.restMinutes = 15,
  });

  Map<String, dynamic> toMap() {
    return {
      'workMinutes': workMinutes,
      'breakMinutes': breakMinutes,
      'restMinutes': restMinutes,
    };
  }

  factory PomodoroSettings.fromMap(Map<String, dynamic> map) {
    return PomodoroSettings(
      workMinutes: map['workMinutes'] ?? 25,
      breakMinutes: map['breakMinutes'] ?? 5,
      restMinutes: map['restMinutes'] ?? 15,
    );
  }

  PomodoroSettings copyWith({
    int? workMinutes,
    int? breakMinutes,
    int? restMinutes,
  }) {
    return PomodoroSettings(
      workMinutes: workMinutes ?? this.workMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      restMinutes: restMinutes ?? this.restMinutes,
    );
  }
}

enum PomodoroPhase { work, break_, rest }

class PomodoroState {
  final PomodoroPhase phase;
  final int remainingSeconds;
  final int completedWorkSessions;
  final bool isRunning;

  const PomodoroState({
    required this.phase,
    required this.remainingSeconds,
    required this.completedWorkSessions,
    required this.isRunning,
  });

  PomodoroState copyWith({
    PomodoroPhase? phase,
    int? remainingSeconds,
    int? completedWorkSessions,
    bool? isRunning,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      completedWorkSessions:
          completedWorkSessions ?? this.completedWorkSessions,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
