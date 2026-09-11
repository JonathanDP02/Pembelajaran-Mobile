import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isCompleted,
        onChanged: onChanged,
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}