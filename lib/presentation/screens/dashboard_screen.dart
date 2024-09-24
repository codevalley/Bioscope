import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'add_food_entry_screen.dart';
import 'onboarding_screen.dart';
import '../../domain/entities/food_entry.dart';
import '../widgets/dashboard_top_section.dart';
import '../widgets/recent_history.dart';
import '../widgets/dashboard_bottom_bar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
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
      backgroundColor: Colors.white,
      body: userProfileAsyncValue.when(
        data: (userProfile) => userProfile != null
            ? _buildDashboardContent(context, ref)
            : _buildOnboardingPrompt(context),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading user data')),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: DashboardTopSection(
                      greeting: dashboardState.greeting,
                      name: dashboardState.userName,
                      caloriesConsumed: dashboardState.caloriesConsumed,
                      dailyCalorieGoal: dashboardState.dailyCalorieGoal,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver:
                        RecentHistory(recentMeals: dashboardState.recentMeals),
                  ),
                ],
              ),
            ),
          ),
          DashboardBottomBar(
            onAddMealPressed: () => _navigateToAddFoodEntry(context, ref),
            onAnalyticsPressed: () {
              // TODO: Implement analytics navigation
            },
            onSettingsPressed: () {
              // TODO: Implement settings navigation
            },
          ),
        ],
      ),
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
      // Trigger a rebuild of the dashboard
      setState(() {});
    }
  }
}
