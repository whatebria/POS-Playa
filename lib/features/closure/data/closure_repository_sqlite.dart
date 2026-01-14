import 'package:playa/db/database.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/repositories/closure_repository.dart';

class ClosureRepositorySqlite implements ClosureRepository {
  @override
  Future<int?> getCashExpected({
    required String businessDay,
  }) async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      'v_daily_summary',
      columns: ['cash_expected'],
      where: 'business_day = ?',
      whereArgs: [businessDay],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return rows.first['cash_expected'] as int;
  }

  @override
  Future<void> closeDay({
    required String businessDay,
    required int cashExpected,
    required int cashCounted,
    required int difference,
    required String userId,
  }) async {
    final db = await AppDatabase.database;

    try {
      await db.insert(
        'daily_closures',
        {
          'business_day': businessDay,
          'opening_cash': cashExpected - difference,
          'sales_cash': 0,
          'sales_transfer': 0,
          'expenses_cash': 0,
          'expenses_transfer': 0,
          'withdrawals_cash': 0,
          'withdrawals_transfer': 0,
          'cash_expected': cashExpected,
          'cash_counted': cashCounted,
          'difference': difference,
          'closed_by_user_id': userId,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
