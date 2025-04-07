import 'package:agri_flutter/core/widgets/BaseStateFullWidget.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/login_view.dart';
import 'package:agri_flutter/providers/post_sign_up_providers/default_farmer_address.dart';
import 'package:agri_flutter/services/local_storage/post_sign_up.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
  void _completePostSignup() async {
    await LocalStorageService.setPostSignupCompleted();
    NavigationUtils.goToHome();
  }

  @override
  Widget build(BuildContext context) {
    final postSignup = Provider.of<PostSignupNotifier>(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: bodyText("Skip"),
                ),
                InkWell(
                  onTap: () {
                    if (postSignup.currentPage < 2) {
                      postSignup.nextPage();
                    } else {
                      _completePostSignup();
                    }
                  },
                  child: Text("${postSignup.currentPage + 1} / 3"),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          SmoothPageIndicator(
            controller: postSignup.pageController,
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
              controller: postSignup.pageController,
              onPageChanged: postSignup.updatePage,
              children: const [
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
