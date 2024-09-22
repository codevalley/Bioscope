import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/data_source.dart';

class SupabaseDataSource<T> implements DataSource<T> {
  final SupabaseClient _supabaseClient;
  final String _tableName;
  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;

  SupabaseDataSource(
      this._supabaseClient, this._tableName, this._fromJson, this._toJson);

  @override
  Future<void> initialize() async {
    // No initialization needed for Supabase
  }

  @override
  Future<List<T>> getAll() async {
    final response = await _supabaseClient.from(_tableName).select();
    return response.map((item) => _fromJson(item)).toList();
  }

  @override
  Future<T?> getById(String id) async {
    final response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('id', id)
        .maybeSingle();
    return response != null ? _fromJson(response) : null;
  }

  @override
  Future<void> create(T item) async {
    await _supabaseClient.from(_tableName).insert(_toJson(item));
  }

  @override
  Future<void> update(T item) async {
    final itemJson = _toJson(item);
    await _supabaseClient
        .from(_tableName)
        .update(itemJson)
        .eq('id', itemJson['id']);
  }

  @override
  Future<void> delete(String id) async {
    await _supabaseClient.from(_tableName).delete().eq('id', id);
  }

  @override
  Stream<List<T>> watchAll() {
    return _supabaseClient.from(_tableName).stream(primaryKey: ['id']).map(
        (event) => event.map((e) => _fromJson(e)).toList());
  }

  @override
  Stream<T?> watchById(String id) {
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((event) => event.isNotEmpty ? _fromJson(event.first) : null);
  }
}
