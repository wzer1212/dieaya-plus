import 'dart:async';
import 'dart:io';
import 'package:dieaya_user/controllers/FavController/fav_controller.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/caching_sevice/shared_preferences.dart';
import 'package:dieaya_user/utils/notification/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alice/alice.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Controllers/AuthController/profile_controller.dart';
import 'Controllers/InternetController/internet_controller.dart';
import 'Controllers/LanguageController/language_controller.dart';
import 'Routes/app_routes.dart';
import 'Utils/app_colors.dart';
import 'Utils/app_translation.dart';
import 'controllers/AuthController/send_otp_controller.dart';
import 'controllers/NotificationController/notification_api_controller.dart';
import 'controllers/NotificationController/notification_controller.dart';
import 'controllers/OffersControllers/get_offer_controller.dart';
import 'controllers/ThemeController/theme_controller.dart';
import 'models/market_banneers_model.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:overlay_support/overlay_support.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print('🔔 Background message received: ${message.notification?.title}');
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

  apnsToken = await messaging.getAPNSToken();

  if (apnsToken == null) {
    print('❌ Failed to get APNs token after retry');
  }

  print('✅ APNs token: $apnsToken');

  // Now safe to get FCM token
  String? fcmToken = await messaging.getToken();
  print('✅ FCM Token: $fcmToken');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Firebase initialization for web + mobile

  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: 'AIzaSyBCuoMUwDdng1rRJ3FUzijRJwjSXBT7zUA',
            authDomain: 'dieayap-793dd.firebaseapp.com',
            projectId: 'dieayap-793dd',
            storageBucket: 'dieayap-793dd.appspot.com',
            messagingSenderId: '843945680710',
            appId: '1:843945680710:web:db90bf74a0963d236c4f47', // Replace this!
          )
        : null,
  );
  await NotificationService.instance.initialize();

  // Initialize local notifications
  MySharedPreference.init();
  setupFirebaseMessaging();
  await GetStorage.init();
  await AppTranslations.loadTranslations();

  // Dependency injection
  Get.put(NotificationController());
  Get.put(NotificationListController());
  Get.put(InternetController(), permanent: true);
  Get.put(ThemeController());
  Get.put(LanguageController());
  Get.put(ProfileController());
  Get.put(MarketOffersController());
  Get.put(MarketBannersController());
  Get.put(FavoriteController());
  Get.put(SendOtpController());

  // if (!kIsWeb) {
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //
  //   print('🔒 User notification permission: ${settings.authorizationStatus}');
  //
  //   String? token = await messaging.getToken();
  //   print('📲 FCM Token: $token');
  // }
  runApp(const MyApp());
  await DeepLinkingHandler.init(); // Initialize deep link handler
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final languageController = Get.put(LanguageController());
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'دعاية بلس',
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
        initialRoute: DeepLinkingHandler.initialRoute,
        getPages: AppRoutes.routes,
      ),
    );
  }
}

class DeepLinkingHandler {
  static const MethodChannel _channel =
      MethodChannel('com.dieayaplus.user/links');
  static String initialRoute = '';

  // Register the method channel listener
  static Future<void> init() async {
    initialRoute = !kIsWeb ? AppRoutes.splash : AppRoutes.home; // default

    // 1. Ask native if there was a cold start link
    final initialLink = await _channel.invokeMethod<String>('getInitialLink');

    if (initialLink != null) {
      print('🔥 Got cold start link: $initialLink');
      Uri uri = Uri.parse(initialLink);
      if (uri.pathSegments.isNotEmpty && uri.pathSegments[1] == 'product') {
        String productId = uri.pathSegments[2]; // extract productId
        print('🔥 Extracted productId: $productId');

        // Build a full route like /product_details/123
        initialRoute = '/product_details/$productId';
        //handel delay on Android
        if (Platform.isAndroid) {
          Get.offAllNamed(initialRoute);
        }
      }
      if (uri.pathSegments.isNotEmpty && uri.pathSegments[1] == 'market') {
        String marketId = uri.pathSegments[2]; // extract marketId
        print('🔥 Extracted marketId: $marketId');

        // Build a full route like /market_details/123
        initialRoute = '/store_details/$marketId';
        //handel delay on Android
        if (Platform.isAndroid) {
          Get.offAllNamed(initialRoute);
        }
      }
      if (uri.pathSegments.isNotEmpty && uri.pathSegments[1] == 'offer') {
        String offerId = uri.pathSegments[2]; // extract offerId
        print('🔥 Extracted offerId: $offerId');

        // Build a full route like /market_details/123
        initialRoute = '/offer_details/$offerId';
        //handel delay on Android
        if (Platform.isAndroid) {
          Get.offAllNamed(initialRoute);
        }
      }
    }

    // 2. Listen for links when app is already running
    _channel.setMethodCallHandler(_handleDeepLink);
  }

  // Handle the deep link
  static Future<void> _handleDeepLink(MethodCall call) async {
    if (call.method == 'onLinkOpened') {
      final String url = call.arguments['url'];
      print('🔥 Deep Link Opened: $url');

      // Parse the URL into a Uri object
      Uri uri = Uri.parse(url);

      // Check if the URI path matches the "product" route
      if (uri.pathSegments.isNotEmpty && uri.pathSegments[1] == 'product') {
        String productId =
            uri.pathSegments[2]; // Extract the productId from the URL
        print('🔥 Product ID: $productId');

        // Navigate to TestScreen (you can use productId for further navigation logic)
        Get.offAllNamed('/product_details/$productId');
      } else if (uri.pathSegments.isNotEmpty &&
          uri.pathSegments[1] == 'market') {
        String marketId = uri.pathSegments[2]; // extract marketId
        print('🔥 Extracted marketId: $marketId');

        Get.offAllNamed('/store_details/$marketId');
      } else if (uri.pathSegments.isNotEmpty &&
          uri.pathSegments[1] == 'offer') {
        String offerId = uri.pathSegments[2]; // extract offerId
        print('🔥 Extracted offerId: $offerId');

        Get.offAllNamed('/offer_details/$offerId');
      } else {
        print('🔴 Invalid deep link path');
      }
    }
  }
}





//
// // Define a navigator key
// final navigatorKey = GlobalKey<NavigatorState>();
//
// // Create Alice with the navigator key
// final alice = Alice(navigatorKey: navigatorKey);