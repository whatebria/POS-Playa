import 'package:playa/features/sales/domain/entities/product.dart';

import '../entities/sale_item.dart';
import '../enums/payment_method.dart';

abstract class SalesRepository {
  Future<List<Product>> getActiveProducts();

  Future<void> registerSale({
    required String businessDay,
    required List<SaleItem> items,
    required PaymentMethod paymentMethod,
    required int totalClp,
    required String userId,
  });
}
