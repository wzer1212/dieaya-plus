import 'package:dieaya_user/ui/pages/NotificationsScreen/notifications_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dieaya_user/utils/dev_runtime_config.dart';


class NotificationService {
  static final instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  Future<void> initialize() async {
    if (!DevRuntimeConfig.canUseFcm) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();  // Correct class for iOS

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationSelect);

    // Create notification channel for Android
    await _createNotificationChannel();

    // Request permissions for iOS
    await _requestPermission();
  }


  // Request notification permission for iOS
  Future<void> _requestPermission() async {
    if (!DevRuntimeConfig.canUseFcm) return;

    final NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notification permissions granted.");
    } else {
      print("Notification permissions denied.");
    }
  }

  // Show local notification
  Future<void> showNotification(RemoteMessage message) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  // Handle notification tap
  Future<void> _onNotificationSelect(NotificationResponse response) async {
    print('Notification tapped: ${response.payload}');
    // You can navigate or perform other actions based on the response
    Get.to(()=>NotificationsScreen());
  }

  // Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id', // Channel ID
      'your_channel_name', // Channel Name
      description: 'Your channel description', // Channel description
      importance: Importance.max,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
