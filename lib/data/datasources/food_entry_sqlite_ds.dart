import 'package:bioscope/core/interfaces/data_source.dart';
import 'package:bioscope/data/models/food_entry_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';

class FoodEntrySqliteDs implements DataSource<FoodEntryModel> {
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
        print('Error in _startWatching: $e');
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
        print('Error parsing FoodEntryModel: $e');
        print('Problematic data: ${maps[i]}');
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
        print('Error parsing FoodEntryModel: $e');
        print('Problematic data: ${maps.first}');
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
      print('Error creating FoodEntryModel: $e');
      print('Problematic item: $item');
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
    print('All entries in food_entries table:');
    for (var map in maps) {
      print(map);
    }
  }

  @override
  void setupRealtimeListeners(Function(List<FoodEntryModel>) onDataChanged) {
    // TODO: implementation needed for SQLite
  }

  @override
  Future<void> recalculate(DateTime date) async {
    // TODO: implementation needed for SQLite
  }
}
