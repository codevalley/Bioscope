import '../entities/food_entry.dart';

/// Repository interface for managing food entries.
///
/// This interface defines the contract for interacting with food entry data,
/// regardless of the underlying data source (e.g., local database, remote API).
abstract class IFoodEntryRepository {
  /// Retrieves all food entries.
  ///
  /// Returns a [Future] that completes with a list of all [FoodEntry] objects.
  Future<List<FoodEntry>> getAllFoodEntries();

  /// Retrieves recent food entries.
  ///
  /// The definition of "recent" may vary based on the implementation.
  /// Returns a [Future] that completes with a list of recent [FoodEntry] objects.
  Future<List<FoodEntry>> getRecentFoodEntries();

  /// Adds a new food entry.
  ///
  /// [entry] The [FoodEntry] object to be added.
  Future<void> addFoodEntry(FoodEntry entry);

  /// Updates an existing food entry.
  ///
  /// [entry] The [FoodEntry] object with updated information.
  Future<void> updateFoodEntry(FoodEntry entry);

  /// Deletes a food entry.
  ///
  /// [id] The unique identifier of the food entry to be deleted.
  Future<void> deleteFoodEntry(String id);

  /// Calculates the total calories consumed.
  ///
  /// Returns a [Future] that completes with the total calories as an integer.
  Future<int> getTotalCaloriesConsumed();

  /// Retrieves food entries for a specific date.
  ///
  /// [date] The date for which to retrieve entries.
  /// Returns a [Future] that completes with a list of [FoodEntry] objects for the given date.
  Future<List<FoodEntry>> getEntriesByDate(DateTime date);

  /// Provides a stream of all food entries.
  ///
  /// Returns a [Stream] that emits a list of [FoodEntry] objects whenever the data changes.
  Stream<List<FoodEntry>> watchAllFoodEntries();

  /// Retrieves an authenticated URL for an image associated with a food entry.
  ///
  /// [fileName] The name of the image file.
  /// Returns a [Future] that completes with the authenticated URL as a [String].
  Future<String> getAuthenticatedImageUrl(String fileName);
}
