import '../entities/food_entry.dart';

abstract class IFoodEntryRepository {
  Future<List<FoodEntry>> getAllFoodEntries();
  Future<List<FoodEntry>> getRecentFoodEntries();
  Future<void> addFoodEntry(FoodEntry entry);
  Future<void> updateFoodEntry(FoodEntry entry);
  Future<void> deleteFoodEntry(String id);
  Future<int> getTotalCaloriesConsumed();
  Stream<List<FoodEntry>> watchAllFoodEntries();
}
