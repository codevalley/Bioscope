import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'dashboard_state.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/entities/user_profile.dart';
import 'dart:async';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final IFoodEntryRepository _foodEntryRepository;
  final IUserProfileRepository _userProfileRepository;
  StreamSubscription? _userProfileSubscription;
  StreamSubscription? _foodEntriesSubscription;

  DashboardNotifier(this._foodEntryRepository, this._userProfileRepository)
      : super(DashboardState.initial()) {
    _initializeListeners();
  }

  void _initializeListeners() {
    _userProfileSubscription = _userProfileRepository.watchUserProfile().listen(
      (userProfile) {
        print("User profile updated: $userProfile"); // Debug print
        if (userProfile != null) {
          _updateDashboardWithUserProfile(userProfile);
        } else {
          state = DashboardState.initial().copyWith(isLoading: false);
        }
      },
      onError: (error) {
        print("Error in user profile stream: $error"); // Debug print
      },
    );

    _foodEntriesSubscription =
        _foodEntryRepository.watchAllFoodEntries().listen(
      (foodEntries) {
        print("Food entries updated: ${foodEntries.length}"); // Debug print
        _updateDashboardWithFoodEntries(foodEntries);
      },
      onError: (error) {
        print("Error in food entries stream: $error"); // Debug print
      },
    );
  }

  void _updateDashboardWithUserProfile(UserProfile userProfile) {
    print("Updating dashboard with user profile"); // Debug print
    state = state.copyWith(
      isLoading: false,
      greeting: _getGreeting(),
      userName: userProfile.name,
      dailyCalorieGoal:
          userProfile.nutritionGoals['Calories']?.target.toInt() ?? 2000,
      nutritionGoals: userProfile.nutritionGoals,
    );
  }

  void _updateDashboardWithFoodEntries(List<FoodEntry> foodEntries) {
    print("Updating dashboard with food entries"); // Debug print
    final recentMeals = foodEntries.take(5).toList();
    final caloriesConsumed = foodEntries.fold<int>(
        0, (sum, entry) => sum + entry.nutritionInfo.calories);

    state = state.copyWith(
      isLoading: false,
      recentMeals: recentMeals,
      caloriesConsumed: caloriesConsumed,
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
    state = state.copyWith(isLoading: true);
    final userProfile = await _userProfileRepository.getUserProfile();
    final foodEntries = await _foodEntryRepository.getAllFoodEntries();

    if (userProfile != null) {
      _updateDashboardWithUserProfile(userProfile);
    }
    _updateDashboardWithFoodEntries(foodEntries);
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _foodEntryRepository.addFoodEntry(entry);
    // The dashboard will update automatically via the watchAllFoodEntries stream
  }

  @override
  void dispose() {
    _userProfileSubscription?.cancel();
    _foodEntriesSubscription?.cancel();
    super.dispose();
  }
}
