/// Data model representing a single To-Do item.
class Task {
  /// Unique identifier for the task.
  final String id;

  /// The text content/description of the task.
  final String title;

  /// Whether the task is completed or pending.
  final bool isCompleted;

  /// Timestamp when the task was created.
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  /// Factory constructor to quickly create a new pending task with a unique ID and current timestamp.
  factory Task.create({required String title}) {
    return Task(
      id: '${DateTime.now().microsecondsSinceEpoch}_${title.hashCode}',
      title: title.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
    );
  }

  /// Creates a copy of this task with updated properties.
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns a new Task with the completion status inverted.
  Task toggle() {
    return copyWith(isCompleted: !isCompleted);
  }

  /// Converts the Task instance to a Map for serialization or debugging.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Recreates a Task from a Map.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, title, isCompleted, createdAt);

  @override
  String toString() {
    return 'Task(id: $id, title: "$title", isCompleted: $isCompleted, createdAt: $createdAt)';
  }
}
