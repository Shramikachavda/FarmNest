import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_onboard.dart';
import 'package:agri_flutter/repo/onboard.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:agri_flutter/presentation/login_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../core/widgets/BaseStateFullWidget.dart';

class OnboardScreen extends BaseStatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/OnboardScreen";

  @override
  String get routeName => route;
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _pageController = PageController();
  final OnboardingRepository _onboardingRepository = OnboardingRepository();

  void _completeOnboarding() async {
    await _onboardingRepository.setOnboardingCompleted();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  CustomOnboard(
                    image: ImageConst.intro1,
                    title: 'Welcome to Farm Nest –Your Digital Farming Companion',
                    description:
                    "Farm Nest gives you smart tools to manage your farm, track weather, and plan every season with confidence.",
                  ),
                  CustomOnboard(
                    image: ImageConst.intro2,
                    title: 'One-Stop Farm Marketplace',
                    description:
                    "Shop fertilizers, seeds, and machinery with ease—get everything your farm needs in one place.",
                  ),
                  CustomOnboard(
                      image: ImageConst.intro3,
                      title: 'Add Your Farm & Boost Yield with Soil Insights',
                      description:
                      "Plan your daily farming activities with ease.Track expenses and get timely updates to stay on top of everything."),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _completeOnboarding,
                  // Mark onboarding as completed
                  child: Text("Skip"),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 6.h,
                    dotWidth: 6.w,
                    activeDotColor: themeColor(context: context).primary,
                    dotColor: themeColor(context: context).secondary,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_pageController.page == 2) {
                      _completeOnboarding(); // Save onboarding completion
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
