import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';

import 'package:agri_flutter/services/hive_user_service.dart';
import 'package:agri_flutter/services/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MarkerPriceProvider viewModel = MarkerPriceProvider();
  final LocationService locationService = LocationService();
  WeatherViewModel? weatherViewModel; // Nullable to avoid init errors

  final HiveService _hiveService = HiveService();
  String? userName;

  @override
  void initState() {
    super.initState();
    viewModel.loadPrices();
    _loadUserName();

    // Delay _fetchWeatherData() to avoid context issues
    Future.delayed(Duration.zero, () {
      weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
      _fetchWeatherData();
    });
  }

  Future<void> _fetchWeatherData() async {
    final locationData = await locationService.fetchLocation();
    if (locationData != null && weatherViewModel != null) {
      double lat = locationData["latitude"]!;
      double lon = locationData["longitude"]!;
      await weatherViewModel!.loadWeather(lat, lon);
    }
  }

  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? name = await _hiveService.getUserName(user.uid);
      setState(() {
        userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final getUpcomingEventProvider = Provider.of<EventExpenseProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => ZoomDrawer.of(context)?.toggle(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName != null ? "Hello, $userName! 🌾" : "Hello, Farmer! 🌾",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Weather Card
            Consumer<WeatherViewModel>(
              builder: (context, weatherViewModel, _) {
                if (weatherViewModel.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (weatherViewModel.errorMessage != null) {
                  return Text(
                    weatherViewModel.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  );
                }
                if (weatherViewModel.currentWeather == null) {
                  return Text('No weather data available.');
                }

                final current = weatherViewModel.currentWeather!;
                return SizedBox(
                  height: 180.h,
                  child: Card(
                    color: Colors.white,

                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0.r),
                      child: Row(
                        children: [
                          Icon(Icons.wb_sunny, size: 40),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${current['main']['temp']}°C",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(current['weather'][0]['description']),
                              Text("Your Location"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16),
            /*
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upcoming Events",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
               getUpcomingEventProvider.isEmpty
                    ? Center(child: Text("No upcoming events"))
                    : Column(
                      children:
                          getUpcomingEventProvider.map((event) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: ListTile(
                                title: Text(
                                  event.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "${event.date.toLocal()}".split(
                                    ' ',
                                  )[0], // Shows only date
                                ),
                                trailing: Icon(
                                  Icons.event,
                                  color: Colors.green,
                                ),
                              ),
                            );
                          }).toList(),
                    ),

                //   Expanded(child: MarketPriceWidget()),
                SizedBox(height: 10),
              ],
            ),
         */
          ],

        ),
      ),
    );
  }
}
