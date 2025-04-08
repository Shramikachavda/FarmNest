import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/drawer/address_scrren.dart';
import 'package:agri_flutter/presentation/drawer/change_password.dart';
import 'package:agri_flutter/providers/user_provider.dart';
import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
     // or any light theme color
      child: Column(
        children: [
          Expanded(child:ListView(
            children: [
              Container(
                height: 200.h,
                child: DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 44.r,
                        backgroundColor: theme.onPrimary,
                        child: Text(
                          context.watch<UserProvider>().userName.isNotEmpty
                              ? context
                              .watch<UserProvider>()
                              .userName[0]
                              .toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: theme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      //   SizedBox(height: 10.h),
                      bodyText(context.watch<UserProvider>().userName),
                      bodyText(context.watch<UserProvider>().userEmail),
                    ],
                  ),
                ),
              ),

              ListTile(
                leading: Icon(Icons.person),
                title: Text("Account"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SelectAddressScreen()),
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
                    context.read<AppThemeBloc>().add(ToggleTheme()); // Toggle theme
                  },
                ),

                onTap: () {
                  context.read<AppThemeBloc>().add(ToggleTheme());
                },
              ),

              ListTile(
                leading: Icon(Icons.lock),
                title: Text("Change Password"),
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => ChangePassword()));
                },
              ),
            ],
          )) ,

          SizedBox(height:  100.h,
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
                 color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.logout,
                      size: 30.sp,
                      color: theme.primary, // Icon color
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
