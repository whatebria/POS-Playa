import '../entities/withdrawal_reason.dart';
import '../repositories/withdrawals_repository.dart';

class GetWithdrawalReasonsUseCase {
  final WithdrawalsRepository repo;
  GetWithdrawalReasonsUseCase(this.repo);

  Future<List<WithdrawalReason>> call() {
    return repo.getActiveReasons();
  }
}
