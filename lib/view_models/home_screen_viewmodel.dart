import 'package:flutter/material.dart';
import 'package:skillhub/res/assets_res.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  // Getter for current user data
  UserModel? get currentUser => _currentUser;

  // Fetch user data when the HomeViewModel is initialized
  Future<void> loadUserData() async {
    _currentUser = _authService.getCurrentUser();
    notifyListeners(); // Notify UI of data changes
  }

  // Learning progress data
  int learnedMinutes = 46;
  int totalMinutes = 60;

  // Cards in the horizontal list
  final List<Map<String, dynamic>> learningCards = [
    {"title": "What do you want to learn today?", "buttonText": "Get Started", "svgImage": AssetsRes.TODAY},
    {"title": "Explore Courses", "buttonText": "Discover", "svgImage": AssetsRes.TODAY2},
  ];

  // Circular progress bar data for learning plan
  final List<Map<String, dynamic>> learningPlans = [
    {"title": "Packaging Design", "completed": 40, "total": 48},
    {"title": "Product Design", "completed": 6, "total": 24},
  ];

  // Getter for progress
  double get learningProgress => learnedMinutes / totalMinutes;
  String get learningProgressText => "$learnedMinutes / $totalMinutes";

  // Getter for learning plan
  List<Map<String, dynamic>> get plans => learningPlans;
}
