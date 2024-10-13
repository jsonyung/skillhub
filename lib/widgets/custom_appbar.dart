import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? description; // Optional description

  const CustomAppBar({
    super.key,
    required this.title,
    this.description, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // To remove the default back button
      backgroundColor: Colors.transparent, // AppBar background color
      elevation: 0, // Remove shadow
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 70.0, left: 20), // Space from the top
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Title color
              ),
            ),
            const SizedBox(height: 2), // Space between title and description
            if (description != null) // Conditionally render the description
              Text(
                description!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey, // Description color
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120.0); // Set height of the AppBar
}
