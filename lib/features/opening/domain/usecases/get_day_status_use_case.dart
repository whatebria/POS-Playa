import '../day_status.dart';
import '../opening_repository.dart';

class GetDayStatusUseCase {
  final OpeningRepository repo;

  GetDayStatusUseCase(this.repo);

  Future<DayStatus> call({required String businessDay}) {
    return repo.getDayStatus(businessDay: businessDay);
  }
}
