/*
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/home_page_view/market_price_widget.dart'; // Assuming MarketPriceCard is here
import 'package:agri_flutter/presentation/search.dart';
import 'package:agri_flutter/presentation/weather_details.dart';
import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/providers/user_provider.dart';
import 'package:agri_flutter/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/BaseStateFullWidget.dart';
import 'weather_forecast/forecast_screen.dart';

class HomePage extends BaseStatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/HomePage";

  @override
  String get routeName => route;
}

class _HomePageState extends State<HomePage> {
  final MarkerPriceProvider viewModel = MarkerPriceProvider();
  final LocationService locationService = LocationService();
  WeatherViewModel? weatherViewModel;

  @override
  void initState() {
    super.initState();
    viewModel.loadInitialPrices(); // Load Gujarat-specific prices

    Future.delayed(Duration.zero, () {
      weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
      _fetchWeatherData();
      Provider.of<EventExpenseProvider>(context, listen: false).fetchAllData();
    });
  }

  Future<void> _fetchWeatherData() async {
    final locationData = await locationService.fetchLocation();
    if (locationData != null && weatherViewModel != null) {
      double lat = locationData.latitude ?? 0 ;
      double lon = locationData.longitude??0;
      await weatherViewModel!.loadWeather(lat, lon);
    }
  }

  String getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 12) return " Good Morning 🌞";
    if (hour >= 12 && hour < 17) return " Good Afternoon ☀️";
    if (hour >= 17 && hour < 21) return " Good Evening 🌆";
    return " Good Night 🌙";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => ZoomDrawer.of(context)?.toggle(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                children: [
                  bodyMediumText("Hy, "),
                  bodyMediumText("${context.watch<UserProvider>().userName}!"),
                  bodyMediumText(getGreeting()),
                ],
              ),
              SizedBox(height: 16.h),

              // Weather Card (Unchanged)
              Consumer<WeatherViewModel>(
                builder: (context, weatherViewModel, _) {
                  if (weatherViewModel.isLoading) {
                    return SizedBox(
                      height: 180.h,
                      child: const Card(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }
                  if (weatherViewModel.errorMessage != null) {
                    return SizedBox(
                      height: 180.h,
                      child: Card(
                        child: Center(
                          child: errorText(
                            weatherViewModel.errorMessage.orEmpty(),
                          ),
                        ),
                      ),
                    );
                  }
                  if (weatherViewModel.currentWeather == null) {
                    return SizedBox(
                      height: 180.h,
                      child: const Card(
                        child: Center(
                          child: Text('No weather data available.'),
                        ),
                      ),
                    );
                  }

                  final weather = weatherViewModel.currentWeather!;
                  final icon = weather['weather'][0]['icon'];
                  final name = weather['name'];
                  final description = weather['weather'][0]['description'];
                  final tempMin = weather['main']['temp_min'];
                  final tempMax = weather['main']['temp_max'];
                  final humidity = weather['main']['humidity'];
                  final windSpeed = weather['wind']['speed'];
                  final sunrise = DateTime.fromMillisecondsSinceEpoch(
                    weather['sys']['sunrise'] * 1000,
                  );
                  final sunset = DateTime.fromMillisecondsSinceEpoch(
                    weather['sys']['sunset'] * 1000,
                  );

                  return SizedBox(
                    height: 220.h,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForecastScreen(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      bodyLargeText(name),
                                      bodyText("🌤 $description"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.network(
                                        "https://openweathermap.org/img/wn/$icon@2x.png",
                                        width: 50.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      bodyLargeText(
                                        "${weather['main']['temp']}°C",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  bodyText("🔽 Min: $tempMin°C"),
                                  bodyText("🔼 Max: $tempMax°C"),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  bodyText("🌬 Wind: $windSpeed m/s"),
                                  bodyText("💧 Humidity: $humidity%"),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  bodyText(
                                    "🌅 Sunrise: ${sunrise.hour}:${sunrise.minute.toString().padLeft(2, '0')}",
                                  ),
                                  bodyText(
                                    "🌇 Sunset: ${sunset.hour}:${sunset.minute.toString().padLeft(2, '0')}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // Upcoming Events (Unchanged)
              Consumer<EventExpenseProvider>(
                builder: (context, provider, _) {
                  final events = provider.upcomingTwoEvents;
                  if (events.isEmpty) return const Text("No upcoming events");

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Events",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 160.h,
                        child: ListView.builder(
                          itemCount: events.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 3,
                              margin: EdgeInsets.only(bottom: 8.h),
                              child: ListTile(
                                title: Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "${event.date.toLocal()}".split(' ')[0],
                                ),
                                trailing: const Icon(
                                  Icons.event,
                             
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Market Prices (Gujarat)",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Consumer<MarkerPriceProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return SizedBox(
                          height: 180.h,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (provider.errorMessage != null) {
                        return SizedBox(
                          height: 180.h,
                          child: Center(child: Text(provider.errorMessage!)),
                        );
                      }
                      if (provider.prices.isEmpty) {
                        return SizedBox(
                          height: 180.h,
                          child: const Center(
                            child: Text('No market data available.'),
                          ),
                        );
                      }

                      final displayCount =
                          provider.prices.length > 2
                              ? 2
                              : provider.prices.length;

                      return ListView.builder(
                        shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            displayCount, // No extra card, use existing count
                        itemBuilder: (context, index) {
                          final isLastCard = index == displayCount - 1;
                          return Stack(
                            children: [
                              MarketPriceCard(record: provider.prices[index]),
                              if (isLastCard) // Add "Search Now" only to the last card
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const SearchScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Search more",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
