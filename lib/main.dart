import 'package:agri_flutter/models/user.dart';
import 'package:agri_flutter/presentation/post_sign_up/farm_detail.dart';
import 'package:agri_flutter/presentation/post_sign_up/farm_detail2.dart';
import 'package:agri_flutter/providers/api_provider/marker_price_provider.dart';
import 'package:agri_flutter/providers/api_provider/weather_provider.dart';
import 'package:agri_flutter/providers/eventExpense.dart/event_expense_provider.dart';
import 'package:agri_flutter/providers/farm_state_provider.dart/crop_details_provider.dart';
import 'package:agri_flutter/providers/farm_state_provider.dart/liveStock_provider.dart';
import 'package:agri_flutter/providers/location_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/cart_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/favorite_provider.dart';
import 'package:agri_flutter/providers/market_place_provider/product_provider.dart';
import 'package:agri_flutter/providers/password_provider.dart';
import 'package:agri_flutter/providers/user_provider.dart';
import 'package:agri_flutter/services/noti_service.dart';
import 'package:agri_flutter/theme/app_theme_bloc.dart';
import 'package:agri_flutter/theme/theme.dart';
import 'package:agri_flutter/theme/util.dart';
import 'package:agri_flutter/utils/navigation/navigation_utils.dart';
import 'package:agri_flutter/utils/shared_prefs_util.dart';
import 'package:agri_flutter/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  await SpUtil.getInstance();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  // Initialize timezone
  tz.initializeTimeZones();

  //  Initialize notifications via NotificationService
  await NotificationService.initNotifications();

  DateTime now = DateTime.now().add(Duration(seconds: 5));
  NotificationService.scheduleNotification("Test Event", now);
  print("📅 Notification Scheduled for: $now");

  final appThemeBloc = await AppThemeBloc.create();

  await SpUtil.getThemeMode();

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
        ChangeNotifierProvider(create: (context) => PasswordProvider()),
        ChangeNotifierProvider(create: (context) => ConfirmPasswordProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(
          create: (context) => MarkerPriceProvider()..loadInitialPrices(),
        ),
      ],
      child: BlocProvider(create: (_) => appThemeBloc, child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = createTextTheme(context, "Lato", "Lato");
    final MaterialTheme materialTheme = MaterialTheme(textTheme);

    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<AppThemeBloc, AppThemeState>(
          bloc: context.read<AppThemeBloc>(),
          builder: (context, state) {
            return MaterialApp(
              title: 'Farm Nest',
              debugShowCheckedModeBanner: false,
              theme: materialTheme.light(),
              darkTheme: materialTheme.dark(),
              themeMode: state.themeMode,
              navigatorKey: NavigationUtils.navigatorKey,
              home: SplashScreen(),
            );
          },
        );
      },
    );
  }
}
