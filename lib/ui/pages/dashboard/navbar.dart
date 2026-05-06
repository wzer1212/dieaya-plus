import 'package:dieaya_user/utils/notification/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controllers/LanguageController/language_controller.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../utils/dev_runtime_config.dart';
import '../CouponsScreen/coupons_screen.dart';
import '../HomeScreen/home_screen.dart';
import '../OffersScreen/offers_screen.dart';
import '../ProductsScreen/products_screen.dart';
import '../ProfileScreen/profile_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';


class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //  Configure Firebase listeners for foreground notifications
  void _configureFirebaseListeners() {
    if (!DevRuntimeConfig.canUseFcm) return;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
    });
  }

  // Show local notification
  Future<void> _showNotification(RemoteMessage message) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  static const List<String> _navIcons = [
    'assets/svg/shop.svg',
    'assets/svg/products.svg',
    'assets/svg/offers.svg',
    'assets/svg/Ticket 2.svg',
    'assets/svg/user.svg',
  ];

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProductsScreen(categoryId: '1'),
    const OffersScreen(),
    const CouponsScreen(),
    ProfileScreen(),
  ];

  final LanguageController languageController = Get.put(LanguageController());
  final ThemeController themeController =
      Get.put(ThemeController()); // Access ThemeController

  @override
  void initState() {
    super.initState();
    if (DevRuntimeConfig.canUseFcm) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message received');
        NotificationService.instance.showNotification(message);
      });
    }
    _currentIndex = 0;
  }

  List<String> get pageTitles => [
        'Shopping'.tr,
        'Products'.tr,
        'Offers'.tr,
        'Coupons'.tr,
        'myAccount'.tr,
      ];

  @override
  Widget build(BuildContext context) {
    if (pageTitles.length != _navIcons.length) {
      return const Scaffold(
          body: Center(
              child: CustomTextSolveIssue("Error: Navigation items mismatch")));
    }
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: GetBuilder<LanguageController>(
        builder: (_) => _buildCustomBottomNavBar(),
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Obx(() {
      // Use Obx to listen to themeMode
      bool isDark = themeController.themeMode.value == ThemeMode.dark;
      return Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navIcons.length, (index) {
            bool isSelected = _currentIndex == index;
            return _buildNavItem(
              index: index,
              iconPath: _navIcons[index],
              label: pageTitles[index],
              isSelected: isSelected,
              onTap: () {
                if (_currentIndex != index) {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
            );
          }),
        ),
      );
    });
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? AppColors.darkBlueBackground
                      : AppColors
                          .lightBlueBackground) // Use isDark for theme-based color
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8.0),
                    child: CustomTextSolveIssue(
                      label,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? AppColors.blue
                        : AppColors.grey.withOpacity(0.8),
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 5,
              width: 5,
              decoration: const BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 9),
        ],
      ),
    );
  }
}
