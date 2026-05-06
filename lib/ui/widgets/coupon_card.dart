import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/app_colors.dart';
import '../../controllers/CountsConroller/counts_controller.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import '../../models/coupons_model.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

// class Coupon {
//   final String id;
//   final String code;
//   final String imageUrl; // Logo/Brand image for the coupon
//   final String description; // e.g., "خصم 50%"
//   final String expiryDate; // Optional: Display if needed
//
//   Coupon(
//       {required this.id,
//         required this.code,
//         required this.imageUrl,
//         required this.description,
//         required this.expiryDate});
// }
// final List<Coupon> dummyCoupons = [
//   Coupon(
//       id: 'coupon1',
//       code: 'SAVE50',
//       imageUrl: 'assets/images/Ellipse 14.png',
//       description: 'خصم 50%',
//       expiryDate: '2025-12-31'), // Replace logo path
//   Coupon(
//       id: 'coupon2',
//       code: 'NAMSHI20',
//       imageUrl: 'assets/images/Ellipse 14.png',
//       description: 'خصم 20%',
//       expiryDate: '2025-06-30'),
//   Coupon(
//       id: 'coupon3',
//       code: 'STYLE15',
//       imageUrl: 'assets/images/Ellipse 14.png',
//       description: 'خصم 15%',
//       expiryDate: '2025-09-15'),
//   Coupon(
//       id: 'coupon4',
//       code: 'DEAL70',
//       imageUrl: 'assets/images/Ellipse 14.png',
//       description: 'خصم 70%',
//       expiryDate: '2025-05-31'),
//   Coupon(
//       id: 'coupon5',
//       code: 'EXTRA10',
//       imageUrl: 'assets/images/Ellipse 14.png',
//       description: 'خصم 10%',
//       expiryDate: '2025-12-31'),
// ];



class CouponCardGrid extends StatelessWidget {
  final MarketCoupon coupon;
  final VoidCallback? onCopy;
  final VoidCallback? onTap;
  final double? logoHeight;

  const CouponCardGrid({
    super.key,
    required this.coupon,
    this.onCopy,
    this.onTap, this.logoHeight,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
    final ViewCountController viewCountController = Get.put(ViewCountController());

    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.45; // 45% of screen width
    final cardHeight = cardWidth * 1.33; // Maintain 4:3 aspect ratio



    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: kIsWeb?280.w:cardWidth,
        // height: kIsWeb?8.h: cardHeight,
        // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        decoration: BoxDecoration(
          color: isDark? Color(0xFF00B4FF).withOpacity(0.3): Color(0xFF00B4FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(cardWidth * 0.08),
        ),
        child: CustomPaint(
          painter: _CouponCardPainter(
            cutoutColor: isDark ? Colors.black : Colors.white,
            cutoutRadius: cardWidth * 0.08,
            dashColor: Colors.white,
            dashWidth: cardWidth * 0.025,
            dashSpace: cardWidth * 0.015,
          ),
          child: Padding(
            padding: EdgeInsets.only(right:cardWidth * 0.08,top: cardWidth *0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: logoHeight??cardWidth * 0.1,
                      backgroundColor: Colors.grey[300],
                      child: coupon.market.logo.isNotEmpty
                          ? ClipOval(
                        child: Image.network(
                          coupon.market.logo,
                          fit: BoxFit.fill,
                          width: cardWidth * 0.2,
                          height: cardWidth * 0.2,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.store, color: Colors.grey),
                        ),
                      )
                          : const Icon(Icons.store, color: Colors.grey),
                    ),
                    SizedBox(width: screenWidth * 0.025),
                    Expanded(
                      child: CustomTextSolveIssue(
                        coupon.market.name,
                        style: GoogleFonts.tajawal(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white :Colors.black87,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: CustomTextSolveIssue(
                        'discount'.tr,
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 3,
                        style: GoogleFonts.tajawal(
                          fontSize: 21.sp,
                          // fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white :Color(0xff666565),
                        ),
                      ),
                    ),
                    // SizedBox(height: cardHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextSolveIssue(
                          coupon.discount,
                          style: GoogleFonts.tajawal(
                            fontSize: 55.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            // height: 1.2,
                          ),
                        ),
                        CustomTextSolveIssue(
                          '%',
                          // overflow: TextOverflow.ellipsis,
                          // maxLines: 3,
                          style: GoogleFonts.tajawal(
                            fontSize: 23.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white :Colors.black54,
                          ),
                        ),

                      ],

                    )],
                ),
                SizedBox(height:5.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        final success = await viewCountController.incrementCouponViews(coupon.id!);
                        debugPrint('Coupon Views Increment for ${coupon.couponCode}: $success');
                        Clipboard.setData(ClipboardData(text: coupon.couponCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: CustomTextSolveIssue('تم نسخ الكود!')),
                        );

                        print(
                            'Attempting to open link: ${coupon.link}');
                        // Normalize URL if scheme is missing
                        String normalizedUrl = coupon.link;
                        if (!coupon.link.startsWith(
                            RegExp(r'https?://'))) {
                          normalizedUrl =
                          'https://$coupon.product.link';
                        }
                        final uri = Uri.tryParse(
                            normalizedUrl);
                        if (uri != null) {
                          try {
                            final canLaunch =
                            await canLaunchUrl(
                                uri);
                            print(
                                'Can launch URL: $canLaunch');
                            if (canLaunch) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode
                                    .externalApplication,
                              );
                              print(
                                  'Successfully opened: $normalizedUrl');
                              // _viewCountController.incrementMarketBannerViews(banner.id);
                            } else {
                              print(
                                  'Cannot launch URL: $normalizedUrl');
                              Get.snackbar(
                                'خطأ',
                                'لا يمكن فتح الرابط: الرابط غير مدعوم',
                                snackPosition:
                                SnackPosition
                                    .BOTTOM,
                                duration:
                                const Duration(
                                    seconds: 3),
                              );
                            }
                          } catch (e) {
                            print(
                                'Error launching URL: $e');
                            Get.snackbar(
                              'خطأ',
                              'حدث خطأ أثناء فتح الرابط: $e',
                              snackPosition:
                              SnackPosition
                                  .BOTTOM,
                              duration:
                              const Duration(
                                  seconds: 3),
                            );
                          }
                        } else {
                          print(
                              'Invalid URL: $normalizedUrl');
                          Get.snackbar(
                            'خطأ',
                            'الرابط غير صالح: $normalizedUrl',
                            snackPosition:
                            SnackPosition.BOTTOM,
                            duration: const Duration(
                                seconds: 3),
                          );
                        }
                        onCopy?.call();
                      },
                      child: SvgPicture.asset(
                        'assets/svg/copy.svg',
                        fit: BoxFit.cover,
                        width: logoHeight ==null ?cardWidth * 0.10:logoHeight!,
                        height:logoHeight ==null ?cardWidth * 0.10:logoHeight!,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: cardWidth * 0.05),

                    Flexible(
                      child: CustomTextSolveIssue(
                        coupon.couponCode,
                        style: GoogleFonts.tajawal(
                          fontSize: cardWidth * 0.07,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white :Colors.black87,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height:20.h,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CouponCardList extends StatelessWidget {
  final MarketCoupon coupon;
  final VoidCallback? onCopy;
  final VoidCallback? onTap;
  final double? logoHeight;
  final double? storeNameFontSize;
  final double? discountPercentageFontSize;
  final double? discountFontSize;
  final double? couponCodeFontSize;
  final double? couponCardHeight;
  final double? CouponCodeIcon;


  const CouponCardList({
    super.key,
    required this.coupon,
    this.onCopy,
    this.onTap, this.logoHeight, this.storeNameFontSize, this.discountPercentageFontSize, this.discountFontSize, this.couponCodeFontSize, this.couponCardHeight, this.CouponCodeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
    final ViewCountController viewCountController = Get.put(ViewCountController());

    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9; // 90% of screen width for list view
    final cardHeight = screenHeight * 0.190; // Fixed height relative to screen


    final bool isArabic = Get.locale?.languageCode == 'ar';

    return GestureDetector(
      onTap: onTap ,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: cardWidth,
            height:couponCardHeight?? cardHeight,
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
              color: isDark? Color(0xFF00B4FF).withOpacity(0.3): Color(0xFF00B4FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(cardWidth * 0.04),
            ),
            child: CustomPaint(
              painter: _CouponCardPainter(
                cutoutColor: isDark ? Colors.black : Colors.white,
                cutoutRadius: cardWidth * 0.04,
                dashColor: Colors.white,
                dashWidth: cardWidth * 0.012,
                dashSpace: cardWidth * 0.008,
              ),
              child: Padding(
                padding: EdgeInsets.all(cardWidth * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: logoHeight??cardWidth * 0.07,
                                backgroundColor: Colors.grey[300],
                                child: coupon.market.logo.isNotEmpty
                                    ? ClipOval(
                                  child: Image.network(
                                    coupon.market.logo,
                                    fit: BoxFit.cover,
                                    width: cardWidth * 0.2,
                                    height: cardWidth * 0.2,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.store, color: Colors.grey),
                                  ),
                                )
                                    : const Icon(Icons.store, color: Colors.grey),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: CustomTextSolveIssue(
                                  coupon.market.name,
                                  style: GoogleFonts.tajawal(
                                    fontSize: storeNameFontSize??cardWidth * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: isDark? Colors.white :Colors.black87,
                                  ),
                                  textAlign:isArabic?TextAlign.right: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            CustomTextSolveIssue(
                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 3,
                              'discount'.tr,
                              style: GoogleFonts.tajawal(
                                fontSize:discountFontSize?? cardWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: isDark? Colors.white :Colors.black54,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            CustomTextSolveIssue(
                              coupon.discount,
                              style: GoogleFonts.tajawal(
                                fontSize:discountPercentageFontSize?? cardWidth * 0.17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                height: 1.1,
                              ),
                            ),
                            CustomTextSolveIssue(
                              '%',
                              style: GoogleFonts.tajawal(
                                fontSize: discountFontSize??cardWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: isDark? Colors.white :AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextSolveIssue(
                          coupon.couponCode,
                          style: GoogleFonts.tajawal(
                            fontSize: couponCodeFontSize??cardWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: isDark? Colors.white :Colors.black87,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: cardWidth * 0.03),
                        InkWell(
                          onTap: () async {
                            final success = await viewCountController.incrementCouponViews(coupon.id!);
                            debugPrint('Coupon Views Increment for ${coupon.couponCode}: $success');
                            Clipboard.setData(ClipboardData(text: coupon.couponCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: CustomTextSolveIssue('تم نسخ الكود!')),
                            );
                            onCopy?.call();
                          },
                          child: SvgPicture.asset(
                            'assets/svg/copy.svg',
                            width:CouponCodeIcon?? cardWidth * 0.05,
                            height: CouponCodeIcon??cardWidth * 0.05,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CouponCardPainter extends CustomPainter {
  final double cutoutRadius;
  final Color dashColor;
  final Color cutoutColor; // New parameter for cutout color
  final double dashWidth;
  final double dashSpace;

  _CouponCardPainter({
    required this.cutoutRadius,
    required this.dashColor,
    required this.cutoutColor,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dashColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final double dashLineY = size.height * 0.70; // Position the dashed line
    final double startX = cutoutRadius;
    final double endX = size.width - cutoutRadius;

    // Draw Dashed Line
    double currentX = startX;
    while (currentX < endX) {
      canvas.drawLine(
        Offset(currentX, dashLineY),
        Offset(currentX + dashWidth, dashLineY),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }

    // Draw Cutouts
    final Paint cutoutPaint = Paint()..color = cutoutColor; // Use provided cutout color

    // Left Cutout
    canvas.drawCircle(
      Offset(0, dashLineY),
      cutoutRadius,
      cutoutPaint,
    );

    // Right Cutout
    canvas.drawCircle(
      Offset(size.width, dashLineY),
      cutoutRadius,
      cutoutPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}