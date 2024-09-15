import 'package:flutter/material.dart';
import 'package:bioscope/domain/entities/food_entry.dart'; // Add this import

class RecentHistory extends StatelessWidget {
  final List<FoodEntry> recentMeals;

  const RecentHistory({Key? key, required this.recentMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Meals',
            style: Theme.of(context)
                .textTheme
                .titleLarge), // Updated to titleLarge
        const SizedBox(height: 8),
        ...recentMeals.map((meal) => ListTile(
              title: Text(meal.name ?? 'Unknown'),
              subtitle: Text('${meal.calories ?? 0} calories'),
              trailing: Text(meal.date?.toString() ?? 'No date'),
            )),
      ],
    );
  }
}
