import 'package:flutter/material.dart';
import '../../../../shared/widgets/money_text.dart';

class DifferenceCard extends StatelessWidget {
  final int differenceClp;

  const DifferenceCard({
    super.key,
    required this.differenceClp,
  });

  @override
  Widget build(BuildContext context) {
    final isZero = differenceClp == 0;
    final color = isZero ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diferencia',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            MoneyText(
              amountIntClp: differenceClp,
              size: 28,
              emphasis: true,
            ),
            const SizedBox(height: 4),
            Text(
              isZero ? 'Caja cuadrada' : 'Descuadre',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
