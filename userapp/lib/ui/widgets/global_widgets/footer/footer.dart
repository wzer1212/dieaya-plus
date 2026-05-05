import 'package:dieaya_user/Utils/app_colors.dart';
import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/routes/app_routes.dart';
import 'package:dieaya_user/ui/pages/CouponsScreen/coupons_screen.dart';
import 'package:dieaya_user/ui/pages/OffersScreen/offers_screen.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/products_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer_sction_title.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer_section_bullet.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/share_button.dart';
import 'package:dieaya_user/utils/constants/image_constants.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FooterWidget extends StatelessWidget {
  FooterWidget({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      child: Column(
        children: [
          // About
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'dieaya_name'.tr,
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextSolveIssue(
                    'marketing_text'.tr,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.facebook,
                        color: AppColors.white,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Icon(
                        FontAwesomeIcons.twitter,
                        color: AppColors.white,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Icon(
                        FontAwesomeIcons.instagram,
                        color: AppColors.white,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Icon(
                        FontAwesomeIcons.tiktok,
                        color: AppColors.white,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FooterSectionsTitle(title: 'website_section'.tr),
                  SizedBox(
                    height: 6.h,
                  ),
                  FooterSectionBullet(
                    title: 'Products'.tr,
                    onTap: () {
                      Get.to(() => const ProductsScreen(categoryId: '1'));
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  FooterSectionBullet(
                    title: 'Offers'.tr,
                    onTap: () {
                      Get.to(
                        () => const OffersScreen(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  FooterSectionBullet(
                    title: 'Coupons'.tr,
                    onTap: () {
                      Get.to(
                        () => const CouponsScreen(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FooterSectionsTitle(title: 'technical_support'.tr),
                  SizedBox(
                    height: 5.h,
                  ),
                  InkWell(
                    onTap: () {
                      _launchSocialMedia(
                          'https://wa.me/966535962469', 'WhatsApp');
                    },
                    child: Row(
                      children: [
                        CustomTextSolveIssue(
                          'whatsapp'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.w,
                              color: AppColors.white),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Icon(FontAwesomeIcons.whatsapp,
                            color: Colors.white, size: 12.h),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),

                  // //download app
                  // FooterSectionsImaTitle(title: 'download_app'.tr),

                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            _launchSocialMedia(
                                'https://apps.apple.com/eg/app/dieaya-plus-%D8%AF%D8%B9%D8%A7%D9%8A%D8%A9-%D8%A8%D9%84%D8%B3/id6664065244',
                                'dieaya');
                          },
                          child: shareButton(
                              icon: isDark
                                  ? ImageConstants.appStoreLogoDark
                                  : ImageConstants.appStoreLogoLight)),
                      SizedBox(
                        width: 5.w,
                      ),
                      GestureDetector(
                          onTap: () {
                            _launchSocialMedia(
                                'https://play.google.com/store/apps/details?id=com.dieayaplus.market',
                                'dieaya');
                          },
                          child: shareButton(
                            icon: isDark
                                ? ImageConstants.googlePlayLogoDark
                                : ImageConstants.googlePlayLogoLight,
                          )),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FooterSectionsTitle(title: 'legal'.tr),
                  SizedBox(
                    height: 6.h,
                  ),
                  FooterSectionBullet(
                    title: 'usage policy'.tr,
                    onTap: () {
                      Get.toNamed(AppRoutes.terms);
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  FooterSectionBullet(
                    title: 'termsConditions'.tr,
                    onTap: () {
                      Get.toNamed(AppRoutes.privacy);
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30.h),
          const Divider(color: Colors.white30),
          CustomTextSolveIssue(
            'copyright'.tr,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          )
        ],
      ),
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
}


