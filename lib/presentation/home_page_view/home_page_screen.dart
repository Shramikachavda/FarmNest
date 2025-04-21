import 'dart:ui';
import 'package:agri_flutter/customs_widgets/custom_icon.dart';
import 'package:agri_flutter/customs_widgets/reusable.dart';
import 'package:agri_flutter/data/product.dart';
import 'package:agri_flutter/presentation/calender_view/add_event_expense.dart';
import 'package:agri_flutter/presentation/home_page_view/market_price_widget.dart'; // Assuming MarketPriceCard is here
import 'package:agri_flutter/presentation/home_page_view/weather_forecast/weather_bloc.dart';
import 'package:agri_flutter/presentation/search.dart';
import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/providers/user_provider.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:agri_flutter/services/location.dart';
import 'package:agri_flutter/utils/comman.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/image.dart';
import '../../core/widgets/BaseStateFullWidget.dart';
import '../../models/responses/weather_response.dart';
import '../../providers/location_provider.dart';
import '../../theme/theme.dart';
import 'weather_forecast/forecast_screen.dart';

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
  final WeatherBloc _weatherBloc = WeatherBloc();

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
  void didChangeDependencies() async {
    await _weatherBloc.fetchWeatherData();
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
      double lat = locationData.latitude ?? 0;
      double lon = locationData.longitude ?? 0;
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

  /*Future<void> uploadStaticProductsToFirestore() async {
  final products = ProductData.products;

  final batch = FirebaseFirestore.instance.batch();
  final productsCollection = FirebaseFirestore.instance.collection('products');

  for (var product in products) {
    final docRef = productsCollection.doc(); // Auto ID
    batch.set(docRef, product.toMap());
  }

  await batch.commit();
}

    Future<void> _uploadProducts() async {
   

    try {
      await uploadStaticProductsToFirestore();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Products uploaded to Firestore!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Upload failed: $e')),
      );
    } 
  }   */

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
              /*    ElevatedButton.icon(
                icon: Icon(Icons.cloud_upload),
                label: Text('Upload Static Products'),
                onPressed: _uploadProducts,
              ), */
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

  //welcome  cards
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

  Widget welcomeHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        color: themeColor(context: context).inversePrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Stack(
        children: [welcomeCardBackGroundImage(), lottieAnim(), welcomeCard()],
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

  //weather card
  Widget weatherCard() {
    return StreamBuilder<Weather>(
      stream: _weatherBloc.dailyWeather,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Card(
              child: Container(
                height: 100.h,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Card(
              child: Container(
                height: 100.h,
                child: Center(child: bodyText("No Weather data are available")),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Container(
              height: 100.h,
              child: Center(
                child: bodyText("Something went wrong.please try again later"),
              ),
            ),
          );
        }

        //weather data
        final today = DateTime.now();
        Weather? weather = snapshot.data;
        final tempData = weather?.list?.firstOrNull;
        final date = tempData?.dtTxt ?? today;
        final city = weather?.city?.name ?? "Unknown";
        final description = tempData?.weather?.first.description ?? "Unknown";
        final maxTemp = tempData?.main?.tempMax ?? 0;
        final minTemp = tempData?.main?.tempMin ?? 0;
        final temp = tempData?.main?.temp ?? 40;
        final humidity = tempData?.main?.humidity ?? 0;
        final pressure = tempData?.main?.pressure ?? 0;
        final windSpeed = tempData?.wind?.speed ?? 0;
        final icon = tempData?.weather?.first.icon ?? "";

        print("Weather list length: ${snapshot.data?.list?.length}");

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForecastScreen()),
              );
            },
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  color: themeColor(
                    context: context,
                  ).inversePrimary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.all(12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Weather Icon
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          [
                            Image.network(
                              "https://openweathermap.org/img/wn/$icon@2x.png",
                              width: 60.w,
                              height: 60.h,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.cloud_off,
                                    size: 60.sp,
                                    color:
                                        themeColor(
                                          context: context,
                                        ).onPrimaryContainer,
                                  ),
                            ),

                            Text(
                              date.format('MMM dd'),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color:
                                    themeColor(
                                      context: context,
                                    ).onPrimaryContainer,
                              ),
                            ),
                          ].separator(SizedBox(height: 8.h)).toList(),
                    ),

                    // Main Weather Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            [
                              //temp
                              bodyText("$temp °C"),

                              //description
                              bodyText(description),

                              //min mx temp
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    size: 16.sp,
                                    color:
                                        themeColor(context: context).secondary,
                                  ),
                                  SizedBox(width: 4.w),
                                  smallText("${minTemp.toStringAsFixed(1)} °C"),
                                  SizedBox(width: 16.w),
                                  Icon(
                                    Icons.arrow_upward,
                                    size: 16.sp,
                                    color:
                                        themeColor(context: context).secondary,
                                  ),
                                  SizedBox(width: 4.w),
                                  smallText("${maxTemp.toStringAsFixed(1)} °C"),
                                ],
                              ),
                            ].separator(SizedBox(height: 10.h)).toList(),
                      ),
                    ),
                    // Additional Stats
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop,
                              size: 20.sp,
                              color: themeColor(context: context).primary,
                            ),
                            SizedBox(width: 4.w),
                            smallText("$humidity%"),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children:
                              [
                                Icon(
                                  Icons.air,
                                  size: 20.sp,
                                  color: themeColor(context: context).primary,
                                ),

                                smallText("$windSpeed m/s"),
                              ].separator(SizedBox(width: 4.w)).toList(),
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
    );
  }

  //event
  Widget upComingEventCard() {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //today events and add button
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bodyMediumText("Today's Events"),
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
                              child: AddEventExpenseDialog(DateTime.now()),
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
          ),
          Consumer<EventExpenseProvider>(
            builder: (context, eventProvider, child) {
              final todayEvents = eventProvider.todayEvents;
              final todayEventsLength = todayEvents.length;

              //if no event added
              if (todayEventsLength == 0) {
                return Card(
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
                      "No events for today is added yet. Tap ➕ to get started!",
                      maxLine: 2,
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 130.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: todayEventsLength,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        eventCard(
                          upComingEvent: todayEvents,
                          index: index,
                          eventProvider: eventProvider,
                        ),
                        SizedBox(width: 12.w),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
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
    final event = upComingEvent[index];
    return Card(
      child: Container(
        padding: EdgeInsets.all(12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  [
                    Tooltip(
                      message: event.title,
                      child: bodyMediumBoldText(event.title),
                    ),
                    bodyText(event.category),
                    bodyText(DateFormat('dd-MM-yyyy').format(event.date)),
                  ].separator(SizedBox(height: 5.h)).toList(),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
