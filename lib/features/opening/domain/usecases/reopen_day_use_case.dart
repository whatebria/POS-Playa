import '../opening_repository.dart';

class ReopenDayUseCase {
  final OpeningRepository repo;
  ReopenDayUseCase(this.repo);

  Future<void> call({
    required String businessDay,
  }) {
    return repo.reopenDay(businessDay: businessDay);
  }
}
