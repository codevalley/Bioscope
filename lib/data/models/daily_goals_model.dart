import '../../domain/entities/daily_goals.dart';
import '../../domain/entities/goal_item.dart';

/// Model class for daily goals, extending the [DailyGoals] entity.
///
/// This class provides additional functionality for JSON serialization and deserialization,
/// as well as conversion between the model and domain entity.
class DailyGoalsModel extends DailyGoals {
  /// Creates a new [DailyGoalsModel] instance.
  DailyGoalsModel({
    required String id,
    required String userId,
    required DateTime date,
    required Map<String, GoalItem> goals,
  }) : super(id: id, userId: userId, date: date, goals: goals);

  /// Creates a [DailyGoalsModel] instance from a JSON map.
  factory DailyGoalsModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalsModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      goals: (json['goals'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          GoalItem(
            name: value['name'],
            description: value['description'],
            target: (value['target'] as num).toDouble(),
            actual: (value['actual'] as num).toDouble(),
            isPublic: value['isPublic'],
            unit: value['unit'],
            timestamp: DateTime.parse(value['timestamp']),
          ),
        ),
      ),
    );
  }

  /// Converts this [DailyGoalsModel] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'goals': goals.map(
        (key, value) => MapEntry(
          key,
          {
            'name': value.name,
            'description': value.description,
            'target': value.target,
            'actual': value.actual,
            'isPublic': value.isPublic,
            'unit': value.unit,
            'timestamp': value.timestamp.toIso8601String(),
          },
        ),
      ),
    };
  }

  /// Converts this [DailyGoalsModel] to a [DailyGoals] domain entity.
  DailyGoals toDomain() {
    return DailyGoals(
      id: id,
      userId: userId,
      date: date,
      goals: goals,
    );
  }

  /// Creates a [DailyGoalsModel] from a [DailyGoals] domain entity.
  static DailyGoalsModel fromDomain(DailyGoals dailyGoals) {
    return DailyGoalsModel(
      id: dailyGoals.id,
      userId: dailyGoals.userId,
      date: dailyGoals.date,
      goals: dailyGoals.goals,
    );
  }

  /// Creates a copy of this [DailyGoalsModel] with the given fields replaced with new values.
  DailyGoalsModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    Map<String, GoalItem>? goals,
  }) {
    return DailyGoalsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      goals: goals ?? this.goals,
    );
  }
}
