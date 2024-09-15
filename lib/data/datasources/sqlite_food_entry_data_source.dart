import 'package:bioscope/domain/datasources/data_source.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class SQLiteFoodEntryDataSource implements DataSource<FoodEntry> {
  late Database _database;
  final _controller = StreamController<List<FoodEntry>>.broadcast();

  @override
  Future<void> initialize() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'food_entry_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE food_entries(id TEXT PRIMARY KEY, name TEXT, calories INTEGER, date TEXT)',
        );
      },
      version: 1,
    );
    _startWatching();
  }

  void _startWatching() {
    Timer.periodic(const Duration(seconds: 1), (_) async {
      final entries = await getAll();
      _controller.add(entries);
    });
  }

  @override
  Future<List<FoodEntry>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('food_entries');
    return List.generate(maps.length, (i) => FoodEntry.fromMap(maps[i]));
  }

  @override
  Future<FoodEntry?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'food_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FoodEntry.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> create(FoodEntry item) async {
    await _database.insert(
      'food_entries',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(FoodEntry item) async {
    await _database.update(
      'food_entries',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await _database.delete(
      'food_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Stream<List<FoodEntry>> watchAll() {
    return _controller.stream;
  }

  @override
  Stream<FoodEntry?> watchById(String id) {
    return watchAll().map((entries) => entries.firstWhere(
          (entry) => entry.id == id,
          orElse: () => FoodEntry(name: '', calories: 0, date: DateTime.now()),
        ));
  }
}
