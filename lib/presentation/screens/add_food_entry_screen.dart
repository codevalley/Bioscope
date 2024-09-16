import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/food_entry.dart';
import '../../data/services/nutrition_service.dart';

class AddFoodEntryScreen extends ConsumerStatefulWidget {
  const AddFoodEntryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddFoodEntryScreen> createState() => _AddFoodEntryScreenState();
}

class _AddFoodEntryScreenState extends ConsumerState<AddFoodEntryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  XFile? _image;

  final NutritionService _nutritionService = NutritionService();

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
      // Process the image and extract nutrition data
      final analyzedEntry =
          await _nutritionService.analyzeImage(File(image.path));

      setState(() {
        nameController.text = analyzedEntry.name;
        caloriesController.text = analyzedEntry.calories.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(
                labelText: 'Calories',
                labelStyle: const TextStyle(color: Colors.black54),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _takePicture,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Take Picture'),
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Image captured: ${_image!.path}'),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      caloriesController.text.isNotEmpty) {
                    final newEntry = FoodEntry(
                      name: nameController.text,
                      calories: int.parse(caloriesController.text),
                      date: DateTime.now(),
                      imagePath: _image?.path,
                    );
                    Navigator.of(context).pop(newEntry);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
