import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:bioscope/core/interfaces/user_profile_datasource.dart';
import '../models/user_profile_model.dart';

class UserProfileSqliteDs implements UserProfileDataSource {
  final Database _database;

  UserProfileSqliteDs(this._database);

  @override
  Future<void> initialize() async {
    await _database.execute('''
      CREATE TABLE IF NOT EXISTS user_profiles(
        id TEXT PRIMARY KEY,
        name TEXT,
        age INTEGER,
        height REAL,
        weight REAL,
        gender TEXT,
        nutritionGoals TEXT
      )
    ''');
  }

  @override
  Future<UserProfileModel?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'user_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      var map = maps.first;
      map['nutritionGoals'] = jsonDecode(map['nutritionGoals'] as String);
      return UserProfileModel.fromJson(map);
    }
    return null;
  }

  @override
  Future<void> create(UserProfileModel item) async {
    var json = item.toJson();
    json['nutritionGoals'] = jsonEncode(json['nutritionGoals']);
    await _database.insert(
      'user_profiles',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(UserProfileModel item) async {
    var json = item.toJson();
    json['nutritionGoals'] = jsonEncode(json['nutritionGoals']);
    await _database.update(
      'user_profiles',
      json,
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await _database.delete(
      'user_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Stream<UserProfileModel?> watchById(String id) {
    // Implement watching a specific user profile if needed
    return Stream.fromFuture(getById(id));
  }

  @override
  void setupRealtimeListeners(Function(List<UserProfileModel>) onDataChanged) {
    // TODO: implementation needed for SQLite
  }
}
