import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/data_source.dart';
import '../models/food_entry_model.dart';
import 'dart:async';
import 'dart:convert';

class FoodEntrySupabaseDs implements DataSource<FoodEntryModel> {
  final SupabaseClient _supabaseClient;
  static const String _tableName = 'food_entries';

  FoodEntrySupabaseDs(this._supabaseClient);

  @override
  Future<void> initialize() async {
    // Supabase tables are created in the dashboard, so we don't need to create them here
    // However, we can check if the table exists and log a warning if it doesn't
    try {
      await _supabaseClient.from(_tableName).select().limit(1);
    } catch (e) {
      print('Warning: $_tableName table might not exist in Supabase');
    }
  }

  @override
  Future<List<FoodEntryModel>> getAll() async {
    final response = await _supabaseClient.from(_tableName).select();
    return (response as List)
        .map((item) => FoodEntryModel.fromJson(item))
        .toList();
  }

  @override
  Future<FoodEntryModel?> getById(String id) async {
    final response =
        await _supabaseClient.from(_tableName).select().eq('id', id).single();
    return response != null ? FoodEntryModel.fromJson(response) : null;
  }

  @override
  Future<void> create(FoodEntryModel item) async {
    await _supabaseClient.from(_tableName).insert(_toJson(item));
  }

  @override
  Future<void> update(FoodEntryModel item) async {
    await _supabaseClient
        .from(_tableName)
        .update(_toJson(item))
        .eq('id', item.id);
  }

  @override
  Future<void> delete(String id) async {
    await _supabaseClient.from(_tableName).delete().eq('id', id);
  }

  @override
  Stream<List<FoodEntryModel>> watchAll() {
    return _supabaseClient.from(_tableName).stream(primaryKey: ['id']).map(
        (event) => event.map((item) => FoodEntryModel.fromJson(item)).toList());
  }

  @override
  Stream<FoodEntryModel?> watchById(String id) {
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((event) =>
            event.isNotEmpty ? FoodEntryModel.fromJson(event.first) : null);
  }

  Map<String, dynamic> _toJson(FoodEntryModel model) {
    final json = model.toJson();
    json['nutritionInfo'] = jsonEncode(json['nutritionInfo']);
    return json;
  }
}
