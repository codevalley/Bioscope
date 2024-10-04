import '../../domain/repositories/daily_goals_repository.dart';
import '../../domain/entities/daily_goals.dart';
import '../../core/interfaces/daily_goals_datasource.dart';
import '../models/daily_goals_model.dart';
import 'package:collection/collection.dart';

/// Implementation of the [IDailyGoalsRepository] interface.
///
/// This class provides concrete implementations for managing daily goals
/// using a [DailyGoalsDataSource].
class DailyGoalsRepositoryImpl implements IDailyGoalsRepository {
  final DailyGoalsDataSource _dataSource;

  /// Creates a new instance of [DailyGoalsRepositoryImpl].
  ///
  /// Requires a [DailyGoalsDataSource] to interact with the data layer.
  DailyGoalsRepositoryImpl(this._dataSource);

  /// Helper method to compare dates without time.
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Retrieves the daily goals for a specific date.
  ///
  /// If no goals are found for the given date, returns null.
  @override
  Future<DailyGoals?> getDailyGoals(DateTime date) async {
    final allGoals = await _dataSource.getAll();
    if (allGoals.isEmpty) {
      return null;
    }
    final goalForDate = allGoals.firstWhereOrNull(
      (goal) => _isSameDate(goal.date, date),
    );
    return goalForDate?.toDomain();
  }

  /// Saves new daily goals or updates existing ones.
  ///
  /// If goals already exist for the given date, they will be updated.
  @override
  Future<void> saveDailyGoals(DailyGoals dailyGoals) async {
    final existingGoals = await getDailyGoals(dailyGoals.date);
    final dailyGoalsModel = DailyGoalsModel.fromDomain(dailyGoals);

    if (existingGoals != null) {
      await _dataSource.update(dailyGoalsModel.copyWith(id: existingGoals.id));
    } else {
      await _dataSource.create(dailyGoalsModel);
    }
  }

  /// Updates existing daily goals.
  @override
  Future<void> updateDailyGoals(DailyGoals dailyGoals) async {
    await _dataSource.update(DailyGoalsModel.fromDomain(dailyGoals));
  }

  /// Retrieves a list of daily goals within a specified date range.
  ///
  /// [startDate] and [endDate] are optional. If not provided, all goals are returned.
  @override
  Future<List<DailyGoals>> getUserDailyGoals(
      {DateTime? startDate, DateTime? endDate}) async {
    final allGoals = await _dataSource.getAll();
    return allGoals
        .where((goal) =>
            (startDate == null ||
                _isSameDate(goal.date, startDate) ||
                goal.date.isAfter(startDate)) &&
            (endDate == null ||
                _isSameDate(goal.date, endDate) ||
                goal.date.isBefore(endDate)))
        .map((model) => model.toDomain())
        .toList();
  }

  /// Retrieves the goals for a specific date.
  @override
  Future<DailyGoals?> getGoalsByDate(DateTime date) async {
    final dailyGoalsModel = await _dataSource.getByDate(date);
    return dailyGoalsModel?.toDomain();
  }

  /// Provides a stream of daily goals for a specific date.
  @override
  Stream<DailyGoals?> watchDailyGoals(DateTime date) {
    return _dataSource.watchAll().map((goals) {
      final goalForDate = goals.firstWhere(
        (goal) => _isSameDate(goal.date, date),
      );
      return goalForDate.toDomain();
    });
  }

  /// Triggers a recalculation of daily goals for a specific date.
  ///
  /// This method currently just updates the existing goals. In a real-world scenario,
  /// this might involve more complex calculations based on user activity, preferences, etc.
  @override
  Future<void> recalculateDailyGoals(DateTime date) async {
    final goals = await getDailyGoals(date);
    if (goals != null) {
      await updateDailyGoals(goals);
    }
  }
}
