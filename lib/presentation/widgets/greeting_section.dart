import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final String greeting;
  final String dateInfo;
  final int caloriesConsumed;
  final int caloriesRemaining;
  final int dailyCalorieGoal;

  const GreetingSection({
    super.key,
    required this.greeting,
    required this.dateInfo,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
    required this.dailyCalorieGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$dateInfo • $caloriesConsumed kcal consumed, $caloriesRemaining kcal remaining',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          'Daily Goal: $dailyCalorieGoal kcal',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
