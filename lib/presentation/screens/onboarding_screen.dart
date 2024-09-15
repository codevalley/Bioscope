import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_button.dart';
import '../state_management/onboarding_notifier.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Off-white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: onboardingState.maybeMap(
                  inProgress: (s) => (s.currentPage + 1) / 3,
                  orElse: () => 0,
                ),
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: onboardingState.maybeMap(
                  initial: (_) => const _WelcomeScreen(),
                  inProgress: (s) {
                    switch (s.currentPage) {
                      case 0:
                        return _GoalScreen(
                          name: s.name,
                          dailyCalorieGoal: s.dailyCalorieGoal,
                          onNameChanged: notifier.setName,
                          onCalorieGoalChanged: notifier.setDailyCalorieGoal,
                        );
                      case 1:
                        return _PreferencesScreen(
                          preferences: s.dietaryPreferences ?? [],
                          onPreferencesChanged: notifier.setDietaryPreferences,
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                  complete: (_) => const _CompletionScreen(),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
              if (onboardingState.maybeMap(
                complete: (_) => false,
                orElse: () => true,
              ))
                const SizedBox(height: 16),
              if (onboardingState.maybeMap(
                complete: (_) => false,
                orElse: () => true,
              ))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (onboardingState.maybeMap(
                      inProgress: (s) => s.currentPage > 0,
                      orElse: () => false,
                    ))
                      CustomButton(
                        onPressed: notifier.previousPage,
                        child: const Text('Back'),
                      )
                    else
                      const SizedBox.shrink(),
                    CustomButton(
                      onPressed: onboardingState.maybeMap(
                        initial: (_) => notifier.startOnboarding,
                        inProgress: (s) {
                          return s.currentPage == 1 &&
                                  notifier.canMoveToNextPage()
                              ? notifier.completeOnboarding
                              : notifier.canMoveToNextPage()
                                  ? notifier.nextPage
                                  : null;
                        },
                        orElse: () => null,
                      ),
                      child: Text(
                        onboardingState.maybeMap(
                          initial: (_) => 'Get Started',
                          inProgress: (s) =>
                              s.currentPage == 1 ? 'Finish' : 'Next',
                          orElse: () => '',
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeScreen extends StatelessWidget {
  const _WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome to Bioscope',
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _GoalScreen extends StatelessWidget {
  final String? name;
  final int? dailyCalorieGoal;
  final Function(String) onNameChanged;
  final Function(int) onCalorieGoalChanged;

  const _GoalScreen({
    required this.name,
    required this.dailyCalorieGoal,
    required this.onNameChanged,
    required this.onCalorieGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            onChanged: onNameChanged,
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
                onCalorieGoalChanged(int.tryParse(value) ?? 0),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter your daily calorie goal',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _PreferencesScreen extends StatelessWidget {
  final List<String> preferences;
  final Function(List<String>) onPreferencesChanged;

  const _PreferencesScreen({
    required this.preferences,
    required this.onPreferencesChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            final isSelected = preferences.contains(pref);
            return FilterChip(
              label: Text(pref),
              selected: isSelected,
              onSelected: (selected) {
                final newPreferences = List<String>.from(preferences);
                if (selected) {
                  newPreferences.add(pref);
                } else {
                  newPreferences.remove(pref);
                }
                onPreferencesChanged(newPreferences);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.purple[100],
              checkmarkColor: Colors.purple,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CompletionScreen extends StatelessWidget {
  const _CompletionScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Onboarding Complete!',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        CustomButton(
          onPressed: () {
            // TODO: Navigate to the main app screen
          },
          child: const Text('Start Your Journey'),
        ),
      ],
    );
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
