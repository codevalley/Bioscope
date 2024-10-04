import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../core/interfaces/data_source.dart';
import '../models/user_profile_model.dart';
import '../../domain/services/auth_service.dart';
import 'dart:async';

/// Implementation of the [IUserProfileRepository] interface.
///
/// This class provides concrete implementations for managing user profiles
/// using a [DataSource] and an [IAuthService].
class UserProfileRepositoryImpl implements IUserProfileRepository {
  final DataSource<UserProfileModel> _dataSource;
  final IAuthService _authService;
  final StreamController<UserProfile?> _userProfileController =
      StreamController<UserProfile?>.broadcast();

  /// Creates a new instance of [UserProfileRepositoryImpl].
  ///
  /// Requires a [DataSource] for user profile data and an [IAuthService] for authentication.
  UserProfileRepositoryImpl(this._dataSource, this._authService) {
    _setupRealtimeListeners();
  }

  /// Sets up real-time listeners for user profile data changes and authentication state.
  void _setupRealtimeListeners() {
    _dataSource.setupRealtimeListeners((updatedData) async {
      final userId = await _authService.getCurrentUserId();
      if (userId != null && updatedData.isNotEmpty) {
        final userProfile = updatedData.first;
        _userProfileController.add(userProfile.toDomain());
      } else {
        _userProfileController.add(null);
      }
    });

    _authService.onAuthStateChange((userId) {
      if (userId == null) {
        _userProfileController.add(null);
      } else {
        getUserProfile().then((profile) {
          _userProfileController.add(profile);
        });
      }
    });
  }

  /// Retrieves the current user's profile.
  @override
  Future<UserProfile?> getUserProfile() async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      return null;
    }
    final userProfileModel = await _dataSource.getById(userId);
    return userProfileModel?.toDomain();
  }

  /// Saves a new user profile.
  @override
  Future<void> saveUserProfile(UserProfile userProfile) async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }
    final updatedProfile = userProfile.copyWith(id: userId);
    await _dataSource.create(UserProfileModel.fromDomain(updatedProfile));
  }

  /// Updates an existing user profile.
  @override
  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _dataSource.update(UserProfileModel.fromDomain(userProfile));
  }

  /// Deletes the current user's profile.
  @override
  Future<void> deleteUserProfile() async {
    final profile = await getUserProfile();
    if (profile != null) {
      await _dataSource.delete(profile.id);
    }
  }

  /// Provides a stream of the current user's profile.
  @override
  Stream<UserProfile?> watchUserProfile() {
    return _userProfileController.stream;
  }

  /// Checks if the user has completed the onboarding process.
  ///
  /// This is determined by whether a user profile exists.
  @override
  Future<bool> isOnboardingCompleted() async {
    return await getUserProfile() != null;
  }

  /// Closes the stream controller when it's no longer needed.
  void dispose() {
    _userProfileController.close();
  }
}
