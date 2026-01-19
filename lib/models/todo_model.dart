class Todo {
  final int? id;
  final String title;
  final String? description;
  final DateTime deadline;
  final int
  repeatIntervalMinutes; // Interval in minutes for repeat notifications
  final bool isCompleted;
  final DateTime createdAt;

  Todo({
    this.id,
    required this.title,
    this.description,
    required this.deadline,
    required this.repeatIntervalMinutes,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'repeatIntervalMinutes': repeatIntervalMinutes,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      deadline: DateTime.parse(map['deadline']),
      repeatIntervalMinutes: map['repeatIntervalMinutes'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? deadline,
    int? repeatIntervalMinutes,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      repeatIntervalMinutes:
          repeatIntervalMinutes ?? this.repeatIntervalMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
