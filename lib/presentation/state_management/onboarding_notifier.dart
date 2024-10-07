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
    Logger.log("_initOnboarding: Starting initialization");
    state = const OnboardingState.inProgress(
      isNewUser: true,
      emailVerificationStatus: EmailVerificationStatus.notStarted,
      isLoading: true,
    );
    Logger.log("_initOnboarding: Set initial state - ${state.toString()}");

    final userId = await _authService.getCurrentUserId();
    Logger.log("_initOnboarding: Retrieved userId - $userId");
    final userProfile =
        userId != null ? await _userProfileRepository.getUserProfile() : null;
    Logger.log(
        "_initOnboarding: Retrieved userProfile - ${userProfile != null}");

    if (userProfile != null) {
      Logger.log("_initOnboarding: Existing user found");
      state = OnboardingState.inProgress(
        isNewUser: false,
        emailVerificationStatus: EmailVerificationStatus.verified,
        name: userProfile.name,
        goals: userProfile.nutritionGoals
            .map((key, value) => MapEntry(key, value.target)),
      );
      Logger.log(
          "_initOnboarding: Set state for existing user - ${state.toString()}");
      await _fetchDailyGoalsAndComplete(userId!);
    } else {
      Logger.log("_initOnboarding: New user");
      state = const OnboardingState.inProgress(
        isNewUser: true,
        emailVerificationStatus: EmailVerificationStatus.notStarted,
        isLoading: false,
      );
      Logger.log(
          "_initOnboarding: Set state for new user - ${state.toString()}");
    }
  }

  void startOnboarding() {
    Logger.log("startOnboarding: Restarting onboarding process");
    state = const OnboardingState.initial();
    _initOnboarding();
  }

  Future<void> startEmailVerification(String email) async {
    Logger.log("startEmailVerification: Starting for email - $email");

    // Set the state to inProgress immediately
    state = const OnboardingState.inProgress(
      isNewUser: true,
      emailVerificationStatus: EmailVerificationStatus.inProgress,
      isLoading: true,
    );
    Logger.log(
        "startEmailVerification: Set state to inProgress - ${state.toString()}");

    try {
      await _authService.signInWithOtp(email);
      Logger.log("startEmailVerification: OTP sent successfully");

      // Update the state to awaitingOtp only after successful OTP send
      state = const OnboardingState.inProgress(
        isNewUser: true,
        emailVerificationStatus: EmailVerificationStatus.awaitingOtp,
        isLoading: false,
      );
      Logger.log(
          "startEmailVerification: Updated state to awaitingOtp - ${state.toString()}");
    } catch (e) {
      Logger.log("startEmailVerification: Error sending OTP - $e");
      state = const OnboardingState.inProgress(
        isNewUser: true,
        emailVerificationStatus: EmailVerificationStatus.failed,
        isLoading: false,
      );
      Logger.log(
          "startEmailVerification: Updated state to failed - ${state.toString()}");
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    Logger.log("verifyOtp: Starting verification for email - $email");
    state = const OnboardingState.inProgress(
      isNewUser: true,
      emailVerificationStatus: EmailVerificationStatus.inProgress,
      isLoading: true,
    );
    Logger.log("verifyOtp: Set initial state - ${state.toString()}");

    try {
      final isVerified = await _authService.verifyOtp(email, otp);
      Logger.log("verifyOtp: OTP verification result - $isVerified");
      if (isVerified) {
        verifiedEmail = email;
        Logger.log("verifyOtp: Email verified - $email");
        final userId = await _authService.getCurrentUserId();
        Logger.log("verifyOtp: Retrieved userId after verification - $userId");
        if (userId != null) {
          final existingProfile = await _userProfileRepository.getUserProfile();
          Logger.log(
              "verifyOtp: Existing profile found - ${existingProfile != null}");
          if (existingProfile != null) {
            await _fetchDailyGoalsAndComplete(userId);
            return true;
          }
        }
        state = const OnboardingState.inProgress(
          isNewUser: true,
          emailVerificationStatus: EmailVerificationStatus.verified,
          isLoading: false,
        );
        Logger.log(
            "verifyOtp: Updated state after successful verification - ${state.toString()}");
        return true;
      } else {
        Logger.log("verifyOtp: OTP verification failed");
        state = const OnboardingState.inProgress(
          isNewUser: true,
          emailVerificationStatus: EmailVerificationStatus.awaitingOtp,
          isLoading: false,
        );
        Logger.log(
            "verifyOtp: Updated state after failed verification - ${state.toString()}");
        return false;
      }
    } catch (e) {
      Logger.log("verifyOtp: Error during verification - $e");
      state = const OnboardingState.inProgress(
        isNewUser: true,
        emailVerificationStatus: EmailVerificationStatus.failed,
        isLoading: false,
      );
      Logger.log("verifyOtp: Updated state after error - ${state.toString()}");
      return false;
    }
  }

  Future<void> skipEmailVerification() async {
    Logger.log("skipEmailVerification: Starting");
    state = const OnboardingState.inProgress(
      isNewUser: true,
      emailVerificationStatus: EmailVerificationStatus.skipped,
      isLoading: true,
    );
    Logger.log(
        "skipEmailVerification: Set initial state - ${state.toString()}");

    try {
      await _authService.signInAnonymously();
      Logger.log("skipEmailVerification: Anonymous sign-in successful");
      final userId = await _authService.getCurrentUserId();
      Logger.log(
          "skipEmailVerification: Retrieved userId after anonymous sign-in - $userId");
      if (userId == null) {
        throw Exception('Failed to get user ID after anonymous sign-in');
      }

      state = const OnboardingState.inProgress(
        isNewUser: true,
        emailVerificationStatus: EmailVerificationStatus.skipped,
        isLoading: false,
      );
      Logger.log(
          "skipEmailVerification: Updated state after anonymous sign-in - ${state.toString()}");
    } catch (e) {
      Logger.log("skipEmailVerification: Error during anonymous sign-in - $e");
      state = OnboardingState.error(e.toString());
      Logger.log(
          "skipEmailVerification: Updated state after error - ${state.toString()}");
    }
  }

  void setName(String name) {
    Logger.log("setName: Setting name - $name");
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
    Logger.log("setName: Updated state - ${state.toString()}");
  }

  void setGoal(String goalType, double value) {
    Logger.log("setGoal: Setting goal - $goalType: $value");
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
    Logger.log("setGoal: Updated state - ${state.toString()}");
  }

  Future<void> completeOnboarding() async {
    Logger.log("completeOnboarding: Starting");
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
    Logger.log("completeOnboarding: Set initial state - ${state.toString()}");

    try {
      final userId = await _authService.getCurrentUserId();
      Logger.log("completeOnboarding: Retrieved userId - $userId");
      if (userId == null) throw Exception('Failed to get user ID');

      final nutritionGoals = _createNutritionGoals(state.maybeWhen(
        inProgress: (_, __, ___, goals, ____) => goals,
        orElse: () => {},
      ));
      Logger.log("completeOnboarding: Created nutrition goals");

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
      Logger.log("completeOnboarding: Created user profile");

      await _userProfileRepository.saveUserProfile(userProfile);
      Logger.log("completeOnboarding: Saved user profile");
      await _fetchDailyGoalsAndComplete(userId);
    } catch (e) {
      Logger.log('completeOnboarding: Error completing onboarding - $e');
      state = OnboardingState.error(e.toString());
      Logger.log(
          "completeOnboarding: Updated state after error - ${state.toString()}");
    }
  }

  Future<void> _fetchDailyGoalsAndComplete(String userId) async {
    Logger.log("_fetchDailyGoalsAndComplete: Starting for userId - $userId");
    try {
      final today = DateTime.now();
      final dailyGoals = await _dailyGoalsRepository.getDailyGoals(
        DateTime(today.year, today.month, today.day),
      );
      Logger.log(
          "_fetchDailyGoalsAndComplete: Retrieved daily goals - ${dailyGoals != null}");

      if (dailyGoals == null) {
        final userProfile = await _userProfileRepository.getUserProfile();
        Logger.log(
            "_fetchDailyGoalsAndComplete: Retrieved user profile - ${userProfile != null}");
        if (userProfile != null) {
          final newDailyGoals = DailyGoals(
            userId: userId,
            date: DateTime(today.year, today.month, today.day),
            goals: userProfile.nutritionGoals.map(
              (key, value) => MapEntry(key, value.copyWith(actual: 0)),
            ),
          );
          await _dailyGoalsRepository.saveDailyGoals(newDailyGoals);
          Logger.log("_fetchDailyGoalsAndComplete: Saved new daily goals");
        }
      }
      state = const OnboardingState.complete();
      Logger.log(
          "_fetchDailyGoalsAndComplete: Onboarding completed - ${state.toString()}");
    } catch (e) {
      Logger.log(
          '_fetchDailyGoalsAndComplete: Error fetching daily goals and completing onboarding - $e');
      state = OnboardingState.error(e.toString());
      Logger.log(
          "_fetchDailyGoalsAndComplete: Updated state after error - ${state.toString()}");
    }
  }

  Map<String, GoalItem> _createNutritionGoals(Map<String, double>? goals) {
    Logger.log("_createNutritionGoals: Creating nutrition goals");
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
