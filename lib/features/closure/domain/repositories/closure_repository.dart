abstract class ClosureRepository {
  Future<int?> getCashExpected({
    required String businessDay,
  });

  Future<void> closeDay({
    required String businessDay,
    required int cashExpected,
    required int cashCounted,
    required int difference,
    required String userId,
  });
}
