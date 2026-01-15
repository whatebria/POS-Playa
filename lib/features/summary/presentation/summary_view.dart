import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/money_text.dart';
import '../../../shared/widgets/ui_event.dart';
import '../../opening/domain/day_status.dart';
import '../../sales/domain/enums/payment_method.dart';
import 'summary_view_model.dart';
import 'widgets/summary_card.dart';

class SummaryView extends ConsumerStatefulWidget {
  final bool isActive;

  const SummaryView({
    super.key,
    required this.isActive,
  });

  @override
  ConsumerState<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends ConsumerState<SummaryView> {
  StreamSubscription<UiEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    if (widget.isActive) {
      Future.microtask(
        () => ref.read(summaryViewModelProvider.notifier).init(),
      );
    }

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
            ? Center(
                child: Text(
                  switch (state.dayStatus) {
                    DayStatus.closed => 'Día cerrado',
                    DayStatus.open => 'Sin movimientos',
                    DayStatus.unknown => 'Día no abierto',
                  },
                ),
              )
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.3,
                      ),
                      delegate: SliverChildListDelegate(
                        [
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
                            title: 'Esperado',
                            amountClp: state.summary!.cashExpected,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Ventas registradas',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  if (state.sales.isEmpty)
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                      sliver: SliverToBoxAdapter(
                        child: Text('Sin ventas registradas'),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final sale = state.sales[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: MoneyText(
                                  amountIntClp: sale.totalClp,
                                  size: 18,
                                  emphasis: true,
                                ),
                                subtitle: Text(
                                  '${sale.paymentMethod.label} • ${_formatTime(sale.createdAt)}',
                                ),
                              ),
                            );
                          },
                          childCount: state.sales.length,
                        ),
                      ),
                    ),
                ],
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

  @override
  void didUpdateWidget(covariant SummaryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      Future.microtask(
        () => ref.read(summaryViewModelProvider.notifier).init(),
      );
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
