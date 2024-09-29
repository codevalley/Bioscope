import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/services/auth_service.dart';
import '../../core/utils/logger.dart';

class SupabaseAuthService implements IAuthService {
  final SupabaseClient _supabaseClient;

  SupabaseAuthService(this._supabaseClient) {
    _supabaseClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      Logger.log('Auth state changed: $event');
      if (session != null) {
        Logger.log('User ID: ${session.user.id}');
      } else {
        Logger.log('No user session');
      }
    });
  }

  @override
  Future<String?> getCurrentUserId() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    Logger.log('Current user ID: $userId');
    return userId;
  }

  @override
  Future<bool> isAnonymous() async {
    return _supabaseClient.auth.currentUser?.appMetadata['provider'] ==
        'anonymous';
  }

  @override
  Future<void> signInAnonymously() async {
    await _supabaseClient.auth.signInAnonymously();
  }

  @override
  Future<void> signUp(String email, String password) async {
    await _supabaseClient.auth.signUp(email: email, password: password);
  }

  @override
  Future<void> signIn(String email, String password) async {
    await _supabaseClient.auth
        .signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  @override
  void onAuthStateChange(Function(String?) listener) {
    _supabaseClient.auth.onAuthStateChange.listen((data) {
      final String? userId = data.session?.user.id;
      listener(userId);
    });
  }
}
