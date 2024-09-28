import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../core/interfaces/data_source.dart';
import '../models/user_profile_model.dart';
import '../../domain/services/auth_service.dart';
import 'dart:async';

class UserProfileRepositoryImpl implements IUserProfileRepository {
  final DataSource<UserProfileModel> _dataSource;
  final IAuthService _authService;
  final StreamController<UserProfile?> _userProfileController =
      StreamController<UserProfile?>.broadcast();

  UserProfileRepositoryImpl(this._dataSource, this._authService) {
    _setupRealtimeListeners();
  }

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
    // Listen to auth state changes
    _authService.onAuthStateChange((userId) {
      if (userId == null) {
        _userProfileController.add(null);
      } else {
        // Trigger a refresh of the user profile when a new user logs in
        getUserProfile().then((profile) {
          _userProfileController.add(profile);
        });
      }
    });
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      return null;
    }
    final userProfileModel = await _dataSource.getById(userId);
    return userProfileModel?.toDomain();
  }

  @override
  Future<void> saveUserProfile(UserProfile userProfile) async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }
    final updatedProfile = userProfile.copyWith(id: userId);
    await _dataSource.create(UserProfileModel.fromDomain(updatedProfile));
  }

  @override
  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _dataSource.update(UserProfileModel.fromDomain(userProfile));
  }

  @override
  Future<void> deleteUserProfile() async {
    final profile = await getUserProfile();
    if (profile != null) {
      await _dataSource.delete(profile.id);
    }
  }

  @override
  Stream<UserProfile?> watchUserProfile() {
    return _userProfileController.stream;
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return await getUserProfile() != null;
  }

  void dispose() {
    _userProfileController.close();
  }
}
