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

  factory DailyGoals.create({
    required String id,
    required String userId,
    required DateTime date,
    required Map<String, GoalItem> goals,
  }) {
    // Strip time component
    final dateOnly = DateTime(date.year, date.month, date.day);
    return DailyGoals(id: id, userId: userId, date: dateOnly, goals: goals);
  }
}
