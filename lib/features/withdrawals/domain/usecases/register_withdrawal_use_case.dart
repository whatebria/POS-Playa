import 'package:playa/features/sales/domain/enums/payment_method.dart';

import '../repositories/withdrawals_repository.dart';

class RegisterWithdrawalUseCase {
  final WithdrawalsRepository repo;
  RegisterWithdrawalUseCase(this.repo);

  Future<void> call({
    required String businessDay,
    required String reasonId,
    required int amountClp,
    required PaymentMethod paymentMethod,
    String? note,
    required String userId,
  }) {
    return repo.registerWithdrawal(
      businessDay: businessDay,
      reasonId: reasonId,
      amountClp: amountClp,
      paymentMethod: paymentMethod,
      note: note,
      userId: userId,
    );
  }
}
