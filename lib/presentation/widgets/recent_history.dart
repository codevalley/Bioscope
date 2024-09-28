import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import '../screens/food_entry_detail_screen.dart'; // Add this import
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
            "Today's progress",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (recentMeals.isEmpty)
          _buildEmptyState(context)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentMeals.length,
            itemBuilder: (context, index) {
              final meal = recentMeals[index];
              return GestureDetector(
                onTap: () => _showFoodEntryDetail(context, meal),
                child: FoodEntryItem(
                  entry: meal,
                  calorieText:
                      '${_getFoodEmoji(meal.nutritionInfo.calories)} ${meal.nutritionInfo.calories} kcal',
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
            'No recent meals',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first meal to see it here!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }
}
