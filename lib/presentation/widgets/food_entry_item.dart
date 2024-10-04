import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import '../../utils/date_formatter.dart';
import 'authenticated_image.dart';

class FoodEntryItem extends StatelessWidget {
  final FoodEntry entry;
  final String calorieText;

  const FoodEntryItem({
    Key? key,
    required this.entry,
    required this.calorieText,
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
                      calorieText,
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
              child: AuthenticatedImage(
                imagePath: entry.imagePath!,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
