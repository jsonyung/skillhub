import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../res/assets_res.dart';
import '../view_models/bottom_nav_viewmodel.dart';
import 'package:skillhub/views/pages/account_screen.dart';
import 'package:skillhub/views/pages/courses_screen.dart';
import 'package:skillhub/views/pages/home_screen.dart';
import 'package:skillhub/views/pages/message_screen.dart';
import 'package:skillhub/views/pages/search_screen.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
  // GlobalKey for the CoursesScreen state to manage focus from outside
  final GlobalKey<CoursesScreenState> _coursesScreenKey = GlobalKey<CoursesScreenState>();

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is open
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return ChangeNotifierProvider(
      create: (_) => BottomNavigationViewModel(),
      child: Consumer<BottomNavigationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            //resizeToAvoidBottomInset: false,
            backgroundColor: Colors.blueAccent,
            body: _getScreen(viewModel.currentIndex),
            // Display selected screen

            floatingActionButton:isKeyboardOpen
                ? null // Hide the floating action button if the keyboard is open
                : Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  // Set index to 1 (CoursesScreen) and focus the search bar
                  viewModel.setIndex(1, context);
                  // Ensure search bar is focused after the screen is built
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_coursesScreenKey.currentState != null) {
                      _coursesScreenKey.currentState!.focusSearchBar(); // Focus the search bar after the frame is rendered
                    }
                  });
                 // viewModel.setIndex(2, context); // Pass context here
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.white,
                  ),
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 247, 255),
                      border: Border.all(color: Colors.white, width: 10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search,
                      size: 30,
                      color: viewModel.currentIndex == 2
                          ? Colors.blue
                          : Colors.grey.withOpacity(
                              0.3),
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomNavItem(AssetsRes.HOME, 'Home', 0, viewModel, context),
                    _buildBottomNavItem(AssetsRes.COURSES, 'Courses', 1, viewModel, context),
                    _buildSearchNavItem(viewModel, context),
                    _buildBottomNavItem(AssetsRes.MESSAGE, 'Messages', 3, viewModel, context),
                    _buildBottomNavItem(AssetsRes.ACCOUNT, 'Account', 4, viewModel, context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


// Custom method for the search tab
  Widget _buildSearchNavItem(BottomNavigationViewModel viewModel, BuildContext context) {
    bool isSelected =
        viewModel.currentIndex == 2;

    return GestureDetector(
      onTap: () {
        viewModel.setIndex(2, context); // Pass context here
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: isSelected
                ? Colors.blue
                : const Color.fromARGB(255, 245, 247, 255),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Search',
              style: TextStyle(
                color: isSelected
                    ? Colors.blue
                    : const Color.fromARGB(255, 184, 184, 210),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build bottom navigation items
  Widget _buildBottomNavItem(
      String assetPath, String label, int index, BottomNavigationViewModel viewModel, BuildContext context) {
    bool isSelected = viewModel.currentIndex == index;

    return GestureDetector(
      onTap: () {
        viewModel.setIndex(index, context); // Pass context here
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          if (isSelected)
            Positioned(
              top: -18,
              child: Container(
                height: 3,
                width: 30,
                color: Colors.blue,
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                assetPath,
                color: isSelected
                    ? Colors.blue
                    : const Color.fromARGB(255, 245, 247, 255),
                height: 24,
                width: 24,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.blue
                      : const Color.fromARGB(255, 184, 184, 210),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to display the correct page based on the selected tab
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return CoursesScreen(key: _coursesScreenKey);
      case 2:
        return const SearchScreen();
      case 3:
        return const MessageScreen();
      case 4:
        return const AccountScreen();
      default:
        return const HomeScreen();
    }
  }

}
