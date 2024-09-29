import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/dashboard_top_section.dart';
import '../widgets/recent_history.dart';
import '../widgets/dashboard_bottom_bar.dart';

import 'add_food_entry_screen.dart';
import 'edit_user_goals_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

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
      body: dashboardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swipe right (previous day)
                  notifier.changeDate(
                    dashboardState.currentDate
                        .subtract(const Duration(days: 1)),
                  );
                } else if (details.primaryVelocity! < 0) {
                  // Swipe left (next day, but not future dates)
                  final nextDate =
                      dashboardState.currentDate.add(const Duration(days: 1));
                  if (nextDate.isBefore(DateTime.now()) ||
                      nextDate.day == DateTime.now().day) {
                    notifier.changeDate(nextDate);
                  }
                }
              },
              child: RefreshIndicator(
                onRefresh: () =>
                    notifier.refreshDashboard(dashboardState.currentDate),
                child: CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      delegate: DashboardHeaderDelegate(
                        DashboardTopSection(
                          greeting: dashboardState.greeting,
                          name: dashboardState.userName,
                          date: dashboardState.currentDate,
                          dailyGoals: dashboardState.dailyGoals,
                        ),
                      ),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: RecentHistory(
                        foodEntries: dashboardState.foodEntries,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: DashboardBottomBar(
        onAddMealPressed: () => _navigateToAddFoodEntry(context, ref),
        onHomePressed: () => notifier.refreshDashboard(DateTime.now()),
        onEditGoalsPressed: () => _navigateToEditNutritionGoals(context),
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
