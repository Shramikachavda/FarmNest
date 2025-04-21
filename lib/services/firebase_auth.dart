import 'package:agri_flutter/presentation/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Authentication Methods ---

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        print('User created: ${user.uid}, sending email verification...');
        await user.sendEmailVerification();
        print('Email verification sent to $email');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print('Sign Up Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected Sign Up Error: $e');
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        print('Email not verified for user: ${user.uid}, returning null');
        return null;
      }
      print('Login successful for user: ${user?.uid}');
      return user;
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected Login Error: $e');
      rethrow;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) print('Logging out user: ${user.uid}');
      await _auth.signOut();
      print('User logged out successfully');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } on FirebaseAuthException catch (e) {
      print('Logout Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected Logout Error: $e');
      rethrow;
    }
  }

  // --- User Management Methods ---

  Future<String?> userId() async {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      // Check if the email exists by fetching sign-in methods
      List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email.trim());

      // If the email is already registered, it will have sign-in methods (like email/password)
      if (signInMethods.isEmpty) {
        print('Email not registered: $email');
        return false; // Email doesn't exist in Firebase
      }

      // Attempt to send the reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      print('Password reset email sent to $email');
      return true; // Success indicates email exists and reset was sent
    } on FirebaseAuthException catch (e) {
      print('Password Reset Error: ${e.code} - ${e.message}');
      rethrow; // Propagate other errors (e.g., invalid-email)
    } catch (e) {
      print('Unexpected Password Reset Error: $e');
      rethrow;
    }
  }


 /* Future<bool> sendPasswordResetEmail(String email) async {
    try {


      // Attempt to send the reset email
      await _auth.sendPasswordResetEmail(email: email.trim());
      print('Password reset email sent to $email');
      return true; // Success indicates email exists and reset was sent
    } on FirebaseAuthException catch (e) {
      print('Password Reset Error: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        print('Email does not exist: $email');
        return false; // Email doesn’t exist
      }
      rethrow; // Propagate other errors (e.g., invalid-email)
    } catch (e) {
      print('Unexpected Password Reset Error: $e');
      rethrow;
    }
  }
*/
 Future<void> reAuthenticateAndChangePassword({
  required String email,
  required String oldPassword,
  required String newPassword,
}) async {
  try {
    User? user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'no-user', message: 'No user is logged in');
    }
    if (user.email != email.trim()) {
      throw FirebaseAuthException(code: 'email-mismatch', message: 'Email mismatch');
    }
    final credential = EmailAuthProvider.credential(email: email.trim(), password: oldPassword);
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  } catch (e) {
    rethrow;
  }
}


}