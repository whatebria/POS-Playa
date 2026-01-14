import 'package:flutter/material.dart';
import '../../domain/enums/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod? selected;
  final void Function(PaymentMethod) onSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    Widget button(PaymentMethod method) {
      final isSelected = selected == method;

      return Expanded(
        child: SizedBox(
          height: 72,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
            ),
            onPressed: () => onSelected(method),
            child: Text(
              method.label,
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          button(PaymentMethod.cash),
          const SizedBox(width: 12),
          button(PaymentMethod.transfer),
        ],
      ),
    );
  }
}
