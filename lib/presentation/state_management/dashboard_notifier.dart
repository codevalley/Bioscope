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
  }

  Future<void> _initializeDashboard() async {
    try {
      final userProfile = await _userProfileRepository.getUserProfile();
      final recentMeals = await _foodEntryRepository.getRecentFoodEntries();
      final totalCalories =
          await _foodEntryRepository.getTotalCaloriesConsumed();

      if (userProfile != null) {
        state = DashboardState(
          greeting: _getGreeting(userProfile.name),
          caloriesConsumed: totalCalories,
          caloriesRemaining: userProfile.dailyCalorieGoal - totalCalories,
          recentMeals: recentMeals,
          userName: userProfile.name,
          dailyCalorieGoal: userProfile.dailyCalorieGoal,
        );
      }
    } catch (e) {
      debugPrint('Error initializing dashboard: $e');
      // You might want to set an error state here
    }
  }

  String _getGreeting(String name) {
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
    await _initializeDashboard();
  }

  Future<void> refreshDashboard() async {
    await _initializeDashboard();
  }
}
