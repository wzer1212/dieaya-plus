import 'package:dieaya_market/utils/app_colors.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../controllers/ThemeController/theme_controller.dart';

import '../../../utils/constants/image_constants.dart';

class MainAppHeader extends StatelessWidget {
  MainAppHeader({
    super.key,
    this.onTap,
    this.onNotificationPressed,
    this.fromSeeAll = false,
    this.readOnly = true,
    this.controller,
    this.onChanged, this.showSuffixIcon = false,
  });

  final TextEditingController? controller;
  final ThemeController themeController = Get.put(ThemeController());
  final Function()? onTap;
  final void Function()? onNotificationPressed;

  final Function(String)? onChanged;
  final bool? fromSeeAll;
  final bool? readOnly;
  final bool? showSuffixIcon;


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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              fromSeeAll!
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.white,
                        size: 34.h,
                      ),
                      onPressed: () {
                        Get.back(); // Navigate back
                      },
                    )
                  : Image.asset(
                      'assets/images/logodiaya.png',
                      width: 35.w,
                      height: 35.h,
                    ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Container(
                  height: 45.h,
                  child: TextFormField(
                    controller: controller,
                    readOnly: readOnly!,
                    // maxLength: 100,
                    maxLength: 100,
                    onTap: onTap,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                       counterText: "",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(2.5.h),
                        child: CircleAvatar(
                          backgroundColor: AppColors.grey3,
                          child: SvgPicture.asset(
                            fit: BoxFit.fill,
                            ImageConstants.search,
                            width: 32.w,
                            height: 25.h,
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      suffixIcon:showSuffixIcon!? Padding(
                        padding: EdgeInsets.all(10.h),
                        child: SvgPicture.asset(
                          'assets/svg/suffix.svg',
                          // width: screenWidth * 0.07,
                          // height: screenWidth * 0.07,
                          colorFilter: const ColorFilter.mode(
                            AppColors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ):null,
                    ),
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
                    backgroundColor: AppColors.white,
                    radius: 22.h,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/notify.svg',
                        width: 36.w,
                        height: 46.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.black54,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: onNotificationPressed,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
