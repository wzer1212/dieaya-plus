import 'package:dieaya_market/ui/pages/NotificationsScreen/components/notification_header.dart';
import 'package:dieaya_market/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../Controllers/LanguageController/language_controller.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/NotificationController/notification_api_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';

import '../../../models/notification_model.dart';

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
        group = 'today'.tr;
      } else {
        final createdDate = DateTime.tryParse(item.createdAt!);
        if (createdDate == null) {
          group = 'today'.tr;
        } else {
          final date =
              DateTime(createdDate.year, createdDate.month, createdDate.day);
          if (date == today) {
            group = 'today'.tr;
          } else if (date == yesterday) {
            group = 'yesterday'.tr;
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
        'image': 'assets/images/logo.png',
        'isUnread': item.issRead,
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

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (notificationController.isUnauthorized.value ||
            notifications.isEmpty) {
          return _buildEmptyState(isDark: isDark);
        } else {
          return Column(
            children: [
              NotificationHeader(
                  isDark: isDark,
                  notificationController: notificationController,
                  notifications: notifications,

              ),
              // if (notifications.isNotEmpty)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         GestureDetector(
              //           onTap: () {
              //             print('Delete All Tapped');
              //             setState(() {
              //               notificationController.notifications.clear();
              //             });
              //           },
              //           child: Row(
              //             children: [
              //               Text(
              //                 'حذف الكل',
              //                 style: GoogleFonts.tajawal(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //               const SizedBox(width: 5),
              //               const Icon(
              //                 Icons.delete_outline,
              //                 size: 20,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              Expanded(
                child: _buildGroupedNotificationsList(),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildEmptyState({required bool isDark}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NotificationHeader(
              isDark: isDark,
              notificationController: notificationController,
              notifications: notifications,
            showNotificationIcon: false,),
          SvgPicture.asset(
            'assets/svg/Notification 1.svg',
            colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
          ),
          const SizedBox(height: 25),
          Text(
            'no_notifications'.tr,
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'cool_message'.tr,
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

  Widget _buildGroupedNotificationsList() {
    final groups = groupedNotifications.keys.toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final groupName = groups[groupIndex];
        final groupItems = groupedNotifications[groupName]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 10.0, top: 0.0, bottom: 8.0, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
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
                      child: Text(
                        'delete_all'.tr,
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
                  isUnread: notification['isUnread'] ,
                  onTap: () {
                    _showNotificationDialog(
                      context,
                      notification,
                      fullMessage,
                    );
                  },
                  onDelete: () async{
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
  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'delete_all_notifications'.tr,
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'delete_all_notifications_message'.tr,
            style: GoogleFonts.tajawal(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'no'.tr,
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await notificationController.deleteAllNotifications();
                await notificationController.fetchNotifications(); // Refresh notifications
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'yes'.tr,
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
          color: isUnread == 0?AppColors.primary.withAlpha(10):null,
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

                  if (isUnread==0)
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
                          Text(
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
                          Text(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<NotificationItem?>(
              future: notificationController.getNotification(notification['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final fetchedNotification = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
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
                            child: Text(
                              notification['title'] as String, // Use title directly
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
                      Text(
                        fetchedNotification?.descriptionAr ?? fullMessage,
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CustomButton(
                          //   width: 130,
                          //   height: 40,
                          //   onPressed: () async {
                          //     await notificationController
                          //         .deleteNotification(notification['id']);
                          //   
                          //     Navigator.pop(context);
                          //   },
                          //   text: 'قراءة',
                          // ),
                          CustomButton(
                            width: 130,
                            height: 40,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: 'cancel'.tr,
                        
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then((value)async {
      await notificationController
          .fetchNotifications(); // Refresh notifications
    },);
  }
// void _showNotificationDialog(
//     BuildContext context,
//     Map<String, dynamic> notification,
//     String fullMessage,
//     VoidCallback onDeleteConfirm,
//     VoidCallback onReadConfirm,
//     ) {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25.0),
//         ),
//         elevation: 5,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               SvgPicture.asset(
//                 'assets/svg/bell 1.svg',
//                 colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 notification['title'] as String,
//                 style: GoogleFonts.tajawal(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 5),
//               CircleAvatar(
//                 radius: 25,
//                 backgroundColor: Colors.grey[200],
//                 backgroundImage: AssetImage(notification['image'] as String),
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 fullMessage,
//                 style: GoogleFonts.tajawal(
//                   fontSize: 14,
//                   height: 1.4,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 25),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: onDeleteConfirm,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[400],
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
//                     ),
//                     child: Text(
//                       'حذف',
//                       style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: onReadConfirm,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
//                     ),
//                     child: Text(
//                       'قراءة',
//                       style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
}

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});
//
//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }
//
//
// // ... (Keep existing StatefulWidget and State class definition) ...
//
// class _NotificationsScreenState extends State<NotificationsScreen> {
//   // ... (Keep existing notifications list and groupedNotifications getter) ...
//   final List<Map<String, dynamic>> notifications = [
//     {
//       'group': 'اليوم', // Today
//       'title': 'متجر امازون',
//       'message': 'تم اضافة عرض جديد ...',
//       'fullMessage': 'عرض جديد: اشتري 2 تيشيرت بسعر تيشيرت واحد. هذا العرض مقدم لك ولكل العملاء المميزين لدينا.', // Add full message for dialog
//       'image': 'assets/images/Ellipse 14.png', // Placeholder - replace with actual asset/URL
//       'isUnread': true,
//     },
//     // ... other notifications (add 'fullMessage' to each) ...
//     {
//       'group': 'اليوم', // Today
//       'title': 'متجر امازون',
//       'message': 'تم اضافة عرض جديد ...',
//       'fullMessage': 'عرض جديد: اشتري 2 تيشيرت بسعر تيشيرت واحد. هذا العرض مقدم لك ولكل العملاء المميزين لدينا.', // Add full message for dialog
//       'image': 'assets/images/Ellipse 14.png',
//       'isUnread': true,
//     },
//     {
//       'group': 'امس', // Yesterday
//       'title': 'متجر امازون',
//       'message': 'تم اضافة عرض جديد ...',
//       'fullMessage': 'عرض جديد: اشتري 2 تيشيرت بسعر تيشيرت واحد. هذا العرض مقدم لك ولكل العملاء المميزين لدينا.', // Add full message for dialog
//       'image': 'assets/images/Ellipse 14.png',
//       'isUnread': true,
//     },
//     {
//       'group': 'امس', // Yesterday
//       'title': 'متجر امازون',
//       'message': 'تم اضافة عرض جديد ...',
//       'fullMessage': 'عرض جديد: اشتري 2 تيشيرت بسعر تيشيرت واحد. هذا العرض مقدم لك ولكل العملاء المميزين لدينا.', // Add full message for dialog
//       'image': 'assets/images/Ellipse 14.png',
//       'isUnread': true,
//     },
//     {
//       'group': '30/04/2025', // Specific Date
//       'title': 'متجر امازون',
//       'message': 'تم اضافة عرض جديد ...',
//       'fullMessage': 'عرض جديد: اشتري 2 تيشيرت بسعر تيشيرت واحد. هذا العرض مقدم لك ولكل العملاء المميزين لدينا.', // Add full message for dialog
//       'image': 'assets/images/Ellipse 14.png',
//       'isUnread': true,
//     },
//     {
//       'group': '30/04/2025', // Specific Date
//       'title': 'متجر امازون',
//       'message': 'تم اضافة عرض جديد ...',
//       'fullMessage': 'عرض جديد: اشتري 2 تيشيرت بسعر تيشيرت واحد. هذا العرض مقدم لك ولكل العملاء المميزين لدينا.', // Add full message for dialog
//       'image': 'assets/images/Ellipse 14.png',
//       'isUnread': true,
//     },
//     {
//       'group': '30/04/2025', // Specific Date
//       'title': 'متجر امازون',
//       'message': 'تم اضافة عرض جديد ...',
//       'fullMessage': 'عرض جديد: اشتري 2 تيشيرت بسعر تيشيرت واحد. هذا العرض مقدم لك ولكل العملاء المميزين لدينا.', // Add full message for dialog
//       'image': 'assets/images/Ellipse 14.png',
//       'isUnread': true,
//     },
//     {
//       'group': '30/04/2025', // Specific Date
//       'title': 'متجر امازون',
//       'message': 'تم اضافة عرض جديد ...',
//       'fullMessage': 'عرض جديد: اشتري 2 تيشيرت بسعر تيشيرت واحد. هذا العرض مقدم لك ولكل العملاء المميزين لدينا.', // Add full message for dialog
//       'image': 'assets/images/Ellipse 14.png',
//       'isUnread': true,
//     },
//   ];
//
//   Map<String, List<Map<String, dynamic>>> get groupedNotifications {
//     // ... existing code ...
//     final Map<String, List<Map<String, dynamic>>> map = {};
//     for (var notification in notifications) {
//       final group = notification['group'] as String;
//       if (map[group] == null) {
//         map[group] = [];
//       }
//       map[group]!.add(notification);
//     }
//     return map;
//   }
//
//
//   final ThemeController themeController =
//   Get.put(ThemeController()); // Access ThemeController
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = themeController.themeMode.value == ThemeMode.dark;
//
//     // ... (Keep existing build method structure up to the Expanded widget) ...
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: isDark? Colors.black:Colors.white, // Set background to white
//         body: Column(
//           children: [
//             // ... (Keep existing Header Container) ...
//             Container(
//               decoration:  BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: isDark?[
//                     AppColors.primary,
//                     AppColors.primary,
//                     Colors.black,
//                   ]:[
//                     AppColors.primary,
//                     AppColors.primary,
//                     Colors.white,
//                   ],
//                   stops: [0.0, 0.0, 5.0],
//                 ),
//               ),
//               child: Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: SvgPicture.asset(
//                         'assets/svg/backbutton.svg',
//                         width: 40,
//                         height: 40,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(right: 20),
//                       child: Text(
//                         'الأشعارات',
//                         style: GoogleFonts.tajawal(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25),
//                         color: Colors.white,
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           // Handle notification action
//                         },
//                         child: Stack(
//                           children: [
//                             IconButton(
//                               icon: SvgPicture.asset(
//                                 'assets/svg/notify.svg',
//                                 width: 24, // Adjust size as needed
//                                 height: 24,
//                                 colorFilter: const ColorFilter.mode(
//                                   Colors
//                                       .black54, // Match the original icon color
//                                   BlendMode.srcIn,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 // Handle notification button press
//                                 print('Notifications Tapped');
//                               },
//                             ),
//                             // Notification Badge
//                             Positioned(
//                               right: 11,
//                               top: 14,
//                               child: Container(
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 constraints: const BoxConstraints(
//                                   minWidth: 8,
//                                   minHeight: 8,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // ... (Keep existing Delete All Button Section) ...
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end, // Align to the right (adjust if needed for RTL)
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       // Handle Delete All action
//                       print('Delete All Tapped');
//                       setState(() {
//                         notifications.clear(); // Example action
//                       });
//                     },
//                     child: Row(
//                       children: [
//                         Text(
//                           'حذف الكل',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 14,
//                             // color: Colors.grey[600], // Adjust color
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Icon(
//                           Icons.delete_outline, // Use a delete icon
//                           // color: Colors.grey[600], // Adjust color
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//             // Main content
//             Expanded(
//               child: notifications.isEmpty
//                   ? _buildEmptyState() // Use the updated empty state
//                   : _buildGroupedNotificationsList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Updated Empty State Widget
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Replace with your SVG asset for the empty notification bell
//           SvgPicture.asset(
//             'assets/svg/Notification 1.svg', // <<<--- ADD YOUR SVG PATH HERE
//             // width: 100, // Adjust size as needed
//             // height: 100,
//             colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn), // Adjust color
//           ),
//           const SizedBox(height: 25),
//           Text(
//             'لم تتلق اي اشعارات بعد',
//             style: GoogleFonts.tajawal(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'سننبهك عندما يحدث شيء رائع',
//             style: GoogleFonts.tajawal(
//               fontSize: 14,
//               color: AppColors.primary, // Use primary color for the link-like text
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ... (Keep existing _buildGroupedNotificationsList method) ...
//   Widget _buildGroupedNotificationsList() {
//     // ... existing code ...
//     final groups = groupedNotifications.keys.toList();
//
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), // Adjust padding
//       itemCount: groups.length,
//       itemBuilder: (context, groupIndex) {
//         final groupName = groups[groupIndex];
//         final groupItems = groupedNotifications[groupName]!;
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.end, // Align group title to the right
//           children: [
//             // Group Header (Date/Time)
//             Padding(
//               padding: const EdgeInsets.only(right: 10.0, top: 15.0, bottom: 8.0),
//               child: Text(
//                 groupName,
//                 style: GoogleFonts.tajawal(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ),
//             // Items within the group
//             ListView.builder(
//               shrinkWrap: true, // Important for nested ListView
//               physics: const NeverScrollableScrollPhysics(), // Disable scrolling for inner list
//               itemCount: groupItems.length,
//               itemBuilder: (context, itemIndex) {
//                 final notification = groupItems[itemIndex];
//                 // Make sure 'fullMessage' exists, provide default if not
//                 final fullMessage = notification['fullMessage'] as String? ?? notification['message'] as String;
//                 return _buildNotificationItem(
//                     title: notification['title'] as String,
//                     message: notification['message'] as String,
//                     imagePath: notification['image'] as String,
//                     isUnread: notification['isUnread'] as bool,
//                     onTap: () {
//                       // Call the dialog function on tap
//                       _showNotificationDialog(
//                           context,
//                           notification, // Pass the whole notification map
//                           fullMessage, // Pass the full message
//                               () { // onDelete callback for the dialog
//                             setState(() {
//                               notifications.remove(notification);
//                               Navigator.of(context).pop(); // Close dialog after delete
//                             });
//                           },
//                               () { // onRead callback for the dialog
//                             setState(() {
//                               notification['isUnread'] = false;
//                             });
//                             Navigator.of(context).pop(); // Close dialog after marking as read
//                           }
//                       );
//                       // Optionally mark as read immediately when tapped (before dialog)
//                       // setState(() {
//                       //   notification['isUnread'] = false;
//                       // });
//                     },
//                     onDelete: () {
//                       // Handle direct delete action from the 'X' icon
//                       print('Delete Tapped: ${notification['title']}');
//                       setState(() {
//                         notifications.remove(notification);
//                       });
//                     }
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   // ... (Keep existing _buildNotificationItem method) ...
//   Widget _buildNotificationItem({
//     required String title,
//     required String message,
//     required String imagePath, // Use imagePath
//     required bool isUnread, // Use isUnread status
//     required VoidCallback onTap,
//     required VoidCallback onDelete, // Callback for delete action
//   }) {
//     // ... existing code ...
//     return GestureDetector(
//       onTap: onTap, // This will now call _showNotificationDialog
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8), // Increased vertical margin
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Adjust padding
//         decoration: BoxDecoration(
//           // color: Colors.white, // White background
//           borderRadius: BorderRadius.circular(30), // More rounded corners
//           border: Border.all( // Add border
//             color: AppColors.primary.withOpacity(0.5), // Light blue border
//             width: 1.5,
//           ),
//           boxShadow: [ // Optional: subtle shadow
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.15),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements out
//           children: [
//             // Delete Icon ('X')
//             GestureDetector(
//               onTap: onDelete, // Direct delete from list item
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 8.0), // Add padding around icon
//                 child: Icon(
//                   Icons.close,
//                   color: Colors.grey[500],
//                   size: 20,
//                 ),
//               ),
//             ),
//
//             // Notification content (takes remaining space)
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end, // Align content to the right
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Text Content Column
//                   Expanded( // Allow text to take available space and wrap if needed
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             title,
//                             style: GoogleFonts.tajawal(
//                               fontSize: 15, // Slightly smaller font
//                               fontWeight: FontWeight.bold,
//                               // color: Colors.black87,
//                             ),
//                             textAlign: TextAlign.right,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 4), // Adjust spacing
//                           Text(
//                             message, // Use the actual message snippet
//                             style: GoogleFonts.tajawal(
//                               fontSize: 13, // Slightly smaller font
//                               // color: Colors.grey[600],
//                             ),
//                             textAlign: TextAlign.right,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Unread Indicator
//                   if (isUnread) // Conditionally show the dot
//                     Container(
//                       width: 8, // Smaller dot
//                       height: 8,
//                       margin: const EdgeInsets.only(left: 8), // Margin next to text
//                       decoration: const BoxDecoration(
//                         color: AppColors.primary, // Blue color from image
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   // Profile image
//                   CircleAvatar(
//                     radius: 22, // Adjust size
//                     backgroundColor: Colors.grey[200], // Placeholder background
//                     backgroundImage: AssetImage(imagePath),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // New Notification Pop-Up Dialog Implementation
//   void _showNotificationDialog(
//       BuildContext context,
//       Map<String, dynamic> notification, // Pass the whole notification data
//       String fullMessage, // Pass the full message separately
//       VoidCallback onDeleteConfirm, // Callback for delete confirmation
//       VoidCallback onReadConfirm,   // Callback for read confirmation
//       ) {
//     showDialog(
//       context: context,
//       barrierDismissible: true, // Allow dismissing by tapping outside
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25.0), // Rounded corners for dialog
//           ),
//           elevation: 5,
//           // backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min, // Make column height fit content
//               children: <Widget>[
//                 // Dialog Bell SVG
//                 SvgPicture.asset(
//                   'assets/svg/bell 1.svg', // <<<--- ADD YOUR SVG PATH HERE
//                   // width: 80, // Adjust size
//                   // height: 80,
//                   // Optional: Add color if needed
//                   colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
//                 ),
//                 const SizedBox(height: 15),
//                 // Title
//                 Text(
//                   notification['title'] as String,
//                   style: GoogleFonts.tajawal(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     // color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 5),
//                 // Profile image (optional, reuse from list item)
//                 CircleAvatar(
//                   radius: 25, // Adjust size
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: AssetImage(notification['image'] as String),
//                 ),
//                 const SizedBox(height: 15),
//                 // Full Message
//                 Text(
//                   fullMessage, // Display the full message here
//                   style: GoogleFonts.tajawal(
//                     fontSize: 14,
//                     // color: Colors.grey[600],
//                     height: 1.4, // Adjust line spacing
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 25),
//                 // Action Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons
//                   children: [
//                     // Delete Button (حذف)
//                     ElevatedButton(
//                       onPressed: onDeleteConfirm, // Use the passed callback
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey[400], // Grey background
//                         foregroundColor: Colors.white, // White text
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
//                       ),
//                       child: Text(
//                         'حذف',
//                         style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15),
//                       ),
//                     ),
//                     // Read Button (قراءة)
//                     ElevatedButton(
//                       onPressed: onReadConfirm, // Use the passed callback
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary, // Blue background
//                         foregroundColor: Colors.white, // White text
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
//                       ),
//                       child: Text(
//                         'قراءة',
//                         style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
