import '../repositories/summary_repository.dart';

class GetClosedBusinessDaysUseCase {
  final SummaryRepository repo;

  GetClosedBusinessDaysUseCase(this.repo);

  Future<List<String>> call() {
    return repo.getClosedBusinessDays();
  }
}
