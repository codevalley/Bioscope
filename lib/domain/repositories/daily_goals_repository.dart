// In domain/repositories/daily_goal_log_repository.dart
import '../entities/daily_goals.dart';

abstract class IDailyGoalsRepository {
  Future<DailyGoals?> getDailyGoals(String userId, DateTime date);
  Future<void> saveDailyGoals(DailyGoals dailyGoalLog);
  Future<void> updateDailyGoals(DailyGoals dailyGoalLog);
  Future<List<DailyGoals>> getUserDailyGoals(String userId,
      {DateTime? startDate, DateTime? endDate});
  Future<void> recalculateDailyGoals(String userId, DateTime date);
}
