import '../entities/food_entry.dart';

abstract class FoodEntryRepository {
  Future<void> initialize();
  Future<List<FoodEntry>> getRecentFoodEntries();
  Future<void> addFoodEntry(FoodEntry entry);
  Future<int> getTotalCaloriesConsumed();
}
