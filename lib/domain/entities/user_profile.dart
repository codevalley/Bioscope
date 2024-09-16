import 'package:uuid/uuid.dart';

class UserProfile {
  final String id;
  final String name;
  final int age;
  final double height;
  final double weight;
  final String gender;
  final int dailyCalorieGoal;

  UserProfile({
    String? id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.dailyCalorieGoal,
  }) : id = id ?? const Uuid().v4();
}
