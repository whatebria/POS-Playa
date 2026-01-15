import '../domain/entities/daily_sale.dart';
import '../domain/entities/daily_summary.dart';

class DailyHistory {
  final DailySummary summary;
  final List<DailySale> sales;

  const DailyHistory({
    required this.summary,
    required this.sales,
  });
}

class HistoryState {
  final bool isLoading;
  final String? errorMessage;
  final List<DailyHistory> history;

  const HistoryState({
    required this.isLoading,
    required this.errorMessage,
    required this.history,
  });

  factory HistoryState.initial() => const HistoryState(
        isLoading: false,
        errorMessage: null,
        history: [],
      );

  HistoryState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DailyHistory>? history,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      history: history ?? this.history,
    );
  }
}
