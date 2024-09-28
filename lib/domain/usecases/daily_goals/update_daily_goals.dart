import '../../entities/daily_goals.dart';
import '../../repositories/daily_goals_repository.dart';

class UpdateDailyGoals {
  final IDailyGoalsRepository repository;

  UpdateDailyGoals(this.repository);

  Future<void> call(DailyGoals dailyGoals) async {
    await repository.updateDailyGoals(dailyGoals);
  }
}
