import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import 'package:bioscope/presentation/widgets/nutrition_info.dart';
import 'package:bioscope/core/utils/date_formatter.dart';
import 'package:bioscope/presentation/widgets/authenticated_image.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';

class FoodEntryDetailScreen extends StatelessWidget {
  final FoodEntry foodEntry;

  const FoodEntryDetailScreen({Key? key, required this.foodEntry})
      : super(key: key);

  String _getNutritionInfo(FoodEntry entry) {
    final calories = entry.nutritionInfo.calories;

    final carbs = entry.nutritionInfo.nutrition
        .firstWhere(
          (component) => component.component == 'Carbs',
          orElse: () => NutritionComponent(
              component: 'Carbs', value: 0, unit: 'g', confidence: 1.0),
        )
        .value
        .toInt();

    final protein = entry.nutritionInfo.nutrition
        .firstWhere(
          (component) => component.component == 'Proteins',
          orElse: () => NutritionComponent(
              component: 'Proteins', value: 0, unit: 'g', confidence: 1.0),
        )
        .value
        .toInt();

    return '🔥 $calories kcal 🍞 $carbs g 🥜 $protein g';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
                  NutritionInfoWidget(nutritionInfo: foodEntry.nutritionInfo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            foodEntry.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormatter.formatDetailDate(foodEntry.date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _getNutritionInfo(foodEntry),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: 16),
          if (foodEntry.imagePath != null)
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: AuthenticatedImage(
                    imagePath: foodEntry.imagePath!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
