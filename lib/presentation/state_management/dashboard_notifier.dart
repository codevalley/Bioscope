import 'package:bioscope/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';

class DashboardState {
  final String greeting;
  final int caloriesConsumed;
  final int caloriesRemaining;
  final List<FoodEntry> recentMeals;
  final String userName;
  final int dailyCalorieGoal;

  DashboardState({
    required this.greeting,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
    required this.recentMeals,
    required this.userName,
    required this.dailyCalorieGoal,
  });
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final IFoodEntryRepository _foodEntryRepository;
  final IUserProfileRepository _userProfileRepository;

  DashboardNotifier(this._foodEntryRepository, this._userProfileRepository)
      : super(DashboardState(
          greeting: '',
          caloriesConsumed: 0,
          caloriesRemaining: 0,
          recentMeals: [],
          userName: '',
          dailyCalorieGoal: 0,
        )) {
    _initializeDashboard();
    _listenToFoodEntries();
  }

  Future<void> _initializeDashboard() async {
    try {
      await _updateDashboardState();
    } catch (e) {
      debugPrint('Error initializing dashboard: $e');
    }
  }

  void _listenToFoodEntries() {
    _foodEntryRepository.watchAllFoodEntries().listen((_) {
      _updateDashboardState();
    });
  }

  Future<void> _updateDashboardState() async {
    try {
      final userProfile = await _userProfileRepository.getUserProfile();
      final recentMeals = await _foodEntryRepository.getRecentFoodEntries();
      final totalCalories =
          await _foodEntryRepository.getTotalCaloriesConsumed();

      if (userProfile != null) {
        state = DashboardState(
          greeting: _getGreeting(),
          caloriesConsumed: totalCalories,
          caloriesRemaining: userProfile.dailyCalorieGoal - totalCalories,
          recentMeals: recentMeals,
          userName: userProfile.name,
          dailyCalorieGoal: userProfile.dailyCalorieGoal,
        );
      }
    } catch (e) {
      debugPrint('Error updating dashboard state: $e');
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _foodEntryRepository.addFoodEntry(entry);
    await _updateDashboardState();
  }

  Future<void> refreshDashboard() async {
    await _updateDashboardState();
  }
}

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final foodEntryRepository = ref.watch(foodEntryRepositoryProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return DashboardNotifier(foodEntryRepository, userProfileRepository);
});
