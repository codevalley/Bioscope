import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_entry.dart';
import '../state_management/dashboard_notifier.dart';

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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
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
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                final name = nameController.text;
                final calories = int.tryParse(caloriesController.text) ?? 0;
                if (name.isNotEmpty && calories > 0) {
                  final entry = FoodEntry(
                    id: DateTime.now().toIso8601String(),
                    name: name,
                    calories: calories,
                    timestamp: DateTime.now(),
                  );
                  ref.read(dashboardProvider.notifier).addFoodEntry(entry);
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Add Entry',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
