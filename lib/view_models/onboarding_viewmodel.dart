import 'package:flutter/material.dart';
import 'package:skillhub/models/onboarding_model.dart';
import 'package:skillhub/res/assets_res.dart';

class OnboardingViewModel extends ChangeNotifier {
  final OnboardingModel onboardingModel = const OnboardingModel(
    title: 'Welcome to SkillHub',
    description: 'Your journey to learning starts here.',
    subdescription: 'Create your own study plan. \nStudy according to the study plan, \nand make studying more motivating.',
    svgImagePath: AssetsRes.ONBOARDING_IMAGE,
  );
}