class User {
  final String id;
  final String name;
  final int dailyCalorieGoal;
  final List<String> dietaryPreferences;

  const User({
    required this.id,
    required this.name,
    required this.dailyCalorieGoal,
    required this.dietaryPreferences,
  });
}
