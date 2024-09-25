import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/dashboard_top_section.dart';
import '../widgets/recent_history.dart';
import '../screens/onboarding_screen.dart';
import '../widgets/dashboard_bottom_bar.dart';
import 'add_food_entry_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    return userProfileAsyncValue.when(
      data: (userProfile) {
        if (userProfile == null) {
          // If userProfile is null, show a loading indicator and try to refresh the data
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.refresh(userProfileProvider);
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        // If user profile exists, show the dashboard
        return _buildDashboard(context, ref);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text('Error loading user data'))),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref) {
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
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(dashboardNotifierProvider.notifier).refreshDashboard(),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 60.0,
                maxHeight: 200.0,
                child: DashboardTopSection(
                  greeting: dashboardState.greeting,
                  name: dashboardState.userName,
                  caloriesConsumed: dashboardState.caloriesConsumed,
                  dailyCalorieGoal: dashboardState.dailyCalorieGoal,
                  nutritionData: {
                    'Calories': dashboardState.dailyCalorieGoal > 0
                        ? dashboardState.caloriesConsumed /
                            dashboardState.dailyCalorieGoal
                        : 0,
                    'Protein': 0.7, // Replace with actual data
                    'Carbs': 0.5, // Replace with actual data
                    'Fat': 0.3, // Replace with actual data
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: RecentHistory(recentMeals: dashboardState.recentMeals),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DashboardBottomBar(
        onAddMealPressed: () => _navigateToAddFoodEntry(context, ref),
        onHomePressed: () {
          ref.read(dashboardNotifierProvider.notifier).refreshDashboard();
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
