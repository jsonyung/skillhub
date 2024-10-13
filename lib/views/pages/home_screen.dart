import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../res/assets_res.dart';
import '../../view_models/home_screen_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = HomeViewModel();
      viewModel.loadUserData(); // Load user data on initialization
      return viewModel;},
      child: Scaffold(
        //backgroundColor: Colors.white.withOpacity(0.96),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Blue Background Header
              Stack(
                children: [
                  Container(
                    height: 210,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4D5DFB), // Blue background
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        // Greeting and Profile Picture
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Greeting based on user information
                            Consumer<HomeViewModel>(
                              builder: (context, viewModel, child) {
                                final user = viewModel.currentUser;
                                final userName = user?.displayName ?? 'User';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hi, $userName',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "Let's start learning",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            // Profile Picture or Default User Icon
                            Consumer<HomeViewModel>(
                              builder: (context, viewModel, child) {
                                final user = viewModel.currentUser;
                                final photoUrl = user?.photoUrl;

                                return Container(
                                  height: 48,
                                  width: 48,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: photoUrl != null
                                        ? CachedNetworkImage(
                                      imageUrl: photoUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => SvgPicture.asset(AssetsRes.USER),
                                    )
                                        : SvgPicture.asset(AssetsRes.USER), // Default user icon
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Progress Bar Section
                        // Progress Bar Section with height constraint of 100px
                    Container(
                      padding: const EdgeInsets.only(left: 14,right: 14,bottom: 16), // Remove vertical padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 4,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Consumer<HomeViewModel>(
                        builder: (context, viewModel, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure spacing fits the height
                            children: [
                              // Top Row with 'Learned Today' and 'My courses'
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Learned today',
                                    style: TextStyle(
                                      fontSize: 14, // Slightly reduce font size
                                      color: Colors.grey, // Light gray text
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                     // padding: EdgeInsets.zero, // Remove default padding of TextButton
                                      minimumSize: const Size(50, 20), // Optional: Adjust the size
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'My Courses',
                                      style: TextStyle(
                                        color: Color(0xFF4D5DFB), // Blue color for the link
                                        fontSize: 12, // Reduce font size
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Bold Text for the learning progress using ViewModel
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${viewModel.learnedMinutes}min',
                                    style: const TextStyle(
                                      fontSize: 24, // Reduce font size slightly
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Dark text
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '/ ${viewModel.totalMinutes}min',
                                    style: const TextStyle(
                                      fontSize: 14, // Reduce font size slightly
                                      color: Colors.grey, // Light gray text for the total time
                                    ),
                                  ),
                                ],
                              ),

                              // Linear Gradient Progress Bar with grey background for remaining progress
                              Container(
                                height: 6, // Smaller height for the progress bar
                                decoration: BoxDecoration(
                                  color: Colors.grey[300], // Grey background for the entire bar (remaining progress)
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Stack(
                                  children: [
                                    // Progress Bar: Orange gradient for the completed part
                                    Align(
                                      alignment: Alignment.centerLeft, // Align to the start (left)
                                      child: FractionallySizedBox(
                                        widthFactor: viewModel.learningProgress, // Completed portion based on progress
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFFFFA726), Color(0xFFFF5722)], // Gradient color from light to dark orange
                                            ),
                                            borderRadius: BorderRadius.circular(4), // Rounded corners for progress bar
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),



                    ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Horizontal Card List with Padding and No Shadow
              Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 180, // Adjust card height
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.learningCards.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final card = viewModel.learningCards[index];

                          return Container(
                            width: 260, // Adjust card width
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F5FF), // Light blue background
                              borderRadius: BorderRadius.circular(16), // Rounded corners
                              // No shadow here since you requested to remove it
                            ),
                            child: Stack(
                              children: [
                                // SVG Background Image
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16), // Rounded corners for SVG background
                                    child: SvgPicture.asset(
                                      card['svgImage'], // SVG background
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.bottomRight, // Align the image to the bottom right corner
                                    ),
                                  ),
                                ),

                                // Card Content (Text and Button) overlaid on SVG background
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title Text
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          card['title'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black, // Dark text color
                                          ),
                                        ),
                                      ),
                                      const Spacer(), // Pushes button to the bottom
                                      // Button
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(10),
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.orange, // Button text color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Rounded button
                                          ),
                                        ),
                                        child: Text(card['buttonText']),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Learning Plan Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16), // Horizontal padding for the text
                child: Align(
                  alignment: Alignment.centerLeft, // Ensures the text is aligned to the start
                  child: Text(
                    'Learning Plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              //const SizedBox(height: 16),

          Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: viewModel.plans.map((plan) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16), // Space between each row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Circular Progress Bar
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24, // Adjust size as needed
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        value: plan['completed'] / plan['total'], // Progress
                                        backgroundColor: const Color(0xFFE0E0E0), // Light grey for uncompleted part
                                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5A5A5A)), // Blue progress
                                        strokeWidth: 4.0, // Adjust stroke width to match the design
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12), // Space between progress bar and text
                                // Plan Title
                                Text(
                                  plan['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            // Completed/Total tasks
                            // Completed / Total tasks
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${plan['completed']}", // Darker color for completed count
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold, // Bold for completed count
                                      color: Colors.black87, // Dark text for completed number
                                    ),
                                  ),
                                  TextSpan(
                                    text: " / ${plan['total']}", // Lighter color for total count
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[400], // Lighter grey for total number
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
              const SizedBox(height: 20),

              // Meetup Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF), // Light purple background color
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center align content vertically
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Meetup',
                              style: TextStyle(
                                fontSize: 32,
                                color: Color(0xFF6A0DAD), // Dark purple text color
                              ),
                            ),
                            SizedBox(height: 4), // Small spacing between title and subtitle
                            Text(
                              'Off-line exchange of learning experiences',
                              style: TextStyle(
                                fontSize: 14,
                                color:  Color(0xFF6A0DAD), // Light grey text for subtitle
                              ),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        AssetsRes.MEETUP, // Use the SVG path from AssetsRes
                        height: 90, // Adjust image size
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
