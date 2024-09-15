import '../entities/user.dart';

abstract class LocalUserDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<bool> isOnboardingCompleted();
}
