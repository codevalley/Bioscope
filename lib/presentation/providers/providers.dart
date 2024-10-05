import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../state_management/dashboard_notifier.dart';
import '../state_management/user_profile_notifier.dart';
import '../state_management/onboarding_notifier.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/entities/user_profile.dart';
import '../../application/di/dependency_injection.dart';
import '../state_management/onboarding_state.dart';
import '../state_management/dashboard_state.dart';
import '../../domain/repositories/daily_goals_repository.dart';

/// Provides access to the SQLite database.
/// This is used for local data persistence when not using Supabase.
final databaseProvider = Provider<Database>((ref) => getIt<Database>());

/// Provides access to the food entry repository.
/// This repository handles CRUD operations for food entries.
final foodEntryRepositoryProvider = Provider<IFoodEntryRepository>((ref) {
  return getIt<IFoodEntryRepository>();
});

/// Provides access to the user profile repository.
/// This repository manages user profile data.
final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  return getIt<IUserProfileRepository>();
});

/// Provides access to the daily goals repository.
/// This repository handles operations related to user's daily nutritional goals.
final dailyGoalsRepositoryProvider = Provider<IDailyGoalsRepository>((ref) {
  return getIt<IDailyGoalsRepository>();
});

/// Provides access to the authentication service.
/// This service handles user authentication operations.
final authServiceProvider = Provider<IAuthService>((ref) {
  return getIt<IAuthService>();
});

/// Manages the state of the user profile.
/// This provider allows reactive access to the user's profile data.
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return UserProfileNotifier(ref.watch(userProfileRepositoryProvider));
});

/// Manages the state of the onboarding process.
/// This provider handles the flow and data of the user onboarding experience.
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref.watch(userProfileRepositoryProvider),
      ref.watch(authServiceProvider), ref.watch(dailyGoalsRepositoryProvider));
});

/// Manages the state of the dashboard.
/// This provider handles the main dashboard data and operations.
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final foodEntryRepository = ref.watch(foodEntryRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final dailyGoalsRepository = ref.watch(dailyGoalsRepositoryProvider);
  return DashboardNotifier(
      foodEntryRepository, userProfileRepository, dailyGoalsRepository);
});
