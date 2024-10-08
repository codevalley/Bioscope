import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bioscope/presentation/blocs/food_capture_bloc.dart';
import 'package:bioscope/data/services/nutrition_service.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';
import 'package:bioscope/domain/entities/food_entry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bioscope/domain/repositories/food_entry_repository.dart';
import 'package:bioscope/application/di/dependency_injection.dart';
import 'package:bioscope/domain/repositories/daily_goals_repository.dart';
import 'package:bioscope/domain/repositories/user_profile_repository.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../widgets/nutrition_info.dart';

class AddFoodEntryScreen extends StatelessWidget {
  const AddFoodEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodCaptureBloc(
        NutritionService(),
        getIt<IFoodEntryRepository>(),
        getIt<IDailyGoalsRepository>(),
        getIt<IUserProfileRepository>(),
      ),
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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      appBar: AppBar(
        title: const Text('Add Food Entry'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<FoodCaptureBloc, FoodCaptureState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFoodDescriptionInput(),
                        const SizedBox(height: 16),
                        _buildImageSection(),
                        const SizedBox(height: 16),
                        if (state is FoodCaptureLoading) _buildLoader(),
                        if (state is FoodCaptureSuccess) ...[
                          NutritionInfoWidget(
                              nutritionInfo: state.nutritionInfo),
                        ] else if (state is FoodCaptureFailure) ...[
                          _buildErrorMessage(state.error),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(state),
              ],
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
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(3),
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
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.file(
                File(_imagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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
      icon: Icon(icon, color: Colors.black),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildBottomBar(FoodCaptureState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFAF8),
        border: Border(top: BorderSide(color: Colors.black, width: 1)),
      ),
      child: SafeArea(
        child: state is FoodCaptureSuccess
            ? _buildSaveButton(state.nutritionInfo)
            : _buildAnalyzeButton(),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return ElevatedButton(
      onPressed: _submitEntry,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFED764A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Analyze Food',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSaveButton(NutritionInfo nutritionInfo) {
    return ElevatedButton(
      onPressed: () => _saveToLog(nutritionInfo),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFED764A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
          side: const BorderSide(color: Colors.black, width: 1),
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
        border: Border.all(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        'Error: $error',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red,
            ),
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFED764A)),
        backgroundColor: Colors.black12,
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
      FocusScope.of(context).unfocus();
      context
          .read<FoodCaptureBloc>()
          .add(AnalyzeImage(_imagePath, _descriptionController.text));
      _scrollToBottom();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a food description'),
          backgroundColor: Colors.red,
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
      final foodCaptureBloc = context.read<FoodCaptureBloc>();
      await foodCaptureBloc.addFoodEntryAndUpdateGoals(foodEntry);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Food entry saved and goals updated successfully'),
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
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
