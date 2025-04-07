import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/presentation/home_view.dart';
import 'package:agri_flutter/presentation/login_view.dart';
import 'package:agri_flutter/presentation/onboard_screen.dart';
import 'package:agri_flutter/repo/onboard.dart';
import 'package:flutter/material.dart';

class NavigationUtils {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Push a new page onto the stack
  static Future<T?> push<T>(Route<T> route) async {
    FocusManager.instance.primaryFocus?.unfocus();
    return navigatorKey.currentState?.push(route);
  }

  /// Replace current page with new page
  static Future<T?> pushReplacement<T, TO>(Route<T> route, {TO? result}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    return navigatorKey.currentState?.pushReplacement(route, result: result);
  }

  /// Push and remove all previous routes
  static Future<T?> pushAndRemoveAll<T>(Route<T> route) async {
    FocusManager.instance.primaryFocus?.unfocus();
    return navigatorKey.currentState?.pushAndRemoveUntil(
      route,
          (Route<dynamic> r) => false,
    );
  }

  /// Push and remove until a condition is met
  static Future<T?> pushAndRemoveUntil<T>(Route<T> route, bool Function(Route<dynamic>) predicate) async {
    FocusManager.instance.primaryFocus?.unfocus();
    return navigatorKey.currentState?.pushAndRemoveUntil(route, predicate);
  }

  /// Pop current route
  static void pop<T extends Object?>([T? result]) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop(result);
    }
  }

  /// Pop until a specific route name is found
  static void popUntil(String routeName) {
    FocusManager.instance.primaryFocus?.unfocus();
    navigatorKey.currentState?.popUntil((route) => route.settings.name == routeName);
  }

  /// Optionally: pop all until root
  static void popToRoot() {
    FocusManager.instance.primaryFocus?.unfocus();
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  /// Navigate from Splash to onboarding (clear backstack)
  static void goToOnboardScreen() {
    pushAndRemoveAll(const OnboardScreen().buildRoute());
  }

  /// Navigate from Splash to Login (clear backstack)
  static void goToLogin() {
    pushAndRemoveAll(const LoginView().buildRoute());
  }

  /// Navigate from Splash to Home (clear backstack)
  static void goToHome() {
    pushAndRemoveAll(const HomeView().buildRoute());
  }

  /// Navigate to next page, keeping current in backstack
  static void goTo<T extends BaseStatefulWidget>(T widget) {
    push(widget.buildRoute());
  }

  /// Replace current page with next
  static void replaceWith<T extends BaseStatefulWidget>(T widget) {
    pushReplacement(widget.buildRoute());
  }
}
