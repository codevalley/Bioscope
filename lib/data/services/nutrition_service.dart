import 'dart:io';
import '../../domain/entities/food_entry.dart';

class NutritionService {
  Future<FoodEntry> analyzeImage(File imageFile) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Return mock data
    return FoodEntry(
      name: 'Analyzed Food',
      calories: 250,
      date: DateTime.now(),
    );
  }
}
