import 'package:playa/features/sales/domain/enums/payment_method.dart';

import '../repositories/expenses_repository.dart';

class RegisterExpenseUseCase {
  final ExpensesRepository repo;
  RegisterExpenseUseCase(this.repo);

  Future<void> call({
    required String businessDay,
    required String categoryId,
    required int amountClp,
    required PaymentMethod paymentMethod,
    String? note,
    required String userId,
  }) {
    return repo.registerExpense(
      businessDay: businessDay,
      categoryId: categoryId,
      amountClp: amountClp,
      paymentMethod: paymentMethod,
      note: note,
      userId: userId,
    );
  }
}
