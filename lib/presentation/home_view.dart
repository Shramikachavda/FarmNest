import 'package:agri_flutter/presentation/calender_view/calender_view.dart';
import 'package:agri_flutter/presentation/farm_state_views/farm_state_home_view.dart';
import 'package:agri_flutter/presentation/market_place_views/market_homePage_view.dart';
import 'package:agri_flutter/presentation/zoom_drawer.dart';
import 'package:flutter/material.dart';

import '../core/widgets/BaseStateFullWidget.dart';
import '../theme/theme.dart';
import 'home_page_view/home_page_screen.dart';

class HomeView extends BaseStatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/HomeView";

  @override
  String get routeName => route;
}

class HomeViewState extends State<HomeView> {
  int pageIndex = 0;

  final pages = const [
    MyZoomDrawer(),
    MarketHomepageView(),
    CalenderView(),
    FarmStateHomeView(),
    HomePageScreen() ,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = themeColor(context: context);

    Color elevatedSurfaceColor = ElevationOverlay.applySurfaceTint(
      theme.surface,
      theme.surfaceTint,
      3, // 3dp elevation for NavigationBar
    );

    return Scaffold(
      backgroundColor: theme.surface,
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: elevatedSurfaceColor,
      height: 70,
      // backgroundColor: theme.tertiaryFixedDim,
      selectedIndex: pageIndex,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: (int index) {
    setState(() {
    pageIndex = index;
    });
    },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),

        NavigationDestination(
          tooltip: "Shop",
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Shop',
        ),
        NavigationDestination(

          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: 'Stats',
        ),

        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
      ],
    ),);
  }
}
