import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'application/di/dependency_injection.dart' as di;
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/state_management/onboarding_notifier.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/datasources/local_user_data_source_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      userRepositoryProvider.overrideWithValue(
        UserRepositoryImpl(
          localDataSource: LocalUserDataSourceImpl(
            sharedPreferences: sharedPreferences,
          ),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bioscope',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}
