import 'package:agri_flutter/services/firebase_auth.dart';
import 'package:flutter/material.dart';



class DrawerWidget extends StatelessWidget {

  final FireBaseAuth _fireBaseAuth =  FireBaseAuth();

   DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.onPrimary,
                ),
                SizedBox(height: 10),
                Text(
                  "data",
                  style: TextStyle(color: theme.textTheme.bodySmall!.color),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: theme.primaryColor),
            title: Text("Account"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.mode_night, color: theme.primaryColor),
            title: Text("Theme"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock, color: theme.primaryColor),
            title: Text("Change Password", style: theme.textTheme.bodySmall),
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
    await _fireBaseAuth.logout(context); // Ensure it runs when tapped
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
                    color: theme.primaryColor, // Icon color
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between icon and text
              Text(
                "Sign Out",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
