import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../core/interfaces/data_source.dart';
import '../models/user_profile_model.dart';
import '../../domain/services/IAuthService.dart';

class UserProfileRepositoryImpl implements IUserProfileRepository {
  final DataSource<UserProfileModel> _dataSource;
  final IAuthService _authService;

  UserProfileRepositoryImpl(this._dataSource, this._authService);

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
  Stream<UserProfile?> watchUserProfile() async* {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      yield null;
      return;
    }
    yield* _dataSource
        .watchById(userId)
        .map((userProfileModel) => userProfileModel?.toDomain());
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final profile = await getUserProfile();
    return profile != null;
  }
}
