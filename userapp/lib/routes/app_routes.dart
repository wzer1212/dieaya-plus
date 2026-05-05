import 'package:dieaya_user/UI/pages/AuthScreens/login_screen.dart';
import 'package:dieaya_user/UI/pages/HomeScreen/home_screen.dart';
import 'package:dieaya_user/UI/pages/ProfileScreen/profile_screen.dart';
import 'package:dieaya_user/UI/pages/SplashScreen/splash_screen.dart';
import 'package:dieaya_user/Utils/app_colors.dart';
import 'package:dieaya_user/main.dart';
import 'package:dieaya_user/ui/pages/OffersScreen/offer_details_screen_deel_link.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/product_details_deep_link.dart';
import 'package:dieaya_user/ui/pages/ProfileScreen/privacy_policy.dart';
import 'package:dieaya_user/ui/pages/StoresScreen/store_details.dart';
import 'package:dieaya_user/ui/pages/categories_screen/categories_screen.dart';
import 'package:dieaya_user/ui/pages/dashboard/navbar.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../UI/pages/NotificationsScreen/notifications_screen.dart';
import '../UI/pages/OnboardingScreen/onboarding_screen.dart';
import '../UI/pages/ProfileScreen/edit_profile_screen.dart';
import '../UI/pages/ProfileScreen/my_favs_screen.dart';
import '../UI/pages/ProfileScreen/terms_condations.dart';
import '../UI/pages/ProfileScreen/who_us.dart';

class AppRoutes {
  static const emptyCase = '/';
  static const splash = '/splash';
  static const storeDetails = '/store_details/:id';
  static const deepLinkProductDetails = '/product_details/:id';
  static const deepLinkOfferDetails = '/offer_details/:id';
  static const home = '/home_screen';
  static const login = '/login';
  static const navbar = '/navbar';
  static const onboarding = '/onboarding';
  static const String editProfile = '/edit_profile';
  static const String notifications = '/notifications';
  static const String favorites = '/favorites';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String about = '/about';
  static const String categoriesScreen = '/categories_screen';
  static List<GetPage> routes = [
    // GetPage(name: AppRoutes.login, page: () => const AuthScreen()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen()),
    GetPage(
        name: AppRoutes.notifications, page: () => const NotificationsScreen()),
    // GetPage(name: AppRoutes.favorites, page: () => const MyFavScreen()),
    GetPage(name: AppRoutes.terms, page: () => TermsConditionsScreen()),
    GetPage(name: AppRoutes.privacy, page: () => PrivacyPolicy()),
    GetPage(name: AppRoutes.about, page: () => AboutApp()),
    GetPage(
        name: AppRoutes.deepLinkProductDetails,
        page: () {
          final productId = Get.parameters['id']!; // extract from URL
          return ProductScreenDeepLink(productId: productId);
        }),
    GetPage(
        name: AppRoutes.storeDetails,
        page: () {
          final marketId = Get.parameters['id']!; // extract from URL
          return StoreDetails(
            marketId: int.tryParse(marketId) ?? 0,
            isFromDeepLink: true,
          );
        }),
    GetPage(
        name: AppRoutes.deepLinkOfferDetails,
        page: () {
          final marketId = Get.parameters['id']!; // extract from URL
          return OfferDetailsScreenDeepLink(
            offerId: marketId,
            isFromDeepLink: true,
          );
        }),
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(name: emptyCase, page: () => EmptyScreen()),

    GetPage(
      name: navbar,
      page: () => const Navbar(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    // GetPage(
    //   name: login,
    //   page: () => LoginScreen(),
    // ),
    GetPage(
      name: onboarding,
      page: () => OnboardingScreen(),
    ),
    GetPage(
      name: favorites,
      page: () => MyFavScreen(),
    ),

    GetPage(
      name: categoriesScreen,
      page: () => CategoriesScreen(),
    ),
  ];
}

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Container(height: 300.h,
            width: 200.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.w),
                child: Image.asset('assets/images/icon_v.png'))),
      ),
    );
  }
}
