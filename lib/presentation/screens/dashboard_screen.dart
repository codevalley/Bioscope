import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'add_food_entry_screen.dart';
import 'onboarding_screen.dart';
import '../../domain/entities/food_entry.dart';
import '../widgets/greeting_section.dart';
import '../widgets/nutrition_meter.dart';
import '../widgets/recent_history.dart';
import '../widgets/add_meal_button.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  Future<void> _refreshData() async {
    final userProfile = await ref.refresh(userProfileProvider.future);
    if (userProfile != null) {
      await ref.read(dashboardNotifierProvider.notifier).refreshDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE6F3EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: userProfileAsyncValue.when(
            data: (userProfile) => userProfile != null
                ? _buildDashboardContent(context, ref)
                : _buildOnboardingPrompt(context),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                const Center(child: Text('Error loading user data')),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingSection(
                  greeting: dashboardState.greeting,
                  name: dashboardState.userName,
                  date: DateTime.now(),
                ),
                const SizedBox(height: 32),
                NutritionMeter(
                  caloriesConsumed: dashboardState.caloriesConsumed,
                  caloriesRemaining: dashboardState.caloriesRemaining,
                  dailyCalorieGoal: dashboardState.dailyCalorieGoal,
                ),
                const SizedBox(height: 32),
                RecentHistory(recentMeals: dashboardState.recentMeals),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        AddMealButton(
          onPressed: () => _navigateToAddFoodEntry(context, ref),
        ),
      ],
    );
  }

  Widget _buildOnboardingPrompt(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome to Bioscope',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Your personal health coach',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black54,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Get Started'),
        ),
      ],
    );
  }

  void _navigateToAddFoodEntry(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFoodEntryScreen()),
    );

    if (result != null && result is FoodEntry) {
      await ref.read(dashboardNotifierProvider.notifier).addFoodEntry(result);
    }
  }
}
