import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playa/features/opening/presentation/opening_view_model.dart';

import '../../opening/domain/day_status.dart';
import '../../opening/domain/usecases/get_day_status_use_case.dart';
import '../../../shared/utils/business_day.dart';
import '../../../shared/widgets/ui_event.dart';
import '../domain/entities/expense_category.dart';
import '../domain/usecases/get_expense_categories_use_case.dart';
import '../domain/usecases/register_expense_use_case.dart';
import 'expenses_state.dart';
import 'expenses_providers.dart';

final expensesViewModelProvider =
    NotifierProvider<ExpensesViewModel, ExpensesState>(
        ExpensesViewModel.new);

class ExpensesViewModel extends Notifier<ExpensesState> {
  late final StreamController<UiEvent> _events;
  Stream<UiEvent> get events => _events.stream;

  GetExpenseCategoriesUseCase get _getCategories =>
      ref.read(getExpenseCategoriesUseCaseProvider);
  RegisterExpenseUseCase get _register =>
      ref.read(registerExpenseUseCaseProvider);
  GetDayStatusUseCase get _getDayStatus =>
      ref.read(getDayStatusUseCaseProvider);

  String get _userId => ref.read(currentUserIdProvider);

  @override
  ExpensesState build() {
    _events = StreamController<UiEvent>.broadcast();
    ref.onDispose(() => _events.close());
    return ExpensesState.initial();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    final day = businessDayFrom(DateTime.now());
    final status = await _getDayStatus(businessDay: day);
    final categories = await _getCategories();

    state = state.copyWith(
      isLoading: false,
      dayStatus: status,
      categories: categories,
    );
  }

  void selectCategory(ExpenseCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void openKeyboard() =>
      state = state.copyWith(keyboardVisible: true);
  void closeKeyboard() =>
      state = state.copyWith(keyboardVisible: false);

  void onDigit(String d) {
    final next = int.tryParse('${state.amountClp}$d') ?? state.amountClp;
    state = state.copyWith(amountClp: next);
  }

  void backspace() {
    final s = state.amountClp.toString();
    state = state.copyWith(
      amountClp: s.length <= 1 ? 0 : int.parse(s.substring(0, s.length - 1)),
    );
  }

  void clearAmount() => state = state.copyWith(amountClp: 0);

  void changeNote(String v) => state = state.copyWith(note: v);

  void confirmSensitive() {
    _doRegister();
}

  Future<void> submit() async {
    final day = businessDayFrom(DateTime.now());
    final latestStatus = await _getDayStatus(businessDay: day);
    state = state.copyWith(dayStatus: latestStatus);
    if (state.dayStatus != DayStatus.open) {
      _events.add(
        const ShowSnack('Debe abrir caja antes de operar', SnackType.error),
      );
      return;
    }

    if (state.selectedCategory == null) {
      _events.add(
        const ShowSnack('Seleccione una categoría', SnackType.error),
      );
      return;
    }

    if (state.amountClp <= 0) {
      _events.add(
        const ShowSnack('Monto inválido', SnackType.error),
      );
      return;
    }

    // Copy obligatorio
    _events.add(
      const ShowSnack('Retiro ≠ Gasto', SnackType.info),
    );

    // Categoría sensible → confirmación
    if (state.selectedCategory!.sensitive) {
      _events.add(
        const ShowDialogEvent(
          title: 'Confirmar gasto sensible',
          message: 'Este gasto es sensible. ¿Desea continuar?',
        ),
      );
      return;
    }

    await _doRegister();
  }

  Future<void> _doRegister() async {
    final day = businessDayFrom(DateTime.now());
    final latestStatus = await _getDayStatus(businessDay: day);
    state = state.copyWith(dayStatus: latestStatus);
    if (state.dayStatus != DayStatus.open) {
      _events.add(
        const ShowSnack('Debe abrir caja antes de operar', SnackType.error),
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      await _register(
        businessDay: day,
        categoryId: state.selectedCategory!.id,
        amountClp: state.amountClp,
        paymentMethod: state.paymentMethod,
        note: state.note,
        userId: _userId,
      );

      state = ExpensesState.initial().copyWith(
        dayStatus: DayStatus.open,
        categories: state.categories,
      );

      _events.add(const ShowSnack('Gasto registrado', SnackType.success));
    } catch (_) {
      state = state.copyWith(isLoading: false);
      _events.add(const ShowSnack('Día cerrado', SnackType.error));
    }
  }
}
