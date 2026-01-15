import 'package:playa/db/database.dart';

import '../domain/entities/daily_sale.dart';
import '../domain/entities/daily_summary.dart';
import '../domain/repositories/summary_repository.dart';
import '../../sales/domain/enums/payment_method.dart';

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

  @override
  Future<List<DailySale>> getDailySales({
    required String businessDay,
  }) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      'sales',
      columns: ['id', 'total', 'payment_method', 'created_at'],
      where: 'business_day = ?',
      whereArgs: [businessDay],
      orderBy: 'created_at ASC',
    );

    return rows.map((r) {
      final methodRaw = (r['payment_method'] as String?) ?? '';
      final createdRaw = (r['created_at'] as String?) ?? '';
      final createdAt = DateTime.tryParse(createdRaw) ??
          DateTime.fromMillisecondsSinceEpoch(0);

      return DailySale(
        id: r['id'] as String,
        totalClp: r['total'] as int,
        paymentMethod: methodRaw == 'CASH'
            ? PaymentMethod.cash
            : PaymentMethod.transfer,
        createdAt: createdAt,
      );
    }).toList();
  }

  @override
  Future<List<String>> getClosedBusinessDays() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      'daily_closures',
      columns: ['business_day'],
      orderBy: 'closed_at DESC',
    );

    return rows
        .map((r) => (r['business_day'] as String?) ?? '')
        .where((day) => day.isNotEmpty)
        .toList();
  }
}
