import 'dart:convert';

import 'package:flutter_todo/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskRepository {
  Future<List<Task>> loadAllTask() async {
    final pref = await SharedPreferences.getInstance();
    final raw = pref.getString("tasks");
    if (raw != null) {
      final decoded = json.decode(raw) as List;
      return decoded
          .cast<Map<String, dynamic>>()
          .map(
            (e) => Task(
          title: e["title"],
          done: e["done"],
        ),
      )
          .toList();
    }
    return [];
  }

  Future<void> saveAllTask(List<Task> tasks) async {
    final pref = await SharedPreferences.getInstance();
    final values = tasks
        .map((e) => {
      "title": e.title,
      "done": e.done,
    })
        .toList();
    final raw = json.encode(values);
    await pref.setString("tasks", raw);
  }
}