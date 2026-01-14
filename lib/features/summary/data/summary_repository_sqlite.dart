import 'package:playa/db/database.dart';

import '../domain/entities/daily_summary.dart';
import '../domain/repositories/summary_repository.dart';

class SummaryRepositorySqlite implements SummaryRepository {
  @override
  Future<DailySummary?> getDailySummary({
    required String businessDay,
  }) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      'v_daily_summary',
      where: 'business_day = ?',
      whereArgs: [businessDay],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final r = rows.first;

    return DailySummary(
      businessDay: r['business_day'] as String,
      openingCash: r['opening_cash'] as int,

      salesCash: r['sales_cash'] as int,
      salesTransfer: r['sales_transfer'] as int,

      expensesCash: r['expenses_cash'] as int,
      expensesTransfer: r['expenses_transfer'] as int,

      withdrawalsCash: r['withdrawals_cash'] as int,
      withdrawalsTransfer: r['withdrawals_transfer'] as int,

      cashExpected: r['cash_expected'] as int,
    );
  }
}
