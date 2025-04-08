import 'package:agri_flutter/presentation/home_page_view/home_page.dart';
import 'package:agri_flutter/presentation/home_view.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/widgets/drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../core/widgets/BaseStateFullWidget.dart';

class MyZoomDrawer extends BaseStatefulWidget {
  const MyZoomDrawer({super.key});

  @override
  State<MyZoomDrawer> createState() => _MyZoomDrawerState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/MyZoomDrawer";

  @override
  String get routeName => route;
}

class _MyZoomDrawerState extends State<MyZoomDrawer> {
  // final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      //  controller: _drawerController, // Ensure the controller is used correctly
      mainScreen: HomePage(),
      menuScreen: DrawerWidget(),
      borderRadius: 24.0,
      // showShadow: true,
      mainScreenAbsorbPointer: true,

      angle: 0.0,

      //     menuScreenTapClose: true,

      duration: const Duration(milliseconds: 300),
  showShadow: true,

      menuBackgroundColor: themeColor(context: context).inversePrimary,
      slideWidth: MediaQuery.of(context).size.width * 0.75, // 70% width for menu
    );
  }
}
