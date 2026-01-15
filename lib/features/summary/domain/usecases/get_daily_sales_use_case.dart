import '../entities/daily_sale.dart';
import '../repositories/summary_repository.dart';

class GetDailySalesUseCase {
  final SummaryRepository repo;
  GetDailySalesUseCase(this.repo);

  Future<List<DailySale>> call({required String businessDay}) {
    return repo.getDailySales(businessDay: businessDay);
  }
}
