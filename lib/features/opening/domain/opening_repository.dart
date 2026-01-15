import 'day_status.dart';

abstract class OpeningRepository {
  Future<DayStatus> getDayStatus({required String businessDay});

  Future<void> createOpening({
    required String businessDay,
    required int openingCashClp,
    required String openedByUserId,
    String? note,
  });

  Future<void> reopenDay({
    required String businessDay,
  });
}
