import 'package:playa/db/database.dart';
import 'package:sqflite/sqflite.dart';
import '../../../shared/utils/business_day.dart';
import '../domain/day_status.dart';
import '../domain/opening_repository.dart';

class OpeningRepositorySqlite implements OpeningRepository {
  @override
  Future<DayStatus> getDayStatus({required String businessDay}) async {
    final db = await AppDatabase.database;

    // closed?
    final closed = await db.query(
      'daily_closures',
      columns: ['business_day'],
      where: 'business_day = ?',
      whereArgs: [businessDay],
      limit: 1,
    );
    if (closed.isNotEmpty) return DayStatus.closed;

    // open?
    final opened = await db.query(
      'daily_openings',
      columns: ['business_day'],
      where: 'business_day = ?',
      whereArgs: [businessDay],
      limit: 1,
    );
    if (opened.isNotEmpty) return DayStatus.open;

    return DayStatus.unknown;
  }

  @override
  Future<void> createOpening({
    required String businessDay,
    required int openingCashClp,
    required String openedByUserId,
    String? note,
  }) async {
    final db = await AppDatabase.database;

    // Nota: reglas de “ya abierto” / “día cerrado” las controla el VM/UseCase,
    // pero igual protegemos por consistencia:
    final status = await getDayStatus(businessDay: businessDay);
    if (status == DayStatus.open) {
      throw OpeningFailure('Día ya abierto');
    }
    if (status == DayStatus.closed) {
      throw OpeningFailure('Día cerrado');
    }

    try {
      await db.insert(
        'daily_openings',
        {
          'business_day': businessDay,
          'opening_cash': openingCashClp,
          'opened_by_user_id': openedByUserId,
          'note': note,
          // opened_at tiene default
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      // si algo viene del motor, lo “humanizamos” arriba en el VM.
      throw OpeningFailure(e.toString());
    }
  }

  @override
  Future<void> reopenDay({
    required String businessDay,
  }) async {
    final db = await AppDatabase.database;
    await db.delete(
      'daily_closures',
      where: 'business_day = ?',
      whereArgs: [businessDay],
    );
  }
}

class OpeningFailure implements Exception {
  final String message;
  OpeningFailure(this.message);

  @override
  String toString() => message;
}

/// Helper opcional para obtener el businessDay actual (yyyy-MM-dd)
String currentBusinessDay() => businessDayFrom(DateTime.now());
