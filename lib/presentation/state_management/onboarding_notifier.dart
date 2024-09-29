import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'onboarding_state.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/entities/goal_item.dart';
import '../../domain/repositories/daily_goals_repository.dart';
import '../../domain/entities/daily_goals.dart';
import '../../core/utils/logger.dart';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final IUserProfileRepository _userProfileRepository;
  final IAuthService _authService;
  final IDailyGoalsRepository _dailyGoalsRepository; // Add this

  OnboardingNotifier(
    this._userProfileRepository,
    this._authService,
    this._dailyGoalsRepository, // Add this
  ) : super(const OnboardingState.inProgress(
          currentPage: 0,
          name: null,
          goals: null,
          dietaryPreferences: null,
        ));

  int _lastSuccessfulStep = 0;

  void startOnboarding() {
    state = OnboardingState.inProgress(
      currentPage: _lastSuccessfulStep,
      name: state.maybeWhen(
        inProgress: (_, name, __, ___) => name,
        orElse: () => null,
      ),
      goals: state.maybeWhen(
        inProgress: (_, __, goals, ___) => goals,
        orElse: () => null,
      ),
      dietaryPreferences: state.maybeWhen(
        inProgress: (_, __, ___, dietaryPreferences) => dietaryPreferences,
        orElse: () => null,
      ),
    );
  }

  void nextPage() {
    if (canMoveToNextPage()) {
      _lastSuccessfulStep = state.maybeMap(
        inProgress: (s) => s.currentPage + 1,
        orElse: () => _lastSuccessfulStep,
      );
      state = state.maybeMap(
        inProgress: (s) => s.copyWith(currentPage: s.currentPage + 1),
        orElse: () => state,
      );
    }
  }

  void setName(String name) {
    state = state.maybeMap(
      inProgress: (s) => s.copyWith(name: name),
      orElse: () => state,
    );
  }

  void setGoal(String goalType, double value) {
    state = state.maybeMap(
      inProgress: (s) {
        final updatedGoals = Map<String, double>.from(s.goals ?? {});
        updatedGoals[goalType] = value;
        return s.copyWith(goals: updatedGoals);
      },
      orElse: () => state,
    );
  }

  void toggleDietaryPreference(String preference) {
    state = state.maybeMap(
      inProgress: (s) {
        final updatedPreferences =
            List<String>.from(s.dietaryPreferences ?? []);
        if (updatedPreferences.contains(preference)) {
          updatedPreferences.remove(preference);
        } else {
          updatedPreferences.add(preference);
        }
        return s.copyWith(dietaryPreferences: updatedPreferences);
      },
      orElse: () => state,
    );
  }

  bool canMoveToNextPage() {
    return state.maybeMap(
      inProgress: (s) {
        if (s.currentPage == 0) {
          return s.name != null && s.name!.isNotEmpty;
        } else if (s.currentPage == 1) {
          //return true;
          return s.goals != null && s.goals!.isNotEmpty;
        }
        return true;
      },
      orElse: () => false,
    );
  }

  void previousPage() {
    state = state.maybeMap(
      inProgress: (s) => s.copyWith(currentPage: s.currentPage - 1),
      orElse: () => state,
    );
  }

  Future<void> completeOnboarding() async {
    state.maybeWhen(
      inProgress: (currentPage, name, goals, dietaryPreferences) async {
        if (name != null && name.isNotEmpty && goals != null) {
          try {
            await _authService.signInAnonymously();

            final userId = await _authService.getCurrentUserId();
            if (userId == null) throw Exception('Failed to get user ID');

            final nutritionGoals = _createNutritionGoals(goals);

            final userProfile = UserProfile(
              id: userId,
              name: name,
              age: 0,
              height: 0,
              weight: 0,
              gender: '',
              nutritionGoals: nutritionGoals,
            );
            await _userProfileRepository.saveUserProfile(userProfile);

            // Create initial DailyGoals for today
            final today = DateTime.now();
            final dailyGoals = DailyGoals(
              userId: userId,
              date: DateTime(today.year, today.month, today.day),
              goals: nutritionGoals.map(
                  (key, value) => MapEntry(key, value.copyWith(actual: 0))),
            );

            // Force refresh the user profile
            await _userProfileRepository.getUserProfile();
            await _dailyGoalsRepository.saveDailyGoals(dailyGoals);
            state = const OnboardingState.complete();
          } catch (e) {
            Logger.log('Error completing onboarding: $e');
            state = OnboardingState.error(e.toString());
          }
        }
      },
      orElse: () {},
    );
  }

  Map<String, GoalItem> _createNutritionGoals(Map<String, double> goals) {
    return {
      'Calories': GoalItem(
        name: 'Calories',
        description: 'Daily calorie intake',
        target: goals['Calories'] ?? 2000,
        unit: 'kcal',
      ),
      'Carbs': GoalItem(
        name: 'Carbs',
        description: 'Daily carbohydrate intake',
        target: goals['Carbs'] ?? 250,
        unit: 'g',
      ),
      'Proteins': GoalItem(
        name: 'Proteins',
        description: 'Daily protein intake',
        target: goals['Proteins'] ?? 50,
        unit: 'g',
      ),
      'Fats': GoalItem(
        name: 'Fats',
        description: 'Daily fat intake',
        target: goals['Fats'] ?? 70,
        unit: 'g',
      ),
      'Fiber': GoalItem(
        name: 'Fiber',
        description: 'Daily fiber intake',
        target: goals['Fiber'] ?? 25,
        unit: 'g',
      ),
    };
  }
}
