import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/assets_res.dart';
import '../../view_models/account_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AccountViewModel()..loadUser(),  // Load user on init
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Account',style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: Consumer<AccountViewModel>(
          builder: (context, viewModel, child) {
            final user = viewModel.userModel;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display user avatar
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 0.5), // Optional border
                    ),
                    child: user?.photoUrl != null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl!),
                    )
                        : SvgPicture.asset(AssetsRes.USER), // Fallback to default avatar
                  ),
                  const SizedBox(height: 16),

                  // Display user name
                  Text(
                    user?.displayName ?? 'User', // Default to 'User' if name is not available
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logout button
                  ElevatedButton(
                    onPressed: () async {
                      await viewModel.logout(context);  // Call logout function
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Delete Account button with red background
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Red background for delete account
                    ),
                    onPressed: () async {
                      await viewModel.reauthenticateAndDelete(context);  // Corrected: Call reauthenticateAndDelete
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
