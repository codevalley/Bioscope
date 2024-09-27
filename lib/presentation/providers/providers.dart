import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../state_management/dashboard_notifier.dart';
import '../state_management/user_profile_notifier.dart';
import '../state_management/onboarding_notifier.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/services/IAuthService.dart';
import '../../domain/entities/user_profile.dart';
import '../../application/di/dependency_injection.dart';
import '../state_management/onboarding_state.dart';
import '../state_management/dashboard_state.dart';

final databaseProvider = Provider<Database>((ref) => getIt<Database>());

final foodEntryRepositoryProvider = Provider<IFoodEntryRepository>((ref) {
  return getIt<IFoodEntryRepository>();
});

final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  return getIt<IUserProfileRepository>();
});

final authServiceProvider = Provider<IAuthService>((ref) {
  return getIt<IAuthService>();
});

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return UserProfileNotifier(ref.watch(userProfileRepositoryProvider));
});

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final foodEntryRepository = ref.watch(foodEntryRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);

  return DashboardNotifier(foodEntryRepository, userProfileRepository);
});

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(
      ref.watch(userProfileRepositoryProvider), ref.watch(authServiceProvider));
});

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final foodEntryRepository = ref.watch(foodEntryRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return DashboardNotifier(foodEntryRepository, userProfileRepository);
});
