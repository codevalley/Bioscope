import 'package:uuid/uuid.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';

/// Represents a food entry in the user's diet log.
class FoodEntry {
  /// Unique identifier for the food entry.
  final String id;

  /// The name of the food item.
  final String name;

  /// Nutritional information for the food item.
  final NutritionInfo nutritionInfo;

  /// The date and time when the food was consumed.
  final DateTime date;

  /// Optional path to an image of the food item.
  final String? imagePath;

  /// Creates a new [FoodEntry] instance.
  ///
  /// If [id] is not provided, a new UUID will be generated.
  FoodEntry({
    String? id,
    required this.name,
    required this.nutritionInfo,
    required this.date,
    this.imagePath,
  }) : id = id ?? const Uuid().v4();
}
