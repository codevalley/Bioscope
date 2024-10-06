import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/daily_goals_datasource.dart';
import '../models/daily_goals_model.dart';
import '../../core/utils/logger.dart';

/// Supabase implementation of the [DailyGoalsDataSource] interface.
///
/// This class provides methods to interact with a Supabase backend
/// for storing and retrieving daily nutritional goals.
class DailyGoalsSupabaseDs implements DailyGoalsDataSource {
  final SupabaseClient _supabaseClient;
  static const String _tableName = 'daily_goals';

  /// Creates a new instance of [DailyGoalsSupabaseDs].
  ///
  /// Requires a [SupabaseClient] instance to interact with Supabase.
  DailyGoalsSupabaseDs(this._supabaseClient);

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

  /// Retrieves all daily goals for the current user, optionally filtered by date range.
  ///
  /// [startDate] Optional start date for filtering.
  /// [endDate] Optional end date for filtering.
  /// Returns a [Future] that completes with a list of [DailyGoalsModel].
  @override
  Future<List<DailyGoalsModel>> getAll(
      {DateTime? startDate, DateTime? endDate}) async {
    var query =
        _supabaseClient.from(_tableName).select().eq('user_id', _currentUserId);

    if (startDate != null) {
      query = query.gte('date', startDate.toIso8601String().split('T')[0]);
    }
    if (endDate != null) {
      query = query.lte('date', endDate.toIso8601String().split('T')[0]);
    }

    final response = await query.order('date', ascending: startDate == null);
    return (response as List)
        .map((item) => DailyGoalsModel.fromJson(item))
        .toList();
  }

  /// Retrieves a specific daily goal by its ID.
  ///
  /// [id] The unique identifier of the daily goal.
  /// Returns a [Future] that completes with the [DailyGoalsModel] if found, or null otherwise.
  @override
  Future<DailyGoalsModel?> getById(String id) async {
    final response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('id', id)
        .eq('user_id', _currentUserId)
        .single();
    return response.isNotEmpty ? DailyGoalsModel.fromJson(response) : null;
  }

  /// Retrieves the daily goals for a specific date.
  ///
  /// [date] The date for which to retrieve goals.
  /// Returns a [Future] that completes with a [DailyGoalsModel] if found, or null otherwise.
  @override
  Future<DailyGoalsModel?> getByDate(DateTime date) async {
    final response = await _supabaseClient
        .from('daily_goals')
        .select()
        .eq('date', date.toIso8601String().split('T')[0])
        .maybeSingle();
    if (response != null) {
      return DailyGoalsModel.fromJson(response);
    }
    return null;
  }

  /// Creates a new daily goal entry in Supabase.
  ///
  /// [item] The [DailyGoalsModel] to be created.
  @override
  Future<void> create(DailyGoalsModel item) async {
    final dataToInsert = item.toJson();
    dataToInsert['user_id'] = _currentUserId;
    await _supabaseClient.from(_tableName).insert(dataToInsert);
  }

  /// Updates an existing daily goal entry in Supabase.
  ///
  /// [item] The [DailyGoalsModel] to be updated.
  @override
  Future<void> update(DailyGoalsModel item) async {
    final dataToUpdate = item.toJson();
    dataToUpdate['user_id'] = _currentUserId;
    await _supabaseClient
        .from(_tableName)
        .update(dataToUpdate)
        .eq('user_id', _currentUserId)
        .eq('date', item.date.toIso8601String().split('T')[0]);
  }

  /// Deletes a daily goal entry from Supabase.
  ///
  /// [id] The unique identifier of the daily goal to be deleted.
  @override
  Future<void> delete(String id) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('id', id)
        .eq('user_id', _currentUserId);
  }

  /// Provides a stream of all daily goals for the current user.
  ///
  /// Returns a [Stream] that emits a list of [DailyGoalsModel] whenever the data changes.
  @override
  Stream<List<DailyGoalsModel>> watchAll() {
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', _currentUserId)
        .order('date', ascending: false)
        .map((event) =>
            event.map((item) => DailyGoalsModel.fromJson(item)).toList());
  }

  /// Provides a stream of a specific daily goal by its ID.
  ///
  /// [id] The unique identifier of the daily goal to watch.
  /// Returns a [Stream] that emits the updated [DailyGoalsModel] whenever it changes.
  @override
  Stream<DailyGoalsModel?> watchById(String id) {
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((event) =>
            event.isNotEmpty ? DailyGoalsModel.fromJson(event.first) : null);
  }

  /// Sets up real-time listeners for data changes.
  ///
  /// [onDataChanged] A callback function that will be called with the updated list of items
  /// whenever the data changes.
  @override
  void setupRealtimeListeners(Function(List<DailyGoalsModel>) onDataChanged) {
    _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', _currentUserId)
        .order('date', ascending: false)
        .listen((event) {
          final updatedData =
              event.map((item) => DailyGoalsModel.fromJson(item)).toList();
          onDataChanged(updatedData);
        });
  }

  /// Recalculates the daily goals for a specific date.
  ///
  /// This method triggers a Supabase Function to perform the recalculation.
  /// [date] The date for which to recalculate goals.
  @override
  Future<void> recalculate(DateTime date) async {
    try {
      final response = await _supabaseClient.functions.invoke(
        'recalculate-daily-goals',
        body: {
          'userId': _currentUserId,
          'date': date.toIso8601String().split('T')[0],
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to recalculate daily goals: ${response.data}');
      }
    } catch (e) {
      Logger.log('Error triggering daily goals recalculation: $e');
      // Handle error (e.g., retry, log, notify user)
    }
  }
}
