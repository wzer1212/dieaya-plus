import 'package:dieaya_user/UI/pages/HomeScreen/home_screen.dart';
import 'package:dieaya_user/UI/pages/ProfileScreen/profile_screen.dart';
import 'package:dieaya_user/UI/pages/StoresScreen/see_all_market.dart';
import 'package:dieaya_user/Utils/app_sharedprefs_contants.dart';
import 'package:dieaya_user/controllers/MarketControllers/best_market_controller.dart';
import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/ui/pages/CouponsScreen/coupons_screen.dart';
import 'package:dieaya_user/ui/pages/NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_user/ui/pages/OffersScreen/offers_screen.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/products_screen.dart';
import 'package:dieaya_user/ui/pages/ProfileScreen/my_favs_screen.dart';
import 'package:dieaya_user/ui/widgets/custom_sheets.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/animated_web_header_button.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_hover_button.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/dropdown_item.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/web_header_dropdown.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/caching_sevice/shared_preferences.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalWebHeader extends StatelessWidget {
  GlobalWebHeader({super.key, required this.scrollController});

  final ScrollController scrollController;
  final ThemeController themeController = Get.put(ThemeController());
  static const List<String> _navIcons = [
    'assets/svg/shop.svg',
    'assets/svg/products.svg',
    'assets/svg/offers.svg',
    'assets/svg/Ticket 2.svg',
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(color: AppColors.primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => HomeScreen());
            },
            child: CustomTextSolveIssue(
              'dieaya_name'.tr,
              style: GoogleFonts.tajawal(
                fontSize: 20.w,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          Row(
            children: [
              // home button
              AnimatedWebHeaderButton(
                title: 'home'.tr,
                onTap: () {
                  Get.to(() => HomeScreen());
                },
              ),
              SizedBox(width: 15.w),
              // dropdown menu
              ShowDropDown(
                items: [
                  WebDropDownItem(
                    icon: _navIcons[1],
                    isDark: isDark,
                    title: 'best_products'.tr,
                    onTap: () {
                      Get.to(() => ProductsScreen(categoryId: '1'));
                    },
                  ),
                  WebDropDownItem(
                    icon: _navIcons[2],
                    isDark: isDark,
                    title: 'best_offers'.tr,
                    onTap: () {
                      Get.to(() => OffersScreen());
                    },
                  ),
                  WebDropDownItem(
                    icon: _navIcons[3],
                    isDark: isDark,
                    title: 'best_coupons'.tr,
                    onTap: () {
                      Get.to(() => CouponsScreen());
                    },
                  ),
                  WebDropDownItem(
                    icon: _navIcons[0],
                    isDark: isDark,
                    title: 'best_stores'.tr,
                    onTap: () {
                      Get.to(() => AllMarketsScreen(controller: BestMarketsController(), title: 'best_stores'.tr));
                    },
                  ),
                ],
              ),
              SizedBox(width: 15.w),
              // business
              AnimatedWebHeaderButton(
                title: 'business'.tr,
                onTap: () {},
              ),
              SizedBox(width: 15.w),
              // download_app
              AnimatedWebHeaderButton(
                title: 'download_app'.tr,
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent, // end of page
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });

                  ;
                },
              ),
              SizedBox(width: 15.w),
            ],
          ),
          Row(
            children: [
              //theme button
              Obx(() =>
                  InkWell(
                    onTap: () {
                      themeController.setThemeMode(
                          themeController.themeMode.value == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark);
                      Navigator.pushAndRemoveUntil(context, 
                          MaterialPageRoute(builder: (context) => HomeScreen(),),(_)=>false);
                    },
                    child: Icon(
                      themeController.themeMode.value == ThemeMode.dark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode,
                    ),
                  )
                ,),
              SizedBox(width: 10.w),
              // login button or my account button
              MySharedPreference.getData(key: SharedPrefsConstants.tokenKey) ==
                      null
                  ? CustomHoverButton(
                      title: 'login'.tr,
                      onTap: () {
                        CustomSheets.showLoginSheet(context);
                      },
                    )
                  : CustomHoverButton(
                      title: 'my_account'.tr,
                      onTap: () async {
                        Get.to(() => ProfileScreen());
                      },
                    )
            ],
          ),
        ],
      ),
    );
  }
}


