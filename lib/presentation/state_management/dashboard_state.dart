import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/entities/goal_item.dart';

part 'dashboard_state.freezed.dart';

/// State for the Dashboard feature
/// if you update this file, you need to update the corresponding freezed file
/// flutter pub run build_runner build --delete-conflicting-outputs

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
    required bool isDailyGoalsEmpty,
    required List<DateTime> datesWithData,
    required bool hasPreviousDay,
    required bool hasNextDay,
  }) = _DashboardState;

  factory DashboardState.initial() => DashboardState(
        isLoading: true,
        greeting: '',
        userName: '',
        nutritionGoals: {},
        dailyGoals: {},
        foodEntries: [],
        currentDate: DateTime.now(),
        isDailyGoalsEmpty: true,
        datesWithData: [],
        hasPreviousDay: false,
        hasNextDay: false,
      );
}
