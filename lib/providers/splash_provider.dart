
import 'package:agri_flutter/providers/location_provider.dart';
import 'package:agri_flutter/repo/onboard.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  final FireBaseAuth _authRepository;
  final OnboardingRepository _onboardingRepository;
  final LocationProvider _locationProvider;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool? _isLoggedIn;
  bool? get isLoggedIn => _isLoggedIn;

  bool? _isOnboardingCompleted;
  bool? get isOnboardingCompleted => _isOnboardingCompleted;

  SplashProvider(this._authRepository, this._onboardingRepository, this._locationProvider);

  Future<void> initializeApp() async {
    // Get location
    await _locationProvider.getLocation();

    // Check onboarding and login status
    _isOnboardingCompleted = await _onboardingRepository.isOnboardingCompleted();
    _isLoggedIn = _authRepository.getCurrentUser() != null;

    _isLoading = false;
    notifyListeners();
  }
}
