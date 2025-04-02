import 'package:agri_flutter/models/user.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/providers/farm_state_provider.dart/crop_details_provider.dart';
import 'package:agri_flutter/providers/farm_state_provider.dart/liveStock_provider.dart';
import 'package:agri_flutter/providers/location_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
import 'package:agri_flutter/services/noti_service.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

//local noti
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  // Initialize timezone
  tz.initializeTimeZones();

  //  Initialize notifications via NotificationService
  await NotificationService.initNotifications();

  DateTime now = DateTime.now().add(Duration(seconds: 5));
  NotificationService.scheduleNotification("Test Event", now);
  print("📅 Notification Scheduled for: $now");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => EventExpenseProvider()),
        ChangeNotifierProvider(create: (context) => LivestockProvider()),
        ChangeNotifierProvider(create: (context) => CropDetailsProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => WeatherViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Farm Nest',

          theme: AppThemes.lightTheme, // Apply light theme
          darkTheme: AppThemes.darkTheme, // Apply dark theme
          themeMode: ThemeMode.system,

          home: SplashScreen(),
        );
      },
    );
  }
}
