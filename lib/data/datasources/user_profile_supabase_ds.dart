import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/interfaces/data_source.dart';
import '../models/user_profile_model.dart';

class UserProfileSupabaseDs implements DataSource<UserProfileModel> {
  final SupabaseClient _supabaseClient;
  static const String _tableName = 'user_profiles';

  UserProfileSupabaseDs(this._supabaseClient);

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
  Future<List<UserProfileModel>> getAll() async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('id', _currentUserId);
      return (response as List)
          .map((item) => UserProfileModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching user profile: $e');
      return [];
    }
  }

  @override
  Future<UserProfileModel?> getById(String id) async {
    if (id != _currentUserId) {
      throw Exception('Unauthorized access to user profile');
    }
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();
      return response != null ? UserProfileModel.fromJson(response) : null;
    } catch (e) {
      print('Error fetching user profile by ID: $e');
      return null;
    }
  }

  @override
  Future<void> create(UserProfileModel item) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User not authenticated');
    }
    try {
      final dataToInsert = item.toJson();
      dataToInsert['id'] = _currentUserId;

      final response =
          await _supabaseClient.from(_tableName).insert(dataToInsert).select();

      if (response.isEmpty) {
        // If response is null or empty, but no error was thrown, assume success
        print('User profile created successfully, but no response received');
        return;
      }

      // If we reach here, we have a response, so we can parse it
      final createdProfile = UserProfileModel.fromJson(response.first);
      print('User profile created successfully: ${createdProfile.id}');
    } catch (e) {
      print('Error creating user profile: $e');
      throw Exception('Failed to create user profile: $e');
    }
  }

  @override
  Future<void> update(UserProfileModel item) async {
    if (item.id != _currentUserId) {
      throw Exception('Unauthorized profile update');
    }
    try {
      await _supabaseClient
          .from(_tableName)
          .update(item.toJson())
          .eq('id', item.id);
    } catch (e) {
      print('Error updating user profile: $e');
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    if (id != _currentUserId) {
      throw Exception('Unauthorized profile deletion');
    }
    try {
      await _supabaseClient.from(_tableName).delete().eq('id', id);
    } catch (e) {
      print('Error deleting user profile: $e');
      throw Exception('Failed to delete user profile: $e');
    }
  }

  @override
  Stream<List<UserProfileModel>> watchAll() {
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', _currentUserId)
        .handleError((error) {
          print('Error in watchAll stream: $error');
        })
        .map((event) =>
            event.map((item) => UserProfileModel.fromJson(item)).toList());
  }

  @override
  Stream<UserProfileModel?> watchById(String id) {
    if (id != _currentUserId) {
      throw Exception('Unauthorized access to user profile stream');
    }
    return _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .handleError((error) {
          print('Error in watchById stream: $error');
        })
        .map((event) =>
            event.isNotEmpty ? UserProfileModel.fromJson(event.first) : null);
  }

  @override
  void setupRealtimeListeners(Function(List<UserProfileModel>) onDataChanged) {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser == null) {
      print('No user logged in. Skipping real-time listener setup.');
      onDataChanged([]); // Notify with an empty list when no user is logged in
      return;
    }

    _supabaseClient
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('id', currentUser.id) // Only listen to the current user's profile
        .listen((event) {
          final updatedData =
              event.map((item) => UserProfileModel.fromJson(item)).toList();
          onDataChanged(updatedData);
        }, onError: (error) {
          print('Error in realtime listener: $error');
          onDataChanged([]); // Notify with an empty list in case of error
        });
  }

  @override
  Future<void> recalculate(String id, DateTime date) async {
    // TODO: implementation needed for Supabase
  }
}
