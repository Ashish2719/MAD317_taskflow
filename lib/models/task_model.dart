class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String category;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
    this.isCompleted = false,
  });
}