import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/services/auth_service.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/cache_manager.dart';

/// Implementation of [IAuthService] using Supabase for authentication.
class SupabaseAuthService implements IAuthService {
  final SupabaseClient _supabaseClient;

  /// Creates a new instance of [SupabaseAuthService].
  ///
  /// Sets up a listener for authentication state changes.
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

  /// Retrieves the current user's ID.
  ///
  /// Returns the user ID if a user is logged in, or null otherwise.
  @override
  Future<String?> getCurrentUserId() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    Logger.log('Current user ID: $userId');
    return userId;
  }

  /// Checks if the current user is anonymous.
  ///
  /// Returns true if the user is anonymous, false otherwise.
  @override
  Future<bool> isAnonymous() async {
    return _supabaseClient.auth.currentUser?.appMetadata['provider'] ==
        'anonymous';
  }

  /// Signs in the user anonymously.
  ///
  /// Creates a new anonymous account or signs in to an existing one.
  @override
  Future<void> signInAnonymously() async {
    await _supabaseClient.auth.signInAnonymously();
  }

  /// Signs up a new user with email and password.
  ///
  /// [email] The email address for the new account.
  /// [password] The password for the new account.
  @override
  Future<void> signUp(String email, String password) async {
    await _supabaseClient.auth.signUp(email: email, password: password);
  }

  /// Signs in an existing user with email and password.
  ///
  /// [email] The email address of the user.
  /// [password] The password of the user.
  @override
  Future<void> signIn(String email, String password) async {
    await _supabaseClient.auth
        .signInWithPassword(email: email, password: password);
  }

  /// Signs out the current user.
  ///
  /// Also clears the local cache after sign out.
  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
    await CacheManager.clearCache();
  }

  /// Sets up a listener for authentication state changes.
  ///
  /// [listener] A function that will be called with the user ID (or null) when the auth state changes.
  @override
  void onAuthStateChange(Function(String?) listener) {
    _supabaseClient.auth.onAuthStateChange.listen((data) {
      final String? userId = data.session?.user.id;
      listener(userId);
    });
  }

  /// Initiates the sign-in process with a one-time password (OTP) sent to the provided email.
  ///
  /// [email] The email address to which the OTP will be sent.
  @override
  Future<void> signInWithOtp(String email) async {
    await _supabaseClient.auth.signInWithOtp(
      email: email,
    );
  }

  /// Verifies the one-time password (OTP) for email sign-in.
  ///
  /// [email] The email address used for the sign-in attempt.
  /// [otp] The one-time password received by the user.
  /// Returns true if the OTP is valid and sign-in is successful, false otherwise.
  @override
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final AuthResponse res = await _supabaseClient.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );
      return res.session != null;
    } catch (e) {
      Logger.log('Error verifying OTP: $e');
      return false;
    }
  }
}
