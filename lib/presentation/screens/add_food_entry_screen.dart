import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_entry.dart';

class AddFoodEntryScreen extends ConsumerWidget {
  const AddFoodEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFE6F3EF),
      appBar: AppBar(
        title: const Text('Add Food Entry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Food Name',
                labelStyle: const TextStyle(color: Colors.black54),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(
                labelText: 'Calories',
                labelStyle: const TextStyle(color: Colors.black54),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                minimumSize: const Size(double.infinity, 56),
              ),
              onPressed: () {
                final name = nameController.text;
                final calories = int.tryParse(caloriesController.text) ?? 0;
                if (name.isNotEmpty && calories > 0) {
                  final entry = FoodEntry(
                    name: name,
                    calories: calories,
                    date: DateTime.now(),
                  );
                  Navigator.of(context).pop(entry);
                }
              },
              child: const Text(
                'Add Entry',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
