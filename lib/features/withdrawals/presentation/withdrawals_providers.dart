import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/withdrawals_repository_sqlite.dart';
import '../domain/repositories/withdrawals_repository.dart';
import '../domain/usecases/get_withdrawal_reasons_use_case.dart';
import '../domain/usecases/register_withdrawal_use_case.dart';

final withdrawalsRepositoryProvider =
    Provider<WithdrawalsRepository>((ref) {
  return WithdrawalsRepositorySqlite();
});

final getWithdrawalReasonsUseCaseProvider =
    Provider<GetWithdrawalReasonsUseCase>((ref) {
  return GetWithdrawalReasonsUseCase(
    ref.read(withdrawalsRepositoryProvider),
  );
});

final registerWithdrawalUseCaseProvider =
    Provider<RegisterWithdrawalUseCase>((ref) {
  return RegisterWithdrawalUseCase(
    ref.read(withdrawalsRepositoryProvider),
  );
});
