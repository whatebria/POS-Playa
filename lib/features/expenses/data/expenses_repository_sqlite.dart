import 'package:playa/db/database.dart';
import 'package:sqflite/sqflite.dart';

import '../../sales/domain/enums/payment_method.dart';
import '../domain/entities/expense_category.dart';
import '../domain/repositories/expenses_repository.dart';

class ExpensesRepositorySqlite implements ExpensesRepository {
  @override
  Future<List<ExpenseCategory>> getActiveCategories() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      'expense_categories',
      where: 'active = 1',
      orderBy: 'name ASC',
    );

    return rows
        .map(
          (r) => ExpenseCategory(
            id: r['id'] as String,
            name: r['name'] as String,
            sensitive: (r['sensitive'] as int) == 1,
          ),
        )
        .toList();
  }

  @override
  Future<void> registerExpense({
    required String businessDay,
    required String categoryId,
    required int amountClp,
    required PaymentMethod paymentMethod,
    String? note,
    required String userId,
  }) async {
    final db = await AppDatabase.database;

    try {
      await db.insert(
        'expenses',
        {
          'id': _uuid(),
          'business_day': businessDay,
          'category_id': categoryId,
          'amount': amountClp,
          'payment_method': _mapPayment(paymentMethod),
          'note': note,
          'created_by_user_id': userId,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      // Propagamos el mensaje del trigger tal cual
      throw Exception(e.toString());
    }
  }

  String _mapPayment(PaymentMethod method) {
    return method == PaymentMethod.cash ? 'CASH' : 'TRANSFER';
  }

  String _uuid() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
