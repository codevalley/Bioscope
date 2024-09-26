import '../entities/user_profile.dart';

abstract class IUserProfileRepository {
  Future<UserProfile?> getUserProfile();
  Future<void> saveUserProfile(UserProfile userProfile);
  Future<void> updateUserProfile(UserProfile userProfile);
  Future<void> deleteUserProfile();
  Stream<UserProfile?> watchUserProfile();
  Future<bool> isOnboardingCompleted();
}
