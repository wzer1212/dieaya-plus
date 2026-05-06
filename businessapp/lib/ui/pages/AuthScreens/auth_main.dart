import 'dart:convert';

import 'package:dieaya_market/ui/pages/AuthScreens/login_screen.dart';
import 'package:dieaya_market/ui/pages/AuthScreens/register_screen.dart';
import 'package:dieaya_market/ui/widgets/buttons.dart';
import 'package:dieaya_market/utils/app_colors.dart';
import 'package:dieaya_market/utils/responsive/adaptive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/ThemeController/theme_controller.dart';

class AuthMain extends StatelessWidget {
  const AuthMain({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return AdaptiveLayOut(
        mobile: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Stack(
            children: [
              Image.asset(
                'assets/images/tester.png',
                // width: double.infinity,
                // height: double.infinity,
                // fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'loginEnter'.tr,
                      onPressed: () {
                        Get.to(LoginScreen());
                      },
                      textSize: 22,
                      textFontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      textSize: 22,
                      textFontWeight: FontWeight.bold,
                      text: 'create_account'.tr,
                      textColor: AppColors.primary,
                      onPressed: () {
                        Get.to(RegisterScreen());
                      },
                      color: Colors.white,
                      borderColor: AppColors.primary,
                      borderWidth: 1,
                    ),
                    const SizedBox(height: 35),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _buildSocialContainer(
                    //       'assets/images/whats.png',
                    //       () => _launchSocialMedia(
                    //           'https://wa.me/966535962469', 'WhatsApp'),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     _buildSocialContainer(
                    //       'assets/images/face.png',
                    //       () => _launchSocialMedia(
                    //           'https://www.facebook.com/people/%D8%AF%D8%B9%D8%A7%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3/61572834316837/',
                    //           'Facebook'),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     _buildSocialContainer(
                    //       'assets/images/insta.png',
                    //       () => _launchSocialMedia(
                    //           'https://www.instagram.com/dieayaplus/',
                    //           'Instagram'),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     _buildSocialContainer(
                    //       'assets/images/tiktok.png',
                    //       () => _launchSocialMedia(
                    //           'https://www.tiktok.com/@dieayaplus', 'TikTok'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        desktop: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Stack(
            children: [
              Image.asset(
                'assets/images/tester.png',
                // width: double.infinity,
                // height: double.infinity,
                // fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'loginEnter'.tr,
                      onPressed: () {
                        Get.to(LoginScreen());
                      },
                      textSize: 22,
                      textFontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      textSize: 22,
                      textFontWeight: FontWeight.bold,
                      text: 'create_account'.tr,
                      textColor: AppColors.primary,
                      onPressed: () {
                        Get.to(RegisterScreen());
                      },
                      color: Colors.white,
                      borderColor: AppColors.primary,
                      borderWidth: 1,
                    ),
                    const SizedBox(height: 35),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _buildSocialContainer(
                    //       'assets/images/whats.png',
                    //       () => _launchSocialMedia(
                    //           'https://wa.me/966535962469', 'WhatsApp'),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     _buildSocialContainer(
                    //       'assets/images/face.png',
                    //       () => _launchSocialMedia(
                    //           'https://www.facebook.com/people/%D8%AF%D8%B9%D8%A7%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3/61572834316837/',
                    //           'Facebook'),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     _buildSocialContainer(
                    //       'assets/images/insta.png',
                    //       () => _launchSocialMedia(
                    //           'https://www.instagram.com/dieayaplus/',
                    //           'Instagram'),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     _buildSocialContainer(
                    //       'assets/images/tiktok.png',
                    //       () => _launchSocialMedia(
                    //           'https://www.tiktok.com/@dieayaplus', 'TikTok'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
    tablet:  Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/tester.png',
            // width: double.infinity,
            // height: double.infinity,
            // fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200,),
                CustomButton(
                  text: 'loginEnter'.tr,
                  onPressed: () {
                    Get.to(LoginScreen());
                  },
                  textSize: 22,
                  textFontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 25),
                CustomButton(
                  textSize: 22,
                  textFontWeight: FontWeight.bold,
                  text: 'create_account'.tr,
                  textColor: AppColors.primary,
                  onPressed: () {
                    Get.to(RegisterScreen());
                  },
                  color: Colors.white,
                  borderColor: AppColors.primary,
                  borderWidth: 1,
                ),
                const SizedBox(height: 35),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _buildSocialContainer(
                //       'assets/images/whats.png',
                //       () => _launchSocialMedia(
                //           'https://wa.me/966535962469', 'WhatsApp'),
                //     ),
                //     const SizedBox(width: 20),
                //     _buildSocialContainer(
                //       'assets/images/face.png',
                //       () => _launchSocialMedia(
                //           'https://www.facebook.com/people/%D8%AF%D8%B9%D8%A7%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3/61572834316837/',
                //           'Facebook'),
                //     ),
                //     const SizedBox(width: 20),
                //     _buildSocialContainer(
                //       'assets/images/insta.png',
                //       () => _launchSocialMedia(
                //           'https://www.instagram.com/dieayaplus/',
                //           'Instagram'),
                //     ),
                //     const SizedBox(width: 20),
                //     _buildSocialContainer(
                //       'assets/images/tiktok.png',
                //       () => _launchSocialMedia(
                //           'https://www.tiktok.com/@dieayaplus', 'TikTok'),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    ),);
  }

// Widget _buildSocialContainer(String imagePath, VoidCallback onTap) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 60, // Fixed width for all containers
//       height: 60, // Fixed height for all containers
//       decoration: BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: BorderRadius.circular(40),
//       ),
//       padding: const EdgeInsets.all(12), // Consistent padding
//       child: Image.asset(
//         imagePath,
//         fit: BoxFit.contain, // Ensure image fits within the container
//       ),
//     ),
//   );
// }
//
// Future<void> _launchSocialMedia(String url, String platformName) async {
//   final Uri uri = Uri.parse(url);
//   try {
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       // Get.snackbar(
//       //   'error'.tr,
//       //   'could_not_open'.trParams({'appName': platformName}),
//       //   backgroundColor: Colors.red,
//       //   colorText: Colors.white,
//       //   snackPosition: SnackPosition.BOTTOM,
//       // );
//     }
//   } catch (e) {
//     // Get.snackbar(
//     //   'error'.tr,
//     //   'error_opening'.trParams({'appName': platformName}),
//     //   backgroundColor: Colors.red,
//     //   colorText: Colors.white,
//     //   snackPosition: SnackPosition.BOTTOM,
//     // );
//   }
// }
}
