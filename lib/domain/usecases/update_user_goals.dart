import 'package:bioscope/domain/repositories/user_profile_repository.dart';
import 'package:bioscope/domain/entities/goal_item.dart';

class UpdateNutritionGoals {
  final IUserProfileRepository repository;

  UpdateNutritionGoals(this.repository);

  Future<void> call(String userId, Map<String, GoalItem> nutritionGoals) async {
    final userProfile = await repository.getUserProfile();
    if (userProfile != null && userProfile.id == userId) {
      final updatedProfile =
          userProfile.copyWith(nutritionGoals: nutritionGoals);
      await repository.updateUserProfile(updatedProfile);
    } else {
      throw Exception('User profile not found or unauthorized');
    }
  }
}
