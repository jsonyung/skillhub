import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Get the currently logged-in Firebase user
  User? getFirebaseUser() {
    return _auth.currentUser; // Firebase User object
  }

  // Get the currently logged-in user as UserModel
  UserModel? getCurrentUser() {
    final User? user = _auth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null; // No user is currently logged in
  }

  // Email/Password SignUp
  Future<UserModel?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw Exception('Error in signing up with email: $e');
    }
  }

  // Email/Password Login
  Future<UserModel?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw Exception('Error in logging in with email: $e');
    }
  }

  // Google SignIn
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  // Facebook SignIn
  Future<UserModel?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        // Use accessToken.token instead of accessToken directly
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken!.tokenString);

        UserCredential userCredential = await _auth.signInWithCredential(credential);
        return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        //print('Facebook login failed: ${result.status}');
        return null;
      }
    } catch (e) {
      throw Exception('Facebook Sign-In failed: $e');
    }
  }

  // Reauthenticate the user with email/password
  Future<void> reauthenticateWithEmail(String email, String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      try {
        await user.reauthenticateWithCredential(credential);  // Reauthenticate the user
        Fluttertoast.showToast(msg: "Reauthenticated successfully");
      } catch (e) {
        Fluttertoast.showToast(msg: "Reauthentication failed: ${e.toString()}");
        throw Exception('Reauthentication failed');
      }
    }
  }

  // Google reauthentication
  Future<void> reauthenticateWithGoogle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) throw Exception('Reauthentication canceled');
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await user.reauthenticateWithCredential(credential);
        Fluttertoast.showToast(msg: "Reauthenticated successfully with Google");
      } catch (e) {
        Fluttertoast.showToast(msg: "Google reauthentication failed: $e");
        throw Exception('Reauthentication failed');
      }
    }
  }

  // Facebook reauthentication
  Future<void> reauthenticateWithFacebook() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final accessToken = result.accessToken;
          final credential = FacebookAuthProvider.credential(accessToken!.tokenString);
          await user.reauthenticateWithCredential(credential);
          Fluttertoast.showToast(msg: "Reauthenticated successfully with Facebook");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Facebook reauthentication failed: $e");
        throw Exception('Reauthentication failed');
      }
    }
  }
  // Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        Fluttertoast.showToast(msg: "Account deleted successfully");
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }
}
