import 'package:flutter/material.dart';
import '../../../../shared/widgets/numeric_keyboard.dart';

class OpeningKeyboardSheet extends StatelessWidget {
  final bool visible;
  final void Function(String digit) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onDone;

  const OpeningKeyboardSheet({
    super.key,
    required this.visible,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return NumericKeyboard(
      onKey: onDigit,
      onBackspace: onBackspace,
      onClear: onClear,
      onDone: onDone,
    );
  }
}
