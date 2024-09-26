import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/services/IAuthService.dart';
import 'dashboard_state.dart';
import 'dart:async';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final IFoodEntryRepository _foodEntryRepository;
  final IUserProfileRepository _userProfileRepository;
  final IAuthService _authService;
  StreamSubscription? _userProfileSubscription;
  StreamSubscription? _foodEntriesSubscription;

  DashboardNotifier(
    this._foodEntryRepository,
    this._userProfileRepository,
    this._authService,
  ) : super(DashboardState.initial()) {
    _initializeDashboard();
  }

  Future<void> _initializeDashboard() async {
    await _updateDashboardState();
    _listenToFoodEntries();
    _listenToUserProfile();
  }

  void _listenToFoodEntries() {
    _foodEntriesSubscription?.cancel();
    _foodEntriesSubscription =
        _foodEntryRepository.watchAllFoodEntries().listen(
      (entries) {
        state = state.copyWith(recentMeals: entries);
        _updateCaloriesConsumed();
      },
      onError: (error) {
        print('Error in food entries stream: $error');
        // Implement retry logic here if needed
      },
    );
  }

  void _listenToUserProfile() {
    _userProfileSubscription?.cancel();
    _userProfileSubscription = _userProfileRepository.watchUserProfile().listen(
      (userProfile) {
        if (userProfile != null) {
          state = state.copyWith(
            userName: userProfile.name,
            dailyCalorieGoal:
                userProfile.nutritionGoals['Calories']?.target.toInt() ?? 2000,
            nutritionGoals: userProfile.nutritionGoals,
          );
          _updateCaloriesConsumed();
        }
      },
      onError: (error) {
        print('Error in user profile stream: $error');
        // Implement retry logic here
        _retryUserProfileStream();
      },
    );
  }

  void _retryUserProfileStream() {
    // Wait for a short duration before retrying
    Timer(const Duration(seconds: 5), () {
      _listenToUserProfile();
    });
  }

  Future<void> _updateCaloriesConsumed() async {
    final totalCalories = await _foodEntryRepository.getTotalCaloriesConsumed();
    state = state.copyWith(
      caloriesConsumed: totalCalories,
      caloriesRemaining: state.dailyCalorieGoal - totalCalories,
    );
  }

  Future<void> _updateDashboardState() async {
    final userProfile = await _userProfileRepository.getUserProfile();
    final recentMeals = await _foodEntryRepository.getRecentFoodEntries();
    final totalCalories = await _foodEntryRepository.getTotalCaloriesConsumed();

    if (userProfile != null) {
      final calorieGoal =
          userProfile.nutritionGoals['Calories']?.target.toInt() ?? 2000;
      state = state.copyWith(
        greeting: _getGreeting(),
        caloriesConsumed: totalCalories,
        caloriesRemaining: calorieGoal - totalCalories,
        recentMeals: recentMeals,
        userName: userProfile.name,
        dailyCalorieGoal: calorieGoal,
        nutritionGoals: userProfile.nutritionGoals,
      );
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<void> refreshDashboard() async {
    await _updateDashboardState();
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _foodEntryRepository.addFoodEntry(entry);
    await _updateDashboardState();
  }

  @override
  void dispose() {
    _userProfileSubscription?.cancel();
    _foodEntriesSubscription?.cancel();
    super.dispose();
  }
}
