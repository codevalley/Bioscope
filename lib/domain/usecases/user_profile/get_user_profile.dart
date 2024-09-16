import '../../entities/user_profile.dart';
import '../../repositories/user_profile_repository.dart';

class GetUserProfile {
  final IUserProfileRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile?> call() async {
    return await repository.getUserProfile();
  }
}
