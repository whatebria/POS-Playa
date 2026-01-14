import 'package:flutter/material.dart';
import '../../../../shared/widgets/money_text.dart';

class CashCountedInput extends StatelessWidget {
  final int amountClp;
  final VoidCallback onTap;

  const CashCountedInput({
    super.key,
    required this.amountClp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Efectivo contado',
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              MoneyText(
                amountIntClp: amountClp,
                size: 28,
                emphasis: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
