import 'package:flutter/material.dart';
import '../../domain/entities/goal_item.dart';

class DailyGoalsSection extends StatelessWidget {
  final Map<String, GoalItem> dailyGoals;

  const DailyGoalsSection({Key? key, required this.dailyGoals})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Goals',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...dailyGoals.entries
              .map((entry) => _buildGoalItem(context, entry.value)),
        ],
      ),
    );
  }

  Widget _buildGoalItem(BuildContext context, GoalItem goal) {
    final progress = goal.actual / goal.target;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${goal.name}: ${goal.actual.toStringAsFixed(1)} / ${goal.target.toStringAsFixed(1)} ${goal.unit}'),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 1.0 ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
