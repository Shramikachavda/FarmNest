import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/theme.dart';
import 'add_farmer_address.dart';
import 'default_location.dart';
import 'farm_detail2.dart';

class PostSignupScreen extends BaseStatefulWidget {
  const PostSignupScreen({super.key});

  @override
  State<PostSignupScreen> createState() => _PostSignupScreenState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/postSignUpScreen";

  @override
  String get routeName => route;
}

class _PostSignupScreenState extends State<PostSignupScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 24.h,) ,
          Padding(
            padding:  EdgeInsets.symmetric( horizontal:  30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(onPressed: () {}, child: bodyText("Skip")),
                InkWell(
                  onTap: () {

                    print(_currentPage);
                    _pageController.nextPage(
                      duration: Duration(seconds: 1),
                      curve: Curves.ease,
                    );
                  },
                  child: ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, value, child) {
                      return Text("${value + 1} / 3");
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: WormEffect(
              dotHeight: 5.h,
              dotWidth: MediaQuery.of(context).size.width * .27,
              activeDotColor: themeColor().primary,
              dotColor: themeColor().secondary,
            ),
          ),
          SizedBox(height: 24.h),

          Expanded(
            child: PageView(
            
              controller: _pageController,
              onPageChanged: (value) {
                _currentPage.value = value;
              },
              children: [
                DefaultFarmAddress(),
                AddFarmerAddress(),
                AddFarmFieldLocationScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
