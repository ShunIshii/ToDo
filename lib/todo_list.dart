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
  List<Todo> _todos = [];

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

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    widget.repository.saveAllTodo(_todos);
  }

  bool _validateTodo(Todo todo) {
    if (todo.title == '') {
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
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];

          return ListTile(
            title: (!todo.done) ? Text(todo.title) : Text(todo.title, style: TextStyle(decoration: TextDecoration.lineThrough),), // 完了したタスクには文字列に取り消し線が入る
            trailing: Checkbox(
              value: todo.done,
              onChanged: (checked) {
                _replaceTodo(
                  index,
                  Todo(title: todo.title, done: checked ?? false),
                );
                if (!todo.done) {
                  _todos.add(_todos.removeAt(index));
                }
                else {
                  _todos.insert(0, _todos.removeAt(index));
                }
              },
            ),
            onLongPress: () async {
              final result = await EditDialog.show(context, todo);
              if (result != null) {
                if (result['operation'] == 'save' && _validateTodo(result['content'])) {
                  _replaceTodo(index, result['content']);
                  result['content'].done = todo.done; // 編集前のチェック状態を反映させる
                }
                else if (result['operation'] == 'delete') {
                  _deleteTodo(index);
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
          if (result != null && _validateTodo(result['content'])) {
            _appendTodo(result['content']);
          }
        },
      ),
    );
  }
}