import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../core/interfaces/food_entry_datasource.dart';
import '../models/food_entry_model.dart';
import 'dart:async';

/// Implementation of the [IFoodEntryRepository] interface.
///
/// This class provides concrete implementations for managing food entries
/// using a [FoodEntryDataSource].
class FoodEntryRepositoryImpl implements IFoodEntryRepository {
  final FoodEntryDataSource _dataSource;
  final StreamController<List<FoodEntry>> _foodEntriesController =
      StreamController<List<FoodEntry>>.broadcast();

  /// Creates a new instance of [FoodEntryRepositoryImpl].
  ///
  /// Requires a [FoodEntryDataSource] to interact with the data layer.
  FoodEntryRepositoryImpl(this._dataSource) {
    _setupRealtimeListeners();
  }

  /// Sets up real-time listeners for food entry data changes.
  void _setupRealtimeListeners() {
    _dataSource.setupRealtimeListeners((updatedData) {
      final foodEntries = updatedData
          .map((model) => model as FoodEntry)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _foodEntriesController.add(foodEntries);
    });
  }

  /// Retrieves all food entries, sorted by date in descending order.
  @override
  Future<List<FoodEntry>> getAllFoodEntries() async {
    final foodEntryModels = await _dataSource.getAll();
    final foodEntries = foodEntryModels
        .map((model) => model as FoodEntry)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return foodEntries;
  }

  /// Retrieves the 5 most recent food entries.
  @override
  Future<List<FoodEntry>> getRecentFoodEntries() async {
    final allEntries = await getAllFoodEntries();
    return allEntries.take(5).toList();
  }

  /// Retrieves food entries for a specific date.
  @override
  Future<List<FoodEntry>> getEntriesByDate(DateTime date) async {
    final foodEntryModels = await _dataSource.getByDate(date);
    return foodEntryModels.map((model) => model.toDomain()).toList();
  }

  /// Adds a new food entry.
  @override
  Future<void> addFoodEntry(FoodEntry entry) async {
    await _dataSource.create(FoodEntryModel(
      id: entry.id,
      name: entry.name,
      nutritionInfo: entry.nutritionInfo,
      date: entry.date,
      imagePath: entry.imagePath,
    ));
  }

  /// Updates an existing food entry.
  @override
  Future<void> updateFoodEntry(FoodEntry entry) async {
    await _dataSource.update(FoodEntryModel(
      id: entry.id,
      name: entry.name,
      nutritionInfo: entry.nutritionInfo,
      date: entry.date,
      imagePath: entry.imagePath,
    ));
  }

  /// Deletes a food entry by its ID.
  @override
  Future<void> deleteFoodEntry(String id) async {
    await _dataSource.delete(id);
  }

  /// Calculates the total calories consumed across all food entries.
  @override
  Future<int> getTotalCaloriesConsumed() async {
    final entries = await getAllFoodEntries();
    return entries.fold<int>(
        0, (sum, entry) => sum + entry.nutritionInfo.calories);
  }

  /// Provides a stream of all food entries.
  @override
  Stream<List<FoodEntry>> watchAllFoodEntries() {
    return _foodEntriesController.stream;
  }

  /// Retrieves an authenticated URL for an image associated with a food entry.
  @override
  Future<String> getAuthenticatedImageUrl(String fileName) async {
    return await _dataSource.getAuthenticatedImageUrl(fileName);
  }

  /// Closes the stream controller when it's no longer needed.
  void dispose() {
    _foodEntriesController.close();
  }
}
