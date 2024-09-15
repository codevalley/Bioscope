import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_button.dart';
import '../screens/onboarding_screen.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

// Add this provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  throw UnimplementedError();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Off-white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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

  Widget _buildDashboardContent(BuildContext context, User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGreeting(user?.name ?? 'User'),
        _buildCalorieGoal(user?.dailyCalorieGoal),
        const SizedBox(height: 24),
        _buildNutritionMeter(),
        const SizedBox(height: 24),
        _buildRecentHistory(),
        const Spacer(),
        _buildAddMealButton(),
      ],
    );
  }

  Widget _buildOnboardingPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to Bioscope!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

  Widget _buildGreeting(String name) {
    return Text(
      'Good morning, $name!',
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCalorieGoal(int? dailyCalorieGoal) {
    return Text(
      'Today\'s goal: ${dailyCalorieGoal ?? 0} calories',
      style: const TextStyle(
        fontSize: 18,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildNutritionMeter() {
    // TODO: Implement circular progress indicator for nutrition meter
    return const Placeholder(
      fallbackHeight: 200,
      child: Center(child: Text('Nutrition Meter Placeholder')),
    );
  }

  Widget _buildRecentHistory() {
    // TODO: Implement list of recent meals
    return const Placeholder(
      fallbackHeight: 200,
      child: Center(child: Text('Recent History Placeholder')),
    );
  }

  Widget _buildAddMealButton() {
    return CustomButton(
      onPressed: () {
        // TODO: Navigate to food capture screen
      },
      child: const Text('Add Meal'),
    );
  }
}

final userProvider = FutureProvider<User?>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUser();
});
