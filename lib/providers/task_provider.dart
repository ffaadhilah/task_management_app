import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  Task? _deletedTask;

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners(); // Ensure listeners are notified
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index >= 0) {
      _tasks[index] = updatedTask;
      notifyListeners(); // Ensure listeners are notified
    }
  }

  void deleteTask(String id) {
    _deletedTask = _tasks.firstWhere((task) => task.id == id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners(); // Ensure listeners are notified
  }

  void undoDeleteTask() {
    if (_deletedTask != null) {
      _tasks.add(_deletedTask!);
      _deletedTask = null;
      notifyListeners(); // Ensure listeners are notified
    }
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index >= 0) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners(); // Ensure listeners are notified
    }
  }
}
