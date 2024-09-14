import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState.initial());

  void startOnboarding() {
    state = const OnboardingState.inProgress(currentPage: 0);
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

  void nextPage() {
    state = state.maybeMap(
      inProgress: (s) => s.copyWith(currentPage: s.currentPage + 1),
      orElse: () => state,
    );
  }

  void previousPage() {
    state = state.maybeMap(
      inProgress: (s) => s.copyWith(currentPage: s.currentPage - 1),
      orElse: () => state,
    );
  }

  void completeOnboarding() {
    state = const OnboardingState.complete();
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);
