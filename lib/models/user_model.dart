import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uid;         // Firebase UID
  final String? displayName; // User's name
  final String? email;       // User's email
  final String? photoUrl;    // Profile picture URL
  final String? phoneNumber; // User's phone number (optional)

  // Any additional fields specific to your app
  final bool? isEmailVerified; // To track email verification status

  UserModel({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.isEmailVerified,
  });

  // Factory constructor to create UserModel from Firebase User (FirebaseUser)
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      isEmailVerified: user.emailVerified,
    );
  }

  // Method to create UserModel from Map (e.g., Firestore data)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      displayName: data['displayName'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      isEmailVerified: data['isEmailVerified'],
    );
  }

  // Convert UserModel to Map (useful for storing in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
    };
  }
}
