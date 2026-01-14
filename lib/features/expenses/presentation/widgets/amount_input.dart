import 'package:flutter/material.dart';
import '../../../../shared/widgets/money_text.dart';

class AmountInput extends StatelessWidget {
  final int amountClp;
  final VoidCallback onTap;

  const AmountInput({
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
                'Monto',
                style: TextStyle(fontSize: 20),
              ),
              const Spacer(),
              MoneyText(
                amountIntClp: amountClp,
                size: 26,
                emphasis: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
