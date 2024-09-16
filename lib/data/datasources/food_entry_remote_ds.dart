import '../../core/interfaces/data_source.dart';
import '../models/food_entry_model.dart';

class FoodEntryRemoteDs implements DataSource<FoodEntryModel> {
  // This is a mock implementation. In a real scenario, this would interact with an API.

  final List<FoodEntryModel> _entries = [];

  @override
  Future<void> initialize() async {
    // No initialization needed for mock
  }

  @override
  Future<List<FoodEntryModel>> getAll() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _entries;
  }

  @override
  Future<FoodEntryModel> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _entries.firstWhere(
      (entry) => entry.id == id,
      orElse: () => FoodEntryModel.empty(),
    );
  }

  @override
  Future<void> create(FoodEntryModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.add(item);
  }

  @override
  Future<void> update(FoodEntryModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _entries.indexWhere((entry) => entry.id == item.id);
    if (index != -1) {
      _entries[index] = item;
    }
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.removeWhere((entry) => entry.id == id);
  }

  @override
  Stream<List<FoodEntryModel>> watchAll() {
    // In a real implementation, this might use web sockets or long polling
    return Stream.fromFuture(getAll());
  }

  @override
  Stream<FoodEntryModel> watchById(String id) {
    return Stream.fromFuture(getById(id));
  }
}
