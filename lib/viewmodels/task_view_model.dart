import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  bool isLoading = false;

  // Load all tasks from DB
  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();

    _tasks = await _dbHelper.getAllTasks();

    isLoading = false;
    notifyListeners();
  }

  // Add new task
  Future<void> addTask(String title) async {
    final task = Task(title: title);
    await _dbHelper.insertTask(task);
    await loadTasks(); // refresh list
  }

  // Update task (status/title)
  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    await loadTasks(); // refresh list
  }

  // Delete task
  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    await loadTasks(); // refresh list
  }

  // Toggle completion
  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      isCompleted: !task.isCompleted,
    );
    await _dbHelper.updateTask(updatedTask);
    await loadTasks();
  }
}
