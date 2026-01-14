import 'package:flutter/material.dart';

class RegisterExpenseButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const RegisterExpenseButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        height: 72,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: enabled ? onPressed : null,
          child: const Text(
            'Registrar gasto',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
