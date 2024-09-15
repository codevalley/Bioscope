import 'package:bioscope/domain/entities/food_entry.dart';

abstract class FoodEntryRepository {
  Future<void> initialize();
  Future<List<FoodEntry>> getAllFoodEntries();
  Future<List<FoodEntry>> getRecentFoodEntries();
  Future<void> addFoodEntry(FoodEntry entry);
  Future<int> getTotalCaloriesConsumed();
  Stream<List<FoodEntry>> watchAllFoodEntries();
}
