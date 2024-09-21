import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/data_source.dart';
import '../models/user_profile_model.dart';

class UserProfileSupabaseDs implements DataSource<UserProfileModel> {
  final SupabaseClient _supabaseClient;
  static const String _tableName = 'user_profiles';

  UserProfileSupabaseDs(this._supabaseClient);

  @override
  Future<void> initialize() async {
    try {
      await _supabaseClient.from(_tableName).select().limit(1);
    } catch (e) {
      print('Warning: $_tableName table might not exist in Supabase');
    }
  }

  @override
  Future<List<UserProfileModel>> getAll() async {
    final response = await _supabaseClient.from(_tableName).select();
    return (response as List)
        .map((item) => UserProfileModel.fromJson(item))
        .toList();
  }

  @override
  Future<UserProfileModel?> getById(String id) async {
    final response =
        await _supabaseClient.from(_tableName).select().eq('id', id).single();
    return response != null ? UserProfileModel.fromJson(response) : null;
  }

  @override
  Future<void> create(UserProfileModel item) async {
    await _supabaseClient.from(_tableName).insert(item.toJson());
  }

  @override
  Future<void> update(UserProfileModel item) async {
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
  Stream<List<UserProfileModel>> watchAll() {
    return _supabaseClient.from(_tableName).stream(primaryKey: ['id']).map(
        (event) =>
            event.map((item) => UserProfileModel.fromJson(item)).toList());
  }

  @override
  Stream<UserProfileModel?> watchById(String id) {
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((event) =>
            event.isNotEmpty ? UserProfileModel.fromJson(event.first) : null);
  }
}
