import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/ui_event.dart';
import 'sales_view_model.dart';
import 'widgets/product_grid.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/payment_method_selector.dart';
import 'widgets/sales_summary.dart';
import 'widgets/register_sale_button.dart';

class SalesView extends ConsumerStatefulWidget {
  const SalesView({super.key});

  @override
  ConsumerState<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends ConsumerState<SalesView> {
  StreamSubscription<UiEvent>? _sub;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(salesViewModelProvider.notifier).init());

    _sub = ref.read(salesViewModelProvider.notifier).events.listen((e) {
      if (!mounted) return;
      if (e is ShowSnack) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesViewModelProvider);
    final vm = ref.read(salesViewModelProvider.notifier);

    return LoadingOverlay(
      visible: state.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Ventas')),
        body: Column(
          children: [
            Expanded(
              child: ProductGrid(
                products: state.products,
                onSelected: vm.selectProduct,
              ),
            ),
            if (state.selectedItem != null)
              QuantitySelector(
                quantity: state.selectedItem!.quantity,
                onChange: vm.changeQuantity,
                onConfirm: vm.addSelectedToCart,
              ),
            PaymentMethodSelector(
              selected: state.paymentMethod,
              onSelected: vm.selectPaymentMethod,
            ),
            SalesSummary(totalClp: state.totalClp),
            RegisterSaleButton(
              enabled: !state.isLoading,
              onPressed: vm.submit,
            ),
          ],
        ),
      ),
    );
  }
}
