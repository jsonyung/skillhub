import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillhub/views/login_page.dart';
import 'package:skillhub/views/signup_page.dart';
import '../view_models/onboarding_viewmodel.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    // Now, navigate to the appropriate page (Login/Signup)
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<OnboardingViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  const SizedBox(height: 100),
                  SvgPicture.asset(viewModel.onboardingModel.svgImagePath),
                  const SizedBox(height: 20),
                  Text(
                    viewModel.onboardingModel.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    viewModel.onboardingModel.description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    viewModel.onboardingModel.subdescription,
                    style: const TextStyle(fontSize: 16,color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding around buttons
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0), // Space between buttons
                            child: ElevatedButton(
                              onPressed: () async {
                                // Mark onboarding as complete and navigate to Sign Up
                                await _completeOnboarding(context);
                                if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                                );
                                }
                              },
                              child: const Text('Sign up'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              // Mark onboarding as complete and navigate to Login
                              await _completeOnboarding(context);
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              }
                            },
                            child: const Text('Log in'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
