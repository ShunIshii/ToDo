import 'package:flutter/material.dart';
import 'package:flutter_todo/edit_component.dart';
import 'package:flutter_todo/todo.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> _todos = [
    Todo(title: "ほげ"),
    Todo(title: "ふが"),
    Todo(title: "ぴよ"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];

          return ListTile(
            title: Text(todo.title),
            trailing: Checkbox(
              value: todo.done,
              onChanged: (checked) {
                setState(() {
                  _todos[index] = Todo(title: todo.title, done: checked ?? false);
                });
              },
            ),
            onLongPress: () async {
              final result = await EditDialog.show(context, todo);
              if (result != null) {
                setState(() {
                  _todos[index] = result;
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await EditDialog.show(context);
          if (result != null) {
            setState(() {
              _todos.add(result);
            });
          }
        },
      ),
    );
  }
}