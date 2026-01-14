import '../entities/sale_item.dart';
import '../enums/payment_method.dart';
import '../repositories/sales_repository.dart';

class RegisterSaleUseCase {
  final SalesRepository repo;
  RegisterSaleUseCase(this.repo);

  Future<void> call({
    required String businessDay,
    required List<SaleItem> items,
    required PaymentMethod paymentMethod,
    required int totalClp,
    required String userId,
  }) {
    return repo.registerSale(
      businessDay: businessDay,
      items: items,
      paymentMethod: paymentMethod,
      totalClp: totalClp,
      userId: userId,
    );
  }
}
