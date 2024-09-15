import 'package:bioscope/domain/datasources/data_source.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';

class FoodEntryRepositoryImpl implements FoodEntryRepository {
  final DataSource<FoodEntry> localDataSource;
  final DataSource<FoodEntry> remoteDataSource;

  FoodEntryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> initialize() async {
    await localDataSource.initialize();
    await remoteDataSource.initialize();
  }

  @override
  Future<List<FoodEntry>> getAllFoodEntries() async {
    try {
      final remoteData = await remoteDataSource.getAll();
      for (var item in remoteData) {
        await localDataSource.create(item);
      }
      return remoteData;
    } catch (e) {
      return localDataSource.getAll();
    }
  }

  @override
  Future<List<FoodEntry>> getRecentFoodEntries() async {
    final allEntries = await getAllFoodEntries();
    allEntries.sort((a, b) {
      final aDate = a.date;
      final bDate = b.date;
      if (aDate == null || bDate == null) return 0;
      return bDate.compareTo(aDate);
    });
    return allEntries.take(5).toList();
  }

  @override
  Future<void> addFoodEntry(FoodEntry entry) async {
    await localDataSource.create(entry);
    try {
      await remoteDataSource.create(entry);
    } catch (e) {
      // Handle error or queue for later sync
    }
  }

  @override
  Future<int> getTotalCaloriesConsumed() async {
    final entries = await getAllFoodEntries();
    return entries.fold<int>(0, (sum, entry) => sum + (entry.calories ?? 0));
  }

  @override
  Stream<List<FoodEntry>> watchAllFoodEntries() {
    return localDataSource.watchAll();
  }
}
