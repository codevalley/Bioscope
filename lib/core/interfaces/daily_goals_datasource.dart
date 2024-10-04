import 'package:bioscope/core/interfaces/data_source.dart';
import 'package:bioscope/data/models/daily_goals_model.dart';

/// Defines the interface for accessing and manipulating daily goals data.
///
/// This interface extends the generic [DataSource] interface, specializing it
/// for [DailyGoalsModel] operations. It provides methods for retrieving,
/// watching, and recalculating daily goals.
abstract class DailyGoalsDataSource extends DataSource<DailyGoalsModel> {
  /// Retrieves all daily goals.
  ///
  /// Returns a [Future] that completes with a list of [DailyGoalsModel].
  Future<List<DailyGoalsModel>> getAll();

  /// Provides a stream of all daily goals.
  ///
  /// This stream emits a new list of [DailyGoalsModel] whenever the underlying
  /// data changes.
  Stream<List<DailyGoalsModel>> watchAll();

  /// Recalculates the daily goals for a specific date.
  ///
  /// This method is useful for updating goals based on new data or changed user preferences.
  ///
  /// [date] The date for which to recalculate goals.
  Future<void> recalculate(DateTime date);

  /// Retrieves the daily goals for a specific date.
  ///
  /// [date] The date for which to retrieve goals.
  /// Returns a [Future] that completes with a [DailyGoalsModel] if found, or null otherwise.
  Future<DailyGoalsModel?> getByDate(DateTime date);
}
