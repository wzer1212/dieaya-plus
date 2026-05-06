import 'dart:async';

import 'package:dieaya_user/config/environment.dart';
import 'package:dieaya_user/core/app_globals.dart';
import 'package:dieaya_user/controllers/AuthController/send_otp_controller.dart';
import 'package:dieaya_user/controllers/InternetController/internet_controller.dart';
import 'package:dieaya_user/controllers/LanguageController/language_controller.dart';
import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/routes/app_routes.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/app_translation.dart';
import 'package:dieaya_user/utils/caching_sevice/shared_preferences.dart';
import 'package:dieaya_user/utils/dev_runtime_config.dart';
import 'package:dieaya_user/utils/notification/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.notification?.title}');
}

Future<void> setupFirebaseMessaging() async {
  if (!DevRuntimeConfig.canUseFcm) {
    debugPrint('[FCM] Disabled for this DEV runtime.');
    return;
  }

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint('[FCM] Permission: ${settings.authorizationStatus}');
  debugPrint('[FCM] APNs token: ${await messaging.getAPNSToken()}');
  debugPrint('[FCM] FCM token: ${await messaging.getToken()}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApiConstants.baseUrl = Environment.DEV_BASE_URL;
  ApiConstants.shareBaseUrl = Environment.DEV_SHARE_BASE_URL;

  if (ApiConstants.baseUrl != Environment.DEV_BASE_URL) {
    throw StateError('DEV must use DEV_BASE_URL only.');
  }
  if (ApiConstants.baseUrl == Environment.PROD_BASE_URL ||
      ApiConstants.shareBaseUrl == Environment.PROD_SHARE_BASE_URL) {
    throw StateError('DEV must not use production URLs.');
  }

  await MySharedPreference.init();
  await GetStorage.init();
  await AppTranslations.loadTranslations();

  Get.put(InternetController(), permanent: true);
  Get.put(ThemeController());
  Get.put(LanguageController());
  Get.put(SendOtpController());

  DeepLinkingHandler.initialRoute =
      kIsWeb ? AppRoutes.navbar : AppRoutes.splash;

  runApp(const MyApp());
  unawaited(_initializeOptionalDevServicesAfterRunApp());
}

Future<void> _initializeOptionalDevServicesAfterRunApp() async {
  try {
    if (DevRuntimeConfig.canUseFcm) {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      await NotificationService.instance.initialize();
      await setupFirebaseMessaging();
    } else {
      debugPrint('[FCM] Skipped. DISABLE_FCM=true or Web runtime.');
    }
  } catch (e) {
    debugPrint('[FCM] Optional initialization failed: $e');
  }

  if (!kIsWeb) {
    try {
      await DeepLinkingHandler.init();
    } catch (e) {
      debugPrint('[DEEPLINK] Optional initialization failed: $e');
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return Obx(() {
      Widget app = GetMaterialApp(
        navigatorKey: appNavigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'دعاية بلس DEV',
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
      );

      if (!kIsWeb) {
        app = OverlaySupport(child: app);
      }

      return app;
    });
  }
}

class DeepLinkingHandler {
  static const MethodChannel _channel =
      MethodChannel('com.dieayaplus.user/links');
  static String initialRoute = AppRoutes.splash;

  static Future<void> init() async {
    if (kIsWeb) {
      initialRoute = AppRoutes.navbar;
      return;
    }

    initialRoute = AppRoutes.splash;

    final initialLink = await _channel.invokeMethod<String>('getInitialLink');
    if (initialLink != null) {
      _handleUrl(initialLink, navigateNow: false);
    }

    _channel.setMethodCallHandler(_handleDeepLink);
  }

  static Future<void> _handleDeepLink(MethodCall call) async {
    if (call.method == 'onLinkOpened') {
      final String url = call.arguments['url'];
      _handleUrl(url);
    }
  }

  static void _handleUrl(String url, {bool navigateNow = true}) {
    try {
      final uri = Uri.parse(url);

      if (uri.pathSegments.length >= 3 && uri.pathSegments[1] == 'product') {
        final productId = uri.pathSegments[2];
        initialRoute = '/product_details/$productId';
      } else if (uri.pathSegments.length >= 3 &&
          uri.pathSegments[1] == 'market') {
        final marketId = uri.pathSegments[2];
        initialRoute = '/store_details/$marketId';
      } else if (uri.pathSegments.length >= 3 &&
          uri.pathSegments[1] == 'offer') {
        final offerId = uri.pathSegments[2];
        initialRoute = '/offer_details/$offerId';
      } else {
        initialRoute = AppRoutes.splash;
      }

      if (navigateNow) {
        Get.offAllNamed(initialRoute);
      }
    } catch (e) {
      debugPrint('[DEEPLINK] Error parsing URL: $e');
      initialRoute = AppRoutes.splash;
    }
  }
}
