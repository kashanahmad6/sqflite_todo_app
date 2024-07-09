import 'package:flutter/material.dart';
import 'package:sqflite_todoapp/database/database.dart';
import 'package:sqflite_todoapp/model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final DbHelper dbHelper = DbHelper();
  List<Task>? _tasks = [];

  List<Task>? get tasks => _tasks;

  Future<void> fetchItems() async {
    _tasks = await dbHelper.getTasks();
  }

  Future<void> addTask(String content) async {
    await dbHelper.addtotasks(content);
    await fetchItems();
    notifyListeners();
  }

  Future<void> updateStatus(int id, int status) async {
    await dbHelper.updateStatus(id, status);
    await fetchItems();
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    fetchItems();

    notifyListeners();
  }
}
