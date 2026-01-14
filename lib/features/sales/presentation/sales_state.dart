import '../domain/entities/product.dart';
import '../domain/entities/sale_item.dart';
import '../domain/enums/payment_method.dart';
import '../../opening/domain/day_status.dart';

class SalesState {
  final bool isLoading;
  final String? errorMessage;

  final DayStatus dayStatus;

  final List<Product> products;
  final SaleItem? selectedItem;
  final List<SaleItem> cart;

  final PaymentMethod? paymentMethod;

  const SalesState({
    required this.isLoading,
    required this.errorMessage,
    required this.dayStatus,
    required this.products,
    required this.selectedItem,
    required this.cart,
    required this.paymentMethod,
  });

  factory SalesState.initial() => const SalesState(
        isLoading: false,
        errorMessage: null,
        dayStatus: DayStatus.unknown,
        products: [],
        selectedItem: null,
        cart: [],
        paymentMethod: null,
      );

  int get totalClp =>
      cart.fold(0, (sum, item) => sum + item.subtotalClp);

  SalesState copyWith({
    bool? isLoading,
    String? errorMessage,
    DayStatus? dayStatus,
    List<Product>? products,
    SaleItem? selectedItem,
    List<SaleItem>? cart,
    PaymentMethod? paymentMethod,
  }) {
    return SalesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dayStatus: dayStatus ?? this.dayStatus,
      products: products ?? this.products,
      selectedItem: selectedItem,
      cart: cart ?? this.cart,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
