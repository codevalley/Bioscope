// onboarding_notifier.dart

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
  String? verifiedEmail;

  OnboardingNotifier(
    this._userProfileRepository,
    this._authService,
    this._dailyGoalsRepository,
  ) : super(const OnboardingState.initial()) {
    _initOnboarding();
  }

  Future<void> _initOnboarding() async {
    state = const OnboardingState.inProgress(
      isNewUser: true,
      emailVerificationStatus: EmailVerificationStatus.notStarted,
      isLoading: true,
    );

    final userId = await _authService.getCurrentUserId();
    final userProfile =
        userId != null ? await _userProfileRepository.getUserProfile() : null;

    if (userProfile != null) {
      state = OnboardingState.inProgress(
        isNewUser: false,
        emailVerificationStatus: EmailVerificationStatus.verified,
        name: userProfile.name,
        goals: userProfile.nutritionGoals
            .map((key, value) => MapEntry(key, value.target)),
      );
      await _fetchDailyGoalsAndComplete(userId!);
    } else {
      state = const OnboardingState.inProgress(
        isNewUser: true,
        emailVerificationStatus: EmailVerificationStatus.notStarted,
      );
    }
  }

  void startOnboarding() {
    state = const OnboardingState.initial();
    _initOnboarding();
  }

  Future<void> startEmailVerification(String email) async {
    state = state.maybeWhen(
      inProgress: (isNewUser, _, name, goals, __) => OnboardingState.inProgress(
        isNewUser: isNewUser,
        emailVerificationStatus: EmailVerificationStatus.inProgress,
        name: name,
        goals: goals,
        isLoading: true,
      ),
      orElse: () => state,
    );

    try {
      await _authService.signInWithOtp(email);
      state = state.maybeWhen(
        inProgress: (isNewUser, _, name, goals, __) =>
            OnboardingState.inProgress(
          isNewUser: isNewUser,
          emailVerificationStatus: EmailVerificationStatus.awaitingOtp,
          name: name,
          goals: goals,
          isLoading: false,
        ),
        orElse: () => state,
      );
    } catch (e) {
      state = state.maybeWhen(
        inProgress: (isNewUser, _, name, goals, __) =>
            OnboardingState.inProgress(
          isNewUser: isNewUser,
          emailVerificationStatus: EmailVerificationStatus.failed,
          name: name,
          goals: goals,
          isLoading: false,
        ),
        orElse: () => state,
      );
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    state = state.maybeWhen(
      inProgress: (isNewUser, _, name, goals, __) => OnboardingState.inProgress(
        isNewUser: isNewUser,
        emailVerificationStatus: EmailVerificationStatus.inProgress,
        name: name,
        goals: goals,
        isLoading: true,
      ),
      orElse: () => state,
    );

    try {
      final isVerified = await _authService.verifyOtp(email, otp);
      if (isVerified) {
        verifiedEmail = email;
        final userId = await _authService.getCurrentUserId();
        if (userId != null) {
          final existingProfile = await _userProfileRepository.getUserProfile();
          if (existingProfile != null) {
            await _fetchDailyGoalsAndComplete(userId);
            return true;
          }
        }
        state = state.maybeWhen(
          inProgress: (isNewUser, _, name, goals, __) =>
              OnboardingState.inProgress(
            isNewUser: isNewUser,
            emailVerificationStatus: EmailVerificationStatus.verified,
            name: name,
            goals: goals,
            isLoading: false,
          ),
          orElse: () => state,
        );
        return true;
      } else {
        state = state.maybeWhen(
          inProgress: (isNewUser, _, name, goals, __) =>
              OnboardingState.inProgress(
            isNewUser: isNewUser,
            emailVerificationStatus: EmailVerificationStatus.failed,
            name: name,
            goals: goals,
            isLoading: false,
          ),
          orElse: () => state,
        );
        return false;
      }
    } catch (e) {
      state = state.maybeWhen(
        inProgress: (isNewUser, _, name, goals, __) =>
            OnboardingState.inProgress(
          isNewUser: isNewUser,
          emailVerificationStatus: EmailVerificationStatus.failed,
          name: name,
          goals: goals,
          isLoading: false,
        ),
        orElse: () => state,
      );
      return false;
    }
  }

  Future<void> skipEmailVerification() async {
    state = state.maybeWhen(
      inProgress: (isNewUser, _, name, goals, __) => OnboardingState.inProgress(
        isNewUser: isNewUser,
        emailVerificationStatus: EmailVerificationStatus.skipped,
        name: name,
        goals: goals,
        isLoading: true,
      ),
      orElse: () => state,
    );

    try {
      await _authService.signInAnonymously();
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('Failed to get user ID after anonymous sign-in');
      }

      state = state.maybeWhen(
        inProgress: (_, __, name, goals, ___) => OnboardingState.inProgress(
          isNewUser: true,
          emailVerificationStatus: EmailVerificationStatus.skipped,
          name: name,
          goals: goals,
        ),
        orElse: () => state,
      );
    } catch (e) {
      state = OnboardingState.error(e.toString());
    }
  }

  void setName(String name) {
    state = state.maybeWhen(
      inProgress: (isNewUser, emailVerificationStatus, _, goals, __) =>
          OnboardingState.inProgress(
        isNewUser: isNewUser,
        emailVerificationStatus: emailVerificationStatus,
        name: name,
        goals: goals,
      ),
      orElse: () => state,
    );
  }

  void setGoal(String goalType, double value) {
    state = state.maybeWhen(
      inProgress: (isNewUser, emailVerificationStatus, name, goals, _) {
        final updatedGoals = Map<String, double>.from(goals ?? {});
        updatedGoals[goalType] = value;
        return OnboardingState.inProgress(
          isNewUser: isNewUser,
          emailVerificationStatus: emailVerificationStatus,
          name: name,
          goals: updatedGoals,
        );
      },
      orElse: () => state,
    );
  }

  Future<void> completeOnboarding() async {
    state = state.maybeWhen(
      inProgress: (isNewUser, emailVerificationStatus, name, goals, _) =>
          OnboardingState.inProgress(
        isNewUser: isNewUser,
        emailVerificationStatus: emailVerificationStatus,
        name: name,
        goals: goals,
        isLoading: true,
      ),
      orElse: () => state,
    );

    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) throw Exception('Failed to get user ID');

      final nutritionGoals = _createNutritionGoals(state.maybeWhen(
        inProgress: (_, __, ___, goals, ____) => goals,
        orElse: () => {},
      ));

      final userProfile = UserProfile(
        id: userId,
        name: state.maybeWhen(
          inProgress: (_, __, name, ___, ____) => name ?? 'User',
          orElse: () => 'User',
        ),
        age: 0,
        height: 0,
        weight: 0,
        gender: '',
        nutritionGoals: nutritionGoals,
      );

      await _userProfileRepository.saveUserProfile(userProfile);
      await _fetchDailyGoalsAndComplete(userId);
      state = const OnboardingState.complete();
    } catch (e) {
      Logger.log('Error completing onboarding: $e');
      state = OnboardingState.error(e.toString());
    }
  }

  Future<void> _fetchDailyGoalsAndComplete(String userId) async {
    try {
      final today = DateTime.now();
      final dailyGoals = await _dailyGoalsRepository.getDailyGoals(
        DateTime(today.year, today.month, today.day),
      );

      if (dailyGoals == null) {
        final userProfile = await _userProfileRepository.getUserProfile();
        if (userProfile != null) {
          final newDailyGoals = DailyGoals(
            userId: userId,
            date: DateTime(today.year, today.month, today.day),
            goals: userProfile.nutritionGoals.map(
              (key, value) => MapEntry(key, value.copyWith(actual: 0)),
            ),
          );
          await _dailyGoalsRepository.saveDailyGoals(newDailyGoals);
        }
      }
    } catch (e) {
      Logger.log('Error fetching daily goals and completing onboarding: $e');
      state = OnboardingState.error(e.toString());
    }
  }

  Map<String, GoalItem> _createNutritionGoals(Map<String, double>? goals) {
    final defaultGoals = {
      'Calories': 2000.0,
      'Carbs': 250.0,
      'Proteins': 50.0,
      'Fats': 70.0,
      'Fiber': 25.0,
    };

    return (goals ?? defaultGoals).map((key, value) => MapEntry(
          key,
          GoalItem(
            name: key,
            description: 'Daily $key intake',
            target: value,
            unit: key == 'Calories' ? 'kcal' : 'g',
          ),
        ));
  }
}
