import 'dart:convert';
import 'package:dieaya_user/main.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/product_details_deep_link.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../Controllers/AuthController/profile_controller.dart';
import '../../../UI/pages/ProductsScreen/products_screen.dart';
import '../../../Utils/app_checker_update.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../models/product_model.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/buttons.dart';
import '../HomeScreen/home_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final AppLinks _appLinks = AppLinks();
  Uri? _initialUri;


  bool isCheckingUpdate = true;

  final _versionChecker = const AppVersionChecker(
    packageName: 'your.app.store.id',
    appStoreId: 'your.app.store.id',
  );

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 2.0).animate(_animationController);

    _animationController.forward();

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
          return; // Exit the function to wait for user to update
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
          title: CustomTextSolveIssue('updateRequired'.tr),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextSolveIssue('${'updateTitle'.tr} ($latestVersion)'),
              const SizedBox(height: 8),
              CustomTextSolveIssue('${'currentVersion'.tr}: $currentVersion'),
              const SizedBox(height: 16),
              CustomTextSolveIssue('updateSubTitle'.tr),
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

  // Future<void> _navigateAfterSplash() async {
  //   try {
  //     // Ensure a minimum delay of 3 seconds for the splash screen
  //     const splashDelay = Duration(seconds: 3);
  //     // Run both the delay and the update check concurrently
  //     await Future.wait([
  //       Future.delayed(splashDelay),
  //       _checkForUpdates(),
  //     ]);
  //
  //     if (!mounted || isCheckingUpdate) return;
  //
  //     bool hasSeenOnboarding = await SharedPrefsConstants.hasSeenOnboarding();
  //     bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
  //
  //     if (!hasSeenOnboarding) {
  //       Get.offNamed(AppRoutes.onboarding);
  //     } else if (isLoggedIn) {
  //       String? token = await SharedPrefsConstants.getToken();
  //       if (token != null && token.isNotEmpty) {
  //         // Fetch profile to verify token validity
  //         final profileController = Get.put(ProfileController());
  //         final profileFetched = await profileController.fetchProfile();
  //         if (profileFetched) {
  //           Get.offNamed(AppRoutes.navbar);
  //         } else {
  //           // Logout and remove token if profile fetch fails
  //           await SharedPrefsConstants.removeToken();
  //           Get.offNamed(AppRoutes.onboarding); // Redirect as guest
  //         }
  //       } else {
  //         // No token, treat as guest
  //         Get.offNamed(AppRoutes.navbar);
  //       }
  //     } else {
  //       // Not logged in, treat as guest
  //       Get.offNamed(AppRoutes.navbar);
  //     }
  //   } catch (e) {
  //     debugPrint('Error in _navigateAfterSplash: $e');
  //     // On error, logout and clear token
  //     await SharedPrefsConstants.removeToken();
  //     if (mounted) {
  //       Get.offNamed(AppRoutes.onboarding); // Redirect as guest
  //     }
  //   }
  // }


  Future<void> _navigateAfterSplash() async {
    try {
      const splashDelay = Duration(seconds: 3);
      await Future.wait([
        Future.delayed(splashDelay),
        _checkForUpdates(),
        _getInitialLink(), // 🔥 fetch link if any
      ]);

      if (!mounted || isCheckingUpdate) return;

      // ✅ Handle deep link if present
      if (_initialUri != null && _initialUri!.path == '/product') {
        final id = _initialUri!.queryParameters['id'];
        if (id != null) {
          final product = await fetchProductById(id); // your custom logic
          if (product != null) {
            Get.off(() => ProductScreenDeepLink(
                productId: product.id.toString()));
            return;
          }
        }
      }

      // 🔁 Continue with normal flow
      bool hasSeenOnboarding = await SharedPrefsConstants.hasSeenOnboarding();
      bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();

      if (!hasSeenOnboarding) {
        Get.offNamed(AppRoutes.onboarding);
      } else if (isLoggedIn) {
        String? token = await SharedPrefsConstants.getToken();
        if (token != null && token.isNotEmpty) {
          final profileController = Get.put(ProfileController());
          final profileFetched = await profileController.fetchProfile();
          if (profileFetched) {
            Get.offNamed(AppRoutes.navbar);
          } else {
            await SharedPrefsConstants.removeToken();
            Get.offNamed(kIsWeb?AppRoutes.navbar:AppRoutes.onboarding);
          }
        } else {
          Get.offNamed(AppRoutes.navbar);
        }
      } else {
        Get.offNamed(AppRoutes.navbar);
      }
    } catch (e) {
      debugPrint('Error in _navigateAfterSplash: $e');
      await SharedPrefsConstants.removeToken();
      if (mounted) {
        Get.offNamed(AppRoutes.onboarding);
      }
    }
  }
  Future<Product?> fetchProductById(String id) async {
    try {
      final response = await HttpService.instance.get(Uri.parse('${ApiConstants.baseUrl}/products/$id'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Product.fromJson(json); // your model
      }
    } catch (e) {
      debugPrint('Error fetching product: $e');
    }
    return null;
  }

  Future<void> _getInitialLink() async {
    try {
      _initialUri = await _appLinks.getInitialLink();
      _appLinks.uriLinkStream.listen((uri) {
        if (uri != null) {
          _initialUri = uri;
        }
      });
    } catch (e) {
      debugPrint('Error reading initial app link: $e');
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 1,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                child: LoadingAnimationWidget.newtonCradle(
                  color: AppColors.primary,
                  size: 100, // Add a loader
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}