import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_button.dart';
import '../../domain/entities/goal_item.dart';
import '../../presentation/providers/providers.dart';

class EditNutritionGoalsScreen extends ConsumerWidget {
  const EditNutritionGoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).value;
    if (userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final nutritionGoals = userProfile.nutritionGoals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Nutrition Goals'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...nutritionGoals.entries.map((entry) {
            final goalItem = entry.value;
            return _buildGoalSlider(context, ref, goalItem);
          }),
          const SizedBox(height: 24),
          CustomButton(
            onPressed: () => _saveGoals(context, ref, nutritionGoals),
            child: const Text('Save Goals'),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSlider(
      BuildContext context, WidgetRef ref, GoalItem goalItem) {
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
                  ref.read(userProfileProvider.notifier).updateNutritionGoal(
                        goalItem.name,
                        goalItem.copyWith(target: newValue),
                      );
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

  void _saveGoals(BuildContext context, WidgetRef ref,
      Map<String, GoalItem> nutritionGoals) {
    ref.read(userProfileProvider.notifier).updateUserProfile(
          ref
              .read(userProfileProvider)
              .value!
              .copyWith(nutritionGoals: nutritionGoals),
        );
    Navigator.of(context).pop();
  }
}
