import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/money_text.dart';
import '../../sales/domain/enums/payment_method.dart';
import 'history_state.dart';
import 'history_view_model.dart';

class HistoryView extends ConsumerStatefulWidget {
  final bool isActive;

  const HistoryView({
    super.key,
    required this.isActive,
  });

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      Future.microtask(
        () => ref.read(historyViewModelProvider.notifier).init(),
      );
    }
  }

  @override
  void didUpdateWidget(covariant HistoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      Future.microtask(
        () => ref.read(historyViewModelProvider.notifier).init(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyViewModelProvider);
    final vm = ref.read(historyViewModelProvider.notifier);

    return LoadingOverlay(
      visible: state.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Historial')),
        body: state.errorMessage != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage!),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: vm.init,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
            : state.history.isEmpty
                ? const Center(child: Text('Sin dias cerrados'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      final item = state.history[index];
                      final summary = item.summary;
                      final sales = item.sales;
                      final totalSales =
                          summary.salesCash + summary.salesTransfer;

                      return Card(
                        margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: ExpansionTile(
                          title: Text(summary.businessDay),
                          subtitle: Row(
                            children: [
                              const Text('Ventas: '),
                              MoneyText(
                                amountIntClp: totalSales,
                                size: 16,
                                emphasis: true,
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 8, 16, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _summaryRow(
                                    label: 'Ventas',
                                    amount: totalSales,
                                    color: Colors.green,
                                  ),
                                  _summaryRow(
                                    label: 'Gastos',
                                    amount: summary.expensesCash +
                                        summary.expensesTransfer,
                                    color: Colors.red,
                                  ),
                                  _summaryRow(
                                    label: 'Retiros',
                                    amount: summary.withdrawalsCash +
                                        summary.withdrawalsTransfer,
                                    color: Colors.orange,
                                  ),
                                  _summaryRow(
                                    label: 'Esperado',
                                    amount: summary.cashExpected,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(),
                                  Text(
                                    'Ventas registradas',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  if (sales.isEmpty)
                                    const Text('Sin ventas registradas')
                                  else
                                    ...sales.map(
                                      (sale) => ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        title: MoneyText(
                                          amountIntClp: sale.totalClp,
                                          size: 16,
                                          emphasis: true,
                                        ),
                                        subtitle: Text(
                                          '${sale.paymentMethod.label} - ${_formatTime(sale.createdAt)}',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _summaryRow({
    required String label,
    required int amount,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color)),
          MoneyText(
            amountIntClp: amount,
            size: 16,
            emphasis: true,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
