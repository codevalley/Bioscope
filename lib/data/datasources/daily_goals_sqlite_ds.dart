import 'package:sqflite/sqflite.dart';
import '../../core/interfaces/data_source.dart';
import '../models/daily_goals_model.dart';
import 'dart:convert';

class DailyGoalsSqliteDs implements DataSource<DailyGoalsModel> {
  final Database _database;

  DailyGoalsSqliteDs(this._database);

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

  @override
  Future<List<DailyGoalsModel>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('daily_goal_logs');
    return List.generate(maps.length, (i) {
      var map = maps[i];
      map['goals'] = jsonDecode(map['goals'] as String);
      return DailyGoalsModel.fromJson(map);
    });
  }

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

  @override
  Future<void> delete(String id) async {
    await _database.delete(
      'daily_goal_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Stream<List<DailyGoalsModel>> watchAll() {
    // Implement watching all daily goal logs if needed
    throw UnimplementedError();
  }

  @override
  Stream<DailyGoalsModel?> watchById(String id) {
    // Implement watching a specific daily goal log if needed
    throw UnimplementedError();
  }

  @override
  void setupRealtimeListeners(Function(List<DailyGoalsModel>) onDataChanged) {
    // Implement if needed for SQLite
  }
}
