import 'dart:io';

import 'package:dieaya_market/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/android_subscription.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/ios_subscriptions_screen.dart';
import 'package:dieaya_market/ui/widgets/custom_verify_sheets.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../Utils/app_checker_update.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../../controllers/ProfileController/profile_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/buttons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  bool isCheckingUpdate = false;

  final _versionChecker = const AppVersionChecker(
    packageName: 'your.app.store.id',
    appStoreId: 'your.app.store.id',
  );

  @override
  void initState() {
    super.initState();

    // Bounce + Fade animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    _navigateAfterSplash();
  }

  Future<void> _checkForUpdates() async {
    try {
      final needsUpdate = await _versionChecker.needsUpdate(context);
      if (needsUpdate && mounted) {
        final currentVersion =
        await PackageInfo.fromPlatform().then((info) => info.version);
        final latestVersion =
        Theme.of(context).platform == TargetPlatform.android
            ? await _versionChecker.getLatestVersionFromPlayStore()
            : await _versionChecker.getLatestVersionFromAppStore();

        debugPrint('Current Version: $currentVersion');
        debugPrint('Latest Version: $latestVersion');

        if (mounted) {
          await _showUpdateDialog(currentVersion, latestVersion);
          return;
        }
      }
      if (mounted) {
        setState(() {
          isCheckingUpdate = false;
        });
      }
    } catch (e) {
      debugPrint('Error checking updates: $e');
      if (mounted) {
        setState(() {
          isCheckingUpdate = false;
        });
      }
    }
  }

  Future<void> _showUpdateDialog(
      String currentVersion,
      String? latestVersion,
      ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('updateRequired'.tr),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${'updateTitle'.tr} ($latestVersion)'),
              const SizedBox(height: 8),
              Text('${'currentVersion'.tr}: $currentVersion'),
              const SizedBox(height: 16),
              Text('updateSubTitle'.tr),
            ],
          ),
          actions: [
            Container(
              alignment: Alignment.centerRight,
              child: CustomButton(
                text: 'updateNow'.tr,
                onPressed: () => _versionChecker.launchStore(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateAfterSplash() async {
    try {
      const splashDelay = Duration(seconds: 3);
      await Future.wait([
        Future.delayed(splashDelay),
        _checkForUpdates(),
      ]);

      if (!mounted || isCheckingUpdate) return;

      bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
      debugPrint('Is logged in: $isLoggedIn');

      if (isLoggedIn) {
        String? token = await SharedPrefsConstants.getToken();
        if (token != null && token.isNotEmpty) {
          final ProfileController profileController =
          Get.put(ProfileController());
          bool profileFetched = await profileController.fetchProfile();

          if (!mounted) return;

          if (profileFetched && profileController.profile.value != null) {
            Get.offNamed(AppRoutes.navbar);
            // // final packageId = profileController.profile.value!.packageId;
            // final isVerified  = profileController.profile.value!.verified;
            // if (  isVerified   == 0) {
            //
            //   print("========> verified" + profileController.profile.value!.verified.toString());
            //   print("========> phone" + profileController.profile.value!.phone.toString());
            //   // var isIOs = Platform.isIOS;
            //   // Get.to(
            //   //         () => isIOs?SubscriptionsScreen():AndroidSubscriptionsScreen());
            //   var ph = profileController.profile.value!.phone;
            //   Get.to(() => VerifyPhoneWidget(phoneNumber: ph!));
            // } else {
            //   Get.offNamed(AppRoutes.navbar);
            // }
          } else {
            Get.offNamed(AppRoutes.auth);
          }
        }
        else {
          Get.offNamed(AppRoutes.auth);
        }
      } else {
        Get.offNamed(AppRoutes.auth);
      }
    } catch (e) {
      debugPrint('Error in _navigateAfterSplash: $e');
      if (mounted) {
        Get.offNamed(AppRoutes.auth);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor:isDark ?Colors.black:Color(0xff43C8FF),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/circle_full.svg',
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.height * 0.20,
            fit: BoxFit.none,
          ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.height * 0.30,
              child: SvgPicture.asset(
                'assets/images/circle_left_cut.svg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Image.asset(
                  'assets/images/4.png',
                  height: 169.h,
                  width: 170.h,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (isCheckingUpdate)
            Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.primary,
                size: 50,
              ),
            ),
        ],
      ),
    );
  }
}
