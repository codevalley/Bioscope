import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.dailyCalorieGoal,
    required super.dietaryPreferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      dailyCalorieGoal: json['dailyCalorieGoal'],
      dietaryPreferences: List<String>.from(json['dietaryPreferences']),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      dailyCalorieGoal: user.dailyCalorieGoal,
      dietaryPreferences: user.dietaryPreferences,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dailyCalorieGoal': dailyCalorieGoal,
      'dietaryPreferences': dietaryPreferences,
    };
  }
}
