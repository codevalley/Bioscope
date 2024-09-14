import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_button.dart';
import '../state_management/onboarding_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider.notifier).startOnboarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  ref.read(onboardingProvider.notifier).nextPage();
                },
                children: const [
                  WelcomePage(),
                  GoalSettingPage(),
                  PreferencesPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (onboardingState.maybeMap(
                    inProgress: (s) => s.currentPage > 0,
                    orElse: () => false,
                  ))
                    CustomButton(
                      text: 'Back',
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        ref.read(onboardingProvider.notifier).previousPage();
                      },
                      isSecondary: true,
                    )
                  else
                    const SizedBox(width: 100),
                  CustomButton(
                    text: onboardingState.maybeMap(
                      inProgress: (s) => s.currentPage == 2 ? 'Finish' : 'Next',
                      orElse: () => 'Next',
                    ),
                    onPressed: () {
                      onboardingState.maybeMap(
                        inProgress: (s) {
                          if (s.currentPage < 2) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            ref
                                .read(onboardingProvider.notifier)
                                .completeOnboarding();
                            // TODO: Navigate to the main app screen
                          }
                        },
                        orElse: () {},
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Bioscope',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your personal health oracle',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

class GoalSettingPage extends StatelessWidget {
  const GoalSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Set your health goals',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Choose your preferences',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
