import '../entities/user.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<bool> isOnboardingCompleted();
}
