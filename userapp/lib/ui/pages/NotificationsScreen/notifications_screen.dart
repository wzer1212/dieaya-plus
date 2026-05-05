import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../Controllers/LanguageController/language_controller.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/NotificationController/notification_api_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/notification_model.dart';
import '../../widgets/custom_sheets.dart';
import '../ProfileScreen/my_favs_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationListController notificationController =
      Get.put(NotificationListController());
  final LanguageController languageController = Get.find<LanguageController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    notificationController.fetchNotifications();
  }

  List<Map<String, dynamic>> get notifications {
    final isArabic = languageController.locale.value.languageCode == 'ar';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return notificationController.notifications.map((NotificationItem item) {
      String group;
      if (item.createdAt == null) {
        group = 'اليوم';
      } else {
        final createdDate = DateTime.tryParse(item.createdAt!);
        if (createdDate == null) {
          group = 'اليوم';
        } else {
          final date =
              DateTime(createdDate.year, createdDate.month, createdDate.day);
          if (date == today) {
            group = 'اليوم';
          } else if (date == yesterday) {
            group = 'أمس';
          } else {
            group =
                '${createdDate.day}/${createdDate.month}/${createdDate.year}';
          }
        }
      }

      return {
        'id': item.id,
        'group': group,
        'title': isArabic ? item.titleAr : item.titleEn,
        'message': (isArabic ? item.descriptionAr : item.descriptionEn)
            .substring(
                0,
                (isArabic ? item.descriptionAr : item.descriptionEn)
                    .length
                    .clamp(0, 20)),
        'fullMessage': isArabic ? item.descriptionAr : item.descriptionEn,
        'image': 'assets/images/Ellipse 14.png',
        'is_read': item.isRead,
      };
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get groupedNotifications {
    final Map<String, List<Map<String, dynamic>>> map = {};
    for (var notification in notifications) {
      final group = notification['group'] as String;
      map.putIfAbsent(group, () => []).add(notification);
    }
    return map;
  }

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return AdaptiveLayOut(
        mobile: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Obx(() {
            if (notificationController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (notificationController.isUnauthorized.value ||
                notifications.isEmpty) {
              return _buildEmptyState();
            } else {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                                AppColors.primary,
                                AppColors.primary,
                                Colors.black
                              ]
                            : [
                                AppColors.primary,
                                AppColors.primary,
                                Colors.white
                              ],
                        stops: [0.0, 0.0, 5.0],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 60),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: SvgPicture.asset(
                              'assets/svg/backbutton.svg',
                              width: 40,
                              height: 40,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 90),
                            child: CustomTextSolveIssue(
                              'الأشعارات',
                              style: GoogleFonts.tajawal(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildGroupedNotificationsList(),
                  ),
                ],
              );
            }
          }),
        ),
        desktop: Scaffold(
          // extendBodyBehindAppBar: true,
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Obx(() {
            if (notificationController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (notificationController.isUnauthorized.value ||
                notifications.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlobalWebHeader(scrollController: _controller),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 65.h,
                          ),
                          _buildEmptyState(showMobileHeader: false),
                          SizedBox(
                            height: 100.h,
                          ),
                          FooterWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  GlobalWebHeader(scrollController: _controller),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 175.w, vertical: 50.h),
                            child: _buildGroupedNotificationsList(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true),
                          ),
                          FooterWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ));
  }

  Widget _buildEmptyState({bool? showMobileHeader = true}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (showMobileHeader!)
            Container(
              padding: AdaptiveLayOut.isDesktop()
                  ? null
                  : EdgeInsets.symmetric(horizontal: 10.w),
              width: AdaptiveLayOut.isDesktop() ? 1.fullWidth : 600.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primary, Colors.white],
                  stops: const [0.0, 0.0, 1.0],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.white,
                          size: 34.h,
                        ),
                        onPressed: () {
                          Get.back(); // Navigate back
                        },
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.white,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/svg/notify.svg',
                                width: 24.w,
                                height: 24.h,
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
                            backgroundColor: AppColors.white,
                            child: IconButton(
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
                                  print(
                                      'Favorites Tapped - Showing Login Bottom Sheet');
                                }
                              },
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
            ),
          SvgPicture.asset(
            'assets/svg/Notification 1.svg',
            colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
          ),
          const SizedBox(height: 25),
          CustomTextSolveIssue(
            'لا توجد إشعارات متاحة',
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CustomTextSolveIssue(
            'سننبهك عندما يحدث شيء رائع',
            style: GoogleFonts.tajawal(
              fontSize: 14,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedNotificationsList(
      {bool shrinkWrap = false, ScrollPhysics? physics}) {
    final groups = groupedNotifications.keys.toList();
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final groupName = groups[groupIndex];
        final groupItems = groupedNotifications[groupName]!;
        print("--------------->>>>" + groupName);
        print("--------------->>>>${groupedNotifications[groupName]}");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 10.0, top: 0.0, bottom: 8.0, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextSolveIssue(
                    groupName,
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDeleteAllDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: CustomTextSolveIssue(
                        'حذف الكل',
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupItems.length,
              itemBuilder: (context, itemIndex) {
                final notification = groupItems[itemIndex];
                final fullMessage = notification['fullMessage'] as String;
                return _buildNotificationItem(
                  title: notification['title'] as String,
                  message: notification['message'] as String,
                  imagePath: notification['image'] as String,
                  isUnread: notification['is_read'] as int,
                  // isUnread: 0,
                  onTap: () {
                    _showNotificationDialog(
                      context,
                      notification,
                      fullMessage,
                    );
                  },
                  onDelete: () async {
                    await notificationController
                        .deleteNotification(notification['id']);
                    await notificationController
                        .fetchNotifications(); // Refresh notifications
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String imagePath,
    required int isUnread,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isUnread == 0 ? AppColors.primary.withAlpha(10) : null,
          borderRadius: BorderRadius.circular(30),
          border: Border(
            top: BorderSide(
              color: AppColors.primary.withOpacity(0.5),
              width: 1.5,
            ),
            right: BorderSide(
              color: AppColors.primary.withOpacity(0.5),
              width: 1.5,
            ),
            left: BorderSide(
              color: AppColors.primary.withOpacity(0.5),
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isUnread == 0)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/notificationApp.png',
                        width: 40,
                        height: 40,
                      )),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextSolveIssue(
                            title,
                            style: GoogleFonts.tajawal(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          CustomTextSolveIssue(
                            message,
                            style: GoogleFonts.tajawal(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // CircleAvatar(
                  //   radius: 22,
                  //   backgroundColor: Colors.grey[200],
                  //   backgroundImage: AssetImage('assets/images/notifyApp.png'),
                  // ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: CustomTextSolveIssue(
            'حذف جميع الإشعارات',
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: CustomTextSolveIssue(
            'هل أنت متأكد من حذف جميع الإشعارات؟',
            style: GoogleFonts.tajawal(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: CustomTextSolveIssue(
                'لا',
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await notificationController.deleteAllNotifications();
                await notificationController
                    .fetchNotifications(); // Refresh notifications
                Navigator.pop(context); // Close the dialog
              },
              child: CustomTextSolveIssue(
                'نعم',
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationDialog(
    BuildContext context,
    Map<String, dynamic> notification,
    String fullMessage,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {


        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 5,
          child: SizedBox(
            width: kIsWeb ? 300.w : null,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<NotificationItem?>(
                future:
                    notificationController.getNotification(notification['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final fetchedNotification = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/bell 1.png',
                            width: 100,
                            height: 100,
                            // colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                AssetImage('assets/images/frameNotify.png'),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: CustomTextSolveIssue(
                              notification['title'] as String,
                              // Use title directly
                              style: GoogleFonts.tajawal(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      CustomTextSolveIssue(
                        fetchedNotification?.descriptionAr ?? fullMessage,
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // CustomButton(
                          //   width: 130,
                          //   height: 40,
                          //   onPressed: () async {
                          //     await notificationController
                          //         .getNotification(notification['id']);
                          //
                          //     Navigator.pop(context);
                          //   },
                          //   text: 'قراءة',
                          // ),
                          Expanded(
                            child: Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  width: 130,
                                  height: 40,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  text: 'إلغاء',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    ).then((value) async{
      await notificationController
          .fetchNotifications(); // Refresh notifications
    },);
  }
}
