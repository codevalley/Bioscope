import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'dashboard_state.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/daily_goals_repository.dart';
import '../../domain/entities/daily_goals.dart';
import 'dart:async';
import '../../domain/entities/goal_item.dart';
import '../../core/utils/logger.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final IFoodEntryRepository _foodEntryRepository;
  final IUserProfileRepository _userProfileRepository;
  final IDailyGoalsRepository _dailyGoalsRepository;
  StreamSubscription? _userProfileSubscription;
  StreamSubscription? _foodEntriesSubscription;
  StreamSubscription? _dailyGoalsSubscription;

  DashboardNotifier(this._foodEntryRepository, this._userProfileRepository,
      this._dailyGoalsRepository)
      : super(DashboardState.initial()) {
    _initializeListeners();
  }

  void _initializeListeners() {
    _userProfileSubscription = _userProfileRepository.watchUserProfile().listen(
      (userProfile) {
        Logger.log("User profile updated: $userProfile"); // Debug print
        if (userProfile != null) {
          _updateDashboardWithUserProfile(userProfile);
        } else {
          state = DashboardState.initial().copyWith(isLoading: false);
        }
      },
      onError: (error) {
        Logger.log("Error in user profile stream: $error"); // Debug print
      },
    );

    _foodEntriesSubscription =
        _foodEntryRepository.watchAllFoodEntries().listen(
      (foodEntries) {
        Logger.log(
            "Food entries updated: ${foodEntries.length}"); // Debug print
        _updateDashboardWithFoodEntries(foodEntries);
      },
      onError: (error) {
        Logger.log("Error in food entries stream: $error"); // Debug print
      },
    );

    _dailyGoalsSubscription =
        _dailyGoalsRepository.watchDailyGoals(_getCurrentDate()).listen(
      (dailyGoals) {
        if (dailyGoals != null) {
          state = state.copyWith(
            dailyGoals: Map.from(dailyGoals.goals),
            isLoading: false,
          );
        }
      },
      onError: (error) {
        Logger.log("Error in daily goals stream: $error");
      },
    );
  }

  DateTime _getCurrentDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _updateDashboardWithUserProfile(UserProfile userProfile) {
    state = state.copyWith(
      isLoading: false,
      greeting: _getGreeting(),
      userName: userProfile.name,
      nutritionGoals: userProfile.nutritionGoals,
    );
  }

  void _updateDashboardWithFoodEntries(List<FoodEntry> foodEntries) {
    final recentMeals = foodEntries.take(5).toList();
    state = state.copyWith(
      recentMeals: recentMeals,
    );
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

  Future<void> refreshDashboard() async {
    try {
      state = state.copyWith(isLoading: true);
      final userProfile = await _userProfileRepository.getUserProfile();
      final foodEntries = await _foodEntryRepository.getAllFoodEntries();
      final today = DateTime.now();
      final dateOnly = DateTime(today.year, today.month, today.day);

      if (userProfile != null) {
        _updateDashboardWithUserProfile(userProfile);
        _updateDashboardWithFoodEntries(foodEntries);
        var dailyGoals = await _dailyGoalsRepository.getDailyGoals(dateOnly);
        dailyGoals ??= await _createDefaultDailyGoals(userProfile, dateOnly);
        _updateDashboardWithDailyGoals(dailyGoals);
      }
    } catch (e, stackTrace) {
      Logger.log('Error refreshing dashboard: $e');
      Logger.log('Stack trace: $stackTrace');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<DailyGoals> _createDefaultDailyGoals(
      UserProfile userProfile, DateTime dateOnly) async {
    final defaultGoals = userProfile.nutritionGoals.map(
      (key, value) => MapEntry(
          key,
          GoalItem(
            name: value.name,
            description: value.description,
            target: value.target.toDouble(), // Ensure this is a double
            actual: 0.0, // Use 0.0 instead of 0
            isPublic: value.isPublic,
            unit: value.unit,
            timestamp: dateOnly,
          )),
    );

    final defaultDailyGoals = DailyGoals(
      userId: userProfile.id,
      date: dateOnly,
      goals: defaultGoals,
    );

    await _dailyGoalsRepository.saveDailyGoals(defaultDailyGoals);
    return defaultDailyGoals;
  }

  void _updateDashboardWithDailyGoals(DailyGoals dailyGoals) {
    state = state.copyWith(
      dailyGoals: Map.from(dailyGoals.goals),
      isLoading: false,
    );
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _foodEntryRepository.addFoodEntry(entry);
    await _updateDailyGoals(entry);
    await refreshDashboard();
  }

  Future<void> _updateDailyGoals(FoodEntry entry) async {
    final userProfile = await _userProfileRepository.getUserProfile();
    if (userProfile == null) return;

    final dateOnly =
        DateTime(entry.date.year, entry.date.month, entry.date.day);
    var dailyGoals = await _dailyGoalsRepository.getDailyGoals(dateOnly);

    dailyGoals ??= await _createDefaultDailyGoals(userProfile, dateOnly);

    // Update actual values based on the new food entry
    for (var component in entry.nutritionInfo.nutrition) {
      if (dailyGoals.goals.containsKey(component.component)) {
        var goal = dailyGoals.goals[component.component]!;
        dailyGoals.goals[component.component] = goal.copyWith(
          actual: goal.actual + component.value,
        );
      }
    }

    await _dailyGoalsRepository.updateDailyGoals(dailyGoals);
    _updateDashboardWithDailyGoals(dailyGoals);
  }

  @override
  void dispose() {
    _userProfileSubscription?.cancel();
    _foodEntriesSubscription?.cancel();
    _dailyGoalsSubscription?.cancel();
    super.dispose();
  }
}
