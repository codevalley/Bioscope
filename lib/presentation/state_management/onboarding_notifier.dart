import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../application/di/dependency_injection.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import 'onboarding_state.dart';

// Add this provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return getIt<UserRepository>();
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final UserRepository userRepository;

  OnboardingNotifier(this.userRepository)
      : super(const OnboardingState.initial());

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
          final user = User(
            id: const Uuid().v4(),
            name: name,
            dailyCalorieGoal: dailyCalorieGoal,
            dietaryPreferences: dietaryPreferences ?? [],
          );
          await userRepository.saveUser(user);
          state = const OnboardingState.complete();
        }
      },
      orElse: () {},
    );
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(ref.watch(userRepositoryProvider)),
);

// Remove this line as it's now defined in user_repository_impl.dart
// final userRepositoryProvider = Provider<UserRepository>((ref) => throw UnimplementedError());
