import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'nutrition_indicator.dart';
import '../../domain/entities/goal_item.dart';
import '../providers/providers.dart';
import '../../core/utils/date_formatter.dart';

class DashboardTopSection extends ConsumerWidget {
  final String greeting;
  final String name;
  final Map<String, GoalItem> dailyGoals;
  final DateTime date;
  final double shrinkOffset;
  final double height;
  final bool hasPreviousDay;
  final bool hasNextDay;
  final Function() onPreviousDay;
  final Function() onNextDay;

  const DashboardTopSection({
    Key? key,
    required this.greeting,
    required this.name,
    required this.dailyGoals,
    required this.date,
    required this.shrinkOffset,
    required this.height,
    required this.hasPreviousDay,
    required this.hasNextDay,
    required this.onPreviousDay,
    required this.onNextDay,
  }) : super(key: key);

  Color _getProgressColor(double progress, BuildContext context) {
    return progress > 1.0 ? Colors.red : const Color(0xFFED764A);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final caloriesGoal = dailyGoals['Calories'];
    final caloriesConsumed = caloriesGoal?.actual.toInt() ?? 0;
    final dailyCalorieGoal = caloriesGoal?.target.toInt() ?? 2000;
    final calorieProgress = caloriesConsumed / dailyCalorieGoal;

    // Calculate opacity based on shrinkOffset
    final double opacity = 1 - (shrinkOffset / (height - 50)).clamp(0.0, 1.0);

    return Container(
      color: const Color(0xFFFAFAF7),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: opacity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      '$greeting, $name',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (dashboardState.isDailyGoalsEmpty)
                    _buildZeroState(context)
                  else
                    _buildNutritionIndicators(context),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  color: const Color(0xFFFFF3E0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left,
                            color: hasPreviousDay
                                ? Colors.black
                                : Colors.grey[400]),
                        onPressed: hasPreviousDay ? onPreviousDay : null,
                        padding:
                            EdgeInsets.zero, // Remove padding from IconButton
                        constraints:
                            const BoxConstraints(), // Remove constraints
                        iconSize: 24, // Explicitly set icon size
                      ),
                      Expanded(
                        child: Text(
                          dashboardState.isDailyGoalsEmpty
                              ? '${DateFormatter().formatShortDate(date)} - Start food journey!'
                              : '${DateFormatter().formatShortDate(date)}: $caloriesConsumed/$dailyCalorieGoal kcal',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis for long text
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right,
                            color:
                                hasNextDay ? Colors.black : Colors.grey[400]),
                        onPressed: hasNextDay ? onNextDay : null,
                        padding:
                            EdgeInsets.zero, // Remove padding from IconButton
                        constraints:
                            const BoxConstraints(), // Remove constraints
                        iconSize: 24, // Explicitly set icon size
                      ),
                    ],
                  ),
                ),
                if (!dashboardState.isDailyGoalsEmpty)
                  LinearProgressIndicator(
                    value: calorieProgress.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(calorieProgress, context)),
                    minHeight: 2,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZeroState(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text(
          'No meals logged yet. Start your day by adding your first meal!',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNutritionIndicators(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: dailyGoals.entries
                .where((entry) => entry.key != 'Calories')
                .map((entry) {
              final goalItem = entry.value;
              final progress = goalItem.actual / goalItem.target;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  width: 66,
                  height: 89,
                  child: NutritionIndicator(
                    label: goalItem.name,
                    value:
                        '${goalItem.actual.toInt()}/${goalItem.target.toInt()}${goalItem.unit}',
                    progress: progress,
                    progressColor: _getProgressColor(progress, context),
                    size: 56,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
