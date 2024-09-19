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
        Text(
          'Recent Meals',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width * 0.3,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 16),
        ...recentMeals.map((meal) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${meal.nutritionInfo.calories} calories',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormatter.getRelativeTime(meal.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
