// File: lib/domain/entities/goal_item.dart

/// Represents a specific nutritional goal item.
class GoalItem {
  /// The name of the goal (e.g., "Calories", "Protein").
  final String name;

  /// A description of the goal.
  final String description;

  /// The target value for this goal.
  final double target;

  /// The actual value achieved for this goal.
  final double actual;

  /// Whether this goal is public or private.
  final bool isPublic;

  /// The unit of measurement for this goal (e.g., "g" for grams, "kcal" for calories).
  final String unit;

  /// The timestamp when this goal was last updated.
  final DateTime timestamp;

  /// Creates a new [GoalItem] instance.
  ///
  /// If [timestamp] is not provided, it defaults to the current time.
  GoalItem({
    required this.name,
    required this.description,
    required this.target,
    this.actual = 0.0,
    this.isPublic = true,
    required this.unit,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Creates a copy of this [GoalItem] with the given fields replaced with new values.
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
