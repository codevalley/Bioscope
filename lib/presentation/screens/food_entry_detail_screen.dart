import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import 'package:bioscope/presentation/widgets/nutrition_info.dart';
import 'package:bioscope/core/utils/date_formatter.dart';
import 'package:bioscope/presentation/widgets/authenticated_image.dart';

class FoodEntryDetailScreen extends StatelessWidget {
  final FoodEntry foodEntry;

  const FoodEntryDetailScreen({Key? key, required this.foodEntry})
      : super(key: key);

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
          const SizedBox(height: 16),
          if (foodEntry.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AuthenticatedImage(
                imagePath: foodEntry.imagePath!,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
