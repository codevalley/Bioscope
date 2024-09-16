import 'package:sqflite/sqflite.dart';
import '../../core/interfaces/data_source.dart';
import '../models/user_profile_model.dart';

class UserProfileSqliteDs implements DataSource<UserProfileModel> {
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
        dailyCalorieGoal INTEGER
      )
    ''');
  }

  @override
  Future<List<UserProfileModel>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('user_profiles');
    return List.generate(
        maps.length, (i) => UserProfileModel.fromJson(maps[i]));
  }

  @override
  Future<UserProfileModel?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'user_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserProfileModel.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> create(UserProfileModel item) async {
    await _database.insert(
      'user_profiles',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(UserProfileModel item) async {
    await _database.update(
      'user_profiles',
      item.toJson(),
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
  Stream<List<UserProfileModel>> watchAll() {
    // Implement watching all user profiles if needed
    return Stream.fromFuture(getAll());
  }

  @override
  Stream<UserProfileModel?> watchById(String id) {
    // Implement watching a specific user profile if needed
    return Stream.fromFuture(getById(id));
  }
}
