import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/data/repositories/food_entry_repository_impl.dart';
import 'package:bioscope/data/datasources/sqlite_food_entry_data_source.dart';
import 'package:bioscope/data/datasources/mock_remote_food_entry_data_source.dart';

final foodEntryRepositoryProvider = Provider<FoodEntryRepository>((ref) {
  return FoodEntryRepositoryImpl(
    localDataSource: SQLiteFoodEntryDataSource(),
    remoteDataSource: MockRemoteFoodEntryDataSource(),
  );
});
