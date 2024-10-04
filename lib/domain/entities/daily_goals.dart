import 'package:uuid/uuid.dart';
import 'goal_item.dart';

/// Represents the daily nutritional goals for a user.
class DailyGoals {
  /// Unique identifier for the daily goals.
  final String id;

  /// The user ID associated with these daily goals.
  final String userId;

  /// The date for which these goals are set.
  final DateTime date;

  /// A map of goal items, where the key is the goal name and the value is a [GoalItem].
  final Map<String, GoalItem> goals;

  /// Creates a new [DailyGoals] instance.
  ///
  /// If [id] is not provided, a new UUID will be generated.
  DailyGoals({
    String? id,
    required this.userId,
    required this.date,
    required this.goals,
  }) : id = id ?? const Uuid().v4();

  /// Factory constructor to create a [DailyGoals] instance with a specific date.
  ///
  /// This constructor ensures that the time component of the date is stripped,
  /// storing only the date part.
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
