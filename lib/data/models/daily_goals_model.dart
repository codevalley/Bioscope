import '../../domain/entities/daily_goals.dart';
import '../../domain/entities/goal_item.dart';

class DailyGoalsModel extends DailyGoals {
  DailyGoalsModel({
    required String id,
    required String userId,
    required DateTime date,
    required Map<String, GoalItem> goals,
  }) : super(id: id, userId: userId, date: date, goals: goals);

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
            target: value['target'],
            actual: value['actual'],
            isPublic: value['isPublic'],
            unit: value['unit'],
            timestamp: DateTime.parse(value['timestamp']),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
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

  DailyGoals toDomain() => this;
}
