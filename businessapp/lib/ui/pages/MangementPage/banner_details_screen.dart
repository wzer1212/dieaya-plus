import 'dart:io';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/app_colors.dart';
import '../../../controllers/BannerController/banner_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/banner_model.dart';
import '../../../utils/app_snackbars.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_sheets.dart';

class PromoBanner extends StatelessWidget {
  final BannerMarket banner;

  const PromoBanner({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final link = banner.link.trim();
    final hasValidLink = link.isNotEmpty && Uri.tryParse(link)?.hasScheme == true;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: SizedBox(
        width: screenWidth * 1, // Match CouponDetailsPage card width
        height: screenHeight * 0.3, // Slightly larger for details page
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.10),
              child: Image.asset(
                'assets/images/continerBack.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
              child: banner.image.startsWith('http')
                  ? Image.network(
                banner.image,
                fit: BoxFit.cover,
                height: screenHeight * 0.28,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/Rectangle 22489.png',
                  fit: BoxFit.cover,
                  height: screenHeight * 0.28,
                  width: double.infinity,
                ),
              )
                  : Image.file(
                File(banner.image),
                fit: BoxFit.cover,
                height: screenHeight * 0.28,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/Rectangle 22489.png',
                  fit: BoxFit.cover,
                  height: screenHeight * 0.28,
                  width: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.015,
              right: Directionality.of(context) == TextDirection.rtl ? screenWidth * 0.03 : null,
              left: Directionality.of(context) == TextDirection.rtl ? null : screenWidth * 0.03,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.04,
                    backgroundImage: banner.market.logo.isNotEmpty
                        ? NetworkImage(banner.market.logo)
                        : null,
                    backgroundColor: Colors.white,
                    child: banner.market.logo.isEmpty
                        ? Image.asset('assets/images/Ellipse 14.png')
                        : null,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    banner.market.name,
                    style: GoogleFonts.tajawal(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.04,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      Get.locale?.languageCode == 'ar' ? banner.descriptionAr : banner.descriptionEn,
                      textAlign: Directionality.of(context) == TextDirection.rtl
                          ? TextAlign.right
                          : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: hasValidLink,
                    child: Expanded(
                      child: SizedBox(
                        width: screenWidth * 0.25,
                        height: screenHeight * 0.05,
                        child: CustomButton(
                          text: 'shop_now'.tr,
                          textSize: 12,
                          onPressed: () async {
                            String normalizedUrl = link;
                            if (!link.startsWith(RegExp(r'https?://'))) {
                              normalizedUrl = 'https://$link';
                            }
                            final uri = Uri.tryParse(normalizedUrl);
                            if (uri != null) {
                              try {
                                final canLaunch = await canLaunchUrl(uri);
                                if (canLaunch) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  Get.snackbar(
                                    'خطأ',
                                    'لا يمكن فتح الرابط: الرابط غير مدعوم',
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 3),
                                  );
                                }
                              } catch (e) {
                                Get.snackbar(
                                  'خطأ',
                                  'حدث خطأ أثناء فتح الرابط: $e',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 3),
                                );
                              }
                            } else {
                              Get.snackbar(
                                'خطأ',
                                'الرابط غير صالح: $normalizedUrl',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 3),
                              );
                            }
                          },
                          textFontWeight: FontWeight.bold,
                          textColor: AppColors.primary,
                          color: Colors.white,
                          iconPath: 'assets/svg/mynaui_click-solid.svg',
                          iconSize: screenWidth * 0.06,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BannerDetailsPage extends StatelessWidget {
  final BannerMarket banner;

  const BannerDetailsPage({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final BannerController bannerController = Get.put(BannerController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void _confirmDelete(BuildContext context, BannerMarket banner) {
      showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/social/deleteacc.svg', // Ensure this SVG asset exists
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 10),
                Text(
                  'acceptMessageDelete'.tr, // Translated text for confirmation
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'sureDelete'.tr, // Translated text for confirmation message
                  style: GoogleFonts.tajawal(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  margin: EdgeInsets.only(bottom: 60.h),
                  onPressed: () async {
                    Navigator.pop(dialogContext); // Dismiss the dialog
                    bool success = await bannerController.deleteBanner(id: banner.id!); // Ensure banner.id is not null
                    if (success) {
                      Get.back(); // Navigate back after deletion
                      SnackBarConstantVersion1.showSuccessSnackbar(
                        'successApp'.tr,
                        'deleteBannerSuccess'.tr, // Specific success message for banner
                      );
                    } else {
                      SnackBarConstantVersion1.showErrorSnackbar( // Use showErrorSnackbar for error
                        'error'.tr,
                        bannerController.errorMessage.value,
                      );
                    }
                  },
                  text: 'deleteApp'.tr, // Translated text for delete button
                  textSize: 16,
                  textFontWeight: FontWeight.bold,
                  color: const Color(0xffAEAEAE), // Custom color for delete button
                  textColor: Colors.white,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  text: 'cancelApp'.tr, // Translated text for cancel button
                  textSize: 16,
                  textFontWeight: FontWeight.bold,
                  // Assuming default button style is sufficient or adjust as needed
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                    AppColors.primary,
                    AppColors.primary,
                    Colors.black,
                  ]
                      : [
                    AppColors.primary,
                    AppColors.primary,
                    Colors.white,
                  ],
                  stops: const [0.0, 0.0, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 60,
                  start: 8,
                  end: 8,
                  bottom: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     // Implement share functionality if needed
                        //     print('Share tapped for banner: ${banner.id}');
                        //   },
                        //   child: Container(
                        //     width: 36,
                        //     height: 36,
                        //     child: SvgPicture.asset(
                        //       'assets/svg/share.svg',
                        //       width: 25,
                        //       height: 25,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Banner
            PromoBanner(banner: banner),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsetsDirectional.all(15.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 30.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: SizedBox(
            height: 120, // Increased height for two stacked buttons
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onPressed: () {
                    CustomSheets.showAddBannerSheet(context, banner: banner);
                  },
                  text: 'editApp'.tr,
                  textFontWeight: FontWeight.bold,
                  textSize: 18,
                  color: AppColors.blue,
                ),
                const SizedBox(height: 8), // Space between buttons
                CustomButton(
                  onPressed: () {
                    _confirmDelete(context, banner);
                  },
                  text: 'deleteApp'.tr,
                  textFontWeight: FontWeight.bold,
                  textSize: 18,
                  color: Color(0xffAEAEAE),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}