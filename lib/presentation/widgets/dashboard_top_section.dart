import 'package:flutter/material.dart';
import 'nutrition_indicator.dart';
import '../../domain/entities/goal_item.dart';

class DashboardTopSection extends StatelessWidget {
  final String greeting;
  final String name;
  final Map<String, GoalItem> dailyGoals;

  const DashboardTopSection({
    Key? key,
    required this.greeting,
    required this.name,
    required this.dailyGoals,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final double expandRatio = (constraints.maxHeight - 70) / (200 - 70);
        final bool isExpanded = expandRatio > 0.5;

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedOpacity(
                opacity: isExpanded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '$greeting, $name',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: dailyGoals.entries
                            .where((entry) => entry.key != 'Calories')
                            .map((entry) {
                          final goalItem = entry.value;
                          final progress = goalItem.actual / goalItem.target;
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              height: 76,
                              child: NutritionIndicator(
                                label: goalItem.name,
                                value:
                                    '${goalItem.actual.toInt()} / ${goalItem.target.toInt()} ${goalItem.unit}',
                                progress: progress,
                                progressColor:
                                    _getProgressColor(progress, context),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Today: $caloriesConsumed / $dailyCalorieGoal kcal',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    LinearProgressIndicator(
                      value: calorieProgress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(calorieProgress, context)),
                      minHeight: 2,
                    ),
                    Container(
                      height: 1,
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
