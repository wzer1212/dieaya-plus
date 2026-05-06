
import 'dart:async';
import 'package:dieaya_user/UI/pages/NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_user/UI/pages/ProfileScreen/my_favs_screen.dart';
import 'package:dieaya_user/UI/widgets/custom_sheets.dart';
import 'package:dieaya_user/controllers/MarketControllers/best_market_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If using SVG icons
import 'package:flutter/services.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/CategoryController/category_controller.dart';
import '../../../controllers/CountsConroller/counts_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/best_market_model.dart';


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeaderWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isDark;
  final bool isArabic;
  final TextEditingController searchController;
  final bool isLoading;

  const HeaderWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.isDark,
    required this.isArabic,
    required this.searchController,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.primary, AppColors.primary, Colors.black]
              : [AppColors.primary, AppColors.primary, Colors.white],
          stops: const [0.0, 0.0, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
            top: 60, bottom: 20, start: 20, end: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
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
                              await SharedPrefsConstants.isLoggedIn();
                              if (isLoggedIn) {
                                Get.to(() => NotificationsScreen());
                              } else {
                                CustomSheets.showLoginSheet(context);
                              }
                            },
                          ),
                          Positioned(
                            right: screenWidth * 0.035,
                            top: screenHeight * 0.019,
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.005),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: screenWidth * 0.014,
                                minHeight: screenWidth * 0.014,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/svg/Heart 2.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.black54,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () async {
                          bool isLoggedIn =
                          await SharedPrefsConstants.isLoggedIn();
                          if (isLoggedIn) {
                            Get.to(() => MyFavScreen());
                          } else {
                            CustomSheets.showLoginSheet(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textAlign:
                    isArabic ? TextAlign.end : TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsetsDirectional.only(
                          bottom: 8, start: 8, end: 8),
                      hintText: 'search_stores'.tr,
                      hintStyle: GoogleFonts.getFont(
                        isArabic ? 'Tajawal' : 'Roboto',
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      suffixIcon: isLoading
                          ? const Padding(
                        padding: EdgeInsetsDirectional.all(8.0),
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                          : Padding(
                        padding:
                        const EdgeInsetsDirectional.all(8.0),
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEAEA),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsetsDirectional.symmetric(
                                horizontal: 8, vertical: 5),
                            child: SvgPicture.asset(
                              'assets/svg/Search 1.svg',
                              width: 26,
                              height: 26,
                              colorFilter: const ColorFilter.mode(
                                Color(0xff5D5C5C),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                        },
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Add your search logic here
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}