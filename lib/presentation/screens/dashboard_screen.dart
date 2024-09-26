import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/dashboard_top_section.dart';
import '../widgets/recent_history.dart';
import '../widgets/dashboard_bottom_bar.dart';
import 'add_food_entry_screen.dart';
import 'edit_user_goals_screen.dart';
import '../state_management/dashboard_state.dart';
import 'package:bioscope/domain/entities/user_profile.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

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
      body: userProfileAsync.when(
        data: (userProfile) {
          if (userProfile == null) {
            return const Center(
                child:
                    Text('No user profile found. Please complete onboarding.'));
          }
          return _buildDashboardContent(
              context, ref, dashboardState, userProfile);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading user data: $error'),
              ElevatedButton(
                onPressed: () {
                  ref.read(userProfileProvider.notifier).refreshUserProfile();
                  ref
                      .read(dashboardNotifierProvider.notifier)
                      .refreshDashboard();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomBar(
        onAddMealPressed: () => _navigateToAddFoodEntry(context, ref),
        onHomePressed: () {
          ref.read(userProfileProvider.notifier).refreshUserProfile();
          ref.read(dashboardNotifierProvider.notifier).refreshDashboard();
        },
        onSettingsPressed: () {
          // TODO: Implement settings navigation
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, WidgetRef ref,
      DashboardState dashboardState, UserProfile userProfile) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(userProfileProvider.notifier).refreshUserProfile();
        await ref.read(dashboardNotifierProvider.notifier).refreshDashboard();
      },
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 60.0,
              maxHeight: 200.0,
              child: DashboardTopSection(
                greeting: dashboardState.greeting,
                name: userProfile.name,
                caloriesConsumed: dashboardState.caloriesConsumed,
                dailyCalorieGoal: dashboardState.dailyCalorieGoal,
                nutritionGoals: dashboardState.nutritionGoals,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: RecentHistory(recentMeals: dashboardState.recentMeals),
          ),
        ],
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
