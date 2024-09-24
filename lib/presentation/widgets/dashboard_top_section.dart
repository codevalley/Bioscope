import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardTopSection extends StatelessWidget {
  final String greeting;
  final String name;
  final int caloriesConsumed;
  final int dailyCalorieGoal;

  const DashboardTopSection({
    Key? key,
    required this.greeting,
    required this.name,
    required this.caloriesConsumed,
    required this.dailyCalorieGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = caloriesConsumed / dailyCalorieGoal;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting $name',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '~$caloriesConsumed kcal',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 8.0,
                percent: progress,
                center: Text(
                  '$dailyCalorieGoal\nkcal',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                progressColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey[200]!,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
