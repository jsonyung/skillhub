import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillhub/widgets/custom_appbar.dart';
import '../view_models/signup_viewmodel.dart';
import '../widgets/success_dialog.dart';
import 'home_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
          backgroundColor: const Color.fromARGB(255, 240, 240, 242),
        appBar:  const CustomAppBar(title: 'Sign Up',description: 'Enter your details below & free sign up',),
        body: SafeArea(
          child: Consumer<SignUpViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white, // Background color for the body
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20), // Rounded corner at the top left
                          topRight: Radius.circular(20), // Rounded corner at the top right
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
                                onChanged: (value) => viewModel.signUpModel.email = value,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  hintStyle: const TextStyle(color: Colors.grey,fontStyle: FontStyle.normal),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Colors.grey,width: 0.5),
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
                                onChanged: (value) => viewModel.signUpModel.password = value,
                                obscureText: !viewModel.isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(color: Colors.grey,fontStyle: FontStyle.normal),
                                  suffixIcon: IconButton(
                                    icon: Icon(viewModel.isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: viewModel.togglePasswordVisibility,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Colors.grey,width: 0.5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Checkbox for Terms and Conditions
                              Row(
                                children: [
                                  Checkbox(
                                    value: viewModel.signUpModel.isAgreedToTerms,
                                    onChanged: viewModel.toggleAgreedToTerms,
                                    side: const BorderSide(
                                      color: Colors.grey, // Set the border color to grey
                                      width: 1.5, // Set the border thickness (optional)
                                    ),
                                    activeColor: Colors.blue, // Color of the checkbox when checked
                                    checkColor: Colors.white, // Color of the checkmark inside the checkbox
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'By creating an account, you agree \nwith our terms & conditions.',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity, // Makes the button expand horizontally
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Call signup function and show success dialog
                                    await viewModel.signUp();
                                    if (viewModel.user != null && context.mounted) {
                                      _showSuccessDialog(context);
                                    }
                                  },
                                  child: const Text('Create Account'),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Already have an account message
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.grey, // Grey color for this text
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context); // Navigate back to login page
                                    },
                                    child: const Text(
                                      'Log in',
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: 'Success',
          description: 'You have successfully signed up!',
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
