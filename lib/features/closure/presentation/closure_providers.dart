import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/closure_repository_sqlite.dart';
import '../domain/repositories/closure_repository.dart';
import '../domain/usecases/get_cash_expected_use_case.dart';
import '../domain/usecases/close_day_use_case.dart';

final closureRepositoryProvider =
    Provider<ClosureRepository>((ref) {
  return ClosureRepositorySqlite();
});

final getCashExpectedUseCaseProvider =
    Provider<GetCashExpectedUseCase>((ref) {
  return GetCashExpectedUseCase(
    ref.read(closureRepositoryProvider),
  );
});

final closeDayUseCaseProvider =
    Provider<CloseDayUseCase>((ref) {
  return CloseDayUseCase(
    ref.read(closureRepositoryProvider),
  );
});
