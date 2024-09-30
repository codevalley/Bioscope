import 'package:flutter/material.dart';
import 'nutrition_indicator.dart';
import '../../domain/entities/goal_item.dart';
import 'package:intl/intl.dart';

class DashboardTopSection extends StatelessWidget {
  final String greeting;
  final String name;
  final Map<String, GoalItem> dailyGoals;
  final DateTime date;
  final double shrinkOffset;
  final double height;

  const DashboardTopSection({
    Key? key,
    required this.greeting,
    required this.name,
    required this.dailyGoals,
    required this.date,
    required this.shrinkOffset,
    required this.height,
  }) : super(key: key);

  Color _getProgressColor(double progress, BuildContext context) {
    return progress > 1.0 ? Colors.red : const Color(0xFFED764A);
  }

  @override
  Widget build(BuildContext context) {
    final caloriesGoal = dailyGoals['Calories'];
    final caloriesConsumed = caloriesGoal?.actual.toInt() ?? 0;
    final dailyCalorieGoal = caloriesGoal?.target.toInt() ?? 2000;
    final calorieProgress = caloriesConsumed / dailyCalorieGoal;

    final dateFormatter = DateFormat('EEEE d');
    final formattedDate = dateFormatter.format(date);

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
                  SizedBox(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: SizedBox(
                                width: 66,
                                height: 89,
                                child: NutritionIndicator(
                                  label: goalItem.name,
                                  value:
                                      '${goalItem.actual.toInt()}/${goalItem.target.toInt()}${goalItem.unit}',
                                  progress: progress,
                                  progressColor:
                                      _getProgressColor(progress, context),
                                  size: 56,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.chevron_left, color: Colors.grey[600]),
                      Expanded(
                        child: Text(
                          'Today, $formattedDate : $caloriesConsumed/$dailyCalorieGoal kcal',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[600]),
                    ],
                  ),
                ),
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
}
