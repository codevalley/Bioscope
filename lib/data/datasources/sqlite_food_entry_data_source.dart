import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../../domain/datasources/food_entry_data_source.dart';
import '../../domain/entities/food_entry.dart';

class SQLiteFoodEntryDataSource implements FoodEntryDataSource {
  late Database _database;

  @override
  Future<void> initialize() async {
    _database = await openDatabase(
      path.join(await getDatabasesPath(), 'food_entry_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE food_entries(id TEXT PRIMARY KEY, name TEXT, calories INTEGER, timestamp TEXT)',
        );
      },
      version: 1,
    );
  }

  @override
  Future<List<FoodEntry>> getRecentFoodEntries() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('food_entries');

    return List.generate(maps.length, (i) {
      return FoodEntry(
        id: maps[i]['id'],
        name: maps[i]['name'],
        calories: maps[i]['calories'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }

  @override
  Future<void> addFoodEntry(FoodEntry entry) async {
    await _database.insert(
      'food_entries',
      {
        'id': entry.id,
        'name': entry.name,
        'calories': entry.calories,
        'timestamp': entry.timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> getTotalCaloriesConsumed() async {
    final result = await _database
        .rawQuery('SELECT SUM(calories) as total FROM food_entries');
    return result.first['total'] as int? ?? 0;
  }
}
