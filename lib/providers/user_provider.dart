import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  String _userName = "Loading...";
  String _email = "";

  String get userName => _userName;
  String get userEmail => _email;

  UserProvider() {
    fetchUserDetail();
  }

  Future<void> fetchUserDetail() async {
    try {
      final user = await _firestore.getUserById(_firestore.userId);
      if (user != null) {
        _userName = user.name;
        print(_userName);
        _email = user.email;
        print(_email);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user details: $e");
    }
  }

  void setUserNameEmail(String name, String email) {
    _userName = name;
    _email = email;
     notifyListeners();
  }
 
}
