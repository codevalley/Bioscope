import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import '../../utils/date_formatter.dart';

class RecentHistory extends StatelessWidget {
  final List<FoodEntry> recentMeals;

  const RecentHistory({Key? key, required this.recentMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Meals', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...recentMeals.map((meal) => ListTile(
              title: Text(meal.name),
              subtitle: Text('${meal.calories} calories'),
              trailing: Text(DateFormatter.getRelativeTime(meal.date)),
            )),
      ],
    );
  }
}
