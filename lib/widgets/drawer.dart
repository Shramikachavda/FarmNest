import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/drawer/selected_address.dart';
import 'package:agri_flutter/presentation/drawer/change_password.dart';
import 'package:agri_flutter/presentation/drawer/order_screen.dart';
import 'package:agri_flutter/presentation/drawer/update_user_info.dart';
import 'package:agri_flutter/providers/user_provider.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../presentation/drawer/farm/farm_dart.dart';
import '../theme/app_theme_bloc.dart';
import '../theme/theme.dart';

class DrawerWidget extends StatelessWidget {
  final FireBaseAuth _fireBaseAuth = FireBaseAuth();

  DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = themeColor(context: context);
    return Drawer(
      backgroundColor: theme.inversePrimary,

      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 200.h,
                  child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 44.r,

                              child: bodyText(
                                context
                                        .watch<UserProvider>()
                                        .userName
                                        .isNotEmpty
                                    ? context
                                        .watch<UserProvider>()
                                        .userName[0]
                                        .toUpperCase()
                                    : '?',
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                NavigationUtils.push(
                                  EditProfileScreen().buildRoute(),
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        bodyText(context.watch<UserProvider>().userName),
                        bodyText(context.watch<UserProvider>().userEmail),
                      ],
                    ),
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: bodyText("Order"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OrderScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: bodyText("Address"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectAddressScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.eco),
                  title: bodyText("Farm"),
                  onTap: () {
                         Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Farm(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.lock),
                  title: bodyText("Change Password"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    );
                  },
                ),

                ListTile(
                  leading:
                      Theme.of(context).brightness == Brightness.light
                          ? Icon(Icons.light_mode)
                          : Icon(Icons.mode_night),
                  title:
                      Theme.of(context).brightness == Brightness.light
                          ? Text("Light")
                          : Text("Dark"),
                  trailing: Switch.adaptive(
                    value:
                        context.watch<AppThemeBloc>().state.themeMode ==
                        ThemeMode.dark,
                    onChanged: (value) {
                      context.read<AppThemeBloc>().add(
                        ToggleTheme(),
                      ); // Toggle theme
                    },
                  ),

                  onTap: () {
                    context.read<AppThemeBloc>().add(ToggleTheme());
                  },
                ),
              ],
            ),
          ),

          SizedBox(
            height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logout
                GestureDetector(
                  onTap: () async {
                    await _fireBaseAuth.logout(
                      context,
                    ); // Ensure it runs when tapped
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:themeColor(context : context).primaryContainer,
                    ),
                    padding: EdgeInsets.all(10.h),
                    child: Icon(
                      Icons.logout,
                      size: 30.sp,
                      // Icon color
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                bodyMediumText("Sign Out"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
