import 'package:uuid/uuid.dart';
import 'goal_item.dart';

/// Represents a user's profile in the application.
class UserProfile {
  /// Unique identifier for the user profile.
  final String id;

  /// The user's name.
  final String name;

  /// The user's age.
  final int age;

  /// The user's height (presumably in cm or inches).
  final double height;

  /// The user's weight (presumably in kg or lbs).
  final double weight;

  /// The user's gender.
  final String gender;

  /// A map of the user's nutritional goals, where the key is the goal name and the value is a [GoalItem].
  final Map<String, GoalItem> nutritionGoals;

  /// Creates a new [UserProfile] instance.
  ///
  /// If [id] is not provided, a new UUID will be generated.
  /// If [nutritionGoals] is not provided, an empty map will be used.
  UserProfile({
    String? id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    Map<String, GoalItem>? nutritionGoals,
  })  : id = id ?? const Uuid().v4(),
        nutritionGoals = nutritionGoals ?? {};

  /// Creates a copy of this [UserProfile] with the given fields replaced with new values.
  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    double? height,
    double? weight,
    String? gender,
    Map<String, GoalItem>? nutritionGoals,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      nutritionGoals: nutritionGoals ?? this.nutritionGoals,
    );
  }
}
