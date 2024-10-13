import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/courses_viewmodel.dart';

class BottomNavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0; // Default to the first tab (Home)

  int get currentIndex => _currentIndex;

  void setIndex(int index, BuildContext context) {
    if (_currentIndex == 1 && index != 1) {
      // If navigating away from the Courses tab (index 1), clear filters
      final coursesViewModel = Provider.of<CoursesViewModel>(context, listen: false);
      coursesViewModel.clearAllFilters();
    }

    _currentIndex = index;
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
