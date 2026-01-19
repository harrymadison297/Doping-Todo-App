import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../models/todo_model.dart';
import 'database_helper.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const DarwinInitializationSettings macosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
    await _requestPermissions();
  }

  void _onNotificationResponse(NotificationResponse response) async {
    if (response.actionId == 'mark_complete') {
      // Mark todo as complete
      final todoId = int.tryParse(response.id.toString());
      if (todoId != null) {
        try {
          final dbHelper = DatabaseHelper();
          final todos = await dbHelper.getAllTodos();
          final todo = todos.firstWhere((t) => t.id == todoId);

          await dbHelper.updateTodo(todo.copyWith(isCompleted: true));
          await cancelNotification(todoId);
        } catch (e) {
          print('Lỗi khi hoàn thành task: $e');
        }
      }
    }
  }

  Future<void> _requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleRepeatingNotification(Todo todo) async {
    if (todo.isCompleted || todo.id == null) return;

    try {
      await cancelNotification(todo.id!);

      final now = DateTime.now();
      final deadline = todo.deadline;

      // Don't schedule if deadline has passed
      if (deadline.isBefore(now)) return;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'todo_reminders',
            'Todo Reminders',
            channelDescription: 'Notifications for incomplete todo tasks',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                'mark_complete',
                '✓ Hoàn thành',
                showsUserInterface: false,
                cancelNotification: true,
              ),
            ],
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        categoryIdentifier: 'todoCategory',
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule repeating notification
      await _notifications.periodicallyShow(
        todo.id!,
        '⏰ Nhắc nhở: ${todo.title}',
        'Công việc chưa hoàn thành. Hạn: ${_formatDeadline(deadline)}',
        _getRepeatInterval(todo.repeatIntervalMinutes),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      print('Lỗi khi lên lịch thông báo: $e');
      // Notification scheduling failed, but we don't want to block todo creation
    }
  }

  RepeatInterval _getRepeatInterval(int minutes) {
    if (minutes <= 1) return RepeatInterval.everyMinute;
    if (minutes <= 60) return RepeatInterval.hourly;
    if (minutes <= 1440) return RepeatInterval.daily;
    return RepeatInterval.weekly;
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày nữa';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ nữa';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút nữa';
    } else {
      return 'Đã quá hạn';
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'pomodoro_timer',
          'Pomodoro Timer',
          channelDescription: 'Notifications for Pomodoro timer phases',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> rescheduleAllNotifications() async {
    final dbHelper = DatabaseHelper();
    final incompleteTodos = await dbHelper.getIncompleteTodos();

    await cancelAllNotifications();

    for (final todo in incompleteTodos) {
      await scheduleRepeatingNotification(todo);
    }
  }
}
