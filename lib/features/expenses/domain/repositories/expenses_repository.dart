import 'package:playa/features/sales/domain/enums/payment_method.dart';

import '../entities/expense_category.dart';

abstract class ExpensesRepository {
  Future<List<ExpenseCategory>> getActiveCategories();

  Future<void> registerExpense({
    required String businessDay,
    required String categoryId,
    required int amountClp,
    required PaymentMethod paymentMethod,
    String? note,
    required String userId,
  });
}
