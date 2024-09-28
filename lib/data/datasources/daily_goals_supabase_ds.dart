import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/data_source.dart';
import '../models/daily_goals_model.dart';

class DailyGoalsSupabaseDs implements DataSource<DailyGoalsModel> {
  final SupabaseClient _supabaseClient;
  static const String _tableName = 'daily_goals';

  DailyGoalsSupabaseDs(this._supabaseClient);

  @override
  Future<void> initialize() async {
    try {
      await _supabaseClient.from(_tableName).select().limit(1);
    } catch (e) {
      print(
          'Warning: $_tableName table might not exist in Supabase. Error: $e');
    }
  }

  @override
  Future<List<DailyGoalsModel>> getAll() async {
    final response = await _supabaseClient
        .from(_tableName)
        .select()
        .order('date', ascending: false);
    return (response as List)
        .map((item) => DailyGoalsModel.fromJson(item))
        .toList();
  }

  @override
  Future<DailyGoalsModel?> getById(String id) async {
    final response =
        await _supabaseClient.from(_tableName).select().eq('id', id).single();
    return response.isNotEmpty ? DailyGoalsModel.fromJson(response) : null;
  }

  Future<DailyGoalsModel?> getByUserAndDate(
      String userId, DateTime date) async {
    final response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .eq('date', date.toIso8601String().split('T')[0])
        .maybeSingle();
    return response != null ? DailyGoalsModel.fromJson(response) : null;
  }

  @override
  Future<void> create(DailyGoalsModel item) async {
    await _supabaseClient.from(_tableName).insert(item.toJson());
  }

  @override
  Future<void> update(DailyGoalsModel item) async {
    await _supabaseClient
        .from(_tableName)
        .update(item.toJson())
        .eq('id', item.id);
  }

  @override
  Future<void> delete(String id) async {
    await _supabaseClient.from(_tableName).delete().eq('id', id);
  }

  @override
  Stream<List<DailyGoalsModel>> watchAll() {
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('date', ascending: false)
        .map((event) =>
            event.map((item) => DailyGoalsModel.fromJson(item)).toList());
  }

  @override
  Stream<DailyGoalsModel?> watchById(String id) {
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((event) =>
            event.isNotEmpty ? DailyGoalsModel.fromJson(event.first) : null);
  }

  @override
  void setupRealtimeListeners(Function(List<DailyGoalsModel>) onDataChanged) {
    _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('date', ascending: false)
        .listen((event) {
          final updatedData =
              event.map((item) => DailyGoalsModel.fromJson(item)).toList();
          onDataChanged(updatedData);
        });
  }

  @override
  Future<void> recalculate(String id, DateTime date) async {
    // Implement if needed for Supabase
  }

  Future<void> recalculateDailyGoals(String userId, DateTime date) async {
    try {
      final response = await _supabaseClient.functions.invoke(
        'recalculate-daily-goals',
        body: {
          'userId': userId,
          'date': date.toIso8601String().split('T')[0],
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to recalculate daily goals: ${response.data}');
      }
    } catch (e) {
      print('Error triggering daily goals recalculation: $e');
      // Handle error (e.g., retry, log, notify user)
    }
  }
}
