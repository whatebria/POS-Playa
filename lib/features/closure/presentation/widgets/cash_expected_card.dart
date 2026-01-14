import 'package:flutter/material.dart';
import '../../../../shared/widgets/money_text.dart';

class CashExpectedCard extends StatelessWidget {
  final int amountClp;

  const CashExpectedCard({
    super.key,
    required this.amountClp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Efectivo esperado',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            MoneyText(
              amountIntClp: amountClp,
              size: 28,
              emphasis: true,
            ),
          ],
        ),
      ),
    );
  }
}
