import '../../domain/entities/user_profile.dart';
import '../../domain/entities/goal_item.dart';

/// Model class for user profiles, extending the [UserProfile] entity.
///
/// This class provides additional functionality for JSON serialization and deserialization,
/// as well as conversion between the model and domain entity.
class UserProfileModel extends UserProfile {
  /// Creates a new [UserProfileModel] instance.
  UserProfileModel({
    required String id,
    required String name,
    required int age,
    required double height,
    required double weight,
    required String gender,
    required Map<String, GoalItem> nutritionGoals,
  }) : super(
          id: id,
          name: name,
          age: age,
          height: height,
          weight: weight,
          gender: gender,
          nutritionGoals: nutritionGoals,
        );

  /// Creates a [UserProfileModel] instance from a JSON map.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      gender: json['gender'],
      nutritionGoals: (json['nutritionGoals'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          GoalItem(
            name: value['name'],
            description: value['description'],
            target: value['target'],
            actual: value['actual'],
            isPublic: value['isPublic'],
            unit: value['unit'],
            timestamp: DateTime.parse(value['timestamp']),
          ),
        ),
      ),
    );
  }

  /// Converts this [UserProfileModel] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'nutritionGoals': nutritionGoals.map(
        (key, value) => MapEntry(
          key,
          {
            'name': value.name,
            'description': value.description,
            'target': value.target,
            'actual': value.actual,
            'isPublic': value.isPublic,
            'unit': value.unit,
            'timestamp': value.timestamp.toIso8601String(),
          },
        ),
      ),
    };
  }

  /// Converts this [UserProfileModel] to a [UserProfile] domain entity.
  UserProfile toDomain() => this;

  /// Creates a [UserProfileModel] from a [UserProfile] domain entity.
  factory UserProfileModel.fromDomain(UserProfile userProfile) {
    return UserProfileModel(
      id: userProfile.id,
      name: userProfile.name,
      age: userProfile.age,
      height: userProfile.height,
      weight: userProfile.weight,
      gender: userProfile.gender,
      nutritionGoals: userProfile.nutritionGoals,
    );
  }
}
