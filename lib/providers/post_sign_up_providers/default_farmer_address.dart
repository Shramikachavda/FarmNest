import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:flutter/material.dart';

class PostSignupNotifier extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  void updatePage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    }

  }

  void completeSignupAndNavigate() {
  NavigationUtils.goToHome(); // your custom navigation
}

}
