import '../../core/interfaces/food_entry_datasource.dart';
import '../models/food_entry_model.dart';

/// Remote API implementation of the [FoodEntryDataSource] interface.
///
/// This class provides methods to interact with a remote API for storing and retrieving food entries.
/// Note: This is currently a mock implementation and should be replaced with actual API calls in production.
class FoodEntryRemoteDs implements FoodEntryDataSource {
  // This is a mock implementation. In a real scenario, this would interact with an API.

  final List<FoodEntryModel> _entries = [];

  /// Initializes the remote data source.
  ///
  /// In a real implementation, this might set up API authentication or other necessary configurations.
  @override
  Future<void> initialize() async {
    // No initialization needed for mock
  }

  /// Retrieves all food entries from the remote API.
  ///
  /// Returns a [Future] that completes with a list of [FoodEntryModel].
  @override
  Future<List<FoodEntryModel>> getAll() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _entries;
  }

  /// Retrieves a specific food entry by its ID from the remote API.
  ///
  /// [id] The unique identifier of the food entry.
  /// Returns a [Future] that completes with the [FoodEntryModel] if found, or an empty model if not found.
  @override
  Future<FoodEntryModel> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _entries.firstWhere(
      (entry) => entry.id == id,
      orElse: () => FoodEntryModel.empty(),
    );
  }

  /// Retrieves food entries for a specific date from the remote API.
  ///
  /// [date] The date for which to retrieve food entries.
  /// Returns a [Future] that completes with a list of [FoodEntryModel] for the given date.
  @override
  Future<List<FoodEntryModel>> getByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _entries.where((entry) => entry.date == date).toList();
  }

  /// Creates a new food entry in the remote API.
  ///
  /// [item] The [FoodEntryModel] to be created.
  @override
  Future<void> create(FoodEntryModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.add(item);
  }

  /// Updates an existing food entry in the remote API.
  ///
  /// [item] The [FoodEntryModel] to be updated.
  @override
  Future<void> update(FoodEntryModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _entries.indexWhere((entry) => entry.id == item.id);
    if (index != -1) {
      _entries[index] = item;
    }
  }

  /// Deletes a food entry from the remote API.
  ///
  /// [id] The unique identifier of the food entry to be deleted.
  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.removeWhere((entry) => entry.id == id);
  }

  /// Provides a stream of all food entries.
  ///
  /// Returns a [Stream] that emits a list of [FoodEntryModel] whenever the data changes.
  /// Note: In a real implementation, this might use web sockets or long polling.
  @override
  Stream<List<FoodEntryModel>> watchAll() {
    // In a real implementation, this might use web sockets or long polling
    return Stream.fromFuture(getAll());
  }

  /// Provides a stream of a specific food entry by its ID.
  ///
  /// [id] The unique identifier of the food entry to watch.
  /// Returns a [Stream] that emits the updated [FoodEntryModel] whenever it changes.
  @override
  Stream<FoodEntryModel> watchById(String id) {
    return Stream.fromFuture(getById(id));
  }

  /// Sets up real-time listeners for data changes.
  ///
  /// This method is not implemented in this mock version.
  @override
  void setupRealtimeListeners(Function(List<FoodEntryModel>) onDataChanged) {
    // No implementation needed for mock
  }

  /// Retrieves an authenticated URL for an image associated with a food entry.
  ///
  /// [fileName] The name of the image file.
  /// Returns a [Future] that completes with the authenticated URL as a [String].
  /// Note: In this mock implementation, it simply returns the file name.
  @override
  Future<String> getAuthenticatedImageUrl(String fileName) async {
    // In a real implementation, this would use an API to get the authenticated URL
    return fileName;
  }
}
