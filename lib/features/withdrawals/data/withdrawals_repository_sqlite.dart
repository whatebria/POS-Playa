import 'package:playa/db/database.dart';
import 'package:sqflite/sqflite.dart';

import '../../sales/domain/enums/payment_method.dart';
import '../domain/entities/withdrawal_reason.dart';
import '../domain/repositories/withdrawals_repository.dart';

class WithdrawalsRepositorySqlite implements WithdrawalsRepository {
  @override
  Future<List<WithdrawalReason>> getActiveReasons() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      'withdrawal_reasons',
      where: 'active = 1',
      orderBy: 'name ASC',
    );

    return rows
        .map(
          (r) => WithdrawalReason(
            id: r['id'] as String,
            name: r['name'] as String,
          ),
        )
        .toList();
  }

  @override
  Future<void> registerWithdrawal({
    required String businessDay,
    required String reasonId,
    required int amountClp,
    required PaymentMethod paymentMethod,
    String? note,
    required String userId,
  }) async {
    final db = await AppDatabase.database;

    try {
      await db.insert(
        'withdrawals',
        {
          'id': _uuid(),
          'business_day': businessDay,
          'reason_id': reasonId,
          'amount': amountClp,
          'payment_method': _mapPayment(paymentMethod),
          'note': note,
          'created_by_user_id': userId,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      // triggers: día cerrado / no abierto
      throw Exception(e.toString());
    }
  }

  String _mapPayment(PaymentMethod m) =>
      m == PaymentMethod.cash ? 'CASH' : 'TRANSFER';

  String _uuid() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}
