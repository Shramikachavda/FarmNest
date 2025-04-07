import 'package:agri_flutter/services/local_storage/post_sign_up.dart';
import 'package:flutter/material.dart';


class AppStateProvider extends ChangeNotifier {
  bool _hasCompletedPostSignup = false;

  bool get hasCompletedPostSignup => _hasCompletedPostSignup;

  Future<void> loadInitialData() async {
    _hasCompletedPostSignup = LocalStorageService.hasCompletedPostSignup();
    notifyListeners();
  }

  Future<void> markPostSignupCompleted() async {
    await LocalStorageService.setPostSignupCompleted();
    _hasCompletedPostSignup = true;
    notifyListeners();
  }
}
