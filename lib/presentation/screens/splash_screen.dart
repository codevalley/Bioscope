import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'welcome_screen.dart';
import 'dashboard_screen.dart';
import '../providers/providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _checkUserStatus(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => snapshot.data == true
                    ? const DashboardScreen()
                    : const WelcomeScreen(),
              ),
            );
          });
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<bool> _checkUserStatus(WidgetRef ref) async {
    final userProfile = await ref.read(userProfileProvider.future);
    return userProfile != null;
  }
}
