import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:bioscope/core/interfaces/user_profile_datasource.dart';
import '../models/user_profile_model.dart';

/// SQLite implementation of the [UserProfileDataSource] interface.
///
/// This class provides methods to interact with a local SQLite database
/// for storing and retrieving user profiles.
class UserProfileSqliteDs implements UserProfileDataSource {
  final Database _database;

  /// Creates a new instance of [UserProfileSqliteDs].
  ///
  /// Requires an open [Database] instance to interact with SQLite.
  UserProfileSqliteDs(this._database);

  /// Initializes the SQLite table for user profiles if it doesn't exist.
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

  /// Retrieves a user profile by its ID from the SQLite database.
  ///
  /// [id] The unique identifier of the user profile.
  /// Returns a [Future] that completes with the [UserProfileModel] if found, or null otherwise.
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

  /// Creates a new user profile in the SQLite database.
  ///
  /// [item] The [UserProfileModel] to be created.
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

  /// Updates an existing user profile in the SQLite database.
  ///
  /// [item] The [UserProfileModel] to be updated.
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

  /// Deletes a user profile from the SQLite database.
  ///
  /// [id] The unique identifier of the user profile to be deleted.
  @override
  Future<void> delete(String id) async {
    await _database.delete(
      'user_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Provides a stream of a specific user profile by its ID.
  ///
  /// [id] The unique identifier of the user profile to watch.
  /// Returns a [Stream] that emits the updated [UserProfileModel] whenever it changes.
  @override
  Stream<UserProfileModel?> watchById(String id) {
    // Implement watching a specific user profile if needed
    return Stream.fromFuture(getById(id));
  }

  /// Sets up real-time listeners for data changes.
  ///
  /// This method is not implemented for SQLite and does nothing.
  @override
  void setupRealtimeListeners(Function(List<UserProfileModel>) onDataChanged) {
    // TODO: implementation needed for SQLite
  }
}
