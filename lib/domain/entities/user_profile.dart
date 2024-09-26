import 'package:uuid/uuid.dart';
import 'goal_item.dart';

class UserProfile {
  final String id;
  final String name;
  final int age;
  final double height;
  final double weight;
  final String gender;
  final Map<String, GoalItem> nutritionGoals;

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
