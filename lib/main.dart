import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'application/di/dependency_injection.dart';
import 'presentation/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bioscope',
      theme: ThemeData(
        primaryColor: const Color(0xFFE6F3EF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFE6F3EF),
          secondary: const Color(0xFFFFD700),
        ),
        scaffoldBackgroundColor: const Color(0xFFE6F3EF),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          headlineMedium: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF333333)),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
