import 'package:flutter/material.dart';

class NumericKeyboard extends StatelessWidget {
  final void Function(String digit) onKey;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onDone;

  const NumericKeyboard({
    super.key,
    required this.onKey,
    required this.onBackspace,
    required this.onClear,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    Widget key(String label, {VoidCallback? onTap, bool big = false}) {
      return SizedBox(
        height: big ? 80 : 72,
        child: FilledButton.tonal(
          onPressed: onTap,
          child: Text(label, style: const TextStyle(fontSize: 22)),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: key('1', onTap: () => onKey('1'))),
                const SizedBox(width: 8),
                Expanded(child: key('2', onTap: () => onKey('2'))),
                const SizedBox(width: 8),
                Expanded(child: key('3', onTap: () => onKey('3'))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: key('4', onTap: () => onKey('4'))),
                const SizedBox(width: 8),
                Expanded(child: key('5', onTap: () => onKey('5'))),
                const SizedBox(width: 8),
                Expanded(child: key('6', onTap: () => onKey('6'))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: key('7', onTap: () => onKey('7'))),
                const SizedBox(width: 8),
                Expanded(child: key('8', onTap: () => onKey('8'))),
                const SizedBox(width: 8),
                Expanded(child: key('9', onTap: () => onKey('9'))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: key('Limpiar', onTap: onClear)),
                const SizedBox(width: 8),
                Expanded(child: key('0', onTap: () => onKey('0'))),
                const SizedBox(width: 8),
                Expanded(child: key('⌫', onTap: onBackspace)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: key('Listo', onTap: onDone, big: true)),
          ],
        ),
      ),
    );
  }
}
