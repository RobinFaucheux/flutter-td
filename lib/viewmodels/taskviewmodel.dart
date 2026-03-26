import 'package:flutter/cupertino.dart';

import '../model/tasks.dart';
import '../DB/database.dart';
class TaskViewModel extends ChangeNotifier{
  late List<Task> liste = [];
  TaskViewModel(){
    liste=[];
  }
  Future<void> addTask(Task task) async {
    database.insertTask(task);
    liste = await database.getAllTasks();
    notifyListeners();
  }

  Future<void> editTask(Task task) async {
    database.updateTask(task);
    liste = await database.getAllTasks();
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    database.deleteTask(id);
    liste = await database.getAllTasks();

    notifyListeners();
  }
}