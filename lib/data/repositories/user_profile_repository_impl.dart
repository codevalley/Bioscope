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
    // await _dataSource
    //     .create(UserProfileModel.fromDomain(userProfile)..id = userId);
    await _dataSource.create(UserProfileModel(
      id: userProfile.id,
      name: userProfile.name,
      age: userProfile.age,
      height: userProfile.height,
      weight: userProfile.weight,
      gender: userProfile.gender,
      dailyCalorieGoal: userProfile.dailyCalorieGoal,
    ));
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
  Future<bool> isOnboardingCompleted() async {
    final profile = await getUserProfile();
    return profile != null;
  }
}
