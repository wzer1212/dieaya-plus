import 'package:dieaya_market/Routes/app_routes.dart';
import 'package:dieaya_market/Utils/app_colors.dart';
import 'package:dieaya_market/controllers/NotificationController/notification_api_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({
    super.key,
    required this.isDark,
  });

  final bool isDark;
  final NotificationListController notificationController =
  Get.put(NotificationListController())..fetchNotifications();
  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Container(
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
            SizedBox(
              width: 50,
            ),
            Expanded(
              child: Text(
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
                    onPressed: () {
                      Get.toNamed(AppRoutes.notifications);
                      print('Notifications Tapped');
                    },
                  ),
                  notificationController.notifications.any((element) => element.issRead==0,)?
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
                  ):SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}