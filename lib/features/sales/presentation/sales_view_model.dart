import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playa/features/opening/presentation/opening_view_model.dart';
import 'package:playa/features/sales/presentation/sales_provider.dart';


import '../../opening/domain/day_status.dart';
import '../../opening/domain/usecases/get_day_status_use_case.dart';
import '../../../shared/utils/business_day.dart';
import '../../../shared/widgets/ui_event.dart';
import '../domain/entities/product.dart';
import '../domain/entities/sale_item.dart';
import '../domain/enums/payment_method.dart';
import '../domain/usecases/get_products_use_case.dart';
import '../domain/usecases/register_sale_use_case.dart';
import 'sales_state.dart';

final salesViewModelProvider =
    NotifierProvider<SalesViewModel, SalesState>(SalesViewModel.new);

class SalesViewModel extends Notifier<SalesState> {
  late final StreamController<UiEvent> _events;
Stream<UiEvent> get events => _events.stream;

  GetProductsUseCase get _getProducts => ref.read(getProductsUseCaseProvider);
  RegisterSaleUseCase get _registerSale =>
      ref.read(registerSaleUseCaseProvider);
  GetDayStatusUseCase get _getDayStatus =>
      ref.read(getDayStatusUseCaseProvider);

  String get _userId => ref.read(currentUserIdProvider);

@override
SalesState build() {
  _events = StreamController<UiEvent>.broadcast();

  ref.onDispose(() {
    _events.close();
  });

  return SalesState.initial();
}
  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    final day = businessDayFrom(DateTime.now());
    final status = await _getDayStatus(businessDay: day);
    final products = await _getProducts();

    state = state.copyWith(
      isLoading: false,
      dayStatus: status,
      products: products,
    );
  }

  void selectProduct(Product product) {
  state = state.copyWith(
    selectedItem: SaleItem(
      productId: product.id,
      unitPriceClp: product.priceClp,
      quantity: 1,
    ),
  );
}


  void changeQuantity(int qty) {
  if (state.selectedItem == null || qty <= 0) return;

  state = state.copyWith(
    selectedItem: SaleItem(
      productId: state.selectedItem!.productId,
      unitPriceClp: state.selectedItem!.unitPriceClp,
      quantity: qty,
    ),
  );
}

  void addSelectedToCart() {
    if (state.selectedItem == null) return;

    state = state.copyWith(
      cart: [...state.cart, state.selectedItem!],
      selectedItem: null,
    );
  }

  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<void> submit() async {
    final day = businessDayFrom(DateTime.now());
    final latestStatus = await _getDayStatus(businessDay: day);
    state = state.copyWith(dayStatus: latestStatus);
    if (state.dayStatus != DayStatus.open) {
      _events.add(
        const ShowSnack('Debe abrir caja antes de operar', SnackType.error),
      );
      return;
    }

    if (state.cart.isEmpty) {
      _events.add(
        const ShowSnack('No hay productos seleccionados', SnackType.info),
      );
      return;
    }

    if (state.paymentMethod == null) {
      _events.add(
        const ShowSnack('Seleccione un método de pago', SnackType.error),
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      await _registerSale(
        businessDay: day,
        items: state.cart,
        paymentMethod: state.paymentMethod!,
        totalClp: state.totalClp,
        userId: _userId,
      );

      state = SalesState.initial().copyWith(
        dayStatus: DayStatus.open,
        products: state.products,
      );

      _events.add(const ShowSnack('Venta registrada', SnackType.success));
    } catch (e) {
      state = state.copyWith(isLoading: false);
      _events.add(const ShowSnack('Día cerrado', SnackType.error));
    }
  }


}
