import '../../domain/repositories/daily_goals_repository.dart';
import '../../domain/entities/daily_goals.dart';
import '../../core/interfaces/data_source.dart';
import '../models/daily_goals_model.dart';
import 'package:collection/collection.dart'; // Add this import

class DailyGoalsRepositoryImpl implements IDailyGoalsRepository {
  final DataSource<DailyGoalsModel> _dataSource;

  DailyGoalsRepositoryImpl(this._dataSource);

  // Helper method to compare dates without time
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Future<DailyGoals?> getDailyGoals(DateTime date) async {
    final allGoals = await _dataSource.getAll();
    if (allGoals.isEmpty) {
      return null; // Return null if no goals are found
    }
    final goalForDate = allGoals.firstWhereOrNull(
      (goal) => _isSameDate(goal.date, date),
    );
    return goalForDate?.toDomain();
  }

  @override
  Future<void> saveDailyGoals(DailyGoals dailyGoals) async {
    final existingGoals = await getDailyGoals(dailyGoals.date);
    final dailyGoalsModel = DailyGoalsModel.fromDomain(dailyGoals);

    if (existingGoals != null) {
      // If a record exists, update it
      await _dataSource.update(dailyGoalsModel.copyWith(id: existingGoals.id));
    } else {
      // If no record exists, create a new one
      await _dataSource.create(dailyGoalsModel);
    }
  }

  @override
  Future<void> updateDailyGoals(DailyGoals dailyGoals) async {
    await _dataSource.update(DailyGoalsModel.fromDomain(dailyGoals));
  }

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

  @override
  Stream<DailyGoals?> watchDailyGoals(DateTime date) {
    return _dataSource.watchAll().map((goals) {
      final goalForDate = goals.firstWhere(
        (goal) => _isSameDate(goal.date, date),
      );
      return goalForDate.toDomain();
    });
  }

  @override
  Future<void> recalculateDailyGoals(DateTime date) async {
    final goals = await getDailyGoals(date);
    if (goals != null) {
      // Perform recalculation logic here
      // For now, we'll just update the existing goals
      await updateDailyGoals(goals);
    }
  }
}
