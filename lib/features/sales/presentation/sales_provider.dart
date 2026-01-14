import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sales_repository_sqlite.dart';
import '../domain/repositories/sales_repository.dart';
import '../domain/usecases/get_products_use_case.dart';
import '../domain/usecases/register_sale_use_case.dart';

/// Repository
final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  return SalesRepositorySqlite();
});

/// UseCases
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.read(salesRepositoryProvider));
});

final registerSaleUseCaseProvider =
    Provider<RegisterSaleUseCase>((ref) {
  return RegisterSaleUseCase(ref.read(salesRepositoryProvider));
});
