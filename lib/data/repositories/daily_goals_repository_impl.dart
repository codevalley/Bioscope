import '../../domain/entities/daily_goals.dart';
import '../../domain/repositories/daily_goals_repository.dart';
import '../../core/interfaces/data_source.dart';
import '../models/daily_goals_model.dart';

class DailyGoalsRepositoryImpl implements IDailyGoalsRepository {
  final DataSource<DailyGoalsModel> _dataSource;

  DailyGoalsRepositoryImpl(this._dataSource);

  @override
  Future<DailyGoals?> getDailyGoals(String userId, DateTime date) async {
    final allGoals = await _dataSource.getAll();
    final dailyGoals = allGoals.where(
            (goals) => goals.userId == userId && goals.date.isAtSameMomentAs(date)
    ).toList();

    if (dailyGoals.isEmpty) {
      return null;
    }

    return dailyGoals.first.toDomain();
  }


  @override
  Future<void> saveDailyGoals(DailyGoals dailyGoals) async {
    await _dataSource.create(DailyGoalsModel(
      id: dailyGoals.id,
      userId: dailyGoals.userId,
      date: dailyGoals.date,
      goals: dailyGoals.goals,
    ));
  }

  @override
  Future<void> updateDailyGoals(DailyGoals dailyGoals) async {
    await _dataSource.update(DailyGoalsModel(
      id: dailyGoals.id,
      userId: dailyGoals.userId,
      date: dailyGoals.date,
      goals: dailyGoals.goals,
    ));
  }

  @override
  Future<List<DailyGoals>> getUserDailyGoals(String userId,
      {DateTime? startDate, DateTime? endDate}) async {
    final allGoals = await _dataSource.getAll();
    return allGoals
        .where((goals) =>
            goals.userId == userId &&
            (startDate == null || goals.date.isAfter(startDate)) &&
            (endDate == null || goals.date.isBefore(endDate)))
        .map((model) => model.toDomain())
        .toList();
  }
}
