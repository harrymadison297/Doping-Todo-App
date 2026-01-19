import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'todo_list_screen.dart';
import 'pomodoro_screen.dart';
import 'settings_screen.dart';
import 'add_edit_todo_screen.dart';
import '../services/pomodoro_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const platform = MethodChannel('com.example.doping/widget');
  final PomodoroService _pomodoroService = PomodoroService();

  @override
  void initState() {
    super.initState();
    _setupWidgetChannel();
  }

  void _setupWidgetChannel() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'openAddTodo') {
        // Navigate to add todo screen
        if (mounted) {
          setState(() {
            _selectedIndex = 0; // Switch to Todo tab
          });
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditTodoScreen()),
          );
        }
      } else if (call.method == 'startPomodoro') {
        // Navigate to Pomodoro tab and start timer
        if (mounted) {
          setState(() {
            _selectedIndex = 1; // Switch to Pomodoro tab
          });
          // Start the timer
          _pomodoroService.startTimer();
        }
      }
    });
  }

  static const List<Widget> _screens = [
    TodoListScreen(),
    PomodoroScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFFFFD700),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.check_circle_outline, size: 28),
              activeIcon: const Icon(Icons.check_circle, size: 28),
              label: l10n.todoTab,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.timer_outlined, size: 28),
              activeIcon: const Icon(Icons.timer, size: 28),
              label: l10n.pomodoroTab,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined, size: 28),
              activeIcon: const Icon(Icons.settings, size: 28),
              label: l10n.settingsTab,
            ),
          ],
        ),
      ),
    );
  }
}
