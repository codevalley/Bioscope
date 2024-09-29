import 'dart:convert';
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

  factory FoodEntryModel.fromJson(Map<String, dynamic> json) {
    try {
      return FoodEntryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        nutritionInfo:
            NutritionInfo.fromJson(jsonDecode(json['nutritionInfo'] as String)),
        date: DateTime.parse(json['date'] as String),
        imagePath: json['imagePath'] as String?,
      );
    } catch (e) {
      print('Error in FoodEntryModel.fromJson: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  FoodEntryModel toDomain() {
    return FoodEntryModel(
      id: id,
      name: name,
      nutritionInfo: nutritionInfo,
      date: date,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nutritionInfo': jsonEncode(nutritionInfo.toJson()),
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory FoodEntryModel.empty() {
    return FoodEntryModel(
      id: '',
      name: '',
      nutritionInfo: NutritionInfo.empty(),
      date: DateTime.now(),
    );
  }
}
