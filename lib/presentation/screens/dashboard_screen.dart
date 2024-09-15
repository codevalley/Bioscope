import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/di/dependency_injection.dart';
import '../widgets/custom_button.dart';
import '../screens/onboarding_screen.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

// Add this provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return getIt<UserRepository>();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: userAsyncValue.when(
            data: (user) => user != null
                ? _buildDashboardContent(context, user)
                : _buildOnboardingPrompt(context),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                const Center(child: Text('Error loading user data')),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, user.name),
        const SizedBox(height: 32),
        _buildProgressChart(user.dailyCalorieGoal),
        const SizedBox(height: 32),
        _buildTaskList(context),
        const Spacer(),
        CustomButton(
          onPressed: () {
            // TODO: Navigate to food capture screen
          },
          child: const Text('Add Meal'),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey, // Placeholder color
          child: Icon(Icons.person, color: Colors.white), // Placeholder icon
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget _buildProgressChart(int dailyCalorieGoal) {
    // TODO: Implement actual progress chart
    return Container(
      height: 200,
      color: Colors.yellow, // Placeholder
      child: Center(child: Text('Progress Chart: $dailyCalorieGoal calories')),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Meals',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        // Placeholder meals
        _buildTaskItem(context, 'Breakfast'),
        _buildTaskItem(context, 'Lunch'),
        _buildTaskItem(context, 'Snack'),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, String meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(meal, style: Theme.of(context).textTheme.bodyLarge),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Bioscope!',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              );
            },
            child: const Text('Start Onboarding'),
          ),
        ],
      ),
    );
  }
}

final userProvider = FutureProvider<User?>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUser();
});
