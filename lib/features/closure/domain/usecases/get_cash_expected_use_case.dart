import '../repositories/closure_repository.dart';

class GetCashExpectedUseCase {
  final ClosureRepository repo;
  GetCashExpectedUseCase(this.repo);

  Future<int?> call({required String businessDay}) {
    return repo.getCashExpected(businessDay: businessDay);
  }
}
