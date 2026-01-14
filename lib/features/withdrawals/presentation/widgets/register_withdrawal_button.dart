import 'package:flutter/material.dart';

class RegisterWithdrawalButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const RegisterWithdrawalButton({
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
            backgroundColor: Colors.orange,
          ),
          onPressed: enabled ? onPressed : null,
          child: const Text(
            'Registrar retiro',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
