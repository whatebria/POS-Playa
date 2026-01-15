import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playa/features/opening/presentation/opening_view_model.dart';

import '../../opening/domain/day_status.dart';
import '../../opening/domain/usecases/get_day_status_use_case.dart';
import '../../../shared/utils/business_day.dart';
import '../../../shared/widgets/ui_event.dart';
import '../domain/entities/withdrawal_reason.dart';
import '../domain/usecases/get_withdrawal_reasons_use_case.dart';
import '../domain/usecases/register_withdrawal_use_case.dart';
import 'withdrawals_state.dart';
import 'withdrawals_providers.dart';

final withdrawalsViewModelProvider =
    NotifierProvider<WithdrawalsViewModel, WithdrawalsState>(
        WithdrawalsViewModel.new);

class WithdrawalsViewModel extends Notifier<WithdrawalsState> {
  late final StreamController<UiEvent> _events;
  Stream<UiEvent> get events => _events.stream;

  GetWithdrawalReasonsUseCase get _getReasons =>
      ref.read(getWithdrawalReasonsUseCaseProvider);
  RegisterWithdrawalUseCase get _register =>
      ref.read(registerWithdrawalUseCaseProvider);
  GetDayStatusUseCase get _getDayStatus =>
      ref.read(getDayStatusUseCaseProvider);

  String get _userId => ref.read(currentUserIdProvider);

  @override
  WithdrawalsState build() {
    _events = StreamController<UiEvent>.broadcast();
    ref.onDispose(() => _events.close());
    return WithdrawalsState.initial();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    final day = businessDayFrom(DateTime.now());
    final status = await _getDayStatus(businessDay: day);
    final reasons = await _getReasons();

    state = state.copyWith(
      isLoading: false,
      dayStatus: status,
      reasons: reasons,
    );
  }

  void selectReason(WithdrawalReason r) =>
      state = state.copyWith(selectedReason: r);

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

    if (state.selectedReason == null) {
      _events.add(
        const ShowSnack('Seleccione una razón', SnackType.error),
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
      const ShowDialogEvent(
        title: 'Confirmar retiro',
        message: 'Retiro ≠ Gasto\n¿Desea continuar?',
      ),
    );
  }

  Future<void> confirm() async {
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
        reasonId: state.selectedReason!.id,
        amountClp: state.amountClp,
        paymentMethod: state.paymentMethod,
        note: state.note,
        userId: _userId,
      );

      state = WithdrawalsState.initial().copyWith(
        dayStatus: DayStatus.open,
        reasons: state.reasons,
      );

      _events.add(const ShowSnack('Retiro registrado', SnackType.success));
    } catch (_) {
      state = state.copyWith(isLoading: false);
      _events.add(const ShowSnack('Día cerrado', SnackType.error));
    }
  }
}
