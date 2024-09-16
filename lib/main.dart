import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bioscope/presentation/screens/dashboard_screen.dart';
import 'package:bioscope/application/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bioscope',
      theme: ThemeData(
        primaryColor: const Color(0xFFFDBA21), // Yellow primary color
        scaffoldBackgroundColor: Colors.white,
        fontFamily:
            'Poppins', // You can replace this with a clean sans-serif font
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          headlineLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFFDBA21), // Yellow accent color
          secondary: Colors.black, // Black text and icons
          onPrimary: Colors.white, // White on primary elements
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          buttonColor: Colors.black,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
