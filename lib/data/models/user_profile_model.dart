import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required String id,
    required String name,
    required int age,
    required double height,
    required double weight,
    required String gender,
    required int dailyCalorieGoal,
  }) : super(
          id: id,
          name: name,
          age: age,
          height: height,
          weight: weight,
          gender: gender,
          dailyCalorieGoal: dailyCalorieGoal,
        );

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      gender: json['gender'],
      dailyCalorieGoal: json['dailyCalorieGoal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'dailyCalorieGoal': dailyCalorieGoal,
    };
  }

  UserProfile toDomain() {
    return UserProfile(
      id: id,
      name: name,
      age: age,
      height: height,
      weight: weight,
      gender: gender,
      dailyCalorieGoal: dailyCalorieGoal,
    );
  }

  factory UserProfileModel.fromDomain(UserProfile userProfile) {
    return UserProfileModel(
      id: userProfile.id,
      name: userProfile.name,
      age: userProfile.age,
      height: userProfile.height,
      weight: userProfile.weight,
      gender: userProfile.gender,
      dailyCalorieGoal: userProfile.dailyCalorieGoal,
    );
  }
}
