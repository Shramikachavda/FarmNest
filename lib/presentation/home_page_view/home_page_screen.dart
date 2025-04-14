import 'dart:ui';
import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/calender_view/add_event_expense.dart';
import 'package:agri_flutter/presentation/home_page_view/market_price_widget.dart'; // Assuming MarketPriceCard is here
import 'package:agri_flutter/presentation/search.dart';
import 'package:agri_flutter/presentation/weather_details.dart';
import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/providers/user_provider.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:agri_flutter/services/location.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../../core/image.dart';
import '../../core/widgets/BaseStateFullWidget.dart';
import '../../providers/location_provider.dart';
import '../../theme/app_theme_bloc.dart';
import '../../theme/theme.dart';
import '../../utils/text_style_utils.dart';

class HomePageScreen extends BaseStatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();

  @override
  Route buildRoute() {
    return materialRoute();
  }

  static const String route = "/HomePageScreen";

  @override
  String get routeName => route;
}

class _HomePageScreenState extends State<HomePageScreen> {
  final MarkerPriceProvider viewModel = MarkerPriceProvider();
  final LocationService locationService = LocationService();
  WeatherViewModel? weatherViewModel;
  final FirestoreService _fireStoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    viewModel.loadInitialPrices();

    Future.delayed(Duration.zero, () {
      weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
      _fetchWeatherData();
      Provider.of<EventExpenseProvider>(context, listen: false).fetchAllData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update status bar style when dependencies (like theme) change
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: themeColor(context: context).inversePrimary,
        // Access theme with context
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
    );
  }

  Future<void> _fetchWeatherData() async {
    final locationData = await locationService.fetchLocation();
    if (locationData != null && weatherViewModel != null) {
      double lat = locationData["latitude"]!;
      double lon = locationData["longitude"]!;
      await weatherViewModel!.loadWeather(lat, lon);
    }
  }

  String getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 12) return "Good Morning 🌞";
    if (hour >= 12 && hour < 17) return "Good Afternoon ☀️";
    if (hour >= 17 && hour < 21) return "Good Evening 🌆";
    return "Good Night 🌙";
  }

  String getAnimation() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 12) return ImageConst.anim1;
    if (hour >= 12 && hour < 17) return ImageConst.anim1;
    if (hour >= 17 && hour < 21) return ImageConst.anim1;
    return ImageConst.anim3;
  }

  @override
  Widget build(BuildContext context) {
    String address =
        context.select<LocationProvider, String?>(
          (provider) => provider.currentAddress,
        ) ??
        "Fetching...";
    return Scaffold(
      backgroundColor: themeColor().surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              welcomeHeader(),
              weatherCard(),
              upComingEventCard(),
              marketPlaceCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget welcomeCard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children:
            [
              //drawer
              Padding(
                padding: EdgeInsets.only(left: 24.w, top: 24.h, bottom: 12.h),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: customIconButton(
                    context: context,
                    onTap: () {
                      ZoomDrawer.of(context)?.toggle();
                    },
                    assetIcon: Icon(
                      Icons.menu,
                      color: themeColor().onInverseSurface,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.w, bottom: 24.h),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: themeColor().surface.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.r),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              bodyMediumBoldText(
                                "Hy , ${context.watch<UserProvider>().userName}!",
                              ),

                              //greeting
                              bodySemiLargeExtraBoldText(getGreeting()),

                              //welcome msg
                              bodyText("Welcome to FarmNest!", maxLine: 2),

                              //location
                              Expanded(
                                child: Row(
                                  spacing: 5.0,
                                  children: [
                                    Icon(Icons.location_on),
                                    Flexible(
                                      child: Wrap(
                                        children: [
                                          bodyText(
                                            context
                                                    .read<LocationProvider>()
                                                    .currentAddress ??
                                                "location unavailable...",
                                            maxLine: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Right Image Section
                    SizedBox(
                      height: 150.h,
                      child: Padding(
                        padding: EdgeInsets.only(right: 24.w),
                        child: Image.asset(
                          ImageConst.welcome2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ].separator(SizedBox(height: 8.h)).toList(),
      ),
    );
  }

  Widget weatherCard() {
    return Consumer<WeatherViewModel>(
      builder: (context, weatherViewModel, _) {
        if (weatherViewModel.isLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: SizedBox(
              height: 180.h,
              child: Card(child: Center(child: CircularProgressIndicator())),
            ),
          );
        }
        if (weatherViewModel.errorMessage != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: SizedBox(
              height: 180.h,
              child: Card(
                child: Center(
                  child: errorText(weatherViewModel.errorMessage.orEmpty()),
                ),
              ),
            ),
          );
        }
        if (weatherViewModel.currentWeather == null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: SizedBox(
              height: 180.h,
              child: Card(
                child: Center(child: Text('No weather data available.')),
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

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForecastScreen()),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Card(
              //elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              [
                                bodyText("🌤 $description"),
                                SizedBox(height: 2.h),
                                bodyText("🔽 Min: $tempMin°C"),
                                bodyText("🌬 Wind: $windSpeed m/s"),
                                bodyText(
                                  "🌅 Sunrise: ${sunrise.hour}:${sunrise.minute.toString().padLeft(2, '0')}",
                                ),
                              ].separator(SizedBox(height: 2.h)).toList(),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children:
                                  [
                                    Image.network(
                                      "https://openweathermap.org/img/wn/$icon@2x.png",
                                      width: 40.w,
                                    ),
                                    bodyMediumText(
                                      "${weather['main']['temp']}°C",
                                    ),
                                  ].separator(SizedBox(height: 2.h)).toList(),
                            ),

                            bodyText("🔼 Max: $tempMax°C"),

                            bodyText("💧 Humidity: $humidity%"),
                            bodyText(
                              "🌇 Sunset: ${sunset.hour}:${sunset.minute.toString().padLeft(2, '0')}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget welcomeHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        color: themeColor().inversePrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Stack(
        children: [
          welcomeCardBackGroundImage(),
          lottieAnim(),
          welcomeCard(),
        ],
      ),
    );
  }

  Widget lottieAnim() {
    final anim = getAnimation();
    return Padding(
      padding: EdgeInsets.only(right: 60.w),
      child: Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          height: 100.h,
          width: 100.h,
          child: DotLottieLoader.fromAsset(
            anim,
            frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
              if (dotlottie != null) {
                return Lottie.memory(dotlottie.animations.values.single);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget welcomeCardBackGroundImage() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        child: Image.asset(
          ImageConst.night,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget upComingEventCard() {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bodyMediumText("Upcoming Events"),
                  customIconButton(
                    context: context,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 2.0,
                                  sigmaY: 2.0,
                                ),
                                child: Container(),
                              ),
                              Center(
                                child: AddEventExpenseDialog(
                                  DateTime.now().add(Duration(days: 1)),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    assetIcon: Icon(
                      Icons.add,
                      color: themeColor().onInverseSurface,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              Consumer<EventExpenseProvider>(
                builder: (context, eventProvider, child) {
                  final upComingEvents = eventProvider.upcomingTwoEvents;
                  final upComingEventLength = upComingEvents.length;

                  if (upComingEventLength == 0) {
                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: themeColor().surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: themeColor().outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: bodyText(
                            "No events added yet. Tap ➕ to get started!",
                            maxLine: 2,
                          ),
                        ),
                      ),
                    );
                  }

                  if (upComingEventLength == 1) {
                    return eventCard(
                      upComingEvent: upComingEvents,
                      index: 0,
                      eventProvider: eventProvider,
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                                    //    scrollDirection: Axis.horizontal,
                       shrinkWrap: true,
                       itemBuilder: (context, index) {
                        return  Expanded(
                          child: eventCard(
                             upComingEvent: upComingEvents,
                             index: index,
                             eventProvider: eventProvider,
                           ),
                        );
                       },

                    ),
                  );
                },
              ),
            ].separator(SizedBox(height: 12)).toList(),
      ),
    );
  }

  Widget marketPlaceCard() {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.h, bottom: 12.h),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bodyMediumText("Market Price(Gujarat)"),
                  InkWell(
                    onTap: () {
                      NavigationUtils.push(SearchScreen().buildRoute());
                    },
                    child: bodyText(
                      "Explore more > ",
                      color: themeColor().primary,
                    ),
                  ),
                ],
              ),

              Consumer<MarkerPriceProvider>(
                builder: (context, value, child) {
                  //length of market price
                  final marketPriceLength =
                      value.prices.length > 2 ? 2 : value.prices.length;

                  if (value.isLoading) {
                    return SizedBox(
                      height: 150.h,
                      child: Card(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (value.errorMessage != null) {
                    return SizedBox(
                      height: 150.h,
                      child: Card(
                        child: Center(child: Text(value.errorMessage!)),
                      ),
                    );
                  }
                  if (value.prices.isEmpty) {
                    return SizedBox(
                      height: 150.h,
                      child: Card(
                        child: Center(child: Text('No market data available.')),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: marketPriceLength,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          MarketPriceCard(record: value.prices[index]),
                          SizedBox(height: 12.h),
                        ],
                      );
                    },
                  );
                },
              ),
            ].separator(SizedBox(height: 12.h)).toList(),
      ),
    );
  }

  Widget eventCard({
    required List upComingEvent,
    required int index,
    required EventExpenseProvider eventProvider,
  }) {
    final event = upComingEvent[index]; // Cleaner access
    return Card(
      child: Container(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(
                    message: event.title,
                    child: bodyMediumBoldText(event.title),
                  ),
                  bodyText(event.category),
                  bodyText(DateFormat('dd-MM-yyyy').format(event.date)),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 2.0,
                                sigmaY: 2.0,
                              ),
                              child: Container(),
                            ),
                            Center(
                              child: AddEventExpenseDialog(
                                event.date,
                                eventToEdit: event,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await eventProvider.removeEventExpense(event);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Event deleted successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete event: $e')),
                      );
                    }
                  },

                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }
}
