import 'package:bioscope/core/interfaces/food_entry_datasource.dart';
import 'package:bioscope/data/models/food_entry_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';
import '../../core/utils/logger.dart';

class FoodEntrySqliteDs implements FoodEntryDataSource {
  final Database _database;
  final _controller = StreamController<List<FoodEntryModel>>.broadcast();

  FoodEntrySqliteDs(this._database);

  @override
  Future<void> initialize() async {
    await _database.execute('''
      CREATE TABLE IF NOT EXISTS food_entries(
        id TEXT PRIMARY KEY,
        name TEXT,
        date TEXT,
        imagePath TEXT,
        nutritionInfo TEXT
      )
    ''');
    _startWatching();
  }

  void _startWatching() {
    Timer.periodic(const Duration(seconds: 1), (_) async {
      try {
        final entries = await getAll();
        _controller.add(entries);
      } catch (e) {
        Logger.log('Error in _startWatching: $e');
      }
    });
  }

  @override
  Future<List<FoodEntryModel>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('food_entries');
    return List.generate(maps.length, (i) {
      try {
        return FoodEntryModel.fromJson(maps[i]);
      } catch (e) {
        Logger.log('Error parsing FoodEntryModel: $e');
        Logger.log('Problematic data: ${maps[i]}');
        return FoodEntryModel
            .empty(); // Return an empty model or handle the error as appropriate
      }
    });
  }

  @override
  Future<FoodEntryModel?> getById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'food_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      try {
        return FoodEntryModel.fromJson(maps.first);
      } catch (e) {
        Logger.log('Error parsing FoodEntryModel: $e');
        Logger.log('Problematic data: ${maps.first}');
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> create(FoodEntryModel item) async {
    try {
      await _database.insert(
        'food_entries',
        {
          'id': item.id,
          'name': item.name,
          'date': item.date.toIso8601String(),
          'imagePath': item.imagePath,
          'nutritionInfo': jsonEncode(item.nutritionInfo.toJson()),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Logger.log('Error creating FoodEntryModel: $e');
      Logger.log('Problematic item: $item');
      rethrow;
    }
  }

  @override
  Future<void> update(FoodEntryModel item) async {
    await _database.update(
      'food_entries',
      {
        'name': item.name,
        'date': item.date.toIso8601String(),
        'imagePath': item.imagePath,
        'nutritionInfo': jsonEncode(item.nutritionInfo.toJson()),
      },
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

  Future<void> debugPrintAllEntries() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('food_entries');
    Logger.log('All entries in food_entries table:');
    for (var map in maps) {
      Logger.log(map.toString());
    }
  }

  @override
  void setupRealtimeListeners(Function(List<FoodEntryModel>) onDataChanged) {
    // TODO: implementation needed for SQLite
  }
  @override
  Future<List<FoodEntryModel>> getByDate(DateTime date) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'food_entries',
      where: 'date = ?',
      whereArgs: [date.toIso8601String().split('T')[0]],
    );
    return List.generate(maps.length, (i) => FoodEntryModel.fromJson(maps[i]));
  }
}
