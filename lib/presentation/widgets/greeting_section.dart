import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final String greeting;
  final int caloriesConsumed;
  final int caloriesRemaining;

  const GreetingSection({
    super.key,
    required this.greeting,
    required this.caloriesConsumed,
    required this.caloriesRemaining,
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
          '${DateTime.now().toString().split(' ')[0]} • $caloriesConsumed kcal consumed, $caloriesRemaining kcal remaining',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333), // Dark gray for less emphasis
          ),
        ),
      ],
    );
  }
}
