import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_button.dart';
import '../../domain/entities/goal_item.dart';
import '../../presentation/providers/providers.dart';
import 'dart:async';

class EditNutritionGoalsScreen extends ConsumerStatefulWidget {
  const EditNutritionGoalsScreen({Key? key}) : super(key: key);

  @override
  _EditNutritionGoalsScreenState createState() =>
      _EditNutritionGoalsScreenState();
}

class _EditNutritionGoalsScreenState
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
                max: _getMaxValueForGoal(goalItem.name),
                onChanged: (newValue) {
                  _updateLocalGoal(
                      goalItem.name, goalItem.copyWith(target: newValue));
                },
              ),
            ),
            Text('${goalItem.target.toInt()} ${goalItem.unit}'),
          ],
        ),
      ],
    );
  }

  double _getMaxValueForGoal(String goalName) {
    switch (goalName) {
      case 'Calories':
        return 5000;
      case 'Carbs':
      case 'Proteins':
      case 'Fats':
        return 300;
      case 'Fiber':
        return 100;
      default:
        return 100;
    }
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
