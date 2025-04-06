import 'package:agri_flutter/presentation/calender_view/calender_view.dart';
import 'package:agri_flutter/presentation/farm_state_views/farm_state_home_view.dart';
import 'package:agri_flutter/presentation/market_place_views/market_homePage_view.dart';
import 'package:agri_flutter/presentation/zoom_drawer.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int pageIndex = 0; // Track the selected index
  final pages = [
    const MyZoomDrawer(),
    const MarketHomepageView(),
    const CalenderView(),
    const FarmStateHomeView(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = themeColor();
    return Scaffold(
      body: pages[pageIndex],

      //  drawer: DrawerWidget(), // Show selected page
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: theme.onPrimaryContainer,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.graphic_eq,
                    color: pageIndex == 0 ? theme.surface : theme.surface,
                    size: pageIndex == 0 ? 30 : 25, // Bigger icon when selected
                  ),
                  if (pageIndex == 0)
                    Text(
                      "home",
                      style: TextStyle(color: theme.surface, fontSize: 10),
                    ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shop,
                    color: pageIndex == 1 ? theme.surface : theme.surface,
                    size: pageIndex == 1 ? 30 : 25, // Bigger icon when selected
                  ),
                  if (pageIndex == 1)
                    Text(
                      "Shop",
                      style: TextStyle(color: theme.surface, fontSize: 10),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: pageIndex == 2 ? theme.surface : theme.surface,
                    size: pageIndex == 2 ? 30 : 25, // Bigger icon when selected
                  ),
                  if (pageIndex == 2)
                    Text("Calendar", style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.graphic_eq,
                    color: pageIndex == 3 ? theme.surface : theme.surface,
                    size: pageIndex == 3 ? 30 : 25, // Bigger icon when selected
                  ),
                  if (pageIndex == 3)
                    Text("Stats", style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
