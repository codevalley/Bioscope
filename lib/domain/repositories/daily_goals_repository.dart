import '../entities/daily_goals.dart';

abstract class IDailyGoalsRepository {
  Future<DailyGoals?> getDailyGoals(DateTime date);
  Future<void> saveDailyGoals(DailyGoals dailyGoals);
  Future<void> updateDailyGoals(DailyGoals dailyGoals);
  Future<List<DailyGoals>> getUserDailyGoals(
      {DateTime? startDate, DateTime? endDate});
  Stream<DailyGoals?> watchDailyGoals(DateTime date);
  Future<DailyGoals?> getGoalsByDate(DateTime date);
  Future<void> recalculateDailyGoals(DateTime date);
}
