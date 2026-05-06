import 'package:dieaya_market/ui/pages/NotificationsScreen/notifications_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class NotificationService {
  static final instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  Future<void> initialize() async {
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
    final NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notification permissions granted.");
    } else {
      print("Notification permissions denied.");
    }



    // request permission locally

    // 🔹 Request permission for local notifications (flutter_local_notifications)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notifications (iOS)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // Show local notification
  Future<void> showNotification(RemoteMessage message) async {
    try{
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'local_channel_id',
          'local_channel',
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
      print('object');
      print('1234');

    }catch(e){
      throw e;
    }
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
      'local_channel_id', // Channel ID
      'local_channel', // Channel Name
      description: 'for flutter local notifications', // Channel description
      importance: Importance.max,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

