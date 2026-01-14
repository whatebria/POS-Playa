import 'package:playa/features/sales/domain/enums/payment_method.dart';

import '../entities/withdrawal_reason.dart';

abstract class WithdrawalsRepository {
  Future<List<WithdrawalReason>> getActiveReasons();

  Future<void> registerWithdrawal({
    required String businessDay,
    required String reasonId,
    required int amountClp,
    required PaymentMethod paymentMethod,
    String? note,
    required String userId,
  });
}
