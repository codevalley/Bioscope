import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/dashboard_top_section.dart';
import '../widgets/recent_history.dart';
import '../widgets/dashboard_bottom_bar.dart';
import 'add_food_entry_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BIOSCOPE'),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Image.network("https://via.placeholder.com/30x30"),
        ),
      ),
      body: Column(
        children: [
          DashboardTopSection(
            greeting: dashboardState.greeting,
            name: dashboardState.userName,
            caloriesConsumed: dashboardState.caloriesConsumed,
            dailyCalorieGoal: dashboardState.dailyCalorieGoal,
            nutritionData: {
              'Calories': dashboardState.caloriesConsumed /
                  dashboardState.dailyCalorieGoal,
              'Protein': 0.7, // Replace with actual data
              'Carbs': 0.5, // Replace with actual data
              'Fat': 0.3, // Replace with actual data
            },
          ),
          Expanded(
            child: RecentHistory(recentMeals: dashboardState.recentMeals),
          ),
        ],
      ),
      bottomNavigationBar: DashboardBottomBar(
        onAddMealPressed: () => _navigateToAddFoodEntry(context, ref),
        onHomePressed: () {
          // TODO: Implement home navigation or refresh dashboard
        },
        onSettingsPressed: () {
          // TODO: Implement settings navigation
        },
      ),
    );
  }

  void _navigateToAddFoodEntry(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFoodEntryScreen()),
    );

    if (result != null) {
      await ref.read(dashboardNotifierProvider.notifier).addFoodEntry(result);
    }
  }
}
