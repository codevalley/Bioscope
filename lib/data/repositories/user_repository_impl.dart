import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_sqlite_ds.dart';
import '../models/user_profile_model.dart';

class UserRepositoryImpl implements IUserProfileRepository {
  final UserProfileSqliteDs _dataSource;

  UserRepositoryImpl(this._dataSource);

  @override
  Future<UserProfile?> getUserProfile() async {
    final profiles = await _dataSource.getAll();
    return profiles.isNotEmpty ? profiles.first : null;
  }

  @override
  Future<void> saveUserProfile(UserProfile userProfile) async {
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
    await _dataSource.update(UserProfileModel(
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
