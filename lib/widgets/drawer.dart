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
    final theme = themeColor();
    return Drawer(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? Colors.green.shade100
              : Color(0xff026666), // or any light theme color

      child: ListView(
        children: [
          DrawerHeader(
            //    decoration: BoxDecoration(color: Colors.green.shade100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 50.r, backgroundColor: theme.onPrimary),
                SizedBox(height: 10.h),

                Text(context.watch<UserProvider>().userName),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Account"),
            onTap: () {},
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
          SizedBox(),
          Column(
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
                    color: Colors.green.shade100, // Light green background
                    shape: BoxShape.circle, // Makes it circular
                  ),
                  padding: EdgeInsets.all(10), // Padding inside the circle
                  child: Icon(
                    Icons.logout,
                    size: 30.sp,
                    color: theme.primary, // Icon color
                  ),
                ),
              ),
              SizedBox(height: 10.h), // Space between icon and text
              Text(
                "Sign Out",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
