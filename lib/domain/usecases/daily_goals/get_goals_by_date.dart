import '../../repositories/daily_goals_repository.dart';
import '../../entities/daily_goals.dart';

class GetGoalsByDate {
  final IDailyGoalsRepository repository;

  GetGoalsByDate(this.repository);

  Future<DailyGoals?> call(DateTime date) async {
    return await repository.getGoalsByDate(date);
  }
}
