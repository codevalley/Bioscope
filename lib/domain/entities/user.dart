class User {
  final String id;
  final String name;
  final int dailyCalorieGoal;
  final List<String> dietaryPreferences;

  User({
    required this.id,
    required this.name,
    required this.dailyCalorieGoal,
    required this.dietaryPreferences,
  });

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
}
