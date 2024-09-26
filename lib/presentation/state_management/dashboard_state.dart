import '../../domain/entities/food_entry.dart';
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
