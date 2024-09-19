import 'package:uuid/uuid.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';

class FoodEntry {
  final String id;
  final String name;
  final NutritionInfo nutritionInfo;
  final DateTime date;
  final String? imagePath;

  FoodEntry({
    String? id,
    required this.name,
    required this.nutritionInfo,
    required this.date,
    this.imagePath,
  }) : id = id ?? const Uuid().v4();
}
