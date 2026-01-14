import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playa/features/expenses/presentation/widgets/amount_input.dart';

import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/numeric_keyboard.dart';
import '../../../shared/widgets/ui_event.dart';
import 'withdrawals_view_model.dart';
import 'widgets/reason_grid.dart';
import 'widgets/notes_field.dart';
import 'widgets/register_withdrawal_button.dart';

class WithdrawalsView extends ConsumerStatefulWidget {
  const WithdrawalsView({super.key});

  @override
  ConsumerState<WithdrawalsView> createState() => _WithdrawalsViewState();
}

class _WithdrawalsViewState extends ConsumerState<WithdrawalsView> {
  StreamSubscription<UiEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(withdrawalsViewModelProvider.notifier).init(),
    );

    _subscription = ref
        .read(withdrawalsViewModelProvider.notifier)
        .events
        .listen(_handleEvent);
  }

  void _handleEvent(UiEvent event) async {
    if (!mounted) return;

    switch (event) {
      case ShowSnack():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(event.message)),
        );
        break;

      case ShowDialogEvent():
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(event.title),
            content: Text(event.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(event.cancelText),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(event.confirmText),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          ref.read(withdrawalsViewModelProvider.notifier).confirm();
        }
        break;

      case Navigate():
        Navigator.of(context).pushNamed(event.route);
        break;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(withdrawalsViewModelProvider);
    final vm = ref.read(withdrawalsViewModelProvider.notifier);

    return LoadingOverlay(
      visible: state.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Retiros')),
        body: Column(
          children: [
            Expanded(
              child: ReasonGrid(
                reasons: state.reasons,
                onSelected: vm.selectReason,
              ),
            ),

            AmountInput(
              amountClp: state.amountClp,
              onTap: vm.openKeyboard,
            ),

            if (state.keyboardVisible)
              NumericKeyboard(
                onKey: vm.onDigit,
                onBackspace: vm.backspace,
                onClear: vm.clearAmount,
                onDone: vm.closeKeyboard,
              ),

            NotesField(
              value: state.note,
              onChanged: vm.changeNote,
            ),

            // Copy obligatorio siempre visible
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                '⚠ Retiro ≠ Gasto',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),

            RegisterWithdrawalButton(
              enabled: !state.isLoading,
              onPressed: vm.submit,
            ),
          ],
        ),
      ),
    );
  }
}
