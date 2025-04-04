import 'package:agri_flutter/services/firebase_auth.dart';
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
  //  final themeProvider = Provider.of<ToggleTheme>(context);
    final theme = themeColor();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green.shade100,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.onPrimary,
                ),
                SizedBox(height: 10),
                Text(
                  "userName",

                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Account"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.mode_night, color: theme.primary),
            title: Text("Theme"),
            onTap: () {
              context.read<AppThemeBloc>().add(ToggleTheme());

            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
            onTap: () {},
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
                    size: 30,
                    color: theme.primary, // Icon color
                  ),
                ),
              ),
              SizedBox(height: 10.h), // Space between icon and text
              Text(
                "Sign Out",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
