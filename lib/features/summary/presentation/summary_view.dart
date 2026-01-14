import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/ui_event.dart';
import 'summary_view_model.dart';
import 'widgets/summary_card.dart';

class SummaryView extends ConsumerStatefulWidget {
  const SummaryView({super.key});

  @override
  ConsumerState<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends ConsumerState<SummaryView> {
  StreamSubscription<UiEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => ref.read(summaryViewModelProvider.notifier).init(),
    );

    _subscription = ref
        .read(summaryViewModelProvider.notifier)
        .events
        .listen(_handleEvent);
  }

  void _handleEvent(UiEvent event) {
    if (!mounted) return;

    if (event is ShowSnack) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(event.message)));
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(summaryViewModelProvider);
    final vm = ref.read(summaryViewModelProvider.notifier);

    return LoadingOverlay(
      visible: state.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Resumen diario')),
        body: state.summary == null
            ? const Center(child: Text('Día cerrado'))
            : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    SummaryCard(
                      title: 'Ventas',
                      amountClp: state.summary!.salesCash +
                          state.summary!.salesTransfer,
                      color: Colors.green,
                    ),
                    SummaryCard(
                      title: 'Gastos',
                      amountClp: state.summary!.expensesCash +
                          state.summary!.expensesTransfer,
                      color: Colors.red,
                    ),
                    SummaryCard(
                      title: 'Retiros',
                      amountClp: state.summary!.withdrawalsCash +
                          state.summary!.withdrawalsTransfer,
                      color: Colors.orange,
                    ),
                    SummaryCard(
                      title: 'Efectivo esperado',
                      amountClp: state.summary!.cashExpected,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 72,
            child: FilledButton(
              onPressed: vm.exportExcel,
              child: const Text(
                'Exportar',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
