import 'package:flutter/material.dart';
import 'package:skillhub/models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      _user = await _authService.signUpWithEmail(email, password);
      notifyListeners();
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      _user = await _authService.loginWithEmail(email, password);
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _user = await _authService.signInWithGoogle();
      notifyListeners();
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      _user = await _authService.signInWithFacebook();
      notifyListeners();
    } catch (e) {
      throw Exception('Facebook Sign-In failed: $e');
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
