import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/datasources/food_entry_data_source.dart';
import '../datasources/sqlite_food_entry_data_source.dart';

class FoodEntryRepositoryImpl implements FoodEntryRepository {
  final FoodEntryDataSource _dataSource;

  FoodEntryRepositoryImpl(this._dataSource);

  @override // Add this line
  Future<void> initialize() async {
    await _dataSource.initialize();
  }

  @override
  Future<List<FoodEntry>> getRecentFoodEntries() async {
    return await _dataSource.getRecentFoodEntries();
  }

  @override
  Future<void> addFoodEntry(FoodEntry entry) async {
    await _dataSource.addFoodEntry(entry);
  }

  @override
  Future<int> getTotalCaloriesConsumed() async {
    return await _dataSource.getTotalCaloriesConsumed();
  }
}

final foodEntryRepositoryProvider = Provider<FoodEntryRepository>((ref) {
  final dataSource = SQLiteFoodEntryDataSource();
  final repository = FoodEntryRepositoryImpl(dataSource);
  repository.initialize(); // Initialize the database
  return repository;
});
