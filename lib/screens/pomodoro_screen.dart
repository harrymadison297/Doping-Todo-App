import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/pomodoro_settings.dart';
import '../services/pomodoro_service.dart';
import '../l10n/app_localizations.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  final PomodoroService _pomodoroService = PomodoroService();

  @override
  void initState() {
    super.initState();
    _pomodoroService.loadSettings();
    _pomodoroService.addListener(_onPomodoroUpdate);
  }

  @override
  void dispose() {
    _pomodoroService.removeListener(_onPomodoroUpdate);
    super.dispose();
  }

  void _onPomodoroUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getPhaseTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_pomodoroService.state.phase) {
      case PomodoroPhase.work:
        return '${l10n.work} 💪';
      case PomodoroPhase.break_:
        return '${l10n.breakPhase} ☕';
      case PomodoroPhase.rest:
        return '${l10n.rest} 🌟';
    }
  }

  Color _getPhaseColor() {
    switch (_pomodoroService.state.phase) {
      case PomodoroPhase.work:
        return const Color(0xFFFF6B6B);
      case PomodoroPhase.break_:
        return const Color(0xFF4ECDC4);
      case PomodoroPhase.rest:
        return const Color(0xFF95E1D3);
    }
  }

  IconData _getPhaseIcon() {
    switch (_pomodoroService.state.phase) {
      case PomodoroPhase.work:
        return Icons.work;
      case PomodoroPhase.break_:
        return Icons.coffee;
      case PomodoroPhase.rest:
        return Icons.beach_access;
    }
  }

  void _showSettingsDialog() {
    final l10n = AppLocalizations.of(context)!;
    final workController = TextEditingController(
      text: _pomodoroService.settings.workMinutes.toString(),
    );
    final breakController = TextEditingController(
      text: _pomodoroService.settings.breakMinutes.toString(),
    );
    final restController = TextEditingController(
      text: _pomodoroService.settings.restMinutes.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.settings, color: Color(0xFFFFD700)),
            const SizedBox(width: 8),
            Text(l10n.settings),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: workController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${l10n.workTime} (${l10n.minutes})',
                  prefixIcon: const Icon(Icons.work),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: breakController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${l10n.breakTime} (${l10n.minutes})',
                  prefixIcon: const Icon(Icons.coffee),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: restController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${l10n.restTime} (${l10n.minutes})',
                  prefixIcon: const Icon(Icons.beach_access),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Chu trình: Work → Break → Work → Break → Work → Rest\n(3 work sessions = 1 rest)',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final work = int.tryParse(workController.text) ?? 25;
              final break_ = int.tryParse(breakController.text) ?? 5;
              final rest = int.tryParse(restController.text) ?? 15;

              _pomodoroService.saveSettings(
                PomodoroSettings(
                  workMinutes: work,
                  breakMinutes: break_,
                  restMinutes: rest,
                ),
              );
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = _pomodoroService.state;
    final phaseColor = _getPhaseColor();
    final progress =
        1 -
        (state.remainingSeconds /
            _getTotalSecondsForPhase(_pomodoroService.state.phase));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer, size: 28),
            const SizedBox(width: 8),
            Text(l10n.pomodoroTimer),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [phaseColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Phase indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: phaseColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getPhaseIcon(), color: phaseColor),
                    const SizedBox(width: 8),
                    Text(
                      _getPhaseTitle(context),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: phaseColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${l10n.sessions} ${state.completedWorkSessions + 1}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const Spacer(),
              // Timer circle
              SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    CustomPaint(
                      size: const Size(280, 280),
                      painter: CircleProgressPainter(
                        progress: progress,
                        color: phaseColor,
                      ),
                    ),
                    // Time display
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(state.remainingSeconds),
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: phaseColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.isRunning ? '${l10n.start}...' : l10n.pause,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Controls
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reset button
                    _buildControlButton(
                      icon: Icons.refresh,
                      label: l10n.reset,
                      color: Colors.grey,
                      onPressed: () {
                        _pomodoroService.resetTimer();
                      },
                    ),
                    // Play/Pause button
                    _buildControlButton(
                      icon: state.isRunning ? Icons.pause : Icons.play_arrow,
                      label: state.isRunning ? l10n.pause : l10n.start,
                      color: phaseColor,
                      onPressed: () {
                        if (state.isRunning) {
                          _pomodoroService.pauseTimer();
                        } else {
                          _pomodoroService.startTimer();
                        }
                      },
                      isPrimary: true,
                    ),
                    // Skip button
                    _buildControlButton(
                      icon: Icons.skip_next,
                      label: l10n.skip,
                      color: Colors.grey,
                      onPressed: () {
                        _pomodoroService.skipPhase();
                      },
                    ),
                  ],
                ),
              ),
              // Statistics
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.check_circle,
                      label: l10n.completed,
                      value: '${state.completedWorkSessions}',
                      color: Colors.green,
                    ),
                    _buildStatItem(
                      icon: Icons.coffee,
                      label: l10n.breakPhase,
                      value: '${state.completedWorkSessions % 3}',
                      color: Colors.blue,
                    ),
                    _buildStatItem(
                      icon: Icons.beach_access,
                      label: l10n.rest,
                      value: '${3 - (state.completedWorkSessions % 3)}',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  int _getTotalSecondsForPhase(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return _pomodoroService.settings.workMinutes * 60;
      case PomodoroPhase.break_:
        return _pomodoroService.settings.breakMinutes * 60;
      case PomodoroPhase.rest:
        return _pomodoroService.settings.restMinutes * 60;
    }
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Column(
      children: [
        Container(
          width: isPrimary ? 80 : 64,
          height: isPrimary ? 80 : 64,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: IconButton(
            icon: Icon(icon, size: isPrimary ? 40 : 32),
            color: color,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(center, radius - 6, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
