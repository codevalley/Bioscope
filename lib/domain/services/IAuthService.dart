abstract class IAuthService {
  Future<String?> getCurrentUserId();
  Future<bool> isAnonymous();
  Future<void> signInAnonymously();
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}
