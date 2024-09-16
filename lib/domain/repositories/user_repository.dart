import '../entities/user.dart';

abstract class IUserRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<bool> isOnboardingCompleted();
}
