// In domain/entities/daily_goal_log.dart
import 'package:uuid/uuid.dart';
import 'goal_item.dart';

class DailyGoals {
  final String id;
  final String userId;
  final DateTime date;
  final Map<String, GoalItem> goals;

  DailyGoals({
    String? id,
    required this.userId,
    required this.date,
    required this.goals,
  }) : id = id ?? const Uuid().v4();
}
