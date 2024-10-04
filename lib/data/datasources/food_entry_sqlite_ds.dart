import 'package:bioscope/core/interfaces/food_entry_datasource.dart';
import 'package:bioscope/data/models/food_entry_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';
import '../../core/utils/logger.dart';

/// SQLite implementation of the [FoodEntryDataSource] interface.
///
/// This class provides methods to interact with a local SQLite database
/// for storing and retrieving food entries.
class FoodEntrySqliteDs implements FoodEntryDataSource {
  final Database _database;
  final _controller = StreamController<List<FoodEntryModel>>.broadcast();

  /// Creates a new instance of [FoodEntrySqliteDs].
  ///
  /// Requires an open [Database] instance to interact with SQLite.
  FoodEntrySqliteDs(this._database);

  /// Initializes the SQLite table for food entries if it doesn't exist.
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

  /// Starts a periodic timer to watch for changes in the food entries table.
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

  /// Retrieves all food entries from the SQLite database.
  ///
  /// Returns a [Future] that completes with a list of [FoodEntryModel].
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

  /// Retrieves a specific food entry by its ID.
  ///
  /// [id] The unique identifier of the food entry.
  /// Returns a [Future] that completes with the [FoodEntryModel] if found, or null otherwise.
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

  /// Creates a new food entry in the SQLite database.
  ///
  /// [item] The [FoodEntryModel] to be created.
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

  /// Updates an existing food entry in the SQLite database.
  ///
  /// [item] The [FoodEntryModel] to be updated.
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

  /// Deletes a food entry from the SQLite database.
  ///
  /// [id] The unique identifier of the food entry to be deleted.
  @override
  Future<void> delete(String id) async {
    await _database.delete(
      'food_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Provides a stream of all food entries.
  ///
  /// Returns a [Stream] that emits a list of [FoodEntryModel] whenever the data changes.
  @override
  Stream<List<FoodEntryModel>> watchAll() {
    return _controller.stream;
  }

  /// Provides a stream of a specific food entry by its ID.
  ///
  /// [id] The unique identifier of the food entry to watch.
  /// Returns a [Stream] that emits the updated [FoodEntryModel] whenever it changes.
  @override
  Stream<FoodEntryModel> watchById(String id) {
    return watchAll().map((entries) => entries.firstWhere(
          (entry) => entry.id == id,
          orElse: () => FoodEntryModel.empty(),
        ));
  }

  /// Prints all entries in the food_entries table for debugging purposes.
  Future<void> debugPrintAllEntries() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('food_entries');
    Logger.log('All entries in food_entries table:');
    for (var map in maps) {
      Logger.log(map.toString());
    }
  }

  /// Sets up real-time listeners for data changes.
  ///
  /// This method is not implemented for SQLite and does nothing.
  @override
  void setupRealtimeListeners(Function(List<FoodEntryModel>) onDataChanged) {
    // TODO: implementation needed for SQLite
  }

  /// Retrieves food entries for a specific date.
  ///
  /// [date] The date for which to retrieve food entries.
  /// Returns a [Future] that completes with a list of [FoodEntryModel] for the given date.
  @override
  Future<List<FoodEntryModel>> getByDate(DateTime date) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'food_entries',
      where: 'date = ?',
      whereArgs: [date.toIso8601String().split('T')[0]],
    );
    return List.generate(maps.length, (i) => FoodEntryModel.fromJson(maps[i]));
  }

  /// Retrieves an authenticated URL for an image associated with a food entry.
  ///
  /// [fileName] The name of the image file.
  /// Returns a [Future] that completes with the authenticated URL as a [String].
  /// Note: In this SQLite implementation, it simply returns the file name.
  @override
  Future<String> getAuthenticatedImageUrl(String fileName) async {
    return fileName;
  }
}
