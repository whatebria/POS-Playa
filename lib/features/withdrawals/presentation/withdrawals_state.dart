import '../../opening/domain/day_status.dart';
import '../../sales/domain/enums/payment_method.dart';
import '../domain/entities/withdrawal_reason.dart';

class WithdrawalsState {
  static const _sentinel = Object();

  final bool isLoading;
  final String? errorMessage;

  final DayStatus dayStatus;

  final List<WithdrawalReason> reasons;
  final WithdrawalReason? selectedReason;

  final int amountClp;
  final PaymentMethod paymentMethod;
  final String note;

  final bool keyboardVisible;

  const WithdrawalsState({
    required this.isLoading,
    required this.errorMessage,
    required this.dayStatus,
    required this.reasons,
    required this.selectedReason,
    required this.amountClp,
    required this.paymentMethod,
    required this.note,
    required this.keyboardVisible,
  });

  factory WithdrawalsState.initial() => const WithdrawalsState(
        isLoading: false,
        errorMessage: null,
        dayStatus: DayStatus.unknown,
        reasons: [],
        selectedReason: null,
        amountClp: 0,
        paymentMethod: PaymentMethod.cash,
        note: '',
        keyboardVisible: false,
      );

  WithdrawalsState copyWith({
    bool? isLoading,
    String? errorMessage,
    DayStatus? dayStatus,
    List<WithdrawalReason>? reasons,
    Object? selectedReason = _sentinel,
    int? amountClp,
    PaymentMethod? paymentMethod,
    String? note,
    bool? keyboardVisible,
  }) {
    return WithdrawalsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dayStatus: dayStatus ?? this.dayStatus,
      reasons: reasons ?? this.reasons,
      selectedReason: selectedReason == _sentinel
          ? this.selectedReason
          : selectedReason as WithdrawalReason?,
      amountClp: amountClp ?? this.amountClp,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      keyboardVisible: keyboardVisible ?? this.keyboardVisible,
    );
  }
}
