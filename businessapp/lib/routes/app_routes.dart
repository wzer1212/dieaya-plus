import 'package:dieaya_market/ui/pages/AuthScreens/auth_main.dart';
import 'package:dieaya_market/ui/pages/AuthScreens/login_screen.dart';
import 'package:dieaya_market/ui/pages/AuthScreens/register_screen.dart';
import 'package:dieaya_market/ui/pages/ProfileScreens/edit_profile_screen.dart';
import 'package:dieaya_market/ui/widgets/navbar.dart';
import 'package:get/get.dart';

import '../ui/pages/AuthScreens/success_register.dart';
import '../ui/pages/NotificationsScreen/notifications_screen.dart';
import '../ui/pages/ProfileScreens/priavcy_policy.dart';
import '../ui/pages/ProfileScreens/terms_condations.dart';
import '../ui/pages/ProfileScreens/who_us.dart';
import '../ui/pages/SplashScreen/splash_screen.dart';
import '../ui/pages/SubscreptionScreens/ios_subscriptions_screen.dart';


class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const navbar = '/navbar';
  static const auth = '/auth';
  static const register = '/register';
  static const login = '/login';
  static const successRegister = '/successRegister';
  static const editProfile = '/editProfile';
  static const  terms = '/terms';
  static const String privacy = '/privacy';
  static const String subscriptionScreen = '/subscreptions_screen';

  static const  about = '/about';
  static const  notifications = '/notifications';
  static const  sub = '/sub';



  static List<GetPage> routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.navbar, page: () => const Navbar()),
    GetPage(name: AppRoutes.auth, page: () => const AuthMain()),
    GetPage(name: AppRoutes.successRegister, page: () => const SuccessRegister()),
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.login, page: () =>  LoginScreen()),
    GetPage(name: AppRoutes.terms, page: () => const TermsConditionsScreen()),
    GetPage(name: AppRoutes.about, page: () => const AboutApp()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsScreen()),
    GetPage(name: AppRoutes.sub, page: () => const IosSubscriptionsScreen()),
    GetPage(name: AppRoutes.privacy, page: () => const PrivacyPolicy()),
    GetPage(name: AppRoutes.subscriptionScreen, page: () => const IosSubscriptionsScreen()),

  ];
}
