import '../entities/user_profile.dart';

/// Repository interface for managing user profiles.
///
/// This interface defines the contract for interacting with user profile data,
/// regardless of the underlying data source (e.g., local database, remote API).
abstract class IUserProfileRepository {
  /// Retrieves the current user's profile.
  ///
  /// Returns a [Future] that completes with the [UserProfile] if found, or null otherwise.
  Future<UserProfile?> getUserProfile();

  /// Saves a new user profile.
  ///
  /// [userProfile] The [UserProfile] object to be saved.
  Future<void> saveUserProfile(UserProfile userProfile);

  /// Updates an existing user profile.
  ///
  /// [userProfile] The [UserProfile] object with updated information.
  Future<void> updateUserProfile(UserProfile userProfile);

  /// Deletes the current user's profile.
  Future<void> deleteUserProfile();

  /// Provides a stream of the current user's profile.
  ///
  /// Returns a [Stream] that emits the [UserProfile] whenever it changes.
  Stream<UserProfile?> watchUserProfile();

  /// Checks if the user has completed the onboarding process.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether onboarding is completed.
  Future<bool> isOnboardingCompleted();
}
