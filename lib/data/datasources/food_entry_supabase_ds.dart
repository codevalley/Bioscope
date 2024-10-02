import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/food_entry_datasource.dart';
import '../models/food_entry_model.dart';
import '../../core/utils/logger.dart';
import 'dart:async';

class FoodEntrySupabaseDs extends FoodEntryDataSource {
  final SupabaseClient _supabaseClient;
  static const String _tableName = 'food_entries';

  FoodEntrySupabaseDs(this._supabaseClient);

  String get _currentUserId => _supabaseClient.auth.currentUser?.id ?? '';

  @override
  Future<void> initialize() async {
    try {
      await _supabaseClient.from(_tableName).select().limit(1);
    } catch (e) {
      Logger.log(
          'Warning: $_tableName table might not exist in Supabase. Error: $e');
    }
  }

  @override
  Future<List<FoodEntryModel>> getAll() async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('userid', _currentUserId);
      return (response as List)
          .map((item) => FoodEntryModel.fromJson(item))
          .toList();
    } catch (e) {
      Logger.log('Error fetching all food entries: $e');
      return [];
    }
  }

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
        .lt('date', endOfDay);

    return (response as List)
        .map((item) => FoodEntryModel.fromJson(item))
        .toList();
  }

  @override
  Future<void> create(FoodEntryModel item) async {
    try {
      final dataToInsert = item.toJson();
      dataToInsert['userid'] = _currentUserId;
      await _supabaseClient.from(_tableName).insert(dataToInsert);
    } catch (e) {
      Logger.log('Error creating food entry: $e');
      throw Exception('Failed to create food entry: $e');
    }
  }

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

  @override
  Stream<List<FoodEntryModel>> watchAll() {
    final stream = _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id']).eq('userid', _currentUserId);

    return stream.map(
        (event) => event.map((item) => FoodEntryModel.fromJson(item)).toList());
  }

  @override
  Stream<FoodEntryModel?> watchById(String id) {
    final stream = _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id']).eq('id', id);
    //.eq('userid', _currentUserId);

    return stream.map((event) =>
        event.isNotEmpty ? FoodEntryModel.fromJson(event.first) : null);
  }

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
