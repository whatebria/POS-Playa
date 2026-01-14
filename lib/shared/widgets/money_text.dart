import 'package:flutter/material.dart';
import '../utils/money_format.dart';

class MoneyText extends StatelessWidget {
  final int amountIntClp;
  final double size;
  final bool emphasis;

  const MoneyText({
    super.key,
    required this.amountIntClp,
    required this.size,
    required this.emphasis,
  });

  @override
  Widget build(BuildContext context) {
    final txt = formatClp(amountIntClp);
    final style = emphasis
        ? Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.titleLarge;

    return Text(txt, style: style?.copyWith(fontSize: size));
  }
}
