import '../opening_repository.dart';

class OpenCashDayUseCase {
  final OpeningRepository repo;

  OpenCashDayUseCase(this.repo);

  Future<void> call({
    required String businessDay,
    required int openingCashClp,
    required String openedByUserId,
    String? note,
  }) {
    return repo.createOpening(
      businessDay: businessDay,
      openingCashClp: openingCashClp,
      openedByUserId: openedByUserId,
      note: note,
    );
  }
}
