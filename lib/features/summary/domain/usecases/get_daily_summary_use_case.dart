import '../entities/daily_summary.dart';
import '../repositories/summary_repository.dart';

class GetDailySummaryUseCase {
  final SummaryRepository repo;
  GetDailySummaryUseCase(this.repo);

  Future<DailySummary?> call({required String businessDay}) {
    return repo.getDailySummary(businessDay: businessDay);
  }
}
