import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/summary_repository_sqlite.dart';
import '../domain/repositories/summary_repository.dart';
import '../domain/usecases/get_daily_summary_use_case.dart';

final summaryRepositoryProvider =
    Provider<SummaryRepository>((ref) {
  return SummaryRepositorySqlite();
});

final getDailySummaryUseCaseProvider =
    Provider<GetDailySummaryUseCase>((ref) {
  return GetDailySummaryUseCase(
    ref.read(summaryRepositoryProvider),
  );
});
