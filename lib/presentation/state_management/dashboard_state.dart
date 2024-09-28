import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/entities/goal_item.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    required bool isLoading,
    required String greeting,
    required String userName,
    required int caloriesConsumed,
    required int dailyCalorieGoal,
    required Map<String, GoalItem> nutritionGoals,
    required Map<String, GoalItem> dailyGoals,
    required List<FoodEntry> recentMeals,
  }) = _DashboardState;

  factory DashboardState.initial() => const DashboardState(
        isLoading: true,
        greeting: '',
        userName: '',
        caloriesConsumed: 0,
        dailyCalorieGoal: 2000,
        nutritionGoals: {},
        dailyGoals: {},
        recentMeals: [],
      );
}
