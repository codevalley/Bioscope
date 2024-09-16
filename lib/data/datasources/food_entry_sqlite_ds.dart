import 'package:bioscope/core/interfaces/data_source.dart';
import 'package:bioscope/data/models/food_entry_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class FoodEntrySqliteDs implements DataSource<FoodEntryModel> {
  final Database _database;
  final _controller = StreamController<List<FoodEntryModel>>.broadcast();

  FoodEntrySqliteDs(this._database);

  @override
  Future<void> initialize() async {
    await _database.execute(
      'CREATE TABLE IF NOT EXISTS food_entries(id TEXT PRIMARY KEY, name TEXT, calories INTEGER, date TEXT)',
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
  Future<List<FoodEntryModel>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('food_entries');
    return List.generate(maps.length, (i) => FoodEntryModel.fromJson(maps[i]));
  }

  @override
  Future<FoodEntryModel?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'food_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FoodEntryModel.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> create(FoodEntryModel item) async {
    await _database.insert(
      'food_entries',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(FoodEntryModel item) async {
    await _database.update(
      'food_entries',
      item.toJson(),
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
  Stream<List<FoodEntryModel>> watchAll() {
    return _controller.stream;
  }

  @override
  Stream<FoodEntryModel> watchById(String id) {
    return watchAll().map((entries) => entries.firstWhere(
          (entry) => entry.id == id,
          orElse: () => FoodEntryModel.empty(),
        ));
  }
}
