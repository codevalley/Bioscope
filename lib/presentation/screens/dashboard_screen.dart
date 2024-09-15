import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/greeting_section.dart';
import '../widgets/nutrition_meter.dart';
import '../widgets/recent_history.dart';
import '../widgets/add_meal_button.dart';
import '../state_management/dashboard_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE6F3EF), // Light mint green background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Consistent 20px margin
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingSection(
                  greeting: dashboardState.greeting,
                  caloriesConsumed: dashboardState.caloriesConsumed,
                  caloriesRemaining: dashboardState.caloriesRemaining,
                ),
                const SizedBox(height: 32), // Increased spacing
                NutritionMeter(
                  caloriesConsumed: dashboardState.caloriesConsumed,
                  caloriesRemaining: dashboardState.caloriesRemaining,
                ),
                const SizedBox(height: 32), // Increased spacing
                RecentHistory(recentMeals: dashboardState.recentMeals),
                const SizedBox(height: 32), // Increased spacing
                const AddMealButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
