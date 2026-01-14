import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final void Function(int) onChange;
  final VoidCallback onConfirm;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChange,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              iconSize: 36,
              onPressed: () => onChange(quantity - 1),
              icon: const Icon(Icons.remove),
            ),
            Expanded(
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            IconButton(
              iconSize: 36,
              onPressed: () => onChange(quantity + 1),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: onConfirm,
                child: const Text('Agregar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
