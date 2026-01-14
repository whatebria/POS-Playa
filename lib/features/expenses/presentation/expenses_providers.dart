import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/expenses_repository_sqlite.dart';
import '../domain/repositories/expenses_repository.dart';
import '../domain/usecases/get_expense_categories_use_case.dart';
import '../domain/usecases/register_expense_use_case.dart';

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  return ExpensesRepositorySqlite();
});

final getExpenseCategoriesUseCaseProvider =
    Provider<GetExpenseCategoriesUseCase>((ref) {
  return GetExpenseCategoriesUseCase(ref.read(expensesRepositoryProvider));
});

final registerExpenseUseCaseProvider =
    Provider<RegisterExpenseUseCase>((ref) {
  return RegisterExpenseUseCase(ref.read(expensesRepositoryProvider));
});
