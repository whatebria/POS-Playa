import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/numeric_keyboard.dart';
import '../../../shared/widgets/ui_event.dart';
import 'closure_view_model.dart';
import 'widgets/cash_expected_card.dart';
import 'widgets/cash_counted_input.dart';
import 'widgets/difference_card.dart';
import 'widgets/close_day_button.dart';

class ClosureView extends ConsumerStatefulWidget {
  const ClosureView({super.key});

  @override
  ConsumerState<ClosureView> createState() => _ClosureViewState();
}

class _ClosureViewState extends ConsumerState<ClosureView> {
  StreamSubscription<UiEvent>? _sub;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(closureViewModelProvider.notifier).init(),
    );

    _sub = ref
        .read(closureViewModelProvider.notifier)
        .events
        .listen(_handleEvent);
  }

  void _handleEvent(UiEvent e) async {
    if (!mounted) return;

    if (e is ShowSnack) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }

    if (e is ShowDialogEvent) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(e.title),
          content: Text(e.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(e.cancelText),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(e.confirmText),
            ),
          ],
        ),
      );

      if (ok == true) {
        ref.read(closureViewModelProvider.notifier).confirmClose();
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(closureViewModelProvider);
    final vm = ref.read(closureViewModelProvider.notifier);

    return LoadingOverlay(
      visible: state.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Cierre de caja')),
        body: Column(
          children: [
            CashExpectedCard(amountClp: state.cashExpected),
            CashCountedInput(
              amountClp: state.cashCounted,
              onTap: vm.openKeyboard,
            ),
            DifferenceCard(differenceClp: state.difference),

            if (state.keyboardVisible)
              NumericKeyboard(
                onKey: vm.onDigit,
                onBackspace: vm.backspace,
                onClear: vm.clearAmount,
                onDone: vm.closeKeyboard,
              ),

            CloseDayButton(
              enabled: !state.isLoading,
              onPressed: vm.submit,
            ),
          ],
        ),
      ),
    );
  }
}
