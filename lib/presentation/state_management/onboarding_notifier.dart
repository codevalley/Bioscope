import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/di/dependency_injection.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'onboarding_state.dart';
import '../../domain/services/IAuthService.dart';

final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  return getIt<IUserProfileRepository>();
});

final authServiceProvider = Provider<IAuthService>((ref) {
  return getIt<IAuthService>();
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final IUserProfileRepository _userProfileRepository;
  final IAuthService _authService;

  OnboardingNotifier(this._userProfileRepository, this._authService)
      : super(const OnboardingState.inProgress(
          currentPage: 0,
          name: null,
          dailyCalorieGoal: null,
          dietaryPreferences: null,
        ));

  void startOnboarding() {
    state = const OnboardingState.inProgress(
      currentPage: 0,
      name: null,
      dailyCalorieGoal: null,
      dietaryPreferences: null,
    );
  }

  void setName(String name) {
    state = state.maybeMap(
      inProgress: (s) => s.copyWith(name: name),
      orElse: () => state,
    );
  }

  void setDailyCalorieGoal(int goal) {
    state = state.maybeMap(
      inProgress: (s) => s.copyWith(dailyCalorieGoal: goal),
      orElse: () => state,
    );
  }

  void setDietaryPreferences(List<String> preferences) {
    state = state.maybeMap(
      inProgress: (s) => s.copyWith(dietaryPreferences: preferences),
      orElse: () => state,
    );
  }

  bool canMoveToNextPage() {
    return state.maybeMap(
      inProgress: (s) {
        if (s.currentPage == 0) {
          return s.name != null &&
              s.name!.isNotEmpty &&
              s.dailyCalorieGoal != null;
        }
        return true;
      },
      orElse: () => false,
    );
  }

  void nextPage() {
    if (canMoveToNextPage()) {
      state = state.maybeMap(
        inProgress: (s) => s.copyWith(currentPage: s.currentPage + 1),
        orElse: () => state,
      );
    }
  }

  void previousPage() {
    state = state.maybeMap(
      inProgress: (s) => s.copyWith(currentPage: s.currentPage - 1),
      orElse: () => state,
    );
  }

  Future<void> completeOnboarding() async {
    state.maybeWhen(
      inProgress:
          (currentPage, name, dailyCalorieGoal, dietaryPreferences) async {
        if (name != null && name.isNotEmpty && dailyCalorieGoal != null) {
          try {
            // Sign in anonymously before creating the profile
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
              dailyCalorieGoal: dailyCalorieGoal,
            );
            await _userProfileRepository.saveUserProfile(userProfile);
            state = const OnboardingState.complete();
          } catch (e) {
            // Handle any errors that occur during the process
            print('Error completing onboarding: $e');
            // Set an error state or notify the UI
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

// Remove this line as it's now defined in user_repository_impl.dart
// final userRepositoryProvider = Provider<UserRepository>((ref) => throw UnimplementedError());
