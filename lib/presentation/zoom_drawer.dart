import 'package:agri_flutter/presentation/home_page_view/home_page.dart';
import 'package:agri_flutter/widgets/drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MyZoomDrawer extends StatefulWidget {
  const MyZoomDrawer({super.key});

  @override
  State<MyZoomDrawer> createState() => _MyZoomDrawerState();
}

class _MyZoomDrawerState extends State<MyZoomDrawer> {
 // final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      //  controller: _drawerController, // Ensure the controller is used correctly
      mainScreen: const HomePage(),
      menuScreen:  DrawerWidget(),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0, // No tilt effect
      menuScreenTapClose: true, // Close menu on tap
      duration: const Duration(milliseconds: 300), // Smooth transition
      menuBackgroundColor: Colors.green.shade100,
      slideWidth: MediaQuery.of(context).size.width * 0.7, // 70% width for menu
    );
  }
}
