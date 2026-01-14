import '../repositories/closure_repository.dart';

class CloseDayUseCase {
  final ClosureRepository repo;
  CloseDayUseCase(this.repo);

  Future<void> call({
    required String businessDay,
    required int cashExpected,
    required int cashCounted,
    required int difference,
    required String userId,
  }) {
    return repo.closeDay(
      businessDay: businessDay,
      cashExpected: cashExpected,
      cashCounted: cashCounted,
      difference: difference,
      userId: userId,
    );
  }
}
