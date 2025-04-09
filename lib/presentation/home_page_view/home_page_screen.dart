import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/presentation/home_page_view/market_price_widget.dart'; // Assuming MarketPriceCard is here
import 'package:agri_flutter/presentation/search.dart';
import 'package:agri_flutter/presentation/weather_details.dart';
import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/providers/user_provider.dart';
import 'package:agri_flutter/services/location.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

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
        statusBarColor:
            themeColor().inversePrimary, // Access theme with context
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
    return " Good Night 🌙";
  }

  @override
  Widget build(BuildContext context) {
    String address =
        context.select<LocationProvider, String?>(
          (provider) => provider.currentAddress,
        ) ??
        "Fetching...";
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [welcomeHeader(), weatherCard(),    upComingEventCard() ,
            ],


          ),
        ),
      ),
    );
  }

  Widget welcomeCard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children:
            [
              //drawer
              Padding(
                padding: EdgeInsets.only(left: 24.w, top: 8.h, bottom: 8.h),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: customIconButton(
                    context: context,
                    onTap: () {},
                    assetIcon: Icon(
                      Icons.menu,
                      color: themeColor().onInverseSurface,
                      size: 24.sp,
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
                        padding: EdgeInsets.only(left: 24.w , bottom: 8.h),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: themeColor().surface.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.all(Radius.circular(30.r),),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              bodySemiLargeExtraBoldText(
                                "Hy , ${context.watch<UserProvider>().userName}!",
                              ),

                              //greeting
                              bodySemiLargeExtraBoldText(getGreeting()),

                              //welcome msg
                              bodyText("Welcome to FarmNest!" , maxLine: 2),

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
maxLine: 2

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
                   //   width: 150.h,
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
                child: errorText(weatherViewModel.errorMessage.orEmpty()),
              ),
            ),
          );
        }
        if (weatherViewModel.currentWeather == null) {
          return SizedBox(
            height: 180.h,
            child: const Card(
              child: Center(child: Text('No weather data available.')),
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
              color: themeColor().surfaceContainerHighest,
              //elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bodyMediumText(name),
                            bodyText("🌤 $description"),
                            SizedBox(height: 2.h),
                            bodyText("🔽 Min: $tempMin°C"),
                            bodyText("🌬 Wind: $windSpeed m/s"),
                            bodyText(
                              "🌅 Sunrise: ${sunrise.hour}:${sunrise.minute.toString().padLeft(2, '0')}",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  "https://openweathermap.org/img/wn/$icon@2x.png",
                                  width: 50.w,
                                ),
                                bodyMediumText("${weather['main']['temp']}°C"),
                              ],
                            ),

                            SizedBox(height: 2.h),

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
      decoration: BoxDecoration(
        color: themeColor().inversePrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Stack(
          children: [
            lottieAnimation(),
            welcomeCard()
          ]
      ),
    );
  }

  Widget lottieAnimation() {
    final isDark =
        context.read<AppThemeBloc>().state.themeMode == ThemeMode.dark;

    final lottiePath =
        isDark ? ImageConst.darkThemeAniamtion : ImageConst.lightThemeAnimation;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: DotLottieLoader.fromAsset(
        lottiePath,
        frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
          if (dotlottie != null) {
            return Lottie.memory(dotlottie.animations.values.single);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget upComingEventCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          // First card
          Expanded(
            child: Card(
              elevation: 3,
              color: themeColor().surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Container(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bodyBoldMediumText("Event 1"),
                    SizedBox(height: 4.h),
                    bodyMediumText("Details about the upcoming event."),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Second card
          Expanded(
            child: Card(
              elevation: 3,
              color: themeColor().surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Container(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bodyBoldMediumText("Event 2"),
                    SizedBox(height: 4.h),
                    bodyMediumText("Another upcoming event description."),
                  ],
                ),
              ),
            ),
          ),
        ],
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
