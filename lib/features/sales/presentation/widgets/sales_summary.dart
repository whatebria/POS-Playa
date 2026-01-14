import 'package:flutter/material.dart';
import '../../../../shared/widgets/money_text.dart';

class SalesSummary extends StatelessWidget {
  final int totalClp;

  const SalesSummary({
    super.key,
    required this.totalClp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 22),
            ),
            const Spacer(),
            MoneyText(
              amountIntClp: totalClp,
              size: 26,
              emphasis: true,
            ),
          ],
        ),
      ),
    );
  }
}
