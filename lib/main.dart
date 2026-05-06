import 'dart:async';

import 'package:dieaya_user/controllers/FavController/fav_controller.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/caching_sevice/shared_preferences.dart';
import 'package:dieaya_user/utils/notification/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message received: ${message.notification?.title}');
}

Future<void> setupFirebaseMessaging() async {
  if (kIsWeb) return;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint(
    '🔒 User notification permission: ${settings.authorizationStatus}',
  );

  String? apnsToken = await messaging.getAPNSToken();

  if (apnsToken == null) {
    debugPrint('❌ Failed to get APNs token after retry');
  }

  debugPrint('✅ APNs token: $apnsToken');

  String? fcmToken = await messaging.getToken();
  debugPrint('✅ FCM Token: $fcmToken');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("🚀 [MAIN] Initializing app...");

  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: 'AIzaSyBCuoMUwDdng1rRJ3FUzijRJwjSXBT7zUA',
            authDomain: 'dieayap-793dd.firebaseapp.com',
            projectId: 'dieayap-793dd',
            storageBucket: 'dieayap-793dd.appspot.com',
            messagingSenderId: '843945680710',
            appId: '1:843945680710:web:db90bf74a0963d236c4f47',
          )
        : null,
  );

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationService.instance.initialize();
    await setupFirebaseMessaging();
  }

  await MySharedPreference.init();
  await GetStorage.init();
  await AppTranslations.loadTranslations();

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

  if (!kIsWeb) {
    await DeepLinkingHandler.init();
  } else {
    DeepLinkingHandler.initialRoute = AppRoutes.home;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    try {
      final themeController = Get.find<ThemeController>();
      final languageController = Get.find<LanguageController>();

      return Obx(() {
        return GetMaterialApp(
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
          initialRoute: DeepLinkingHandler.initialRoute.isNotEmpty
              ? DeepLinkingHandler.initialRoute
              : AppRoutes.home,
          getPages: AppRoutes.routes,
        );
      });
    } catch (e) {
      print("❌ [BUILD] Build failed: $e");
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('❌ حدث خطأ في تحميل التطبيق'),
                const SizedBox(height: 20),
                SelectableText(e.toString()),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class DeepLinkingHandler {
  static const MethodChannel _channel = MethodChannel(
    'com.dieayaplus.user/links',
  );

  static String initialRoute = AppRoutes.splash;

  static Future<void> init() async {
    if (kIsWeb) {
      initialRoute = AppRoutes.home;
      return;
    }

    initialRoute = AppRoutes.splash;

    final initialLink = await _channel.invokeMethod<String>('getInitialLink');

    if (initialLink != null) {
      debugPrint('🔥 Got cold start link: $initialLink');
      _handleUrl(initialLink, navigateNow: false);
    }

    _channel.setMethodCallHandler(_handleDeepLink);
  }

  static void _handleUrl(String url, {bool navigateNow = true}) {
    final Uri uri = Uri.parse(url);

    if (uri.pathSegments.length >= 3 && uri.pathSegments[1] == 'product') {
      final String productId = uri.pathSegments[2];
      initialRoute = '/product_details/$productId';

      if (navigateNow) {
        Get.offAllNamed(initialRoute);
      }
    } else if (uri.pathSegments.length >= 3 &&
        uri.pathSegments[1] == 'market') {
      final String marketId = uri.pathSegments[2];
      initialRoute = '/store_details/$marketId';

      if (navigateNow) {
        Get.offAllNamed(initialRoute);
      }
    } else if (uri.pathSegments.length >= 3 && uri.pathSegments[1] == 'offer') {
      final String offerId = uri.pathSegments[2];
      initialRoute = '/offer_details/$offerId';

      if (navigateNow) {
        Get.offAllNamed(initialRoute);
      }
    } else {
      debugPrint('🔴 Invalid deep link path');
    }
  }

  static Future<void> _handleDeepLink(MethodCall call) async {
    if (call.method == 'onLinkOpened') {
      final String url = call.arguments['url'];
      debugPrint('🔥 Deep Link Opened: $url');
      _handleUrl(url);
    }
  }
}
