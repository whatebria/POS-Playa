import '../domain/day_status.dart';

class OpeningState {
  final bool isLoading;
  final String? errorMessage;

  final DayStatus dayStatus;

  // input montos CLP (int) – se arma con teclado numérico
  final int openingCashClp;

  // UI-only flags (permitido)
  final bool keyboardVisible;

  const OpeningState({
    required this.isLoading,
    required this.errorMessage,
    required this.dayStatus,
    required this.openingCashClp,
    required this.keyboardVisible,
  });

  factory OpeningState.initial() => const OpeningState(
        isLoading: false,
        errorMessage: null,
        dayStatus: DayStatus.unknown,
        openingCashClp: 0,
        keyboardVisible: false,
      );

  OpeningState copyWith({
    bool? isLoading,
    String? errorMessage,
    DayStatus? dayStatus,
    int? openingCashClp,
    bool? keyboardVisible,
  }) {
    return OpeningState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dayStatus: dayStatus ?? this.dayStatus,
      openingCashClp: openingCashClp ?? this.openingCashClp,
      keyboardVisible: keyboardVisible ?? this.keyboardVisible,
    );
  }
}
