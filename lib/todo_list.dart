import 'package:flutter/material.dart';
import 'package:flutter_todo/edit_component.dart';
import 'package:flutter_todo/repository.dart';
import 'package:flutter_todo/task.dart';

class TodoListPage extends StatefulWidget {
  final TaskRepository repository;
  TodoListPage(this.repository);
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    widget.repository.loadAllTask().then((tasks) => setState(() {
      _tasks = tasks;
    }));
  }

  void _replaceTask(int index, Task newTask) {
    setState(() {
      _tasks[index] = newTask;
    });
    widget.repository.saveAllTask(_tasks);
  }

  void _appendTask(Task newTask) {
    setState(() {
      _tasks.insert(0, newTask);
    });
    widget.repository.saveAllTask(_tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    widget.repository.saveAllTask(_tasks);
  }

  bool _validateTask(Task task) {
    if (task.title == '') {
      return false;
    }
    else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];

          return ListTile(
            title: (!task.done) ? Text(task.title) : Text(task.title, style: TextStyle(decoration: TextDecoration.lineThrough),), // 完了したタスクには文字列に取り消し線が入る
            trailing: Checkbox(
              value: task.done,
              onChanged: (checked) {
                _replaceTask(
                  index,
                  Task(title: task.title, done: checked ?? false),
                );
                if (!task.done) {
                  _tasks.add(_tasks.removeAt(index));
                }
                else {
                  _tasks.insert(0, _tasks.removeAt(index));
                }
              },
            ),
            onLongPress: () async {
              final result = await EditDialog.show(context, task);
              if (result != null) {
                if (result['operation'] == 'save' && _validateTask(result['content'])) {
                  _replaceTask(index, result['content']);
                  result['content'].done = task.done; // 編集前のチェック状態を反映させる
                }
                else if (result['operation'] == 'delete') {
                  _deleteTask(index);
                }
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await EditDialog.show(context);
          if (result != null && _validateTask(result['content'])) {
            _appendTask(result['content']);
          }
        },
      ),
    );
  }
}