import 'package:flutter/material.dart';
import 'dart:io';
import '../../domain/entities/food_entry.dart';
import 'package:bioscope/presentation/widgets/nutrition_info.dart';

class FoodEntryDetailScreen extends StatelessWidget {
  final FoodEntry foodEntry;

  const FoodEntryDetailScreen({Key? key, required this.foodEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodEntry.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              foodEntry.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Date: ${foodEntry.date.toString()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (foodEntry.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(foodEntry.imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            const SizedBox(height: 24),
            NutritionInfoWidget(nutritionInfo: foodEntry.nutritionInfo),
          ],
        ),
      ),
    );
  }
}
