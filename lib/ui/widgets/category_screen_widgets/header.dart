import 'package:cached_network_image/cached_network_image.dart';
import 'package:dieaya_user/UI/pages/NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_user/UI/pages/ProfileScreen/my_favs_screen.dart';
import 'package:dieaya_user/UI/widgets/custom_sheets.dart';
import 'package:dieaya_user/Utils/app_sharedprefs_contants.dart';
import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/models/categories_model.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/products_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/constants/image_constants.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryHeader extends StatelessWidget {
  CategoryHeader(
      {super.key,
        required this.searchController,
        this.onChanged,
        this.onFieldSubmitted});

  final ThemeController themeController = Get.put(ThemeController());
  final TextEditingController searchController;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      width: 600.w,
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
      child: Column(
        children: [
          SizedBox(
            height: 90.h,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.white,
                  size: 34.h,
                ),
              ),
              Expanded(
                child: TextFormField(
                  style: TextStyle(
                    color: isDark?Colors.black:null
                  ),
                  onFieldSubmitted: onFieldSubmitted,
                  onChanged: onChanged,
                  controller: searchController,
                  textAlign: TextAlign.right,
                  // Align Arabic text
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CircleAvatar(
                        backgroundColor: AppColors.grey2,
                        child: SvgPicture.asset(
                          ImageConstants.search,
                          width: 30.w,
                          height: 28.h,
                          colorFilter: const ColorFilter.mode(
                            Color(0xff5D5C5C),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    hintText: 'search'.tr,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.r),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.r),
                        borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.white,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/notify.svg',
                        width: 28.w,
                        height: 28.h,
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
                          print(
                              'Favorites Tapped - Showing Login Bottom Sheet');
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.white,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/Heart 2.svg',
                        width: 28,
                        height: 28,
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
                          print(
                              'Favorites Tapped - Showing Login Bottom Sheet');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          //   children:[
          //    IconButton(
          //       icon: const Icon(
          //         Icons.arrow_back_ios_rounded,
          //         color: Colors.white, // Adjust color as needed
          //         size: 30,
          //       ),
          //       onPressed: () {
          //         Get.back(); // Navigate back
          //       },
          //     )
          //         ,
          //     Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(25),
          //         color: Colors.white,
          //       ),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Stack(
          //             children: [
          //               IconButton(
          //                 icon: SvgPicture.asset(
          //                   'assets/svg/notify.svg',
          //                   width: 24,
          //                   height: 24,
          //                   colorFilter: const ColorFilter.mode(
          //                     Colors.black54,
          //                     BlendMode.srcIn,
          //                   ),
          //                 ),
          //                 onPressed: () async {
          //                   bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
          //                   if (isLoggedIn) {
          //                     Get.to(() => NotificationsScreen());
          //                   } else {
          //                     CustomSheets.showLoginSheet(context);
          //                     print('Favorites Tapped - Showing Login Bottom Sheet');
          //                   }
          //                 },
          //               ),
          //               Positioned(
          //                 right: screenWidth * 0.035,
          //                 top: screenHeight * 0.019,
          //                 child: Container(
          //                   padding:
          //                   EdgeInsets.all(screenWidth * 0.005),
          //                   decoration: BoxDecoration(
          //                     color: Colors.red,
          //                     borderRadius: BorderRadius.circular(6),
          //                   ),
          //                   constraints: BoxConstraints(
          //                     minWidth: screenWidth * 0.014,
          //                     minHeight: screenWidth * 0.014,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           IconButton(
          //             icon: SvgPicture.asset(
          //               'assets/svg/Heart 2.svg',
          //               width: 24,
          //               height: 24,
          //               colorFilter: const ColorFilter.mode(
          //                 Colors.black54,
          //                 BlendMode.srcIn,
          //               ),
          //             ),
          //             onPressed: () async {
          //               bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
          //               if (isLoggedIn) {
          //                 Get.to(() => MyFavScreen());
          //               } else {
          //                 CustomSheets.showLoginSheet(context);
          //                 print('Favorites Tapped - Showing Login Bottom Sheet');
          //               }
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          //   children: [
          //   TextField(
          //   // controller: _searchController,
          //   textAlign: isArabic ? TextAlign.end : TextAlign.start,
          //   textAlignVertical: TextAlignVertical.center,
          //   decoration: InputDecoration(
          //     contentPadding:
          //     const EdgeInsetsDirectional.only(bottom: 8, start: 8, end: 8),
          //     hintText: 'search_stores'.tr,
          //     hintStyle: GoogleFonts.getFont(
          //       isArabic ? 'Tajawal' : 'Roboto',
          //       color: Colors.grey,
          //       fontSize: 14,
          //     ),
          //     // suffixIcon: isLoading
          //     //     ? const Padding(
          //     //   padding: EdgeInsetsDirectional.all(8.0),
          //     //   child: SizedBox(
          //     //     width: 26,
          //     //     height: 26,
          //     //     child: CircularProgressIndicator(strokeWidth: 2),
          //     //   ),
          //     // )
          //     //     : Padding(
          //     //   padding: const EdgeInsetsDirectional.all(8.0),
          //     //   child: Container(
          //     //     width: 50,
          //     //     decoration: BoxDecoration(
          //     //       color: const Color(0xFFEAEAEA),
          //     //       borderRadius: BorderRadius.circular(50),
          //     //     ),
          //     //     child: Padding(
          //     //       padding: const EdgeInsetsDirectional.only(
          //     //           start: 8, end: 8, top: 5, bottom: 5),
          //     //       child: SvgPicture.asset(
          //     //         'assets/svg/Search 1.svg',
          //     //         width: 26,
          //     //         height: 26,
          //     //         colorFilter: const ColorFilter.mode(
          //     //           Color(0xff5D5C5C),
          //     //           BlendMode.srcIn,
          //     //         ),
          //     //       ),
          //     //     ),
          //     //   ),
          //     // ),
          //     prefixIcon:  IconButton(
          //       icon: const Icon(Icons.clear, color: Colors.grey),
          //       onPressed: () {
          //
          //       },
          //     )
          //         ,
          //     border: InputBorder.none,
          //     enabledBorder: InputBorder.none,
          //     focusedBorder: InputBorder.none,
          //   ),
          //   onChanged: (value) {
          //
          //   },
          // )
          //   ],
          // ),
        ],
      ),
    );
  }
}