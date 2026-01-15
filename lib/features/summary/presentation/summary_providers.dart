import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/summary_repository_sqlite.dart';
import '../domain/repositories/summary_repository.dart';
import '../domain/usecases/get_closed_business_days_use_case.dart';
import '../domain/usecases/get_daily_summary_use_case.dart';
import '../domain/usecases/get_daily_sales_use_case.dart';

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

final getDailySalesUseCaseProvider =
    Provider<GetDailySalesUseCase>((ref) {
  return GetDailySalesUseCase(
    ref.read(summaryRepositoryProvider),
  );
});

final getClosedBusinessDaysUseCaseProvider =
    Provider<GetClosedBusinessDaysUseCase>((ref) {
  return GetClosedBusinessDaysUseCase(
    ref.read(summaryRepositoryProvider),
  );
});
