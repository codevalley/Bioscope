import '../../domain/entities/food_entry.dart';
import '../../domain/entities/nutrition_info.dart';

class FoodEntryModel extends FoodEntry {
  FoodEntryModel({
    required String id,
    required String name,
    required NutritionInfo nutritionInfo,
    required DateTime date,
    String? imagePath,
  }) : super(
          id: id,
          name: name,
          nutritionInfo: nutritionInfo,
          date: date,
          imagePath: imagePath,
        );

  factory FoodEntryModel.empty() {
    return FoodEntryModel(
      id: '',
      name: '',
      nutritionInfo: NutritionInfo(nutrition: [], summary: ''),
      date: DateTime.now(),
    );
  }

  factory FoodEntryModel.fromJson(Map<String, dynamic> json) {
    return FoodEntryModel(
      id: json['id'],
      name: json['name'],
      nutritionInfo: NutritionInfo.fromJson(json['nutritionInfo']),
      date: DateTime.parse(json['date']),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nutritionInfo':
          nutritionInfo.toJson(), // Assuming NutritionInfo has a toJson method
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }
}
