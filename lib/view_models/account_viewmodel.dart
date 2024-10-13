import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../views/login_page.dart';  // Import your login page

class AccountViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  User? _firebaseUser;

  UserModel? get userModel => _userModel;

  // Load the user details from the auth service
  Future<void> loadUser() async {
    final userModel = _authService.getCurrentUser();
    _firebaseUser = _authService.getFirebaseUser(); // Get the Firebase User directly

    if (userModel != null) {
      _userModel = userModel;
    } else {
      _userModel = null;  // No user is logged in
    }
    notifyListeners();
  }

  // Reauthenticate and delete account
// Reauthenticate and delete account
  Future<void> reauthenticateAndDelete(BuildContext context) async {
    try {
      if (_firebaseUser == null) return;

      // Check the providerId to determine the login method
      final providerId = _firebaseUser!.providerData.isNotEmpty
          ? _firebaseUser!.providerData.first.providerId
          : 'password'; // Default to 'password' if not found

      bool reauthenticated = false; // Flag to check reauthentication status

      if (providerId == 'password') {
        // If user logged in with email/password, show dialog to enter password
        reauthenticated = await _showReauthenticationDialog(context, _firebaseUser!.email!);
      } else if (providerId == 'google.com') {
        await _authService.reauthenticateWithGoogle();
        reauthenticated = true;
      } else if (providerId == 'facebook.com') {
        await _authService.reauthenticateWithFacebook();
        reauthenticated = true;
      }

      // Only proceed to delete the account if reauthentication was successful
      if (reauthenticated) {
        await _authService.deleteAccount();

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'Reauthentication canceled.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting account: $e');
    }
  }

// Show a dialog to enter the password for reauthentication
  Future<bool> _showReauthenticationDialog(BuildContext context, String email) async {
    final TextEditingController passwordController = TextEditingController();
    bool isPasswordVisible = false; // Local state for password visibility

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Reauthenticate to Delete Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,  // Control visibility with local state
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(color: Colors.grey, fontStyle: FontStyle.normal),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;  // Toggle visibility state
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: <Widget>[
                // Cancel Button
                TextButton(
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop(false);  // Return false when canceled
                  },
                ),
                // Confirm Button
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    final password = passwordController.text;
                    if (password.isNotEmpty) {
                      try {
                        await _authService.reauthenticateWithEmail(email, password);
                        if (!context.mounted) return; // Check if the widget is still mounted
                        Navigator.of(context).pop(true);  // Return true on success
                      } catch (e) {
                        if (!context.mounted) return; // Check if the widget is still mounted
                        Fluttertoast.showToast(msg: 'Invalid password or reauthentication failed');
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Password cannot be empty');
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    // If the dialog is dismissed, result will be null. So return false in that case.
    return result ?? false;
  }




  // Logout the user and navigate to the login screen
  Future<void> logout(BuildContext context) async {
    await _authService.signOut();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }
}
