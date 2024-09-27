import 'package:flutter/material.dart';
import 'nutrition_indicator.dart';
import '../../domain/entities/goal_item.dart';

class DashboardTopSection extends StatelessWidget {
  final String greeting;
  final String name;
  final int caloriesConsumed;
  final int dailyCalorieGoal;
  final Map<String, GoalItem> nutritionGoals;

  const DashboardTopSection({
    Key? key,
    required this.greeting,
    required this.name,
    required this.caloriesConsumed,
    required this.dailyCalorieGoal,
    required this.nutritionGoals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        children: nutritionGoals.entries.map((entry) {
                          final goalItem = entry.value;
                          final progress = goalItem.actual / goalItem.target;
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: NutritionIndicator(
                              label: goalItem.name,
                              value:
                                  '${goalItem.actual.toInt()} / ${goalItem.target.toInt()} ${goalItem.unit}',
                              progress: progress,
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
