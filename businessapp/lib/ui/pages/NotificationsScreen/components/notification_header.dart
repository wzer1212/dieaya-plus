import 'package:dieaya_market/controllers/NotificationController/notification_api_controller.dart';
import 'package:dieaya_market/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';



class NotificationHeader extends StatelessWidget {
  const NotificationHeader({
    super.key,
    required this.isDark,
    required this.notificationController,
    required this.notifications, this.showNotificationIcon = true,
  });

  final bool isDark;
  final NotificationListController notificationController;
  final List<Map<String, dynamic>> notifications;
  final bool? showNotificationIcon;

  @override
  Widget build(BuildContext context) {
    print("notifications:$notifications");
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.primary, AppColors.primary, Colors.black]
              : [AppColors.primary, AppColors.primary, Colors.white],
          stops: [0.0, 0.0, 5.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(Icons.arrow_back_ios,color: Colors.white,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                'notification'.tr,
                style: GoogleFonts.tajawal(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            showNotificationIcon!?
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
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
                      print('Notifications Tapped');
                      notificationController.fetchNotifications();
                    },
                  ),
                  if ((notifications.any((n) => (n['isUnread'] ==0 ) )))
                    Positioned(
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
                    ),
                ],
              ),
            ):SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}