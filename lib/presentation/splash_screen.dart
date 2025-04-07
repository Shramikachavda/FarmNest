import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/presentation/post_sign_up/post_signup_screen.dart';
import 'package:agri_flutter/providers/location_provider.dart';
import 'package:agri_flutter/repo/onboard.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/services/local_storage/post_sign_up.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../core/widgets/BaseStateFullWidget.dart';
import '../theme/theme.dart';

class SplashScreen extends BaseStatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static const String route = "/SplashScreen";

  @override
  String get routeName => route;

  @override
  Route buildRoute() {
    return materialRoute();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  //di
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
    bool isOnboardingCompleted =
        await _onboardingRepository.isOnboardingCompleted();
    User? user = _fireBaseAuth.getCurrentUser();

    /// Load local flag from Hive
    bool hasCompletedPostSignup = LocalStorageService.hasCompletedPostSignup();

    Future.delayed(const Duration(seconds: 2), () {
      if (!isOnboardingCompleted) {
        NavigationUtils.goToOnboardScreen();
      }
       else if (user != null && !hasCompletedPostSignup) {
      // ✅ Show PostSignupScreen for first-time users
        NavigationUtils.pushReplacement(PostSignupScreen().buildRoute());
       }
      else if (user != null) {
        NavigationUtils.goToHome();
      } else {
        NavigationUtils.goToLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor().surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 97.5.w, vertical: 301.58.h),
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            curve: Curves.easeIn,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Image.asset(
                  ImageConst.logoName,
                  width: 180.w,
                  height: 180.h,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
