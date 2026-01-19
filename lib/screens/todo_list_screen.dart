import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';
import '../l10n/app_localizations.dart';
import 'add_edit_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  List<Todo> _todos = [];
  bool _showCompletedOnly = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _dbHelper.getAllTodos();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _toggleTodoComplete(Todo todo) async {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await _dbHelper.updateTodo(updatedTodo);

    if (updatedTodo.isCompleted) {
      await _notificationService.cancelNotification(updatedTodo.id!);
    } else {
      await _notificationService.scheduleRepeatingNotification(updatedTodo);
    }

    await _loadTodos();
  }

  Future<void> _deleteTodo(Todo todo) async {
    await _dbHelper.deleteTodo(todo.id!);
    await _notificationService.cancelNotification(todo.id!);
    await _loadTodos();

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${l10n.delete}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _navigateToAddEdit({Todo? todo}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditTodoScreen(todo: todo)),
    );

    if (result == true) {
      await _loadTodos();
    }
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays > 0) {
      return 'Còn ${difference.inDays} ngày';
    } else if (difference.inHours > 0) {
      return 'Còn ${difference.inHours} giờ';
    } else if (difference.inMinutes > 0) {
      return 'Còn ${difference.inMinutes} phút';
    } else {
      return 'Quá hạn';
    }
  }

  Color _getDeadlineColor(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inHours < 0) {
      return Colors.red;
    } else if (difference.inHours < 24) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getRepeatIntervalText(int minutes) {
    if (minutes < 60) {
      return '$minutes phút';
    } else if (minutes < 1440) {
      return '${minutes ~/ 60} giờ';
    } else {
      return '${minutes ~/ 1440} ngày';
    }
  }

  List<Todo> get _filteredTodos {
    if (_showCompletedOnly) {
      return _todos.where((todo) => todo.isCompleted).toList();
    }
    return _todos;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final incompleteTodos = _todos.where((todo) => !todo.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 28),
            const SizedBox(width: 8),
            Text(l10n.todoList),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_showCompletedOnly ? Icons.list : Icons.done_all),
            onPressed: () {
              setState(() {
                _showCompletedOnly = !_showCompletedOnly;
              });
            },
            tooltip: _showCompletedOnly ? l10n.showCompleted : l10n.hideCompleted,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFD700),
                  const Color(0xFFFFD700).withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  icon: Icons.assignment,
                  title: l10n.total,
                  value: '${_todos.length}',
                  color: Colors.white,
                ),
                _buildStatCard(
                  icon: Icons.pending_actions,
                  title: l10n.incomplete,
                  value: '$incompleteTodos',
                  color: Colors.white,
                ),
                _buildStatCard(
                  icon: Icons.check_circle,
                  title: l10n.completed,
                  value: '${_todos.length - incompleteTodos}',
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredTodos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _showCompletedOnly
                              ? Icons.celebration
                              : Icons.inbox_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showCompletedOnly
                              ? l10n.noTodos
                              : l10n.noTodos,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.addFirstTask,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = _filteredTodos[index];
                      return _buildTodoCard(todo);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEdit(),
        icon: const Icon(Icons.add),
        label: Text(l10n.addTask),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
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
          Text(title, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _buildTodoCard(Todo todo) {
    final isOverdue = todo.deadline.isBefore(DateTime.now());

    return Dismissible(
      key: Key(todo.id.toString()),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteTodo(todo),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () => _navigateToAddEdit(todo: todo),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _toggleTodoComplete(todo),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: todo.isCompleted
                            ? const Color(0xFFFFD700)
                            : Colors.grey,
                        width: 2,
                      ),
                      color: todo.isCompleted
                          ? const Color(0xFFFFD700)
                          : Colors.transparent,
                    ),
                    child: todo.isCompleted
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      if (todo.description != null &&
                          todo.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: _getDeadlineColor(todo.deadline),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDeadline(todo.deadline),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getDeadlineColor(todo.deadline),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.notifications_active,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Mỗi ${_getRepeatIntervalText(todo.repeatIntervalMinutes)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isOverdue && !todo.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Quá hạn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
