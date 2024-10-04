import 'dart:convert';
import '../../domain/entities/food_entry.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/nutrition_info.dart';

/// Model class for food entries, extending the [FoodEntry] entity.
///
/// This class provides additional functionality for JSON serialization and deserialization,
/// as well as conversion between the model and domain entity.
class FoodEntryModel extends FoodEntry {
  /// Creates a new [FoodEntryModel] instance.
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

  /// Creates a [FoodEntryModel] instance from a JSON map.
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
      Logger.log('Error in FoodEntryModel.fromJson: $e');
      Logger.log('Problematic JSON: $json');
      rethrow;
    }
  }

  /// Converts this [FoodEntryModel] to a [FoodEntry] domain entity.
  FoodEntryModel toDomain() {
    return FoodEntryModel(
      id: id,
      name: name,
      nutritionInfo: nutritionInfo,
      date: date,
      imagePath: imagePath,
    );
  }

  /// Converts this [FoodEntryModel] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nutritionInfo': jsonEncode(nutritionInfo.toJson()),
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  /// Creates an empty [FoodEntryModel] instance.
  factory FoodEntryModel.empty() {
    return FoodEntryModel(
      id: '',
      name: '',
      nutritionInfo: NutritionInfo.empty(),
      date: DateTime.now(),
    );
  }
}
