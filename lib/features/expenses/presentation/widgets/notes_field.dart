import 'package:flutter/material.dart';

class NotesField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const NotesField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: 'Nota (opcional)',
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
