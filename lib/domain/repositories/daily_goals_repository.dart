import '../entities/daily_goals.dart';

/// Repository interface for managing daily goals.
///
/// This interface defines the contract for interacting with daily goals data,
/// regardless of the underlying data source (e.g., local database, remote API).
abstract class IDailyGoalsRepository {
  /// Retrieves the daily goals for a specific date.
  ///
  /// [date] The date for which to retrieve the goals.
  /// Returns a [Future] that completes with the [DailyGoals] if found, or null otherwise.
  Future<DailyGoals?> getDailyGoals(DateTime date);

  /// Saves new daily goals.
  ///
  /// [dailyGoals] The [DailyGoals] object to be saved.
  Future<void> saveDailyGoals(DailyGoals dailyGoals);

  /// Updates existing daily goals.
  ///
  /// [dailyGoals] The [DailyGoals] object with updated information.
  Future<void> updateDailyGoals(DailyGoals dailyGoals);

  /// Retrieves a list of daily goals for a user within a specified date range.
  ///
  /// [startDate] Optional start date for the range.
  /// [endDate] Optional end date for the range.
  /// Returns a [Future] that completes with a list of [DailyGoals].
  Future<List<DailyGoals>> getUserDailyGoals(
      {DateTime? startDate, DateTime? endDate});

  /// Provides a stream of daily goals for a specific date.
  ///
  /// [date] The date for which to watch the goals.
  /// Returns a [Stream] that emits the [DailyGoals] whenever they change.
  Stream<DailyGoals?> watchDailyGoals(DateTime date);

  /// Retrieves the goals for a specific date.
  ///
  /// [date] The date for which to retrieve the goals.
  /// Returns a [Future] that completes with the [DailyGoals] if found, or null otherwise.
  Future<DailyGoals?> getGoalsByDate(DateTime date);

  /// Triggers a recalculation of daily goals for a specific date.
  ///
  /// This method might be used to update goals based on new data or changed user preferences.
  /// [date] The date for which to recalculate goals.
  Future<void> recalculateDailyGoals(DateTime date);
}
