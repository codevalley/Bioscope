import 'package:bioscope/core/interfaces/data_source.dart';
import 'package:bioscope/data/models/food_entry_model.dart';

/// Defines the interface for accessing and manipulating food entry data.
///
/// This interface extends the generic [DataSource] interface, specializing it
/// for [FoodEntryModel] operations. It provides methods for retrieving,
/// watching, and managing food entries.
abstract class FoodEntryDataSource extends DataSource<FoodEntryModel> {
  /// Retrieves all food entries.
  ///
  /// Returns a [Future] that completes with a list of [FoodEntryModel].
  Future<List<FoodEntryModel>> getAll();

  /// Provides a stream of all food entries.
  ///
  /// This stream emits a new list of [FoodEntryModel] whenever the underlying
  /// data changes.
  Stream<List<FoodEntryModel>> watchAll();

  /// Retrieves food entries for a specific date.
  ///
  /// [date] The date for which to retrieve food entries.
  /// Returns a [Future] that completes with a list of [FoodEntryModel].
  Future<List<FoodEntryModel>> getByDate(DateTime date);

  /// Retrieves an authenticated URL for an image associated with a food entry.
  ///
  /// This method is useful when images are stored in a secure location and require
  /// authentication to access.
  ///
  /// [fileName] The path or identifier of the image.
  /// Returns a [Future] that completes with the authenticated URL as a [String].
  Future<String> getAuthenticatedImageUrl(String fileName);
}
