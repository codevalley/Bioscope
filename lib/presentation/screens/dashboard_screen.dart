import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/greeting_section.dart';
import '../widgets/nutrition_meter.dart';
import '../widgets/recent_history.dart';
import '../widgets/add_meal_button.dart';
import '../state_management/dashboard_notifier.dart';
import '../providers/providers.dart';
import 'onboarding_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen>
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
    // Use the result of refresh
    final user = await ref.refresh(userProvider.future);
    if (user != null) {
      await ref.read(dashboardNotifierProvider.notifier).refreshUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE6F3EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: userAsyncValue.when(
            data: (user) => user != null
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GreetingSection(
            greeting: dashboardState.greeting,
            dateInfo: dashboardState.dateInfo,
            caloriesConsumed: dashboardState.caloriesConsumed,
            caloriesRemaining: dashboardState.caloriesRemaining,
            dailyCalorieGoal: dashboardState.dailyCalorieGoal,
          ),
          const SizedBox(height: 32),
          NutritionMeter(
            caloriesConsumed: dashboardState.caloriesConsumed,
            caloriesRemaining: dashboardState.caloriesRemaining,
          ),
          const SizedBox(height: 32),
          RecentHistory(recentMeals: dashboardState.recentMeals),
          const SizedBox(height: 32),
          const AddMealButton(),
        ],
      ),
    );
  }

  Widget _buildOnboardingPrompt(BuildContext context) {
    return Container(
      color: const Color(0xFFE6F3EF),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to Bioscope',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
