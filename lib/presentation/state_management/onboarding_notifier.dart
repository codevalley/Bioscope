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
  final IDailyGoalsRepository _dailyGoalsRepository;

  OnboardingNotifier(
    this._userProfileRepository,
    this._authService,
    this._dailyGoalsRepository,
  ) : super(const OnboardingState.inProgress(
          currentPage: 0,
          emailVerificationStatus: EmailVerificationStatus.notStarted,
        ));

  void startOnboarding() {
    state = const OnboardingState.inProgress(
      currentPage: 0,
      emailVerificationStatus: EmailVerificationStatus.notStarted,
    );
  }

  Future<void> startEmailVerification(String email) async {
    state.maybeWhen(
      inProgress: (currentPage, name, _, goals) async {
        try {
          await _authService.signInWithOtp(email);
          state = OnboardingState.inProgress(
            currentPage: currentPage,
            name: name,
            emailVerificationStatus: EmailVerificationStatus.inProgress,
            goals: goals,
          );
        } catch (e) {
          state = OnboardingState.error(e.toString());
        }
      },
      orElse: () {},
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    state.maybeWhen(
      inProgress: (currentPage, name, _, goals) async {
        try {
          final isVerified = await _authService.verifyOtp(email, otp);
          state = OnboardingState.inProgress(
            currentPage: currentPage,
            name: name,
            emailVerificationStatus: isVerified
                ? EmailVerificationStatus.verified
                : EmailVerificationStatus.failed,
            goals: goals,
          );
        } catch (e) {
          state = OnboardingState.error(e.toString());
        }
      },
      orElse: () {},
    );
  }

  void setName(String name) {
    state.maybeWhen(
      inProgress: (currentPage, _, emailVerificationStatus, goals) {
        state = OnboardingState.inProgress(
          currentPage: currentPage,
          name: name,
          emailVerificationStatus: emailVerificationStatus,
          goals: goals,
        );
      },
      orElse: () {},
    );
  }

  void setGoal(String goalType, double value) {
    state.maybeWhen(
      inProgress: (currentPage, name, emailVerificationStatus, goals) {
        final updatedGoals = Map<String, double>.from(goals ?? {});
        updatedGoals[goalType] = value;
        state = OnboardingState.inProgress(
          currentPage: currentPage,
          name: name,
          emailVerificationStatus: emailVerificationStatus,
          goals: updatedGoals,
        );
      },
      orElse: () {},
    );
  }

  void nextPage() {
    state.maybeWhen(
      inProgress: (currentPage, name, emailVerificationStatus, goals) {
        if (canMoveToNextPage()) {
          state = OnboardingState.inProgress(
            currentPage: currentPage + 1,
            name: name,
            emailVerificationStatus: emailVerificationStatus,
            goals: goals,
          );
        }
      },
      orElse: () {},
    );
  }

  bool canMoveToNextPage() {
    return state.maybeMap(
      inProgress: (s) {
        if (s.currentPage == 0) {
          return s.name != null &&
              s.name!.isNotEmpty &&
              s.emailVerificationStatus == EmailVerificationStatus.verified;
        } else if (s.currentPage == 1) {
          return s.goals != null && s.goals!.isNotEmpty;
        }
        return false;
      },
      orElse: () => false,
    );
  }

  Future<void> completeOnboarding() async {
    state.maybeWhen(
      inProgress: (_, name, emailVerificationStatus, goals) async {
        if (name != null &&
            name.isNotEmpty &&
            goals != null &&
            emailVerificationStatus == EmailVerificationStatus.verified) {
          try {
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

            final today = DateTime.now();
            final dailyGoals = DailyGoals(
              userId: userId,
              date: DateTime(today.year, today.month, today.day),
              goals: nutritionGoals.map(
                  (key, value) => MapEntry(key, value.copyWith(actual: 0))),
            );

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
