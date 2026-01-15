import '../entities/daily_summary.dart';
import '../entities/daily_sale.dart';

abstract class SummaryRepository {
  Future<DailySummary?> getDailySummary({
    required String businessDay,
  });

  Future<List<DailySale>> getDailySales({
    required String businessDay,
  });

  Future<List<String>> getClosedBusinessDays();
}
