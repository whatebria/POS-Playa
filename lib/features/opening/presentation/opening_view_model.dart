import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:riverpod/riverpod.dart';

import '../../../shared/utils/business_day.dart';
import '../../../shared/widgets/ui_event.dart';
import '../domain/day_status.dart';
import '../domain/opening_repository.dart';
import '../domain/usecases/get_day_status_use_case.dart';
import '../domain/usecases/open_cash_day_use_case.dart';
import '../domain/usecases/reopen_day_use_case.dart';
import 'opening_state.dart';
import '../data/opening_repository_sqlite.dart';

/// Providers (DI)
final openingRepositoryProvider = Provider<OpeningRepository>((ref) {
  return OpeningRepositorySqlite();
});

final getDayStatusUseCaseProvider = Provider<GetDayStatusUseCase>((ref) {
  return GetDayStatusUseCase(ref.watch(openingRepositoryProvider));
});

final openCashDayUseCaseProvider = Provider<OpenCashDayUseCase>((ref) {
  return OpenCashDayUseCase(ref.watch(openingRepositoryProvider));
});

final reopenDayUseCaseProvider = Provider<ReopenDayUseCase>((ref) {
  return ReopenDayUseCase(ref.watch(openingRepositoryProvider));
});

/// En una app real, esto viene de auth/session.
final currentUserIdProvider = Provider<String>((ref) => 'USER_DEMO');

final openingViewModelProvider =
    NotifierProvider<OpeningViewModel, OpeningState>(OpeningViewModel.new);

class OpeningViewModel extends Notifier<OpeningState> {
  final _events = StreamController<UiEvent>.broadcast();
  Stream<UiEvent> get events => _events.stream;

  GetDayStatusUseCase get _getStatus => ref.read(getDayStatusUseCaseProvider);
  OpenCashDayUseCase get _openDay => ref.read(openCashDayUseCaseProvider);
  ReopenDayUseCase get _reopenDay => ref.read(reopenDayUseCaseProvider);
  String get _userId => ref.read(currentUserIdProvider);

  @override
  OpeningState build() {
    // ✅ Riverpod Notifier: cleanup aquí, no con override dispose()
    ref.onDispose(() {
      _events.close();
    });

      final initial = OpeningState.initial();
      // Defer async work until after the initial state is set.
      Future.microtask(_loadDayStatus);
      return initial;
  }

  Future<void> _loadDayStatus() async {
  state = state.copyWith(isLoading: true, errorMessage: null);

  try {
    final day = businessDayFrom(DateTime.now());
    final status = await _getStatus(businessDay: day);

    state = state.copyWith(
      isLoading: false,
      dayStatus: status,
    );
  } catch (_) {
    state = state.copyWith(isLoading: false);
    _events.add(
      const ShowSnack(
        'Error al cargar estado del día',
        SnackType.error,
      ),
    );
  }
}

  void openKeyboard() => state = state.copyWith(keyboardVisible: true);
  void closeKeyboard() => state = state.copyWith(keyboardVisible: false);

  void clearAmount() => state = state.copyWith(openingCashClp: 0);

  void onDigit(String digit) {
    // No cálculos de negocio, solo composición de input int con dígitos (UI input)
    final current = state.openingCashClp;
    final next = int.tryParse('$current$digit') ?? current;
    state = state.copyWith(openingCashClp: next);
  }

  void backspace() {
    final s = state.openingCashClp.toString();
    if (s.length <= 1) {
      state = state.copyWith(openingCashClp: 0);
      return;
    }
    state = state.copyWith(
      openingCashClp: int.parse(s.substring(0, s.length - 1)),
    );
  }

  Future<void> submit() async {
    final day = businessDayFrom(DateTime.now());
    final latestStatus = await _getStatus(businessDay: day);
    state = state.copyWith(dayStatus: latestStatus);
    print('🟡 submit con dayStatus = ${state.dayStatus}');

    // validaciones de flujo (obligatorias)
    if (state.dayStatus == DayStatus.open) {
      _events.add(const ShowSnack('Día ya abierto', SnackType.info));
      return;
    }
    if (state.dayStatus == DayStatus.closed) {
      _events.add(const ShowSnack('Día cerrado', SnackType.error));
      return;
    }

    // validación de monto (Opening permite 0 o más)
    if (state.openingCashClp < 0) {
      _events.add(const ShowSnack('Monto inválido', SnackType.error));
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _openDay(
        businessDay: day,
        openingCashClp: state.openingCashClp,
        openedByUserId: _userId,
      );

      state = state.copyWith(isLoading: false, dayStatus: DayStatus.open);
      _events.add(const ShowSnack('Caja abierta', SnackType.success));
      _events.add(const Navigate('/sales'));
    } catch (e) {
      final msg = _mapError(e);
      final raw = e.toString();
      state = state.copyWith(isLoading: false, errorMessage: msg);
      final shown =
          msg == 'Error al abrir caja' ? 'Error al abrir caja: $raw' : msg;
      _events.add(ShowSnack(shown, SnackType.error));
    }
  }

  String _mapError(Object e) {
    final raw = e.toString();

    // Mensajería estándar solicitada
    if (raw.contains('Día cerrado')) return 'Día cerrado';
    if (raw.contains('Debe abrir caja antes de operar')) {
      return 'Debe abrir caja antes de operar';
    }
    if (raw.contains('Día ya abierto')) return 'Día ya abierto';

    return 'Error al abrir caja';
  }

  Future<void> reopenDay() async {
    final day = businessDayFrom(DateTime.now());
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _reopenDay(businessDay: day);
      final status = await _getStatus(businessDay: day);
      state = state.copyWith(isLoading: false, dayStatus: status);
      _events.add(const ShowSnack('Dia reabierto (debug)', SnackType.info));
    } catch (e) {
      state = state.copyWith(isLoading: false);
      _events.add(
        ShowSnack('Error al reabrir dia (debug): $e', SnackType.error),
      );
    }
  }
}
