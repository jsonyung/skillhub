import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skillhub/models/user_model.dart';
import '../models/signup_model.dart';
import '../services/auth_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Use SignUpModel to encapsulate email, password, and terms agreement
  SignUpModel signUpModel = SignUpModel(email: '', password: '');

  bool isPasswordVisible = false;
  UserModel? _user;

  UserModel? get user => _user;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleAgreedToTerms(bool? value) {
    signUpModel.isAgreedToTerms = value ?? false;
    notifyListeners();
  }

  // Show toast messages
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Sign up with email and password
  Future<void> signUp() async {
    if (!signUpModel.isValid()) {
      _showToast("Please fill in all fields and agree to the terms");
      return;
    }

    try {
      _user = await _authService.signUpWithEmail(signUpModel.email, signUpModel.password);
      if (_user != null) {
        _showToast("Sign up successful");
      }
      notifyListeners();
    } catch (e) {
      _showToast("Sign up failed: $e");
    }
  }
}
