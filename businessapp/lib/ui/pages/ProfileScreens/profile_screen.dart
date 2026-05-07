import 'dart:io';

import 'package:dieaya_market/controllers/NotificationController/notification_api_controller.dart';
import 'package:dieaya_market/ui/pages/AuthScreens/auth_main.dart';
import 'package:dieaya_market/ui/pages/ProfileScreens/test_in_app_purchasw.dart';
import 'package:dieaya_market/ui/pages/ProfileScreens/widgets/profile_header.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/android_subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Controllers/LanguageController/language_controller.dart';
import '../../../Routes/app_routes.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/ProfileController/delete_acc_controller.dart';
import '../../../controllers/ProfileController/profile_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../utils/caching_sevice/app_sharedprefs_contants.dart';

import 'package:flutter_svg/svg.dart';

import '../../widgets/buttons.dart';
import '../WhatsappScreen/whatsapp_screen.dart';

class _ProfileHeaderShimmer extends StatelessWidget {
  final bool isDark;

  const _ProfileHeaderShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final Color base =
        isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade300;
    final Color highlight =
        isDark ? Colors.white.withOpacity(0.12) : Colors.grey.shade100;

    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Row(
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 14,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

  void openAppInPlayStore(String playStoreUrl) async {
    Uri storeUri = Uri.parse(playStoreUrl);

    if (Platform.isIOS) {
      // Primary: https URL (external)
      final https = Uri.parse('https://apps.apple.com/app/id6664065244');

      // Fallback: itms-apps (direct to App Store app)
      final itms = Uri.parse('itms-apps://itunes.apple.com/app/id6664065244');

      final ok = await launchUrl(https, mode: LaunchMode.externalApplication);
      if (!ok) {
        await launchUrl(itms, mode: LaunchMode.inAppWebView);
      }
      return;
    }

    if (await canLaunchUrl(storeUri)) {
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch Play Store URL');
    }
  }

// 6633412575
  Future<void> _resetAppState() async {
    // Get.deleteAll();
    SharedPrefsConstants.removeToken();
  }

  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.dieayaplus.market'; // Replace with your app's Play Store URL
  static const String _appStoreUrl =
      'https://apps.apple.com/app/id1234567890'; // Replace with your app's App Store URL
  static const String _appName =
      'دعاية بلس أعمال'; // Replace with your app's name

  void _shareApp() {
    final String shareUrl = Platform.isAndroid ? _playStoreUrl : _appStoreUrl;
    final String shareText = 'تحقق من تطبيق دعاية بلس أعمال'.trParams({
      'appName': _appName,
      'shareUrl': shareUrl,
    });
    Share.share(shareText,
        subject: 'شارك تطبيق دعاية بلس أعمال'.trParams({'appName': _appName}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        bool isDark = themeController.themeMode.value == ThemeMode.dark;
        final bool isArabic = Get.locale?.languageCode == 'ar';
        return Container(
          color: isDark ? Colors.black : Colors.white,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                ProfileHeader(
                  isDark: isDark,
                ),
                FutureBuilder<bool>(
                  future: SharedPrefsConstants.isLoggedIn(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final bool isLoggedIn = snapshot.data ?? false;
                    return Obx(() {
                      return Column(
                        children: [
                          profileController.isLoading.value
                              ? _ProfileHeaderShimmer(
                                  isDark: isDark,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.black : Colors.white,
                                    borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(50.0),
                                        top: Radius.circular(50)),
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
                                    padding: EdgeInsets.only(
                                        left: 30, right: 30, bottom: 30),
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
                                                                  .logo !=
                                                              null
                                                      ? ClipOval(
                                                          child: Image.network(
                                                            profileController
                                                                .profile
                                                                .value!
                                                                .logo!,
                                                            width: 60,
                                                            height: 60,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Icon(
                                                              Icons.person,
                                                              size: 50,
                                                              color: isDark
                                                                  ? Colors.grey
                                                                  : Colors.grey,
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
                                                Text(
                                                  isLoggedIn &&
                                                          profileController
                                                                  .profile
                                                                  .value !=
                                                              null
                                                      ? profileController
                                                          .profile.value!.name!
                                                      : 'guest'.tr,
                                                  style: GoogleFonts.tajawal(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  isLoggedIn &&
                                                          profileController
                                                                  .profile
                                                                  .value !=
                                                              null
                                                      ? profileController
                                                          .profile.value!.email!
                                                      : '',
                                                  style: GoogleFonts.tajawal(
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
                                                  ? AppColors.primary
                                                  : AppColors.primary,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 30),
                          // _buildMenuItem(
                          //   iconPath:
                          //       'assets/svg/profile/whatsapp-logo-thin-svgrepo-com.svg',
                          //   label: 'add_whatsapp_campaign'.tr,
                          //   onTap: () {
                          //     Get.to(() => AddWhatsAppCampaignScreen());
                          //   },
                          // ),
                          _buildMenuItem(
                            iconPath: 'assets/svg/Dollar Circle.svg',
                            label: 'subscreption'.tr,
                            onTap: () {
                              // Get.to(()=>TestInAppPurchase());
                              // Get.to(()=>TestPayment());
                              var ios = Platform.isIOS;
                              ios
                                  ? Get.toNamed(AppRoutes.sub)
                                  : Get.to(() => AndroidSubscriptionsScreen());
                            },
                          ),
                          _buildMenuItem(
                            iconPath: 'assets/svg/profile/Notification 3.svg',
                            label: 'read notifications'.tr,
                            onTap: () {
                              Get.toNamed(AppRoutes.notifications);
                            },
                          ),
                          // _buildMenuItem(
                          //   iconPath: 'assets/svg/share.svg',
                          //   label: 'share app'.tr,
                          //   onTap: () async{
                          //
                          //
                          //     final appLink = Platform.isIOS
                          //         ? 'https://apps.apple.com/eg/app/%D8%AF%D8%B9%D8%A7%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3-%D8%A3%D8%B9%D9%85%D8%A7%D9%84/id6633412575'
                          //         : 'https://play.google.com/store/apps/details?id=com.dieayaplus.market&pcampaignid=web_share';
                          //     final box = context.findRenderObject() as RenderBox?;
                          //     if (box != null) {
                          //       final size = MediaQuery.of(context).size;
                          //
                          //       final sharePositionOrigin =Rect.fromCenter(
                          //         center: Offset(size.width / 2, size.height / 2),
                          //         width: 200,
                          //         height: 200,
                          //       );
                          //
                          //
                          //       await SharePlus.instance.share(
                          //         ShareParams(
                          //           text: appLink,
                          //           sharePositionOrigin: sharePositionOrigin,
                          //         ),
                          //       );
                          //     }
                          //     else{
                          //       Share.share('$appLink');
                          //     }
                          //   },
                          // ),
                          _buildMenuItem(
                            iconPath: 'assets/svg/profile/Shield Tick.svg',
                            label: 'usage policy'.tr,
                            onTap: () {
                              Get.toNamed(AppRoutes.terms);
                            },
                          ),
                          _buildMenuItem(
                            iconPath: 'assets/svg/profile/Shield Tick.svg',
                            label: 'terms_and_conditions'.tr,
                            onTap: () {
                              Get.toNamed(AppRoutes.privacy);
                            },
                          ),
                          _buildMenuItem(
                            iconPath: 'assets/svg/profile/Danger Circle.svg',
                            label: 'about app'.tr,
                            onTap: () {
                              Get.toNamed(AppRoutes.about);
                            },
                          ),
                          _buildMenuItem(
                            iconPath: 'assets/svg/profile/Calling 2.svg',
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
                                  String newLanguage = languageController
                                              .locale.value.languageCode ==
                                          'ar'
                                      ? 'en'
                                      : 'ar';
                                  languageController
                                      .changeLanguage(newLanguage);
                                },
                              )),
                          Obx(() => _buildMenuItem(
                                iconPath: themeController.themeMode.value ==
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
  iconPath: 'assets/svg/profile/User Tag.svg',
  label: 'app_name'.tr,
  onTap: () async {

    final Uri url = Uri.parse(
      'https://site.tcore.site/business',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

  },
),

await launchUrl(
  url,
  mode: LaunchMode.externalApplication,
);
                          ),
                          if (isLoggedIn)
                            _buildMenuItem(
                              iconPath: 'assets/svg/profile/Delete 2.svg',
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
                                margin: const EdgeInsetsDirectional.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 25, vertical: 18),
                                child: Row(
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        profileController.isLoading.value
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
                                margin: const EdgeInsetsDirectional.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 25, vertical: 18),
                                child: Row(
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
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
                                // CustomSheets.showLoginSheet(context);
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
    );
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
            Expanded(
              child: Text(
                label,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final DeleteAccountController deleteController =
        Get.put(DeleteAccountController());
    final TextEditingController confirmationController =
        TextEditingController();
    final RxBool isDeleteEnabled = false.obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsetsDirectional.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/social/deleteacc.svg',
                        height: 100,
                        width: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.delete_forever,
                          size: 80,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'confirm delete account'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'delete_confirmation_warning'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          color: Colors.grey[600],
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
                          labelText: 'type_delete_to_confirm'.tr,
                          hintText: 'type_delete_hint'.tr,
                          labelStyle: GoogleFonts.tajawal(fontSize: 14),
                          hintStyle: GoogleFonts.tajawal(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                        ),
                        style: GoogleFonts.tajawal(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: (deleteController.isLoading.value ||
                                !isDeleteEnabled.value)
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          padding:
                                              const EdgeInsetsDirectional.all(
                                                  30),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                'assets/images/check 1.png',
                                                height: 100,
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                'account deleted'.tr,
                                                style: GoogleFonts.tajawal(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                            const AuthMain()),
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
                                    deleteController
                                            .errorMessage.value.isNotEmpty
                                        ? deleteController.errorMessage.value
                                        : 'delete account failed'.tr,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
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
                        child: Text(
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
            ));
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
                Text(
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
        // Get.snackbar(
        //   'error'.tr,
        //   'could_not_open'.trParams({'appName': platformName}),
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
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
                Text(
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
                      Get.offAll(() => AuthMain());
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
                  child: Text(
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
                  child: Text(
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
