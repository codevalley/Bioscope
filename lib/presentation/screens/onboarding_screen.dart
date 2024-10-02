import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/onboarding_notifier.dart';
import '../widgets/custom_button.dart';
import 'dashboard_screen.dart';
import '../providers/providers.dart';
import '../state_management/onboarding_state.dart';

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
            inProgress: (currentPage, name, emailVerificationStatus, goals) {
              switch (currentPage) {
                case 0:
                  return _buildNameScreen(
                      context, notifier, name, emailVerificationStatus);
                case 1:
                  return _buildGoalsScreen(context, notifier, goals);
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
      [String? name, EmailVerificationStatus? emailVerificationStatus]) {
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
        if (emailVerificationStatus != EmailVerificationStatus.verified)
          CustomButton(
            onPressed: () =>
                _showEmailVerificationBottomSheet(context, notifier),
            child: const Text('Verify Email'),
          )
        else
          Text('Email verified', style: Theme.of(context).textTheme.bodyLarge),
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
              notifier.completeOnboarding();
            }
          },
          child: const Text('Complete'),
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
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (route) => false,
            );
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

  void _showEmailVerificationBottomSheet(
      BuildContext context, OnboardingNotifier notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EmailVerificationBottomSheet(notifier: notifier);
      },
    );
  }
}

class EmailVerificationBottomSheet extends StatefulWidget {
  final OnboardingNotifier notifier;

  const EmailVerificationBottomSheet({Key? key, required this.notifier})
      : super(key: key);

  @override
  _EmailVerificationBottomSheetState createState() =>
      _EmailVerificationBottomSheetState();
}

class _EmailVerificationBottomSheetState
    extends State<EmailVerificationBottomSheet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isEmailSent ? 'Enter OTP' : 'Enter your email',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (!_isEmailSent)
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            )
          else
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                hintText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          const SizedBox(height: 16),
          CustomButton(
            onPressed: _isEmailSent ? _verifyOtp : _sendOtp,
            child: Text(_isEmailSent ? 'Verify OTP' : 'Send OTP'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      await widget.notifier.startEmailVerification(email);
      setState(() {
        _isEmailSent = true;
      });
    }
  }

  void _verifyOtp() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    if (email.isNotEmpty && otp.isNotEmpty) {
      await widget.notifier.verifyOtp(email, otp);
      Navigator.of(context).pop();
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
