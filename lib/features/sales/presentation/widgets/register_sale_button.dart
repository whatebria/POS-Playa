import 'package:flutter/material.dart';

class RegisterSaleButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const RegisterSaleButton({
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
          onPressed: enabled ? onPressed : null,
          child: const Text(
            'Registrar venta',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
