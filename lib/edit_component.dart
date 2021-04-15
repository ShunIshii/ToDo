import 'package:flutter/material.dart';
import 'package:flutter_todo/task.dart';

class EditDialog extends StatefulWidget {
  static Future show(BuildContext context, [Task? base]) {
    return showDialog(
      context: context,
      builder: (context) => EditDialog(base: base),
    );
  }

  EditDialog({this.base}):super();

  final Task? base;

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.base?.title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(hintText: 'TASK'),
        autofocus: true, // AlertDialog が表示されると、自動的に TextField へフォーカスされる
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            var result = Map();
            result['operation'] = 'delete';
            result['content'] = Task(title: '');
            Navigator.pop(
              context,
              result,
            );
          },
          child: Text('削除'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            var result = Map();
            result['operation'] = 'save';
            result['content'] = Task(title: _textEditingController.text);
            Navigator.pop(
              context,
              result,
            );
          },
          child: Text('保存'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}