import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/onboarding_notifier.dart';
import '../widgets/custom_button.dart';
import 'dashboard_screen.dart';
import '../providers/providers.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: onboardingState.when(
            initial: () =>
                _buildNameAndCalorieScreen(context, notifier, null, null),
            inProgress:
                (currentPage, name, dailyCalorieGoal, dietaryPreferences) {
              switch (currentPage) {
                case 0:
                  return _buildNameAndCalorieScreen(
                      context, notifier, name, dailyCalorieGoal);
                case 1:
                  return _buildDietaryPreferencesScreen(
                      context, notifier, dietaryPreferences);
                default:
                  return const SizedBox.shrink();
              }
            },
            complete: () => _buildCompletionScreen(context, notifier, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildNameAndCalorieScreen(BuildContext context,
      OnboardingNotifier notifier, String? name, int? dailyCalorieGoal) {
    return ListView(
      children: [
        Text(
          'Set your health goals',
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
        const SizedBox(height: 16),
        _InputCard(
          icon: Icons.local_fire_department,
          label: 'Daily Calorie Goal',
          child: TextField(
            onChanged: (value) =>
                notifier.setDailyCalorieGoal(int.tryParse(value) ?? 0),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter your daily calorie goal',
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
                final newPreferences =
                    List<String>.from(dietaryPreferences ?? []);
                if (selected) {
                  newPreferences.add(pref);
                } else {
                  newPreferences.remove(pref);
                }
                notifier.setDietaryPreferences(newPreferences);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.purple[100],
              checkmarkColor: Colors.purple,
            );
          }).toList(),
        ),
        const Spacer(),
        CustomButton(
          onPressed: () async {
            await notifier.completeOnboarding();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            }
          },
          child: const Text('Finish'),
        ),
      ],
    );
  }

  Widget _buildCompletionScreen(
      BuildContext context, OnboardingNotifier notifier, WidgetRef ref) {
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
            _completeOnboardingAndNavigate(context, notifier, ref);
          },
          child: const Text('Start your journey'),
        ),
      ],
    );
  }

  Future<void> _completeOnboardingAndNavigate(
      BuildContext context, OnboardingNotifier notifier, WidgetRef ref) async {
    await notifier.completeOnboarding();
    if (!context.mounted) return;

    final user = await ref.refresh(userProfileProvider.future);
    if (!context.mounted) return;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
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
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.purple, size: 28),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black87,
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
