import '../../entities/user_profile.dart';
import '../../repositories/user_profile_repository.dart';

class SaveUserProfile {
  final IUserProfileRepository repository;

  SaveUserProfile(this.repository);

  Future<void> call(UserProfile userProfile) async {
    await repository.saveUserProfile(userProfile);
  }
}
