import 'package:flutter/material.dart';
import 'package:playa/features/withdrawals/domain/entities/withdrawal_reason.dart';

class ReasonGrid extends StatelessWidget {
  final List<WithdrawalReason> reasons;
  final void Function(WithdrawalReason) onSelected;
  final WithdrawalReason? selectedReason;

  const ReasonGrid({
    super.key,
    required this.reasons,
    required this.onSelected,
    required this.selectedReason,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),
      itemCount: reasons.length,
      itemBuilder: (_, i) {
        final r = reasons[i];
        final isSelected = selectedReason?.id == r.id;
        return FilledButton(
          style: isSelected
              ? FilledButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                )
              : null,
          onPressed: () => onSelected(r),
          child: Text(
            r.name,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
