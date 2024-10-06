import 'package:sqflite/sqflite.dart';
import '../models/daily_goals_model.dart';
import '../../core/interfaces/daily_goals_datasource.dart';
import 'dart:convert';

/// SQLite implementation of the [DailyGoalsDataSource] interface.
///
/// This class provides methods to interact with a local SQLite database
/// for storing and retrieving daily nutritional goals.
class DailyGoalsSqliteDs implements DailyGoalsDataSource {
  final Database _database;

  /// Creates a new instance of [DailyGoalsSqliteDs].
  ///
  /// Requires an open [Database] instance to interact with SQLite.
  DailyGoalsSqliteDs(this._database);

  /// Initializes the SQLite table for daily goals if it doesn't exist.
  @override
  Future<void> initialize() async {
    await _database.execute('''
      CREATE TABLE IF NOT EXISTS daily_goal_logs(
        id TEXT PRIMARY KEY,
        userId TEXT,
        date TEXT,
        goals TEXT
      )
    ''');
  }

  /// Retrieves all daily goals from the SQLite database.
  ///
  /// Returns a [Future] that completes with a list of [DailyGoalsModel].
  @override
  Future<List<DailyGoalsModel>> getAll(
      {DateTime? startDate, DateTime? endDate}) async {
    final List<Map<String, dynamic>> maps =
        await _database.query('daily_goal_logs');
    return List.generate(maps.length, (i) {
      var map = maps[i];
      map['goals'] = jsonDecode(map['goals'] as String);
      return DailyGoalsModel.fromJson(map);
    });
  }

  /// Retrieves a specific daily goal by its ID.
  ///
  /// [id] The unique identifier of the daily goal.
  /// Returns a [Future] that completes with the [DailyGoalsModel] if found, or null otherwise.
  @override
  Future<DailyGoalsModel?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'daily_goal_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      var map = maps.first;
      map['goals'] = jsonDecode(map['goals'] as String);
      return DailyGoalsModel.fromJson(map);
    }
    return null;
  }

  /// Retrieves the daily goals for a specific date.
  ///
  /// [date] The date for which to retrieve goals.
  /// Returns a [Future] that completes with a [DailyGoalsModel] if found, or null otherwise.
  @override
  Future<DailyGoalsModel?> getByDate(DateTime date) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'daily_goals',
      where: 'date = ?',
      whereArgs: [date.toIso8601String().split('T')[0]],
    );
    if (maps.isNotEmpty) {
      return DailyGoalsModel.fromJson(maps.first);
    }
    return null;
  }

  /// Creates a new daily goal entry in the SQLite database.
  ///
  /// [item] The [DailyGoalsModel] to be created.
  @override
  Future<void> create(DailyGoalsModel item) async {
    var json = item.toJson();
    json['goals'] = jsonEncode(json['goals']);
    await _database.insert(
      'daily_goal_logs',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Updates an existing daily goal entry in the SQLite database.
  ///
  /// [item] The [DailyGoalsModel] to be updated.
  @override
  Future<void> update(DailyGoalsModel item) async {
    var json = item.toJson();
    json['goals'] = jsonEncode(json['goals']);
    await _database.update(
      'daily_goal_logs',
      json,
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// Deletes a daily goal entry from the SQLite database.
  ///
  /// [id] The unique identifier of the daily goal to be deleted.
  @override
  Future<void> delete(String id) async {
    await _database.delete(
      'daily_goal_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Provides a stream of all daily goals.
  ///
  /// Returns a [Stream] that emits a list of [DailyGoalsModel] whenever the data changes.
  @override
  Stream<List<DailyGoalsModel>> watchAll() {
    // Implement watching all daily goal logs if needed
    throw UnimplementedError();
  }

  /// Provides a stream of a specific daily goal by its ID.
  ///
  /// [id] The unique identifier of the daily goal to watch.
  /// Returns a [Stream] that emits the updated [DailyGoalsModel] whenever it changes.
  @override
  Stream<DailyGoalsModel?> watchById(String id) {
    // Implement watching a specific daily goal log if needed
    throw UnimplementedError();
  }

  /// Sets up real-time listeners for data changes.
  ///
  /// This method is not typically used for SQLite, as it doesn't support real-time updates.
  /// Consider using a local broadcast mechanism if needed.
  @override
  void setupRealtimeListeners(Function(List<DailyGoalsModel>) onDataChanged) {
    // Implement if needed for SQLite
  }

  /// Recalculates the daily goals for a specific date.
  ///
  /// This method is not implemented for SQLite and throws an [UnimplementedError].
  @override
  Future<void> recalculate(DateTime date) async {
    // Implement if needed for SQLite
    throw UnimplementedError();
  }
}
