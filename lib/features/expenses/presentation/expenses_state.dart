import '../../opening/domain/day_status.dart';
import '../domain/entities/expense_category.dart';
import '../../sales/domain/enums/payment_method.dart';

class ExpensesState {
  final bool isLoading;
  final String? errorMessage;

  final DayStatus dayStatus;

  final List<ExpenseCategory> categories;
  final ExpenseCategory? selectedCategory;

  final int amountClp;
  final PaymentMethod paymentMethod;
  final String note;

  final bool keyboardVisible;

  const ExpensesState({
    required this.isLoading,
    required this.errorMessage,
    required this.dayStatus,
    required this.categories,
    required this.selectedCategory,
    required this.amountClp,
    required this.paymentMethod,
    required this.note,
    required this.keyboardVisible,
  });

  factory ExpensesState.initial() => const ExpensesState(
        isLoading: false,
        errorMessage: null,
        dayStatus: DayStatus.unknown,
        categories: [],
        selectedCategory: null,
        amountClp: 0,
        paymentMethod: PaymentMethod.cash,
        note: '',
        keyboardVisible: false,
      );

  ExpensesState copyWith({
    bool? isLoading,
    String? errorMessage,
    DayStatus? dayStatus,
    List<ExpenseCategory>? categories,
    ExpenseCategory? selectedCategory,
    int? amountClp,
    PaymentMethod? paymentMethod,
    String? note,
    bool? keyboardVisible,
  }) {
    return ExpensesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dayStatus: dayStatus ?? this.dayStatus,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory,
      amountClp: amountClp ?? this.amountClp,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      keyboardVisible: keyboardVisible ?? this.keyboardVisible,
    );
  }
}
