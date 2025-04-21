import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// **Initialize Notifications**
  static Future<void> initNotifications() async {
    print("🔄 Initializing Notifications...");

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    print("✅ Notifications Initialized");

    // Request permission for Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      bool? granted = await androidPlugin.requestNotificationsPermission();
      print("🛑 Notification Permission: $granted");
    }

    // Request Exact Alarm Permission for Android 12+
    if (Platform.isAndroid && await _checkExactAlarmPermission()) {
      print("✅ Exact Alarm Permission Granted");
    } else {
      print("❌ Exact Alarm Permission Denied");
    }

    // Initialize Timezones
    tz.initializeTimeZones();
  }

  /// **Check & Request Exact Alarm Permission (Android 12+)**
  static Future<bool> _checkExactAlarmPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.scheduleExactAlarm.status;

      if (status.isDenied) {
        print("⚠️ Requesting Exact Alarm Permission...");
        var result = await Permission.scheduleExactAlarm.request();
        return result.isGranted;
      }

      return status.isGranted;
    }
    return true;
  }

  /// **Schedule a Notification**
  static Future<void> scheduleNotification(
    String title,
    DateTime reminderTime,
  ) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Unique ID
      "Reminder: $title",
      "Your scheduled event is due now!",
      tz.TZDateTime.from(reminderTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'event_channel_id',
          'Event Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print("✅ Notification Scheduled Successfully");
  }

  /// **Cancel a Scheduled Notification**
  static Future<void> cancelNotification(int id) async {
    print("❌ Cancelling Notification with ID: $id");
    await _flutterLocalNotificationsPlugin.cancel(id);
    print("✅ Notification Cancelled");
  }

  Future<void> checkNotificationStatus() async {
    final bool? isGranted =
        await NotificationService._flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled();

    print("🔍 Notifications Enabled: $isGranted");
  }
}
