import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final int dailyCalorieGoal;
  final List<String> dietaryPreferences;

  User({
    String? id,
    required this.name,
    required this.dailyCalorieGoal,
    required this.dietaryPreferences,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dailyCalorieGoal': dailyCalorieGoal,
      'dietaryPreferences': dietaryPreferences,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      dailyCalorieGoal: json['dailyCalorieGoal'],
      dietaryPreferences: List<String>.from(json['dietaryPreferences']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dailyCalorieGoal': dailyCalorieGoal,
      'dietaryPreferences': dietaryPreferences.join(','),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      dailyCalorieGoal: map['dailyCalorieGoal'],
      dietaryPreferences: (map['dietaryPreferences'] as String).split(','),
    );
  }
}
