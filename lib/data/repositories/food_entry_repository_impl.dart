import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../datasources/food_entry_sqlite_ds.dart';
import '../models/food_entry_model.dart';

class FoodEntryRepositoryImpl implements IFoodEntryRepository {
  final FoodEntrySqliteDs _dataSource;

  FoodEntryRepositoryImpl(this._dataSource);

  @override
  Future<List<FoodEntry>> getAllFoodEntries() async {
    final foodEntryModels = await _dataSource.getAll();
    return foodEntryModels.map((model) => model as FoodEntry).toList();
  }

  @override
  Future<List<FoodEntry>> getRecentFoodEntries() async {
    final allEntries = await getAllFoodEntries();
    allEntries.sort((a, b) => b.date.compareTo(a.date));
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
    return _dataSource.watchAll().map(
          (foodEntryModels) =>
              foodEntryModels.map((model) => model as FoodEntry).toList(),
        );
  }
}
