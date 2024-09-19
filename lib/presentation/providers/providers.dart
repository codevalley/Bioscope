import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/domain/entities/user_profile.dart';
import 'package:bioscope/domain/repositories/user_profile_repository.dart';
import 'package:bioscope/application/di/dependency_injection.dart';
import '../state_management/dashboard_notifier.dart';

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

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final foodEntryRepository = ref.watch(foodEntryRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return DashboardNotifier(foodEntryRepository, userProfileRepository);
});
