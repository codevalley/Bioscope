import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import 'food_entry_item.dart';

class RecentHistory extends StatelessWidget {
  final List<FoodEntry> recentMeals;

  const RecentHistory({Key? key, required this.recentMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recentMeals.length,
      itemBuilder: (context, index) => FoodEntryItem(entry: recentMeals[index]),
    );
  }
}
