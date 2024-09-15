import 'package:bioscope/domain/datasources/data_source.dart';
import 'package:bioscope/domain/entities/food_entry.dart';

class MockRemoteFoodEntryDataSource implements DataSource<FoodEntry> {
  final List<FoodEntry> _entries = [];

  @override
  Future<void> initialize() async {
    // No initialization needed for mock
  }

  @override
  Future<List<FoodEntry>> getAll() async {
    return _entries;
  }

  @override
  Future<FoodEntry?> getById(String id) async {
    return _entries.firstWhere((entry) => entry.id == id);
  }

  @override
  Future<void> create(FoodEntry item) async {
    _entries.add(item);
  }

  @override
  Future<void> update(FoodEntry item) async {
    final index = _entries.indexWhere((entry) => entry.id == item.id);
    if (index != -1) {
      _entries[index] = item;
    }
  }

  @override
  Future<void> delete(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
  }

  @override
  Stream<List<FoodEntry>> watchAll() {
    return Stream.value(_entries);
  }

  @override
  Stream<FoodEntry?> watchById(String id) {
    return Stream.value(_entries.firstWhere((entry) => entry.id == id));
  }
}
