import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/onboarding_notifier.dart';
import '../widgets/custom_button.dart';
import 'dashboard_screen.dart';
import '../providers/providers.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      appBar: AppBar(
        title: const Text('BIOSCOPE'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: onboardingState.when(
            initial: () => _buildNameScreen(context, notifier),
            inProgress: (currentPage, name, goals, dietaryPreferences) {
              switch (currentPage) {
                case 0:
                  return _buildNameScreen(context, notifier, name);
                case 1:
                  return _buildGoalsScreen(context, notifier, goals);
                case 2:
                  return _buildDietaryPreferencesScreen(
                      context, notifier, dietaryPreferences);
                default:
                  return const SizedBox.shrink();
              }
            },
            complete: () => _buildCompletionScreen(context, notifier, ref),
            error: (message) => _buildErrorScreen(context, message, notifier),
          ),
        ),
      ),
    );
  }

  Widget _buildNameScreen(BuildContext context, OnboardingNotifier notifier,
      [String? name]) {
    return ListView(
      children: [
        Text(
          'Welcome to Bioscope',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        _InputCard(
          icon: Icons.person,
          label: 'Your Name',
          child: TextField(
            onChanged: notifier.setName,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        CustomButton(
          onPressed: () {
            if (notifier.canMoveToNextPage()) {
              notifier.nextPage();
            }
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildGoalsScreen(BuildContext context, OnboardingNotifier notifier,
      Map<String, double>? goals) {
    final goalTypes = ['Calories', 'Carbs', 'Proteins', 'Fats', 'Fiber'];
    return ListView(
      children: [
        Text(
          'Set your nutrition goals',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 24),
        ...goalTypes.map((goal) =>
            _buildGoalSlider(context, notifier, goal, goals?[goal] ?? 0.5)),
        const SizedBox(height: 24),
        CustomButton(
          onPressed: () {
            if (notifier.canMoveToNextPage()) {
              notifier.nextPage();
            }
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildGoalSlider(BuildContext context, OnboardingNotifier notifier,
      String goalType, double value) {
    double maxValue;
    double step;
    switch (goalType) {
      case 'Calories':
        maxValue = 4000;
        step = 50;
        break;
      case 'Carbs':
      case 'Proteins':
      case 'Fats':
        maxValue = 300;
        step = 5;
        break;
      case 'Fiber':
        maxValue = 50;
        step = 1;
        break;
      default:
        maxValue = 100;
        step = 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(goalType, style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: maxValue,
                divisions: (maxValue / step).round(),
                label: value.round().toString(),
                onChanged: (newValue) {
                  notifier.setGoal(goalType, newValue);
                },
              ),
            ),
            Text('${value.round()} ${goalType == 'Calories' ? 'kcal' : 'g'}'),
          ],
        ),
      ],
    );
  }

  Widget _buildDietaryPreferencesScreen(BuildContext context,
      OnboardingNotifier notifier, List<String>? dietaryPreferences) {
    final allPreferences = [
      'Vegetarian',
      'Vegan',
      'Gluten-free',
      'Dairy-free',
      'Keto',
      'Paleo'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your preferences',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allPreferences.map((pref) {
            final isSelected = dietaryPreferences?.contains(pref) ?? false;
            return FilterChip(
              label: Text(pref),
              selected: isSelected,
              onSelected: (selected) {
                notifier.toggleDietaryPreference(pref);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: const Color(0xFFED764A),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const Spacer(),
        Consumer(
          builder: (context, ref, child) {
            final isLoading = ref.watch(onboardingProvider).maybeWhen(
                  inProgress: (_, __, ___, ____) => false,
                  orElse: () => true,
                );
            return CustomButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (context.mounted) {
                        await _completeOnboardingAndNavigate(
                            context, notifier, ref);
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Finish'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCompletionScreen(
      BuildContext context, OnboardingNotifier notifier, WidgetRef ref) {
    Navigator.of(context).pop(); // Dismiss the loading indicator
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Onboarding complete!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        CustomButton(
          onPressed: () {
            // Navigate to dashboard
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              );
            }
          },
          child: const Text('Start your journey'),
        ),
      ],
    );
  }

  Widget _buildErrorScreen(
      BuildContext context, String message, OnboardingNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          CustomButton(
            onPressed: () {
              notifier.startOnboarding();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboardingAndNavigate(
      BuildContext context, OnboardingNotifier notifier, WidgetRef ref) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Add a small delay to ensure the loading indicator is visible
      // await Future.delayed(const Duration(milliseconds: 300));

      // Complete onboarding first
      await notifier.completeOnboarding();
    } catch (e) {
      // Dismiss loading indicator if it's showing
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      if (!context.mounted) return;
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing onboarding: $e')),
      );
    }
  }
}

class _InputCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _InputCard({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFED764A), size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
