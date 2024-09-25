import 'package:uuid/uuid.dart';

class UserProfile {
  final String id;
  final String name;
  final int age;
  final double height;
  final double weight;
  final String gender;
  final int dailyCalorieGoal;
  final double carbsGoal;
  final double proteinGoal;
  final double fatGoal;
  final double fiberGoal;
  final List<String> dietaryPreferences;

  UserProfile({
    String? id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.dailyCalorieGoal,
    required this.carbsGoal,
    required this.proteinGoal,
    required this.fatGoal,
    required this.fiberGoal,
    required this.dietaryPreferences,
  }) : id = id ?? const Uuid().v4();

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    double? height,
    double? weight,
    String? gender,
    int? dailyCalorieGoal,
    double? carbsGoal,
    double? proteinGoal,
    double? fatGoal,
    double? fiberGoal,
    List<String>? dietaryPreferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      fatGoal: fatGoal ?? this.fatGoal,
      fiberGoal: fiberGoal ?? this.fiberGoal,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
    );
  }
}
