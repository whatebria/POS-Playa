import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/get_closed_business_days_use_case.dart';
import '../domain/usecases/get_daily_sales_use_case.dart';
import '../domain/usecases/get_daily_summary_use_case.dart';
import 'history_state.dart';
import 'summary_providers.dart';

final historyViewModelProvider =
    NotifierProvider<HistoryViewModel, HistoryState>(HistoryViewModel.new);

class HistoryViewModel extends Notifier<HistoryState> {
  GetClosedBusinessDaysUseCase get _getDays =>
      ref.read(getClosedBusinessDaysUseCaseProvider);
  GetDailySummaryUseCase get _getSummary =>
      ref.read(getDailySummaryUseCaseProvider);
  GetDailySalesUseCase get _getSales =>
      ref.read(getDailySalesUseCaseProvider);

  @override
  HistoryState build() {
    return HistoryState.initial();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final days = await _getDays();
      final histories = await Future.wait(
        days.map((day) async {
          final summary = await _getSummary(businessDay: day);
          if (summary == null) return null;
          final sales = await _getSales(businessDay: day);
          return DailyHistory(summary: summary, sales: sales);
        }),
      );

      state = state.copyWith(
        isLoading: false,
        history: histories.whereType<DailyHistory>().toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
