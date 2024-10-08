import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Add this import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bioscope/presentation/screens/splash_screen.dart';
import 'package:bioscope/application/di/dependency_injection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bioscope/core/utils/logger.dart';

void main() async {
  // Add async keyword here
  // Enable logging for debug mode, disable for release
  if (kDebugMode) {
    Logger.enable();
  } else {
    Logger.disable();
  }

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

ThemeData buildAppTheme() {
  return ThemeData(
    primaryColor: const Color(0xFFFAFAF7),
    scaffoldBackgroundColor: const Color(0xFFFAFAF7),
    fontFamily: 'Manrope',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFF3E0),
      primary: const Color(0xFFFFF3E0),
      secondary: const Color(0xFFED764A),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.90,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAFAF7),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.90,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFBFAF8),
      selectedItemColor: Color(0xFFED764A),
      unselectedItemColor: Color(0xFFA1A1A1),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bioscope',
      theme: buildAppTheme(),
      home: const SplashScreen(), // Change this line
    );
  }
}
