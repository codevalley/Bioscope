import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import 'food_entry_item.dart';

class RecentHistory extends StatelessWidget {
  final List<FoodEntry> recentMeals;

  const RecentHistory({Key? key, required this.recentMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentMeals.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('No recent meals. Add your first meal!'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentMeals.length,
      itemBuilder: (context, index) => FoodEntryItem(entry: recentMeals[index]),
    );
  }
}
