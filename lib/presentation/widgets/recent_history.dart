import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';

import '../screens/food_entry_detail_screen.dart';
import 'package:bioscope/presentation/widgets/authenticated_image.dart';
import 'package:bioscope/core/utils/date_formatter.dart';

class RecentHistory extends StatelessWidget {
  final List<FoodEntry> foodEntries;

  const RecentHistory({Key? key, required this.foodEntries}) : super(key: key);

  String _getNutritionInfo(FoodEntry entry) {
    final nutritionToGoalMapping = {
      'Calories': 'Calories',
      'Total Fat': 'Fats',
      'Total Carbohydrates': 'Carbs',
      'Dietary Fiber': 'Fiber',
      'Protein': 'Proteins',
    };

    final nutritionInfo = <String, String>{};

    for (var component in entry.nutritionInfo.nutrition) {
      final mappedKey = nutritionToGoalMapping[component.component];
      if (mappedKey != null && component.value > 0) {
        String value = component.value.toInt().toString();
        String unit = component.unit;

        switch (mappedKey) {
          case 'Calories':
            nutritionInfo['Calories'] = '🔥 $value $unit';
            break;
          case 'Carbs':
            nutritionInfo['Carbs'] = '🍞 $value $unit';
            break;
          case 'Proteins':
            nutritionInfo['Proteins'] = '🥜 $value $unit';
            break;
          case 'Fats':
            nutritionInfo['Fats'] = '🥑 $value $unit';
            break;
        }
      }
    }

    return nutritionInfo.values.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Today's Meals",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (foodEntries.isEmpty)
          _buildEmptyState(context)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodEntries.length,
            itemBuilder: (context, index) {
              final meal = foodEntries[index];
              return GestureDetector(
                onTap: () => _showFoodEntryDetail(context, meal),
                child: FoodEntryItem(
                  entry: meal,
                  nutritionText: _getNutritionInfo(meal),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showFoodEntryDetail(BuildContext context, FoodEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FoodEntryDetailScreen(foodEntry: entry),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_meals, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No meals recorded today',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a meal to see it here!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }
}

class FoodEntryItem extends StatelessWidget {
  final FoodEntry entry;
  final String nutritionText;

  const FoodEntryItem({
    Key? key,
    required this.entry,
    required this.nutritionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: entry.imagePath != null
                    ? AuthenticatedImage(imagePath: entry.imagePath!)
                    : const Icon(Icons.fastfood),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nutritionText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          DateFormatter.getRelativeTime(entry.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (entry.imagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: AuthenticatedImage(
                      imagePath: entry.imagePath!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
