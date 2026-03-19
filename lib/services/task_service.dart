import '../models/task_model.dart';

class TaskService {
  final List<Task> _tasks = [];

  List<Task> getAllTasks() => _tasks;

  List<Task> getActiveTasks() => _tasks.where((t) => !t.isCompleted).toList();

  List<Task> getCompletedTasks() => _tasks.where((t) => t.isCompleted).toList();

  void addTask(Task task) {
    _tasks.add(task);
  }

  void updateTask(String id, {String? title, String? description, bool? isCompleted}) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = Task(
        id: task.id,
        title: title ?? task.title,
        description: description ?? task.description,
        dueDate: task.dueDate,
        category: task.category,
        isCompleted: isCompleted ?? task.isCompleted,
      );
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }
}