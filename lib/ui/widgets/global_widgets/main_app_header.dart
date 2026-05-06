import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../Utils/app_colors.dart';

import '../../../controllers/ThemeController/theme_controller.dart';

import '../../../utils/constants/image_constants.dart';

class MainAppHeader extends StatelessWidget {
  MainAppHeader({
    super.key,
    this.onTap,
    this.onNotificationPressed,
    this.onFavoritePressed,
    this.fromSeeAll = false,
    this.readOnly = true,
    this.controller, this.onChanged, this.width, this.spacingAbove, this.notificationIconSize, this.favouriteIconSize, this.textFieldHeight, this.logoHeight, this.logoWidth,
  });

  final TextEditingController? controller;
  final ThemeController themeController = Get.put(ThemeController());
  final Function()? onTap;
  final void Function()? onNotificationPressed;
  final void Function()? onFavoritePressed;
  final Function(String)? onChanged;
  final bool? fromSeeAll;
  final bool? readOnly;
  final double? width;
  final double? spacingAbove;
  final double? notificationIconSize;
  final double? favouriteIconSize;
  final double? textFieldHeight;
  final double? logoHeight;
  final double? logoWidth;


  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      width: width??600.w,
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
            height:spacingAbove?? 90.h,
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
                      width: logoWidth??35.w,
                      height: logoHeight??35.h,
                    ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Container(
                  height:textFieldHeight?? 45.h,

                  child: TextFormField(

                    controller: controller,
                    readOnly: readOnly!,
                    onTap: onTap,
                    onChanged:onChanged ,
                    maxLength: 100,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    decoration: InputDecoration(

                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.h),
                        child: CircleAvatar(

                          backgroundColor: kIsWeb?AppColors.white:AppColors.grey2,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SvgPicture.asset(
                              fit: BoxFit.none,
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      counterText: ""
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
                    radius: notificationIconSize?? 22.h,
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
                  CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: favouriteIconSize?? 22.h,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/Heart 2.svg',
                        width: 34.w,
                        height: 40.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.black54,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: onFavoritePressed,
                    ),
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
