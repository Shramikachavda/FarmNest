import 'package:agri_flutter/services/hive_user_service.dart';
import 'package:agri_flutter/presentation/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HiveService _hiveService = HiveService();



  // ✅ Sign Up (Register) User & Store Name in Hive with UID
Future<User?> signUp(String name, String email, String password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {

      // ✅ Send Email Verification (OTP via Email)
      await user.sendEmailVerification();

      // ✅ Store username in Hive using UID as the key
      await _hiveService.saveUserName(user.uid, name);
    }

    return user;
  } catch (e) {
    print("Sign Up Error: $e");
    return null;
  }
}


  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // ✅ Check if email is verified
        if (!user.emailVerified) {
          print("Email not verified! Please check your inbox.");
          return null; // Block login for unverified users
        }

        // ✅ Retrieve the user's name from Hive
        String? userName = await _hiveService.getUserName(user.uid);
        print("Logged in as: $userName");
      }

      return user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }


  Future<String?> userId() async {
  User? user = _auth.currentUser;
  return user?.uid; // ✅ Returns UID or null
}


  // ✅ Logout User & Remove Only Their Data
  Future<void> logout(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // ✅ Remove only the **logged-in user's data** from Hive
        await _hiveService.clearUserName(user.uid);
      }
      await _auth.signOut();

      // ✅ Navigate to Login Page
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginView()));
      print("User Logged Out");
    } catch (e) {
      print("Logout Error: $e");
    }
  }

  // ✅ Get Current Logged-in User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ✅ Get Logged-in User's Name
  Future<String?> getCurrentUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await _hiveService.getUserName(user.uid);
    }
    return null;
  }


  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
