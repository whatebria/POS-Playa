import '../repositories/sales_repository.dart';
import '../entities/product.dart';

class GetProductsUseCase {
  final SalesRepository repo;
  GetProductsUseCase(this.repo);

  Future<List<Product>> call() {
    return repo.getActiveProducts();
  }
}
