class Task {
  final int? id;         // SQLite primary key (auto increment)
  final String title;    // Task title
  final bool isCompleted; // Completed status (true/false)

  Task({
    this.id,
    required this.title,
    this.isCompleted = false,
  });

  // Convert Dart object → Map (SQLite insert/update ചെയ്യാൻ)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0, // SQLite 0/1 format
    };
  }

  // Convert SQLite Map → Dart object (fetch ചെയ്യുമ്പോൾ)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
