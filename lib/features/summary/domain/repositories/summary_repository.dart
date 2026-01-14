import '../entities/daily_summary.dart';

abstract class SummaryRepository {
  Future<DailySummary?> getDailySummary({
    required String businessDay,
  });
}
