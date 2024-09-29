import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_button.dart';
import '../../domain/entities/goal_item.dart';
import '../../presentation/providers/providers.dart';
import 'dart:async';

class EditNutritionGoalsScreen extends ConsumerStatefulWidget {
  const EditNutritionGoalsScreen({Key? key}) : super(key: key);

  @override
  EditNutritionGoalsScreenState createState() =>
      EditNutritionGoalsScreenState();
}

class EditNutritionGoalsScreenState
    extends ConsumerState<EditNutritionGoalsScreen> {
  late Map<String, GoalItem> _localNutritionGoals;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _localNutritionGoals =
        Map.from(ref.read(userProfileProvider).value?.nutritionGoals ?? {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _updateLocalGoal(String name, GoalItem updatedGoal) {
    setState(() {
      _localNutritionGoals[name] = updatedGoal;
    });

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(userProfileProvider.notifier)
          .updateNutritionGoal(name, updatedGoal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Nutrition Goals'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._localNutritionGoals.entries.map((entry) {
            final goalItem = entry.value;
            return _buildGoalSlider(context, goalItem);
          }),
          const SizedBox(height: 24),
          CustomButton(
            onPressed: () => _saveGoals(context),
            child: const Text('Save Goals'),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSlider(BuildContext context, GoalItem goalItem) {
    double maxValue;
    double step;
    switch (goalItem.name) {
      case 'Calories':
        maxValue = 4000;
        step = 50;
        break;
      case 'Carbs':
      case 'Proteins':
      case 'Fats':
        maxValue = 300;
        step = 5;
        break;
      case 'Fiber':
        maxValue = 50;
        step = 1;
        break;
      default:
        maxValue = 100;
        step = 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(goalItem.name, style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: goalItem.target,
                min: 0,
                max: maxValue,
                divisions: (maxValue / step).round(),
                label: goalItem.target.round().toString(),
                onChanged: (newValue) {
                  _updateLocalGoal(
                      goalItem.name, goalItem.copyWith(target: newValue));
                },
              ),
            ),
            Text('${goalItem.target.round()} ${goalItem.unit}'),
          ],
        ),
      ],
    );
  }

  void _saveGoals(BuildContext context) {
    ref.read(userProfileProvider.notifier).updateUserProfile(
          ref
              .read(userProfileProvider)
              .value!
              .copyWith(nutritionGoals: _localNutritionGoals),
        );
    Navigator.of(context).pop();
  }
}
