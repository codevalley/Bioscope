import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/onboarding_notifier.dart';
import '../widgets/custom_button.dart';
import 'dashboard_screen.dart';
import '../providers/providers.dart';
import '../state_management/onboarding_state.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            initial: () => const Center(child: CircularProgressIndicator()),
            inProgress:
                (isNewUser, emailVerificationStatus, name, goals, isLoading) {
              if (isNewUser) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: emailVerificationStatus ==
                          EmailVerificationStatus.verified
                      ? _buildNameAndGoalsSection(
                          context, notifier, name, goals, isLoading)
                      : _buildWelcomeSection(context, notifier,
                          emailVerificationStatus, isLoading),
                );
              } else {
                return _buildExistingUserFlow(
                    context, notifier, name, isLoading);
              }
            },
            complete: () => _navigateToDashboard(context),
            error: (message) => _buildErrorScreen(context, message, notifier),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, OnboardingNotifier notifier,
      EmailVerificationStatus status, bool isLoading) {
    final isAwaitingOtp = status == EmailVerificationStatus.awaitingOtp;

    return ListView(
      children: [
        const SizedBox(height: 48),
        Text(
          'Join Bioscope',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          isAwaitingOtp
              ? 'Enter the magic code sent to your email.'
              : 'Link your email to setup a multi-device account or to login to an existing account.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Your personal email',
            border: const OutlineInputBorder(),
            enabled: !isAwaitingOtp,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        if (isAwaitingOtp) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _otpController,
            decoration: const InputDecoration(
              hintText: 'Enter magic code',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
        const SizedBox(height: 16),
        CustomButton(
          onPressed: isLoading ? null : (isAwaitingOtp ? _verifyOtp : _sendOtp),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(isAwaitingOtp ? 'Verify Magic Code' : 'Send Magic Code'),
        ),
        const SizedBox(height: 24),
        const Divider(thickness: 1),
        const SizedBox(height: 24),
        CustomButton(
          onPressed: () => notifier.skipEmailVerification(),
          style: CustomButton.outlinedStyle,
          child: const Text('Set up a local account'),
        ),
      ],
    );
  }

  Widget _buildNameAndGoalsSection(
      BuildContext context,
      OnboardingNotifier notifier,
      String? name,
      Map<String, double>? goals,
      bool isLoading) {
    return ListView(
      children: [
        Text(
          'Set Up Your Profile',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
        Text(
          'Set your nutrition goals',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ..._buildGoalSliders(context, notifier, goals),
        const SizedBox(height: 24),
        CustomButton(
          onPressed: isLoading ? null : () => notifier.completeOnboarding(),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Complete'),
        ),
      ],
    );
  }

  Widget _buildExistingUserFlow(BuildContext context,
      OnboardingNotifier notifier, String? name, bool isLoading) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome back, ${name ?? 'User'}!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          CustomButton(
            onPressed: isLoading ? null : () => notifier.completeOnboarding(),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Continue to Dashboard'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGoalSliders(BuildContext context,
      OnboardingNotifier notifier, Map<String, double>? goals) {
    final goalTypes = ['Calories', 'Carbs', 'Proteins', 'Fats', 'Fiber'];
    return goalTypes
        .map((goal) =>
            _buildGoalSlider(context, notifier, goal, goals?[goal] ?? 0.5))
        .toList();
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

  Widget _navigateToDashboard(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    });
    return const SizedBox.shrink();
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      await ref.read(onboardingProvider.notifier).startEmailVerification(email);
    }
  }

  Future<void> _verifyOtp() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    if (email.isNotEmpty && otp.isNotEmpty) {
      final success =
          await ref.read(onboardingProvider.notifier).verifyOtp(email, otp);
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid code. Please try again.')),
          );
        }
        _otpController.clear();
      }
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
