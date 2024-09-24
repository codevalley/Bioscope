import 'package:flutter/material.dart';
import 'nutrition_indicator.dart';

class DashboardTopSection extends StatelessWidget {
  final String greeting;
  final String name;
  final int caloriesConsumed;
  final int dailyCalorieGoal;
  final Map<String, double> nutritionData;

  const DashboardTopSection({
    Key? key,
    required this.greeting,
    required this.name,
    required this.caloriesConsumed,
    required this.dailyCalorieGoal,
    required this.nutritionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '$greeting, $name',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: nutritionData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: NutritionIndicator(
                  label: entry.key,
                  value: '${(entry.value * dailyCalorieGoal).toInt()} kcal',
                  progress: entry.value,
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Today: $caloriesConsumed / $dailyCalorieGoal kcal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.black12,
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ],
    );
  }
}
