import 'dart:io';

import 'package:dieaya_market/controllers/NotificationController/notification_controller.dart';
import 'package:dieaya_market/controllers/PackgesController/packges_controller.dart';
import 'package:dieaya_market/controllers/ProfileController/profile_controller.dart';
import 'package:dieaya_market/routes/app_routes.dart';
import 'package:dieaya_market/utils/api_constant.dart';
import 'package:dieaya_market/utils/app_colors.dart';
import 'package:dieaya_market/utils/app_translation.dart';
import 'package:dieaya_market/utils/caching_sevice/shared_preferences.dart';
import 'package:dieaya_market/utils/notification/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Controllers/LanguageController/language_controller.dart';
import 'controllers/InternetController/internet_controller.dart';
import 'controllers/PackgesController/buy_packge_controller.dart';
import 'controllers/ProductsControllers/product_controller.dart';
import 'controllers/ThemeController/theme_controller.dart';
import 'controllers/WhatsappController/whatsapp_controller.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:overlay_support/overlay_support.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.notification?.title}');
  // Add custom logic here (e.g., save to storage, update UI via a service)
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('🔒 User notification permission: ${settings.authorizationStatus}');

  // Wait for APNs token
  String? apnsToken;
  int retries = 10;

  if (!kIsWeb) {
    if (Platform.isIOS) {
      while (apnsToken == null && retries > 0) {
        await Future.delayed(Duration(seconds: 1));
        apnsToken = await messaging.getAPNSToken();
        retries--;
      }
      print('==================>$apnsToken');
      if (apnsToken == null) {
        print('❌ Failed to get APNs token after retry');
        return;
      }

      print('✅ APNs token: $apnsToken');
    }
  }
  // Now safe to get FCM token
  String? fcmToken = await messaging.getToken();
  print('✅ FCM Token: $fcmToken');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiConstants.baseUrl = "https://dev.admin.dieaya-plus.com/api";
  print('i am in dev flavor');
  await MySharedPreference.init();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyAhRG-Uoie2bJwQja2tBUvMZwHFHUSK05A",
            authDomain: "dieayap-793dd.firebaseapp.com",
            projectId: "dieayap-793dd",
            storageBucket: "dieayap-793dd.firebasestorage.app",
            messagingSenderId: "843945680710",
            appId: "1:843945680710:web:db90bf74a0963d236c4f47")
        : null,
  );
  await NotificationService.instance.initialize();

  Get.put(InternetController(), permanent: true);
  Get.put(ThemeController());
  Get.put(LanguageController());
  Get.put(ProductController());
  Get.put(PackageController());
  Get.put(BuyPackageController());
  Get.put(WhatsAppCampaignController());
  Get.put(NotificationController());
  setupFirebaseMessaging();

  // try {
  //   if (Platform.isAndroid) {
  //     await Firebase.initializeApp(
  //       options: const FirebaseOptions(
  //         apiKey: 'AIzaSyBCuoMUwDdng1rRJ3FUzijRJwjSXBT7zUA',
  //         appId: '1:843945680710:android:f6551df9ece104516c4f47',
  //         messagingSenderId: '843945680710',
  //         projectId: 'dieayap-793dd',
  //       ),
  //     );
  //   } else {
  //     await Firebase.initializeApp();
  //   }
  //   print('Firebase initialized successfully');
  // } catch (e) {
  //   print('Error initializing Firebase: $e');
  // }
  await GetStorage.init();
  await AppTranslations.loadTranslations();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // This callback runs when a notification arrives while the app is in foreground
    print("Message received in foreground: ${message.notification?.title}");
    NotificationService.instance.showNotification(message);
  });

  // Request notification permissions (iOS-specific, harmless on Android)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  // // Get the FCM token (optional, for targeting specific devices)
  // String? token = await messaging.getToken();
  // print('FCM Token: $token');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final LanguageController languageController = Get.put(LanguageController());

    return Obx(() => OverlaySupport(
      child: GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'app_title'.tr,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryDark,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeController.themeMode.value,
            locale: languageController.locale.value,
            fallbackLocale: const Locale('ar'),

            translations: AppTranslations(),
            initialRoute: !kIsWeb ? AppRoutes.splash : AppRoutes.login,
            getPages: AppRoutes.routes,
          ),
    ));
  }
}

// Define a navigator key
final navigatorKey = GlobalKey<NavigatorState>();

// Create Alice with the navigator key
final alice = Alice(navigatorKey: navigatorKey);
