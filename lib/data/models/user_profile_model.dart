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
    required double carbsGoal,
    required double proteinGoal,
    required double fatGoal,
    required double fiberGoal,
    required List<String> dietaryPreferences,
  }) : super(
          id: id,
          name: name,
          age: age,
          height: height,
          weight: weight,
          gender: gender,
          dailyCalorieGoal: dailyCalorieGoal,
          carbsGoal: carbsGoal,
          proteinGoal: proteinGoal,
          fatGoal: fatGoal,
          fiberGoal: fiberGoal,
          dietaryPreferences: dietaryPreferences,
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
      carbsGoal: (json['carbsGoal'] as num).toDouble(),
      proteinGoal: (json['proteinGoal'] as num).toDouble(),
      fatGoal: (json['fatGoal'] as num).toDouble(),
      fiberGoal: (json['fiberGoal'] as num).toDouble(),
      dietaryPreferences: List<String>.from(json['dietaryPreferences']),
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
      'carbsGoal': carbsGoal,
      'proteinGoal': proteinGoal,
      'fatGoal': fatGoal,
      'fiberGoal': fiberGoal,
      'dietaryPreferences': dietaryPreferences,
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
      carbsGoal: carbsGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
      fiberGoal: fiberGoal,
      dietaryPreferences: dietaryPreferences,
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
      carbsGoal: userProfile.carbsGoal,
      proteinGoal: userProfile.proteinGoal,
      fatGoal: userProfile.fatGoal,
      fiberGoal: userProfile.fiberGoal,
      dietaryPreferences: userProfile.dietaryPreferences,
    );
  }
}
