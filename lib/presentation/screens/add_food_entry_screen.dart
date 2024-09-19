import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bioscope/presentation/blocs/food_capture_bloc.dart';
import 'package:bioscope/data/services/nutrition_service.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';
import 'package:image_picker/image_picker.dart';
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
      appBar: AppBar(title: const Text('Add Food Entry')),
      body: BlocBuilder<FoodCaptureBloc, FoodCaptureState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Food Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _getImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Picture'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _getImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from Gallery'),
                    ),
                  ],
                ),
                if (_imagePath != null) ...[
                  const SizedBox(height: 16),
                  Image.file(File(_imagePath!), height: 200),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitEntry,
                  child: const Text('Submit'),
                ),
                if (state is FoodCaptureLoading) ...[
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                  const SizedBox(height: 8),
                  const Text('Analyzing image...', textAlign: TextAlign.center),
                ] else if (state is FoodCaptureSuccess) ...[
                  const SizedBox(height: 16),
                  NutritionInfoDisplay(state.nutritionInfo),
                ] else if (state is FoodCaptureFailure) ...[
                  const SizedBox(height: 16),
                  Text('Error: ${state.error}',
                      style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          );
        },
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
    if (_imagePath != null) {
      context
          .read<FoodCaptureBloc>()
          .add(AnalyzeImage(_imagePath!, _descriptionController.text));
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

class NutritionInfoDisplay extends StatelessWidget {
  final NutritionInfo nutritionInfo;

  const NutritionInfoDisplay(this.nutritionInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analysis Results', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(nutritionInfo.summary),
        const SizedBox(height: 16),
        ...nutritionInfo.nutrition.map((component) => ListTile(
              title: Text(component.component),
              subtitle: Text('${component.value} ${component.unit}'),
              trailing: Text(
                  'Confidence: ${(component.confidence * 100).toStringAsFixed(0)}%'),
            )),
      ],
    );
  }
}
