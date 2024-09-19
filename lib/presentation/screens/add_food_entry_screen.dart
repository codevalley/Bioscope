import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bioscope/presentation/blocs/food_capture_bloc.dart';
import 'package:bioscope/data/services/nutrition_service.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/application/di/dependency_injection.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class AddFoodEntryScreen extends StatelessWidget {
  const AddFoodEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodCaptureBloc(NutritionService()),
      child: const AddFoodEntryView(),
    );
  }
}

class AddFoodEntryView extends StatefulWidget {
  const AddFoodEntryView({Key? key}) : super(key: key);

  @override
  AddFoodEntryViewState createState() => AddFoodEntryViewState();
}

class AddFoodEntryViewState extends State<AddFoodEntryView> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _imagePath;

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
      body: BlocBuilder<FoodCaptureBloc, FoodCaptureState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFoodDescriptionInput(),
                  const SizedBox(height: 24),
                  _buildImageSection(),
                  const SizedBox(height: 24),
                  _buildAnalyzeButton(),
                  const SizedBox(height: 24),
                  if (state is FoodCaptureLoading) ...[
                    _buildLoadingIndicator(),
                  ] else if (state is FoodCaptureSuccess) ...[
                    _buildNutritionInfo(state.nutritionInfo),
                    const SizedBox(height: 24),
                    _buildSaveButton(state.nutritionInfo),
                  ] else if (state is FoodCaptureFailure) ...[
                    _buildErrorMessage(state.error),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodDescriptionInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: TextField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          hintText: 'Describe your meal',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildImageButton(
              icon: Icons.camera_alt,
              label: 'Take Picture',
              onPressed: () => _getImage(ImageSource.camera),
            ),
            _buildImageButton(
              icon: Icons.photo_library,
              label: 'Choose from Gallery',
              onPressed: () => _getImage(ImageSource.gallery),
            ),
          ],
        ),
        if (_imagePath != null) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(_imagePath!),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return ElevatedButton(
      onPressed: _submitEntry,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFDBA21),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Analyze Food',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        const LinearProgressIndicator(
          backgroundColor: Color(0xFFE6F3EF),
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDBA21)),
        ),
        const SizedBox(height: 16),
        Text(
          'Analyzing food...',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }

  Widget _buildNutritionInfo(NutritionInfo nutritionInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Results',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            nutritionInfo.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 16),
          ...nutritionInfo.nutrition.map((component) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      component.component,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '${component.value} ${component.unit}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSaveButton(NutritionInfo nutritionInfo) {
    return ElevatedButton(
      onPressed: () => _saveToLog(nutritionInfo),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Save to Log',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Error: $error',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red.shade800,
            ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _submitEntry() {
    if (_descriptionController.text.isNotEmpty) {
      context
          .read<FoodCaptureBloc>()
          .add(AnalyzeImage(_imagePath, _descriptionController.text));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a food description'),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  void _saveToLog(NutritionInfo nutritionInfo) async {
    final foodEntry = FoodEntry(
      id: const Uuid().v4(),
      name: _descriptionController.text,
      nutritionInfo: nutritionInfo,
      date: DateTime.now(),
      imagePath: _imagePath,
    );

    try {
      final IFoodEntryRepository repository = getIt<IFoodEntryRepository>();
      await repository.addFoodEntry(foodEntry);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Food entry saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving food entry: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
