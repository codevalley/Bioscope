import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/repositories/food_entry_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/services/IAuthService.dart';
import '../../domain/entities/goal_item.dart';

class DashboardState {
  final String greeting;
  final int caloriesConsumed;
  final int caloriesRemaining;
  final List<FoodEntry> recentMeals;
  final String userName;
  final int dailyCalorieGoal;
  final Map<String, GoalItem> nutritionGoals;

  DashboardState({
    required this.greeting,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
    required this.recentMeals,
    required this.userName,
    required this.dailyCalorieGoal,
    required this.nutritionGoals,
  });

  factory DashboardState.initial() => DashboardState(
        greeting: '',
        caloriesConsumed: 0,
        caloriesRemaining: 0,
        recentMeals: [],
        userName: '',
        dailyCalorieGoal: 0,
        nutritionGoals: {},
      );

  DashboardState copyWith({
    String? greeting,
    int? caloriesConsumed,
    int? caloriesRemaining,
    List<FoodEntry>? recentMeals,
    String? userName,
    int? dailyCalorieGoal,
    Map<String, GoalItem>? nutritionGoals,
  }) {
    return DashboardState(
      greeting: greeting ?? this.greeting,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesRemaining: caloriesRemaining ?? this.caloriesRemaining,
      recentMeals: recentMeals ?? this.recentMeals,
      userName: userName ?? this.userName,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      nutritionGoals: nutritionGoals ?? this.nutritionGoals,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final IFoodEntryRepository _foodEntryRepository;
  final IUserProfileRepository _userProfileRepository;
  final IAuthService _authService;

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
    _foodEntryRepository.watchAllFoodEntries().listen((entries) {
      state = state.copyWith(recentMeals: entries);
      _updateCaloriesConsumed();
    });
  }

  void _listenToUserProfile() {
    _userProfileRepository.watchUserProfile().listen((userProfile) {
      if (userProfile != null) {
        state = state.copyWith(
          userName: userProfile.name,
          dailyCalorieGoal:
              userProfile.nutritionGoals['Calories']?.target.toInt() ?? 2000,
          nutritionGoals: userProfile.nutritionGoals,
        );
        _updateCaloriesConsumed();
      }
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
}
