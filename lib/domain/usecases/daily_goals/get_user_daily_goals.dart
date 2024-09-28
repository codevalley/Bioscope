import '../../entities/daily_goals.dart';
import '../../repositories/daily_goals_repository.dart';

class GetUserDailyGoals {
  final IDailyGoalsRepository repository;

  GetUserDailyGoals(this.repository);

  Future<List<DailyGoals>> call(String userId,
      {DateTime? startDate, DateTime? endDate}) async {
    return await repository.getUserDailyGoals(
        startDate: startDate, endDate: endDate);
  }
}
