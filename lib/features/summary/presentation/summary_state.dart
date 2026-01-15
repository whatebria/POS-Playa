import '../../opening/domain/day_status.dart';
import '../domain/entities/daily_sale.dart';
import '../domain/entities/daily_summary.dart';

class SummaryState {
  final bool isLoading;
  final String? errorMessage;

  final DayStatus dayStatus;
  final DailySummary? summary;
  final List<DailySale> sales;

  const SummaryState({
    required this.isLoading,
    required this.errorMessage,
    required this.dayStatus,
    required this.summary,
    required this.sales,
  });

  factory SummaryState.initial() => const SummaryState(
        isLoading: false,
        errorMessage: null,
        dayStatus: DayStatus.unknown,
        summary: null,
        sales: [],
      );

  SummaryState copyWith({
    bool? isLoading,
    String? errorMessage,
    DayStatus? dayStatus,
    DailySummary? summary,
    List<DailySale>? sales,
  }) {
    return SummaryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dayStatus: dayStatus ?? this.dayStatus,
      summary: summary ?? this.summary,
      sales: sales ?? this.sales,
    );
  }
}
