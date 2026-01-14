import 'package:flutter/material.dart';
import '../../../../shared/widgets/money_text.dart';
import '../../domain/day_status.dart';

class OpeningAmountCard extends StatelessWidget {
  final int openingCashClp;
  final DayStatus dayStatus;
  final VoidCallback onTapAmount;

  const OpeningAmountCard({
    super.key,
    required this.openingCashClp,
    required this.dayStatus,
    required this.onTapAmount,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = switch (dayStatus) {
      DayStatus.open => 'Día ya abierto',
      DayStatus.closed => 'Día cerrado',
      DayStatus.unknown => 'Día no abierto',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(statusText, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text('Vuelto inicial (CLP)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            InkWell(
              onTap: onTapAmount,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: MoneyText(amountIntClp: openingCashClp, size: 28, emphasis: true),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque el monto para ingresar con teclado numérico',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
