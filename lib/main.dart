import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillhub/view_models/courses_viewmodel.dart';
import 'package:skillhub/views/home_page.dart';
import 'package:skillhub/views/login_page.dart';
import 'package:skillhub/views/onboarding_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoursesViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showOnboarding = true;
  bool _isUserSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Check SharedPreferences for onboarding completion
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    // Check if a user is signed in
    final currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      _showOnboarding = !hasSeenOnboarding;
      _isUserSignedIn = currentUser != null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Filled button background color
            foregroundColor: Colors.white, // Filled button text color
            padding: const EdgeInsets.symmetric(vertical: 12), // Increased vertical padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Low radius for filled button
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent, // Transparent background
            foregroundColor: Colors.blue, // Outlined button text color
            side: const BorderSide(color: Colors.blue), // Blue border
            padding: const EdgeInsets.symmetric(vertical: 12), // Increased vertical padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Low radius for outlined button
            ),
          ),
        ),
      ),
      home: _showOnboarding
          ? const OnboardingPage()
          : (_isUserSignedIn ?  HomePage() : const LoginPage()),
    );
  }
}
