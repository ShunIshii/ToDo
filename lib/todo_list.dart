import 'package:flutter/material.dart';
import 'package:flutter_todo/edit_component.dart';
import 'package:flutter_todo/repository.dart';
import 'package:flutter_todo/todo.dart';

class TodoListPage extends StatefulWidget {
  final TodoRepository repository;
  TodoListPage(this.repository);
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
  void initState() {
    super.initState();
    widget.repository.loadAllTodo().then((todos) => setState(() {
      _todos = todos;
    }));
  }

  void _replaceTodo(int index, Todo newTodo) {
    setState(() {
      _todos[index] = newTodo;
    });
    widget.repository.saveAllTodo(_todos);
  }

  void _appendTodo(Todo newTodo) {
    setState(() {
      _todos.add(newTodo);
    });
    widget.repository.saveAllTodo(_todos);
  }

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
                _replaceTodo(
                  index,
                  Todo(title: todo.title, done: checked ?? false),
                );
              },
            ),
            onLongPress: () async {
              final result = await EditDialog.show(context, todo);
              if (result != null) {
                _replaceTodo(index, result);
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
            _appendTodo(result);
          }
        },
      ),
    );
  }
}