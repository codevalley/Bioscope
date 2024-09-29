import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/daily_goals_repository.dart';
import 'dashboard_state.dart';
import '../../domain/entities/food_entry.dart';
import 'dart:async';
import 'package:bioscope/core/utils/logger.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final IFoodEntryRepository _foodEntryRepository;
  final IUserProfileRepository _userProfileRepository;
  final IDailyGoalsRepository _dailyGoalsRepository;

  DashboardNotifier(
    this._foodEntryRepository,
    this._userProfileRepository,
    this._dailyGoalsRepository,
  ) : super(DashboardState.initial()) {
    refreshDashboard(state.currentDate);
  }

  Future<void> refreshDashboard(DateTime date) async {
    state = state.copyWith(isLoading: true, currentDate: date);
    final userProfile = await _userProfileRepository.getUserProfile();
    final foodEntries = await _foodEntryRepository.getEntriesByDate(date);
    final dailyGoals = await _dailyGoalsRepository.getDailyGoals(date);

    if (userProfile != null) {
      state = state.copyWith(
        isLoading: false,
        greeting: _getGreeting(),
        userName: userProfile.name,
        nutritionGoals: userProfile.nutritionGoals,
        dailyGoals: dailyGoals?.goals ?? {},
        foodEntries: foodEntries, // Make sure this is being set correctly
      );
    }

    // Debug print
    Logger.log('Food entries for ${date.toString()}: ${foodEntries.length}');
  }

  void changeDate(DateTime newDate) {
    refreshDashboard(newDate);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '🌅 Good Morning';
    } else if (hour < 17) {
      return '☀️ Good Afternoon';
    } else {
      return '🌙 Good Evening';
    }
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _foodEntryRepository.addFoodEntry(entry);
    await refreshDashboard(state.currentDate);
  }
}
