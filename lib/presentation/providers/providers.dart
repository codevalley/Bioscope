import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/domain/entities/user_profile.dart';
import 'package:bioscope/domain/repositories/user_profile_repository.dart';
import 'package:bioscope/application/di/dependency_injection.dart';
import '../state_management/dashboard_notifier.dart';
import 'package:bioscope/domain/services/IAuthService.dart';

final databaseProvider = Provider<Database>((ref) => getIt<Database>());

final foodEntryRepositoryProvider = Provider<IFoodEntryRepository>((ref) {
  return getIt<IFoodEntryRepository>();
});

final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  return getIt<IUserProfileRepository>();
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final userRepository = ref.watch(userProfileRepositoryProvider);
  return userRepository.getUserProfile();
});

final authServiceProvider = Provider<IAuthService>((ref) {
  return getIt<IAuthService>();
});

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final foodEntryRepository = ref.watch(foodEntryRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  return DashboardNotifier(
      foodEntryRepository, userProfileRepository, authService);
});
