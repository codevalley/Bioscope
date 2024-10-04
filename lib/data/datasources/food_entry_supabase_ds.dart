import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/food_entry_datasource.dart';
import '../models/food_entry_model.dart';
import '../../core/utils/logger.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// Supabase implementation of the [FoodEntryDataSource] interface.
///
/// This class provides methods to interact with a Supabase backend
/// for storing and retrieving food entries.
class FoodEntrySupabaseDs extends FoodEntryDataSource {
  final SupabaseClient _supabaseClient;
  static const String _tableName = 'food_entries';

  /// Creates a new instance of [FoodEntrySupabaseDs].
  ///
  /// Requires a [SupabaseClient] instance to interact with Supabase.
  FoodEntrySupabaseDs(this._supabaseClient);

  /// Gets the current user's ID from Supabase authentication.
  String get _currentUserId => _supabaseClient.auth.currentUser?.id ?? '';

  /// Initializes the Supabase connection and checks if the table exists.
  @override
  Future<void> initialize() async {
    try {
      await _supabaseClient.from(_tableName).select().limit(1);
    } catch (e) {
      Logger.log(
          'Warning: $_tableName table might not exist in Supabase. Error: $e');
    }
  }

  /// Retrieves an authenticated URL for an image associated with a food entry.
  ///
  /// [fileName] The name of the image file.
  /// Returns a [Future] that completes with the authenticated URL as a [String].
  @override
  Future<String> getAuthenticatedImageUrl(String fileName) async {
    try {
      final response = await _supabaseClient.storage
          .from('food_images')
          .createSignedUrl(
              fileName, 60 * 60 * 24 * 30); // URL valid for 30 days

      return response;
    } catch (e) {
      Logger.log('Error getting authenticated image URL: $e');
      return _supabaseClient.storage.from('food_images').getPublicUrl(fileName);
    }
  }

  /// Uploads an image file to Supabase storage.
  ///
  /// [localPath] The local path of the image file to be uploaded.
  /// Returns a [Future] that completes with the file name of the uploaded image, or null if the upload fails.
  Future<String?> _uploadImage(String localPath) async {
    try {
      final file = File(localPath);
      final fileExtension = path.extension(localPath);
      final fileName = '${const Uuid().v4()}$fileExtension';

      final urlpath = await _supabaseClient.storage
          .from('food_images')
          .upload(fileName, file);

      if (urlpath.isNotEmpty) {
        return fileName; // Return only the file name
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      Logger.log('Error uploading image: $e');
      return null;
    }
  }

  /// Retrieves all food entries for the current user from Supabase.
  ///
  /// Returns a [Future] that completes with a list of [FoodEntryModel].
  @override
  Future<List<FoodEntryModel>> getAll() async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('userid', _currentUserId)
          .order('date', ascending: false); // Sort in descending order
      return (response as List)
          .map((item) => FoodEntryModel.fromJson(item))
          .toList();
    } catch (e) {
      Logger.log('Error fetching all food entries: $e');
      return [];
    }
  }

  /// Retrieves a specific food entry by its ID from Supabase.
  ///
  /// [id] The unique identifier of the food entry.
  /// Returns a [Future] that completes with the [FoodEntryModel] if found, or null otherwise.
  @override
  Future<FoodEntryModel?> getById(String id) async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('id', id)
          .eq('userid', _currentUserId)
          .single();
      return FoodEntryModel.fromJson(response);
    } catch (e) {
      Logger.log('Error fetching food entry by ID: $e');
      return null;
    }
  }

  /// Retrieves food entries for a specific date from Supabase.
  ///
  /// [date] The date for which to retrieve food entries.
  /// Returns a [Future] that completes with a list of [FoodEntryModel] for the given date.
  @override
  Future<List<FoodEntryModel>> getByDate(DateTime date) async {
    final startOfDay =
        DateTime(date.year, date.month, date.day).toIso8601String();
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999)
        .toIso8601String();

    final response = await _supabaseClient
        .from('food_entries')
        .select()
        .eq('userid', _currentUserId)
        .gte('date', startOfDay)
        .lt('date', endOfDay)
        .order('date', ascending: false); // Sort in descending order

    return (response as List)
        .map((item) => FoodEntryModel.fromJson(item))
        .toList();
  }

  /// Creates a new food entry in Supabase.
  ///
  /// [item] The [FoodEntryModel] to be created.
  @override
  Future<void> create(FoodEntryModel item) async {
    try {
      final dataToInsert = item.toJson();
      dataToInsert['userid'] = _currentUserId;
      if (item.imagePath != null) {
        final fileName = await _uploadImage(item.imagePath!);
        dataToInsert['imagePath'] = fileName; // Store only the file name
      }
      await _supabaseClient.from(_tableName).insert(dataToInsert);
    } catch (e) {
      Logger.log('Error creating food entry: $e');
      throw Exception('Failed to create food entry: $e');
    }
  }

  /// Updates an existing food entry in Supabase.
  ///
  /// [item] The [FoodEntryModel] to be updated.
  @override
  Future<void> update(FoodEntryModel item) async {
    try {
      final dataToUpdate = item.toJson();
      dataToUpdate['userid'] = _currentUserId;
      await _supabaseClient
          .from(_tableName)
          .update(dataToUpdate)
          .eq('id', item.id)
          .eq('userid', _currentUserId);
    } catch (e) {
      Logger.log('Error updating food entry: $e');
      throw Exception('Failed to update food entry: $e');
    }
  }

  /// Deletes a food entry from Supabase.
  ///
  /// [id] The unique identifier of the food entry to be deleted.
  @override
  Future<void> delete(String id) async {
    try {
      await _supabaseClient
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('userid', _currentUserId);
    } catch (e) {
      Logger.log('Error deleting food entry: $e');
      throw Exception('Failed to delete food entry: $e');
    }
  }

  /// Provides a stream of all food entries for the current user.
  ///
  /// Returns a [Stream] that emits a list of [FoodEntryModel] whenever the data changes.
  @override
  Stream<List<FoodEntryModel>> watchAll() {
    final stream = _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('userid', _currentUserId)
        .order('date', ascending: false); // Sort in descending order

    return stream.map(
        (event) => event.map((item) => FoodEntryModel.fromJson(item)).toList());
  }

  /// Provides a stream of a specific food entry by its ID.
  ///
  /// [id] The unique identifier of the food entry to watch.
  /// Returns a [Stream] that emits the updated [FoodEntryModel] whenever it changes.
  @override
  Stream<FoodEntryModel?> watchById(String id) {
    final stream = _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id']).eq('id', id);
    //.eq('userid', _currentUserId);

    return stream.map((event) =>
        event.isNotEmpty ? FoodEntryModel.fromJson(event.first) : null);
  }

  /// Sets up real-time listeners for data changes in Supabase.
  ///
  /// [onDataChanged] A callback function that will be called with the updated list of items
  /// whenever the data changes.
  @override
  void setupRealtimeListeners(Function(List<FoodEntryModel>) onDataChanged) {
    _supabaseClient
        .channel('public:$_tableName')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _tableName,
          callback: (payload) async {
            // Fetch the latest data when a change occurs
            final updatedData = await getAll();
            onDataChanged(updatedData);
          },
        )
        .subscribe();
  }
}
