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

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(dashboardProvider.notifier).refreshDashboard(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 60.0,
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
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 50.0, // Height of the "Today" row
                maxHeight:
                    200.0, // Total height including greeting and nutrition indicators
                child: (shrinkOffset, height) => DashboardTopSection(
                  greeting: dashboardState.greeting,
                  name: dashboardState.userName,
                  dailyGoals: dashboardState.dailyGoals,
                  date: dashboardState.currentDate,
                  shrinkOffset: shrinkOffset,
                  height: height,
                  hasPreviousDay: dashboardState.hasPreviousDay,
                  hasNextDay: dashboardState.hasNextDay,
                  onPreviousDay: () => ref
                      .read(dashboardProvider.notifier)
                      .navigateToPreviousDay(),
                  onNextDay: () =>
                      ref.read(dashboardProvider.notifier).navigateToNextDay(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: RecentHistory(
                foodEntries: dashboardState.foodEntries,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DashboardBottomBar(
        onAddMealPressed: () => _navigateToAddFoodEntry(context, ref),
        onHomePressed: () =>
            ref.read(dashboardProvider.notifier).refreshDashboard(),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget Function(double shrinkOffset, double height) child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child(shrinkOffset, maxHeight));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
