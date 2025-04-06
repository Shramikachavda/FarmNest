import 'package:agri_flutter/presentation/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Sign Up (Register) User & Store Name in Hive with UID
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        // ✅ Send Email Verification (OTP via Email)
        await user.sendEmailVerification();
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
      if (user != null) {}
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

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }


Future<void> reAuthenticateAndChangePassword({
  required String email,
  required String oldPassword,
  required String newPassword,
}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Step 1: Re-authenticate
      final cred = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);

      // Step 2: Check if email is verified
      await user.reload(); // Reload user data
      if (!user.emailVerified) {
        print("❌ Email not verified.");
        await user.sendEmailVerification();
        print("📩 Verification email sent! Please verify before changing password.");
        return;
      }

      // Step 3: Change password
      await user.updatePassword(newPassword);
      print("✅ Password updated successfully.");
    } else {
      print("❌ No user is logged in.");
    }
  } catch (e) {
    print("❌ Error: $e");
  }
}

}
