import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/providers/location_provider.dart';
import 'package:agri_flutter/repo/onboard.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/services/location.dart';
import 'package:agri_flutter/presentation/home_view.dart';
import 'package:agri_flutter/presentation/login_view.dart';
import 'package:agri_flutter/presentation/onboard_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final FireBaseAuth _fireBaseAuth = FireBaseAuth();
  final OnboardingRepository _onboardingRepository = OnboardingRepository();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Provider.of<LocationProvider>(context, listen: false).getLocation();
    
    // Check onboarding status
    bool isOnboardingCompleted = await _onboardingRepository.isOnboardingCompleted();
    User? user = _fireBaseAuth.getCurrentUser();

    Future.delayed(const Duration(seconds: 2), () {
      if (!isOnboardingCompleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardScreen()),
        );
      } else if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 97.5.w , vertical: 301.58.h),
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            curve: Curves.easeIn,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Image.asset(ImageConst.logoName, width: 180.w, height: 180.h),
              );
            },
          ),
        ),
      ),
    );
  }
}
