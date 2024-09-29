// File: lib/domain/entities/goal_item.dart

class GoalItem {
  final String name;
  final String description;
  final double target;
  final double actual;
  final bool isPublic;
  final String unit;
  final DateTime timestamp;

  GoalItem({
    required this.name,
    required this.description,
    required this.target,
    this.actual = 0.0,
    this.isPublic = true,
    required this.unit,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  GoalItem copyWith({
    String? name,
    String? description,
    double? target,
    double? actual,
    bool? isPublic,
    String? unit,
    DateTime? timestamp,
  }) {
    return GoalItem(
      name: name ?? this.name,
      description: description ?? this.description,
      target: target ?? this.target,
      actual: actual ?? this.actual,
      isPublic: isPublic ?? this.isPublic,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
