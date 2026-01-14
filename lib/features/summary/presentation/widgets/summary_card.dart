import 'package:flutter/material.dart';
import '../../../../shared/widgets/money_text.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int amountClp;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amountClp,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color)),
            const SizedBox(height: 8),
            MoneyText(
              amountIntClp: amountClp,
              size: 26,
              emphasis: true,
            ),
          ],
        ),
      ),
    );
  }
}
