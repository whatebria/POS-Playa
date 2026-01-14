import '../../opening/domain/day_status.dart';

class ClosureState {
  final bool isLoading;
  final String? errorMessage;

  final DayStatus dayStatus;

  final int cashExpected;
  final int cashCounted;

  final bool keyboardVisible;

  const ClosureState({
    required this.isLoading,
    required this.errorMessage,
    required this.dayStatus,
    required this.cashExpected,
    required this.cashCounted,
    required this.keyboardVisible,
  });

  factory ClosureState.initial() => const ClosureState(
        isLoading: false,
        errorMessage: null,
        dayStatus: DayStatus.unknown,
        cashExpected: 0,
        cashCounted: 0,
        keyboardVisible: false,
      );

  int get difference => cashCounted - cashExpected;

  ClosureState copyWith({
    bool? isLoading,
    String? errorMessage,
    DayStatus? dayStatus,
    int? cashExpected,
    int? cashCounted,
    bool? keyboardVisible,
  }) {
    return ClosureState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dayStatus: dayStatus ?? this.dayStatus,
      cashExpected: cashExpected ?? this.cashExpected,
      cashCounted: cashCounted ?? this.cashCounted,
      keyboardVisible: keyboardVisible ?? this.keyboardVisible,
    );
  }
}
