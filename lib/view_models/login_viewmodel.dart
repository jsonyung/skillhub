import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Use LoginModel to encapsulate email/password fields
  final  _loginModel = LoginModel(email: '', password: '');
  bool isPasswordVisible = false;
  UserModel? _user;

  UserModel? get user => _user;

  String get email => _loginModel.email;
  String get password => _loginModel.password;

  set email(String value) {
    _loginModel.email = value;
    notifyListeners();
  }

  set password(String value) {
    _loginModel.password = value;
    notifyListeners();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  // Helper function to show toast messages
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Login with Email
  Future<void> login() async {
    if (_loginModel.email.isEmpty || _loginModel.password.isEmpty) {
      _showToast('Email and password cannot be empty');
      return;
    }

    try {
      _user = await _authService.loginWithEmail(_loginModel.email, _loginModel.password);
      _showToast('Login successful');
      notifyListeners();
    } catch (e) {
      _showToast('Login failed: $e');
    }
  }

  // Google Sign-In
  Future<void> loginWithGoogle() async {
    try {
      _user = await _authService.signInWithGoogle();
      _showToast('Google Sign-In successful');
      notifyListeners();
    } catch (e) {
      _showToast('Google Sign-In failed: $e');
    }
  }

  // Facebook Sign-In
  Future<void> loginWithFacebook() async {
    try {
      _user = await _authService.signInWithFacebook();
      _showToast('Facebook Sign-In successful');
      notifyListeners();
    } catch (e) {
      _showToast('Facebook Sign-In failed: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _showToast('Logged out successfully');
    notifyListeners();
  }
}
