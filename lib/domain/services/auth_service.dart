abstract class IAuthService {
  Future<String?> getCurrentUserId();
  Future<bool> isAnonymous();
  Future<void> signInAnonymously();
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  void onAuthStateChange(Function(String?) listener);

  Future<void> signInWithOtp(String email);
  Future<bool> verifyOtp(String email, String otp);
}
