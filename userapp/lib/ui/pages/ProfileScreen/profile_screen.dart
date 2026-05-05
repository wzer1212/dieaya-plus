import 'dart:io';

import 'package:dieaya_user/UI/pages/AuthScreens/auth_screen.dart';
import 'package:dieaya_user/UI/pages/HomeScreen/home_screen.dart';
import 'package:dieaya_user/UI/pages/SplashScreen/splash_screen.dart';
import 'package:dieaya_user/ui/pages/ProfileScreen/my_favs_screen.dart';
import 'package:dieaya_user/ui/pages/dashboard/navbar.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Controllers/AuthController/profile_controller.dart';
import '../../../Controllers/LanguageController/language_controller.dart';
import '../../../Routes/app_routes.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/AuthController/delete_acc_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../utils/app_sharedprefs_contants.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_sheets.dart';
import 'package:flutter_svg/svg.dart';

import '../NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final ThemeController themeController = Get.put(ThemeController());
  final LanguageController languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final isLoggedIn = await SharedPrefsConstants.isLoggedIn();
    if (isLoggedIn) {
      await profileController.fetchProfile();
    }
  }

  Future<void> _resetAppState() async {
    Get.deleteAll();
    SharedPrefsConstants.removeToken();
    // Explicitly set the theme after logout
    bool isDarkMode = themeController.themeMode.value == ThemeMode.dark;
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  void _launchAppOrStore(String appUrlScheme, String playStoreUrl,
      {String? appName}) async {
    Uri appUri = Uri.parse(appUrlScheme);
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      Uri storeUri = Uri.parse(playStoreUrl);
      if (await canLaunchUrl(storeUri)) {
        await launchUrl(storeUri, mode: LaunchMode.externalApplication);
      } else {
        // SnackbarUtils.showErrorSnackbar(
        //   "Error".tr,
        //   "Could not open ${appName ?? 'the application'}. Please check your internet connection or try manually.".tr,
        // );
      }
    }
  }

  void openApp(String playStoreUrl) async {
    Uri storeUri = Uri.parse(playStoreUrl);
    if (await canLaunchUrl(storeUri)) {
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch Play Store URL');
    }
  }

  ScrollController _scrollController = ScrollController();

  // Define app store links
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.dieayaplus.user'; // Replace with your app's Play Store URL
  static const String _appStoreUrl =
      'https://apps.apple.com/app/id1234567890'; // Replace with your app's App Store URL
  static const String _appName =
      'Dieaya Plus - دعاية بلس'; // Replace with your app's name
  // void _shareApp() {
  //   final String shareUrl = Platform.isAndroid ? _playStoreUrl : _appStoreUrl;
  //   final String shareText = 'تحقق من تطبيق Dieaya Plus'.trParams({
  //     'appName': _appName,
  //     'shareUrl': shareUrl,
  //   });
  //   Share.share(shareText, subject: 'شارك تطبيق Dieaya Plus - دعاية بلس'.trParams({'appName': _appName}));
  // }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AdaptiveLayOut(
        mobile: Scaffold(
          body: Column(
            children: [
              Obx(
                () {
                  bool isDark =
                      themeController.themeMode.value == ThemeMode.dark;

                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary,
                          AppColors.primary,
                          isDark ? Colors.black : Colors.white,
                        ],
                        stops: const [0.0, 0.0, 5.0],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10, vertical: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: SizedBox(
                                width: 30,
                              )),
                          Expanded(
                            child: CustomTextSolveIssue(
                              'myAccount'.tr,
                              style: GoogleFonts.tajawal(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: isDark ? Colors.white : Colors.white,
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Stack(
                                children: [
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/svg/notify.svg',
                                      width: 24,
                                      height: 24,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black54,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    onPressed: () async {
                                      bool isLoggedIn =
                                          await SharedPrefsConstants
                                              .isLoggedIn();
                                      if (isLoggedIn) {
                                        Get.to(() => NotificationsScreen());
                                      } else {
                                        CustomSheets.showLoginSheet(context);
                                        print(
                                            'Favorites Tapped - Showing Login Bottom Sheet');
                                      }
                                    },
                                  ),
                                  Positioned(
                                    // end: 11,
                                    right: 11,
                                    top: 14,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 8,
                                        minHeight: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: Obx(() {
                  bool isDark =
                      themeController.themeMode.value == ThemeMode.dark;
                  final bool isArabic = Get.locale?.languageCode == 'ar';
                  return SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Container(
                      color: isDark ? Colors.black : Colors.white,
                      child: Column(
                        children: [
                          FutureBuilder<bool>(
                            future: SharedPrefsConstants.isLoggedIn(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final bool isLoggedIn = snapshot.data ?? false;
                              return Obx(() {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          bottom: Radius.circular(50.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.4),
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: isDark
                                                      ? Colors.white
                                                      : Colors.white,
                                                  child: profileController
                                                          .isLoading.value
                                                      ? const CircularProgressIndicator()
                                                      : isLoggedIn &&
                                                              profileController
                                                                      .profile
                                                                      .value !=
                                                                  null &&
                                                              profileController
                                                                      .profile
                                                                      .value!
                                                                      .image !=
                                                                  null
                                                          ? ClipOval(
                                                              child:
                                                                  Image.network(
                                                                profileController
                                                                    .profile
                                                                    .value!
                                                                    .image!,
                                                                width: 60,
                                                                height: 60,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder:
                                                                    (context,
                                                                            error,
                                                                            stackTrace) =>
                                                                        Icon(
                                                                  Icons.person,
                                                                  size: 50,
                                                                  color: isDark
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                              ),
                                                            )
                                                          : Icon(
                                                              Icons.person,
                                                              size: 50,
                                                              color: isDark
                                                                  ? Colors.grey
                                                                  : Colors.grey,
                                                            ),
                                                ),
                                                const SizedBox(width: 25),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomTextSolveIssue(
                                                      isLoggedIn &&
                                                              profileController
                                                                      .profile
                                                                      .value !=
                                                                  null
                                                          ? profileController
                                                              .profile
                                                              .value!
                                                              .name
                                                          : 'guest'.tr,
                                                      style:
                                                          GoogleFonts.tajawal(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isDark
                                                            ? Colors.white
                                                            : Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    CustomTextSolveIssue(
                                                      isLoggedIn &&
                                                              profileController
                                                                      .profile
                                                                      .value !=
                                                                  null
                                                          ? profileController
                                                              .profile
                                                              .value!
                                                              .email
                                                          : '',
                                                      style:
                                                          GoogleFonts.tajawal(
                                                        fontSize: 16,
                                                        color: isDark
                                                            ? Colors.grey
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if (isLoggedIn)
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                      AppRoutes.editProfile);
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/svg/profile/Edit Square.svg',
                                                  width: 30,
                                                  height: 30,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    _buildMenuItem(
                                      iconPath: 'assets/svg/fullheart2.svg',
                                      label: 'favorites list'.tr,
                                      onTap: () async {
                                        bool isLoggedIn =
                                            await SharedPrefsConstants
                                                .isLoggedIn();
                                        if (isLoggedIn) {
                                          Get.to(() => MyFavScreen());
                                        } else {
                                          CustomSheets.showLoginSheet(context);
                                          print(
                                              'Favorites Tapped - Showing Login Bottom Sheet');
                                        }
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Notification 3.svg',
                                      label: 'read notifications'.tr,
                                      onTap: () async {
                                        bool isLoggedIn =
                                            await SharedPrefsConstants
                                                .isLoggedIn();
                                        if (isLoggedIn) {
                                          Get.to(() => NotificationsScreen());
                                        } else {
                                          CustomSheets.showLoginSheet(context);
                                          print(
                                              'Favorites Tapped - Showing Login Bottom Sheet');
                                        }
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath: 'assets/svg/share.svg',
                                      label: 'share app'.tr,
                                      onTap: () {
                                        var appLink = Platform.isIOS
                                            ? 'https://apps.apple.com/eg/app/dieaya-plus-%D8%AF%D8%B9%D8%A7%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3/id6664065244'
                                            : 'https://play.google.com/store/apps/details?id=com.dieayaplus.user';

                                        final box = context.findRenderObject() as RenderBox?;
                                        final sharePositionOrigin = box != null
                                            ? box.localToGlobal(Offset.zero) & box.size
                                            : Rect.fromLTWH(0, 0, screenWidth, screenHeight / 2);

                                        Share.share(
                                          '$appLink',
                                          sharePositionOrigin: sharePositionOrigin,
                                        );
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Shield Tick.svg',
                                      label: 'usage policy'.tr,
                                      onTap: () {
                                        Get.toNamed(AppRoutes.terms);
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Shield Tick.svg',
                                      label: 'termsConditions'.tr,
                                      onTap: () {
                                        Get.toNamed(AppRoutes.privacy);
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Danger Circle.svg',
                                      label: 'about app'.tr,
                                      onTap: () {
                                        Get.toNamed(AppRoutes.about);
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Calling 2.svg',
                                      label: 'contact us'.tr,
                                      onTap: () {
                                        _showContactUsDialog(context);
                                      },
                                    ),
                                    Obx(() => _buildMenuItem(
                                          iconPath:
                                              'assets/svg/profile/language-icon.svg',
                                          label: 'change_lang'.tr,
                                          onTap: () {
                                            String newLanguage =
                                                languageController.locale.value
                                                            .languageCode ==
                                                        'ar'
                                                    ? 'en'
                                                    : 'ar';
                                            languageController
                                                .changeLanguage(newLanguage);
                                          },
                                        )),
                                    Obx(() => _buildMenuItem(
                                          iconPath: themeController
                                                      .themeMode.value ==
                                                  ThemeMode.dark
                                              ? 'assets/svg/profile/Graph.svg'
                                              : 'assets/svg/profile/Graph.svg',
                                          label: 'theme mode'.tr,
                                          onTap: () {
                                            themeController.setThemeMode(
                                              themeController.themeMode.value ==
                                                      ThemeMode.dark
                                                  ? ThemeMode.light
                                                  : ThemeMode.dark,
                                            );
                                          },
                                        )),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/User Tag.svg',
                                      label: 'become merchant'.tr,
                                      onTap: () {
                                        var url = Platform.isIOS
                                            ? 'https://apps.apple.com/eg/app/%D8%AF%D8%B9%D8%A7%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3-%D8%A3%D8%B9%D9%85%D8%A7%D9%84/id6633412575'
                                            : 'https://play.google.com/store/apps/details?id=com.dieayaplus.market';
                                        openApp(url);
                                      },
                                    ),
                                    if (isLoggedIn)
                                      _buildMenuItem(
                                        iconPath:
                                            'assets/svg/profile/Delete 2.svg',
                                        label: 'delete account'.tr,
                                        onTap: () {
                                          _showDeleteAccountDialog(context);
                                        },
                                      ),
                                    const SizedBox(height: 20),
                                    if (isLoggedIn)
                                      GestureDetector(
                                        onTap: () {
                                          _showLogoutDialog(context);
                                        },
                                        child: Container(
                                          margin: const EdgeInsetsDirectional
                                              .symmetric(
                                              vertical: 5, horizontal: 10),
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(
                                              horizontal: 25, vertical: 18),
                                          child: Row(
                                            textDirection: isArabic
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            // mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: CustomTextSolveIssue(
                                                  profileController
                                                          .isLoading.value
                                                      ? 'logging out'.tr
                                                      : 'logout'.tr,
                                                  style: GoogleFonts.tajawal(
                                                    fontSize: 16,
                                                    color: AppColors.red,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/svg/profile/Logout.svg',
                                                width: 24,
                                                height: 24,
                                                color: AppColors.red,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (!isLoggedIn)
                                      GestureDetector(
                                        child: Container(
                                          margin: const EdgeInsetsDirectional
                                              .symmetric(
                                              vertical: 5, horizontal: 10),
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(
                                              horizontal: 25, vertical: 18),
                                          child: Row(
                                            textDirection: isArabic
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            // mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: CustomTextSolveIssue(
                                                  'login'.tr,
                                                  // textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                                  style: GoogleFonts.tajawal(
                                                    fontSize: 16,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/svg/profile/Logout.svg',
                                                width: 24,
                                                height: 24,
                                                color: AppColors.primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          CustomSheets.showLoginSheet(context);
                                        },
                                      ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        desktop: Scaffold(
          body: Column(
            children: [
              GlobalWebHeader(scrollController: _scrollController),
              Expanded(
                child: Obx(() {
                  bool isDark =
                      themeController.themeMode.value == ThemeMode.dark;
                  final bool isArabic = Get.locale?.languageCode == 'ar';
                  return Container(
                    color: isDark ? Colors.black : Colors.white,
                    child: ListView(
                      controller: _scrollController,
                      // shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 150.w),
                          child: FutureBuilder<bool>(
                            future: SharedPrefsConstants.isLoggedIn(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final bool isLoggedIn = snapshot.data ?? false;
                              return Obx(() {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          bottom: Radius.circular(50.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.4),
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: isDark
                                                      ? Colors.white
                                                      : Colors.white,
                                                  child: profileController
                                                          .isLoading.value
                                                      ? const CircularProgressIndicator()
                                                      : isLoggedIn &&
                                                              profileController
                                                                      .profile
                                                                      .value !=
                                                                  null &&
                                                              profileController
                                                                      .profile
                                                                      .value!
                                                                      .image !=
                                                                  null
                                                          ? ClipOval(
                                                              child:
                                                                  Image.network(
                                                                profileController
                                                                    .profile
                                                                    .value!
                                                                    .image!,
                                                                width: 60,
                                                                height: 60,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder:
                                                                    (context,
                                                                            error,
                                                                            stackTrace) =>
                                                                        Icon(
                                                                  Icons.person,
                                                                  size: 50,
                                                                  color: isDark
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                              ),
                                                            )
                                                          : Icon(
                                                              Icons.person,
                                                              size: 50,
                                                              color: isDark
                                                                  ? Colors.grey
                                                                  : Colors.grey,
                                                            ),
                                                ),
                                                const SizedBox(width: 25),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomTextSolveIssue(
                                                      isLoggedIn &&
                                                              profileController
                                                                      .profile
                                                                      .value !=
                                                                  null
                                                          ? profileController
                                                              .profile
                                                              .value!
                                                              .name
                                                          : 'guest'.tr,
                                                      style:
                                                          GoogleFonts.tajawal(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isDark
                                                            ? Colors.white
                                                            : Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    CustomTextSolveIssue(
                                                      isLoggedIn &&
                                                              profileController
                                                                      .profile
                                                                      .value !=
                                                                  null
                                                          ? profileController
                                                              .profile
                                                              .value!
                                                              .email
                                                          : '',
                                                      style:
                                                          GoogleFonts.tajawal(
                                                        fontSize: 16,
                                                        color: isDark
                                                            ? Colors.grey
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if (isLoggedIn)
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                      AppRoutes.editProfile);
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/svg/profile/Edit Square.svg',
                                                  width: 30,
                                                  height: 30,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    _buildMenuItem(
                                      iconPath: 'assets/svg/fullheart2.svg',
                                      label: 'favorites list'.tr,
                                      onTap: () async {
                                        bool isLoggedIn =
                                            await SharedPrefsConstants
                                                .isLoggedIn();
                                        if (isLoggedIn) {
                                          Get.to(() => MyFavScreen());
                                        } else {
                                          CustomSheets.showLoginSheet(context);
                                          print(
                                              'Favorites Tapped - Showing Login Bottom Sheet');
                                        }
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Notification 3.svg',
                                      label: 'read notifications'.tr,
                                      onTap: () async {
                                        bool isLoggedIn =
                                            await SharedPrefsConstants
                                                .isLoggedIn();
                                        if (isLoggedIn) {
                                          Get.to(() => NotificationsScreen());
                                        } else {
                                          CustomSheets.showLoginSheet(context);
                                          print(
                                              'Favorites Tapped - Showing Login Bottom Sheet');
                                        }
                                      },
                                    ),
                                    // _buildMenuItem(
                                    //   iconPath: 'assets/svg/share.svg',
                                    //   label: 'share app'.tr,
                                    //   onTap: () {
                                    //     var appLink = Platform.isIOS
                                    //         ? 'https://apps.apple.com/eg/app/dieaya-plus-%D8%AF%D8%B9%D8%A7%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3/id6664065244'
                                    //         : 'https://play.google.com/store/apps/details?id=com.dieayaplus.user';
                                    //     Share.share(
                                    //       '$appLink',
                                    //       sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
                                    //     );
                                    //   },
                                    // ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Shield Tick.svg',
                                      label: 'usage policy'.tr,
                                      onTap: () {
                                        Get.toNamed(AppRoutes.terms);
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Shield Tick.svg',
                                      label: 'termsConditions'.tr,
                                      onTap: () {
                                        Get.toNamed(AppRoutes.privacy);
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Danger Circle.svg',
                                      label: 'about app'.tr,
                                      onTap: () {
                                        Get.toNamed(AppRoutes.about);
                                      },
                                    ),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/Calling 2.svg',
                                      label: 'contact us'.tr,
                                      onTap: () {
                                        _showContactUsDialog(context);
                                      },
                                    ),
                                    Obx(() => _buildMenuItem(
                                          iconPath:
                                              'assets/svg/profile/language-icon.svg',
                                          label: 'change_lang'.tr,
                                          onTap: () {
                                            String newLanguage =
                                                languageController.locale.value
                                                            .languageCode ==
                                                        'ar'
                                                    ? 'en'
                                                    : 'ar';
                                            languageController
                                                .changeLanguage(newLanguage);
                                          },
                                        )),
                                    Obx(() => _buildMenuItem(
                                          iconPath: themeController
                                                      .themeMode.value ==
                                                  ThemeMode.dark
                                              ? 'assets/svg/profile/Graph.svg'
                                              : 'assets/svg/profile/Graph.svg',
                                          label: 'theme mode'.tr,
                                          onTap: () {
                                            themeController.setThemeMode(
                                              themeController.themeMode.value ==
                                                      ThemeMode.dark
                                                  ? ThemeMode.light
                                                  : ThemeMode.dark,
                                            );
                                          },
                                        )),
                                    _buildMenuItem(
                                      iconPath:
                                          'assets/svg/profile/User Tag.svg',
                                      label: 'become merchant'.tr,
                                      onTap: () {
                                        openApp(
                                            'https://play.google.com/store/apps/details?id=com.dieayaplus.market');
                                      },
                                    ),
                                    if (isLoggedIn)
                                      _buildMenuItem(
                                        iconPath:
                                            'assets/svg/profile/Delete 2.svg',
                                        label: 'delete account'.tr,
                                        onTap: () {
                                          _showDeleteAccountDialog(context);
                                        },
                                      ),
                                    const SizedBox(height: 20),
                                    if (isLoggedIn)
                                      GestureDetector(
                                        onTap: () {
                                          _showLogoutDialog(context);
                                        },
                                        child: Container(
                                          margin: const EdgeInsetsDirectional
                                              .symmetric(
                                              vertical: 5, horizontal: 10),
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(
                                              horizontal: 25, vertical: 18),
                                          child: Row(
                                            textDirection: isArabic
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            // mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: CustomTextSolveIssue(
                                                  profileController
                                                          .isLoading.value
                                                      ? 'logging out'.tr
                                                      : 'logout'.tr,
                                                  style: GoogleFonts.tajawal(
                                                    fontSize: 16,
                                                    color: AppColors.red,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/svg/profile/Logout.svg',
                                                width: 24,
                                                height: 24,
                                                color: AppColors.red,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (!isLoggedIn)
                                      GestureDetector(
                                        child: Container(
                                          margin: const EdgeInsetsDirectional
                                              .symmetric(
                                              vertical: 5, horizontal: 10),
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(
                                              horizontal: 25, vertical: 18),
                                          child: Row(
                                            textDirection: isArabic
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                            // mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: CustomTextSolveIssue(
                                                  'login'.tr,
                                                  // textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                                  style: GoogleFonts.tajawal(
                                                    fontSize: 16,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/svg/profile/Logout.svg',
                                                width: 24,
                                                height: 24,
                                                color: AppColors.primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          CustomSheets.showLoginSheet(context);
                                        },
                                      ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              });
                            },
                          ),
                        ),
                        FooterWidget(),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ));
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xff9C9C9C).withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextSolveIssue(
                label,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final DeleteAccountController deleteController =
        Get.put(DeleteAccountController());
    final TextEditingController confirmationController = TextEditingController();
    final RxBool isDeleteEnabled = false.obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          bool isDark = themeController.themeMode.value == ThemeMode.dark;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: kIsWeb ? 300.w : null,
              padding: const EdgeInsetsDirectional.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/social/deleteacc.svg',
                      height: 100,
                      width: 100,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.delete_forever,
                        size: 80,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextSolveIssue(
                      'confirm delete account'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    CustomTextSolveIssue(
                      'delete_confirmation_warning'.tr,
                      maxLines: 3,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: confirmationController,
                      onChanged: (value) {
                        isDeleteEnabled.value = value.trim() == 'DELETE';
                      },
                      decoration: InputDecoration(
                        labelText: 'type delete to confirm'.tr,
                        hintText: 'DELETE',
                        hintStyle: GoogleFonts.tajawal(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                      ),
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: deleteController.isLoading.value || !isDeleteEnabled.value
                          ? null
                          : () async {
                              final token =
                                  await SharedPrefsConstants.getToken() ?? '';
                              if (token.isEmpty) {
                                Get.snackbar(
                                  'error'.tr,
                                  'token not found'.tr,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }
                              final success =
                                  await deleteController.deleteAccount();
                              if (success) {
                                await _resetAppState();
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        padding:
                                            const EdgeInsetsDirectional.all(30),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'assets/images/check 1.png',
                                              height: 100,
                                            ),
                                            const SizedBox(height: 20),
                                            CustomTextSolveIssue(
                                              'account deleted'.tr,
                                              style: GoogleFonts.tajawal(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                            CustomButton(
                                              text: 'close'.tr,
                                              textSize: 22,
                                              textFontWeight: FontWeight.bold,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const Navbar()),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                Get.snackbar(
                                  'error'.tr,
                                  deleteController.errorMessage.value.isNotEmpty
                                      ? deleteController.errorMessage.value
                                      : 'delete account failed'.tr,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDeleteEnabled.value ? Colors.red : Colors.grey,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: CustomTextSolveIssue(
                        deleteController.isLoading.value
                            ? 'deleting'.tr
                            : 'delete'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: deleteController.isLoading.value
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      child: CustomTextSolveIssue(
                        'cancel'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showContactUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: kIsWeb ? 300.w : null,
            padding: const EdgeInsetsDirectional.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svg/social/contact_us.svg',
                  height: 80,
                  width: 80,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.phone,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextSolveIssue(
                  'contact us'.tr,
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialMediaIcon(
                      'assets/svg/social/social1.svg',
                      () => _launchSocialMedia(
                          'https://www.tiktok.com/@dieayaplus', 'TikTok'),
                    ),
                    const SizedBox(width: 15),
                    _socialMediaIcon(
                      'assets/svg/social/social2.svg',
                      () => _launchSocialMedia(
                          'https://www.instagram.com/dieayaplus/', 'Instagram'),
                    ),
                    const SizedBox(width: 15),
                    _socialMediaIcon(
                      'assets/svg/social/social3.svg',
                      () => _launchSocialMedia(
                          'https://wa.me/966535962469', 'WhatsApp'),
                    ),
                    const SizedBox(width: 15),
                    _socialMediaIcon(
                      'assets/svg/social/social4.svg',
                      () => _launchSocialMedia('https://x.com/dieayaplus', 'X'),
                    ),
                    // const SizedBox(width: 15),
                    // _socialMediaIcon(
                    //   'assets/svg/social/facebook.svg',
                    //       () => _launchSocialMedia(
                    //       'https://www.facebook.com/people/دعاية-بلس/61572834316837/', 'Facebook'),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchSocialMedia(String url, String platformName) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'error'.tr,
          'could_not_open'.trParams({'appName': platformName}),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Get.snackbar(
      //   'error'.tr,
      //   'error_opening'.trParams({'appName': platformName}),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  Widget _socialMediaIcon(String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        width: 40,
        height: 40,
        placeholderBuilder: (BuildContext context) => Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.link, color: AppColors.primary),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: kIsWeb ? 300.w : null,
            padding: const EdgeInsetsDirectional.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svg/profile/Logout.svg',
                  height: 100,
                  width: 100,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.logout,
                    size: 80,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextSolveIssue(
                  'confirm logout'.tr,
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final success = await profileController.logout();
                    if (success) {
                      await _resetAppState();
                      if (kIsWeb) {
                        Get.offAll(() => HomeScreen());
                        return;
                      }
                      Get.offAll(() => Navbar());
                      // Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => Navbar(),) , (_)=>false);
                    } else {
                      Get.snackbar(
                        'error'.tr,
                        profileController.errorMessage.value.isNotEmpty
                            ? profileController.errorMessage.value
                            : 'logout failed'.tr,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: CustomTextSolveIssue(
                    'yes'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  child: CustomTextSolveIssue(
                    'no'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
