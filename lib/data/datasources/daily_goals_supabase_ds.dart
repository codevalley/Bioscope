import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/daily_goals_datasource.dart';
import '../models/daily_goals_model.dart';

class DailyGoalsSupabaseDs implements DailyGoalsDataSource {
  final SupabaseClient _supabaseClient;
  static const String _tableName = 'daily_goals';

  DailyGoalsSupabaseDs(this._supabaseClient);

  String get _currentUserId => _supabaseClient.auth.currentUser?.id ?? '';

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

    final response = await query.order('date', ascending: false);
    return (response as List)
        .map((item) => DailyGoalsModel.fromJson(item))
        .toList();
  }

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

  @override
  Future<void> create(DailyGoalsModel item) async {
    final dataToInsert = item.toJson();
    dataToInsert['user_id'] = _currentUserId;
    await _supabaseClient.from(_tableName).insert(dataToInsert);
  }

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

  @override
  Future<void> delete(String id) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('id', id)
        .eq('user_id', _currentUserId);
  }

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

  // Stream<DailyGoalsModel?> watchByDate(DateTime date) {
  //   return _supabaseClient
  //       .from(_tableName)
  //       .stream(primaryKey: ['id'])
  //       .eq('user_id', _currentUserId)
  //       .eq('date', date.toIso8601String().split('T')[0])
  //       .map((event) =>
  //           event.isNotEmpty ? DailyGoalsModel.fromJson(event.first) : null);
  // }

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
        .eq('user_id', _currentUserId)
        .order('date', ascending: false)
        .listen((event) {
          final updatedData =
              event.map((item) => DailyGoalsModel.fromJson(item)).toList();
          onDataChanged(updatedData);
        });
  }

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
      print('Error triggering daily goals recalculation: $e');
      // Handle error (e.g., retry, log, notify user)
    }
  }
}
