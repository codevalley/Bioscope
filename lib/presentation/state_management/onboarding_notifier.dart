import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../application/di/dependency_injection.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'onboarding_state.dart';

final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  return getIt<IUserProfileRepository>();
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final IUserProfileRepository userProfileRepository;

  OnboardingNotifier(this.userProfileRepository)
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
          final userProfile = UserProfile(
            id: const Uuid().v4(),
            name: name,
            age: 0, // You might want to add age to onboarding
            height: 0, // You might want to add height to onboarding
            weight: 0, // You might want to add weight to onboarding
            gender: '', // You might want to add gender to onboarding
            dailyCalorieGoal: dailyCalorieGoal,
          );
          await userProfileRepository.saveUserProfile(userProfile);
          state = const OnboardingState.complete();
        }
      },
      orElse: () {},
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(ref.watch(userProfileRepositoryProvider)),
);

// Remove this line as it's now defined in user_repository_impl.dart
// final userRepositoryProvider = Provider<UserRepository>((ref) => throw UnimplementedError());
