import 'package:agri_flutter/core/color_const.dart';
import 'package:agri_flutter/core/image.dart';
import 'package:agri_flutter/customs_widgets/custom_onboard.dart';
import 'package:agri_flutter/repo/onboard.dart';
import 'package:flutter/material.dart';
import 'package:agri_flutter/views/login_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
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
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                CustomOnboard(
                  image: ImageConst.intro1,
                  title: 'Welcome to Farm Nest',
                  description:
                      "Manage your farm effortlessly with digital tools.",
                ),
                CustomOnboard(
                  image: ImageConst.intro2,
                  title: 'One-Stop Farm Marketplace',
                  description:
                      "Explore farm essentials like fertilizers and machinery.",
                ),
                CustomOnboard(
                  image: ImageConst.intro3,
                  title: 'Smart Farm Management',
                  description:
                      "Plan activities, track expenses, and stay updated.",
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _completeOnboarding, // Mark onboarding as completed
                child: Text("Skip"),
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: WormEffect(
                  activeDotColor: ColorConst.midGreen,
                  dotColor: ColorConst.green,
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
    );
  }
}
