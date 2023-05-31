import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function(String) onUpdate;

  EditDialog({required this.title, required this.initialValue, required this.onUpdate});

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    String updatedValue = _textEditingController.text;
    widget.onUpdate(updatedValue);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Container(
        width: double.maxFinite,  // Set the width to occupy the maximum available space
        child: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Enter new ${widget.title}',
            border: OutlineInputBorder(),  // Add border to the TextField
          ),
          maxLines: null,  // Allow multiple lines of text
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleUpdate,
          child: Text('Update'),
        ),
      ],
    );
  }
}
