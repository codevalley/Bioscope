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
    final isExceeded = caloriesConsumed > dailyCalorieGoal;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.black, width: 1), // Added 1px black border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calories',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE6F3EF),
            valueColor: AlwaysStoppedAnimation<Color>(
              isExceeded ? Colors.red : const Color(0xFFFDBA21),
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Text(
            '$caloriesConsumed / $dailyCalorieGoal kcal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
