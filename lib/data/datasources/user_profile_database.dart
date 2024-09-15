import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/user.dart';

class UserProfileDatabase {
  static final UserProfileDatabase instance = UserProfileDatabase._init();
  static Database? _database;

  UserProfileDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_profile.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user_profile(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      dailyCalorieGoal INTEGER NOT NULL,
      dietaryPreferences TEXT
    )
    ''');
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('user_profile', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUser() async {
    final db = await database;
    final maps = await db.query('user_profile');
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update('user_profile', user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }
}
