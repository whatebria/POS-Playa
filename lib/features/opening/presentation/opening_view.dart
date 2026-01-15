import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  void initState() {
    super.initState();
    _sub = ref
        .read(openingViewModelProvider.notifier)
        .events
        .listen(_handleEvent);
  }

  void _handleEvent(UiEvent event) {
    if (!mounted) return;

    switch (event) {
      case ShowSnack():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(event.message)),
        );
        break;
      case Navigate():
        Navigator.of(context).pushNamed(event.route);
        break;
      case ShowDialogEvent():
        // No dialogs here for now.
        break;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const enableDebugReopenButton = true;
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
                    onPressed: state.isLoading ? null : vm.submit,
                    child: const SizedBox(
                      height: 56,
                      child: Center(child: Text('Abrir caja')),
                    ),
                  ),
                ),
                if (enableDebugReopenButton) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: state.isLoading ? null : vm.reopenDay,
                      child: const Text('Reabrir dia (debug)'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
