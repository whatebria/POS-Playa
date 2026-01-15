import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playa/features/closure/domain/usecases/close_day_use_case.dart';
import 'package:playa/features/closure/domain/usecases/get_cash_expected_use_case.dart';
import 'package:playa/features/opening/presentation/opening_view_model.dart';

import '../../opening/domain/day_status.dart';
import '../../opening/domain/usecases/get_day_status_use_case.dart';
import '../../../shared/utils/business_day.dart';
import '../../../shared/widgets/ui_event.dart';
import 'closure_state.dart';
import 'closure_providers.dart';

final closureViewModelProvider =
    NotifierProvider<ClosureViewModel, ClosureState>(
        ClosureViewModel.new);

class ClosureViewModel extends Notifier<ClosureState> {
  late final StreamController<UiEvent> _events;
  Stream<UiEvent> get events => _events.stream;

  GetCashExpectedUseCase get _getCashExpected =>
      ref.read(getCashExpectedUseCaseProvider);
  CloseDayUseCase get _closeDay =>
      ref.read(closeDayUseCaseProvider);
  GetDayStatusUseCase get _getDayStatus =>
      ref.read(getDayStatusUseCaseProvider);

  String get _userId => ref.read(currentUserIdProvider);

  @override
  ClosureState build() {
    _events = StreamController<UiEvent>.broadcast();
    ref.onDispose(() => _events.close());
    return ClosureState.initial();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    final day = businessDayFrom(DateTime.now());
    final status = await _getDayStatus(businessDay: day);

    if (status != DayStatus.open) {
      state = state.copyWith(
        isLoading: false,
        dayStatus: status,
      );
      return;
    }

    final expected = await _getCashExpected(businessDay: day);

    state = state.copyWith(
      isLoading: false,
      dayStatus: status,
      cashExpected: expected ?? 0,
    );
  }

  void openKeyboard() =>
      state = state.copyWith(keyboardVisible: true);
  void closeKeyboard() =>
      state = state.copyWith(keyboardVisible: false);

  void onDigit(String d) {
    final next =
        int.tryParse('${state.cashCounted}$d') ?? state.cashCounted;
    state = state.copyWith(cashCounted: next);
  }

  void backspace() {
    final s = state.cashCounted.toString();
    state = state.copyWith(
      cashCounted: s.length <= 1 ? 0 : int.parse(s.substring(0, s.length - 1)),
    );
  }

  void clearAmount() =>
      state = state.copyWith(cashCounted: 0);

  Future<void> submit() async {
    if (state.dayStatus != DayStatus.open) {
      _events.add(
        const ShowSnack('Día cerrado', SnackType.error),
      );
      return;
    }

    _events.add(
      ShowDialogEvent(
        title: 'Cerrar caja',
        message:
            'Efectivo esperado: ${state.cashExpected}\n'
            'Efectivo contado: ${state.cashCounted}\n'
            'Diferencia: ${state.difference}\n\n'
            '¿Desea cerrar la caja?',
      ),
    );
  }

  Future<void> confirmClose() async {
    state = state.copyWith(isLoading: true);

    try {
      await _closeDay(
        businessDay: businessDayFrom(DateTime.now()),
        cashExpected: state.cashExpected,
        cashCounted: state.cashCounted,
        difference: state.difference,
        userId: _userId,
      );

      state = state.copyWith(
        isLoading: false,
        dayStatus: DayStatus.closed,
      );
      _events.add(
        const ShowSnack('Caja cerrada correctamente', SnackType.success),
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
      _events.add(
        const ShowSnack('Error al cerrar caja', SnackType.error),
      );
    }
  }
}
