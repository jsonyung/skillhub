import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skillhub/views/home_page.dart';
import 'package:skillhub/views/signup_page.dart';
import '../res/assets_res.dart';
import '../view_models/login_viewmodel.dart';
import '../widgets/custom_appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/success_dialog.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(), // Initialize ViewModel
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 242),
        appBar:  const CustomAppBar(title: 'Log In',),
        body: SafeArea(
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Email',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                onChanged: (value) => viewModel.email = value, // Binds email input
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontStyle: FontStyle.normal),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                    const BorderSide(color: Colors.grey, width: 0.5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Password',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                onChanged: (value) => viewModel.password = value, // Binds password input
                                obscureText: !viewModel.isPasswordVisible, // Controls visibility
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontStyle: FontStyle.normal),
                                  suffixIcon: IconButton(
                                    icon: Icon(viewModel.isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: viewModel.togglePasswordVisibility, // Toggles visibility
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                    const BorderSide(color: Colors.grey, width: 0.5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Forgot Password Link
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to Forgot Password screen
                                  },
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Call login function and show success dialog
                                    await viewModel.login();
                                    // Check if the widget is still mounted before showing the dialog
                                    if (context.mounted && viewModel.user != null) {
                                      showSuccessDialog(context);
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: Colors.grey, // Grey color for this text
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                                      );
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.blue,                   // Blue color for "Login"
                                        fontWeight: FontWeight.bold,          // Bold font
                                        decoration: TextDecoration.underline, // Underline "Login"
                                        decorationColor: Colors.blue,         // Blue underline color
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Divider with text "or login with"
                               const Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Or login with',style: TextStyle(color: Colors.grey),),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Social login buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40, // Adjust the size of the CircleAvatar (default is 20)
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                        AssetsRes.GOOGLE_LOGO,
                                        height: 40, // Adjust the height of the icon
                                        width: 40,  // Adjust the width of the icon
                                      ),
                                      iconSize: 40, // This adjusts the size of the IconButton
                                      onPressed: () async {
                                        await viewModel.loginWithGoogle();
                                        // Check if the widget is still mounted before showing the dialog
                                        if (context.mounted && viewModel.user != null) {
                                          showSuccessDialog(context);
                                        }
                                      },
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40, // Adjust the size of the CircleAvatar
                                    child: IconButton(
                                      icon: const FaIcon(
                                        FontAwesomeIcons.facebook,
                                        color: Colors.blue,
                                      ),
                                      iconSize: 40, // Adjust the size of the Facebook icon
                                      onPressed: () async {
                                        await viewModel.loginWithFacebook();
                                        // Check if the widget is still mounted before showing the dialog
                                        if (context.mounted && viewModel.user != null) {
                                          showSuccessDialog(context);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }



  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: 'Success',
          description: 'Login successful!',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  HomePage()),
            );
          },
        );
      },
    );
  }

}
