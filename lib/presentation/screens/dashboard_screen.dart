import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/dashboard_top_section.dart';
import '../widgets/recent_history.dart';
import '../widgets/dashboard_bottom_bar.dart';
import 'add_food_entry_screen.dart';
import 'edit_user_goals_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).refreshDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final userProfileState = ref.watch(userProfileProvider);

    print("Dashboard state: $dashboardState"); // Debug print
    print("User profile state: $userProfileState"); // Debug print

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditNutritionGoals(context),
          ),
        ],
      ),
      body: userProfileState.when(
        data: (userProfile) {
          if (userProfile == null) {
            return const Center(child: Text('User profile not found'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(dashboardProvider.notifier).refreshDashboard();
            },
            child: dashboardState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        delegate: DashboardHeaderDelegate(
                          DashboardTopSection(
                            greeting: dashboardState.greeting,
                            name: dashboardState.userName,
                            caloriesConsumed: dashboardState.caloriesConsumed,
                            dailyCalorieGoal: dashboardState.dailyCalorieGoal,
                            nutritionGoals: dashboardState.nutritionGoals,
                          ),
                        ),
                        pinned: true,
                      ),
                      SliverToBoxAdapter(
                        child: RecentHistory(
                            recentMeals: dashboardState.recentMeals),
                      ),
                    ],
                  ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: DashboardBottomBar(
        onAddMealPressed: () => _navigateToAddFoodEntry(context, ref),
        onHomePressed: () {
          ref.read(dashboardProvider.notifier).refreshDashboard();
        },
        onSettingsPressed: () {
          // TODO: Implement settings navigation
        },
      ),
    );
  }

  void _navigateToEditNutritionGoals(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditNutritionGoalsScreen()),
    );
  }

  void _navigateToAddFoodEntry(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFoodEntryScreen()),
    );

    if (result != null) {
      await ref.read(dashboardProvider.notifier).addFoodEntry(result);
    }
  }
}

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  DashboardHeaderDelegate(this.child);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
