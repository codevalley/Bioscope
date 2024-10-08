import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/goal_item.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'dart:async';

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final IUserProfileRepository _repository;
  Timer? _debounceTimer;

  UserProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _repository.watchUserProfile().listen(
      (userProfile) {
        state = AsyncValue.data(userProfile);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  Future<void> refreshUserProfile() async {
    try {
      final userProfile = await _repository.getUserProfile();
      state = AsyncValue.data(userProfile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    try {
      await _repository.updateUserProfile(updatedProfile);
      state = AsyncValue.data(updatedProfile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void updateNutritionGoal(String goalName, GoalItem updatedGoal) {
    state.whenData((userProfile) {
      if (userProfile != null) {
        final updatedGoals =
            Map<String, GoalItem>.from(userProfile.nutritionGoals);
        updatedGoals[goalName] = updatedGoal;
        final updatedProfile =
            userProfile.copyWith(nutritionGoals: updatedGoals);
        state = AsyncValue.data(updatedProfile);

        // Debounce the actual update to the repository
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          updateUserProfile(updatedProfile);
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
