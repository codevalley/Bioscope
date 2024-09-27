import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../core/interfaces/data_source.dart';
import '../models/food_entry_model.dart';
import 'dart:async';

class FoodEntryRepositoryImpl implements IFoodEntryRepository {
  final DataSource<FoodEntryModel> _dataSource;
  final StreamController<List<FoodEntry>> _foodEntriesController =
      StreamController<List<FoodEntry>>.broadcast();

  FoodEntryRepositoryImpl(this._dataSource) {
    _setupRealtimeListeners();
  }

  void _setupRealtimeListeners() {
    _dataSource.setupRealtimeListeners((updatedData) {
      final foodEntries = updatedData
          .map((model) => model as FoodEntry)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Sort the list here
      _foodEntriesController.add(foodEntries);
    });
  }

  @override
  Future<List<FoodEntry>> getAllFoodEntries() async {
    final foodEntryModels = await _dataSource.getAll();
    final foodEntries = foodEntryModels
        .map((model) => model as FoodEntry)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort the list here
    return foodEntries;
  }

  @override
  Future<List<FoodEntry>> getRecentFoodEntries() async {
    final allEntries = await getAllFoodEntries();
    return allEntries.take(5).toList();
  }

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

  @override
  Future<void> deleteFoodEntry(String id) async {
    await _dataSource.delete(id);
  }

  @override
  Future<int> getTotalCaloriesConsumed() async {
    final entries = await getAllFoodEntries();
    return entries.fold<int>(
        0, (sum, entry) => sum + entry.nutritionInfo.calories);
  }

  @override
  Stream<List<FoodEntry>> watchAllFoodEntries() {
    return _foodEntriesController.stream;
  }

  // Don't forget to close the StreamController when it's no longer needed
  void dispose() {
    _foodEntriesController.close();
  }
}
