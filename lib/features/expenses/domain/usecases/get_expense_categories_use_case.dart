import '../entities/expense_category.dart';
import '../repositories/expenses_repository.dart';

class GetExpenseCategoriesUseCase {
  final ExpensesRepository repo;
  GetExpenseCategoriesUseCase(this.repo);

  Future<List<ExpenseCategory>> call() {
    return repo.getActiveCategories();
  }
}
