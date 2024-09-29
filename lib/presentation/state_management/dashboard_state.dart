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
    required Map<String, GoalItem> nutritionGoals,
    required Map<String, GoalItem> dailyGoals,
    required List<FoodEntry> foodEntries,
    required DateTime currentDate,
  }) = _DashboardState;

  factory DashboardState.initial() => DashboardState(
        isLoading: true,
        greeting: '',
        userName: '',
        nutritionGoals: {},
        dailyGoals: {},
        foodEntries: [],
        currentDate: DateTime.now(),
      );
}
