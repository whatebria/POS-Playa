import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playa/features/opening/domain/day_status.dart';

import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/ui_event.dart';
import 'opening_view_model.dart';
import 'widgets/opening_amount_card.dart';
import 'widgets/opening_keyboard_sheet.dart';

class OpeningView extends ConsumerStatefulWidget {
  const OpeningView({super.key});

  @override
  ConsumerState<OpeningView> createState() => _OpeningViewState();
}

class _OpeningViewState extends ConsumerState<OpeningView> {
  StreamSubscription<UiEvent>? _sub;


  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  ref.listen(openingViewModelProvider, (_, __) {
    final events = ref.read(openingViewModelProvider.notifier).events;
    // normalmente escucharías eventos de otra forma,
    // pero si mantienes Stream, el setup va fuera del initState
  });

  final state = ref.watch(openingViewModelProvider);
  final vm = ref.read(openingViewModelProvider.notifier);
    return LoadingOverlay(
      visible: state.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Apertura de caja')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OpeningAmountCard(
                  openingCashClp: state.openingCashClp,
                  dayStatus: state.dayStatus,
                  onTapAmount: vm.openKeyboard,
                ),
                const SizedBox(height: 12),
                OpeningKeyboardSheet(
                  visible: state.keyboardVisible,
                  onDigit: vm.onDigit,
                  onBackspace: vm.backspace,
                  onClear: vm.clearAmount,
                  onDone: vm.closeKeyboard,
                ),
                const Spacer(),
                // Sticky bottom bar (acción principal siempre visible)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                        state.isLoading || state.dayStatus == DayStatus.unknown
                        ? null
                        : vm.submit,
                    child: const SizedBox(
                      height: 56,
                      child: Center(child: Text('Abrir caja')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
