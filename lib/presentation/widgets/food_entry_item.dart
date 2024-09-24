import 'package:flutter/material.dart';
import '../../domain/entities/food_entry.dart';
import '../../utils/date_formatter.dart';
import 'dart:io';

class FoodEntryItem extends StatelessWidget {
  final FoodEntry entry;

  const FoodEntryItem({Key? key, required this.entry}) : super(key: key);

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
                    ? Image.file(File(entry.imagePath!), fit: BoxFit.cover)
                    : const Icon(Icons.fastfood),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.nutritionInfo.calories} Calories',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      entry.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Text(
                DateFormatter.getRelativeTime(entry.date),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (entry.imagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.file(
                File(entry.imagePath!),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
