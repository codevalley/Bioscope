import 'package:flutter/material.dart';

class NutritionMeter extends StatelessWidget {
  final int caloriesConsumed;
  final int caloriesRemaining;
  final int dailyCalorieGoal;

  const NutritionMeter({
    Key? key,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
    required this.dailyCalorieGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalCalories = caloriesConsumed + caloriesRemaining;
    final progress = totalCalories > 0 ? caloriesConsumed / totalCalories : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calories',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE6F3EF),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
          ),
          const SizedBox(height: 8),
          Text(
            '$caloriesConsumed / $totalCalories kcal',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
