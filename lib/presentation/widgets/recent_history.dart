import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import 'food_entry_item.dart';

class RecentHistory extends StatelessWidget {
  final List<FoodEntry> recentMeals;

  const RecentHistory({Key? key, required this.recentMeals}) : super(key: key);

  String _getFoodEmoji(int calories) {
    if (calories < 200) return '🥗';
    if (calories < 400) return '🍽️';
    if (calories < 600) return '🍔';
    if (calories < 800) return '🍕';
    return '🍰';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Recent Meals',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentMeals.length,
          itemBuilder: (context, index) {
            final meal = recentMeals[index];
            return FoodEntryItem(
              entry: meal,
              calorieText:
                  '${_getFoodEmoji(meal.nutritionInfo.calories)} ${meal.nutritionInfo.calories} kcal',
            );
          },
        ),
      ],
    );
  }
}
