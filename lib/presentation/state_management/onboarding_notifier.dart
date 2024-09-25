import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bioscope/presentation/providers/providers.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'onboarding_state.dart';
import '../../domain/services/IAuthService.dart';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final IUserProfileRepository _userProfileRepository;
  final IAuthService _authService;

  OnboardingNotifier(this._userProfileRepository, this._authService)
      : super(const OnboardingState.inProgress(
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

            final userProfile = UserProfile(
              id: userId,
              name: name,
              age: 0,
              height: 0,
              weight: 0,
              gender: '',
              dailyCalorieGoal: (goals['Calories'] ?? 0.5 * 2000).toInt(),
              carbsGoal: goals['Carbs'] ?? 0.5,
              proteinGoal: goals['Proteins'] ?? 0.5,
              fatGoal: goals['Fats'] ?? 0.5,
              fiberGoal: goals['Fiber'] ?? 0.5,
              dietaryPreferences: dietaryPreferences ?? [],
            );
            await _userProfileRepository.saveUserProfile(userProfile);
            _lastSuccessfulStep = currentPage;
            state = const OnboardingState.complete();
          } catch (e) {
            print('Error completing onboarding: $e');
            state = OnboardingState.error(e.toString());
          }
        }
      },
      orElse: () {},
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(
      ref.watch(userProfileRepositoryProvider), ref.watch(authServiceProvider)),
);
