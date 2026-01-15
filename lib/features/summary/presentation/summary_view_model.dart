import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playa/features/opening/presentation/opening_view_model.dart';

import '../../opening/domain/usecases/get_day_status_use_case.dart';
import '../../../shared/utils/business_day.dart';
import '../../../shared/widgets/ui_event.dart';
import '../domain/usecases/get_daily_summary_use_case.dart';
import '../domain/usecases/get_daily_sales_use_case.dart';
import 'summary_state.dart';
import 'summary_providers.dart';

final summaryViewModelProvider =
    NotifierProvider<SummaryViewModel, SummaryState>(
        SummaryViewModel.new);

class SummaryViewModel extends Notifier<SummaryState> {
  late final StreamController<UiEvent> _events;
  Stream<UiEvent> get events => _events.stream;

  GetDailySummaryUseCase get _getSummary =>
      ref.read(getDailySummaryUseCaseProvider);
  GetDailySalesUseCase get _getSales =>
      ref.read(getDailySalesUseCaseProvider);
  GetDayStatusUseCase get _getDayStatus =>
      ref.read(getDayStatusUseCaseProvider);

  @override
  SummaryState build() {
    _events = StreamController<UiEvent>.broadcast();
    ref.onDispose(() => _events.close());
    return SummaryState.initial();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    final day = businessDayFrom(DateTime.now());
    final status = await _getDayStatus(businessDay: day);
    final summary = await _getSummary(businessDay: day);
    final sales = await _getSales(businessDay: day);

    state = state.copyWith(
      isLoading: false,
      dayStatus: status,
      summary: summary,
      sales: sales,
    );
  }

  void exportExcel() {
    // Solo emite evento UI (la lógica real vendrá después)
    _events.add(
      const ShowSnack('Exportación iniciada', SnackType.info),
    );
  }
}
