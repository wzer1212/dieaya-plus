import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../../Utils/app_colors.dart';
import '../../controllers/ThemeController/theme_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../Utils/app_colors.dart';

// Define MarketCoupon and Market classes
class MarketCoupon {
  final int id;
  final String discount;
  final String couponCode;
  final Market market;

  MarketCoupon({
    required this.id,
    required this.discount,
    required this.couponCode,
    required this.market,
  });
}

class Market {
  final String name;
  final String logo;

  Market({required this.name, required this.logo});
}

// Static test data for coupons
final List<MarketCoupon> testCoupons = [
  MarketCoupon(
    id: 1,
    discount: '25',
    couponCode: 'SAVE25',
    market: Market(
      name: 'متجر التوفير',
      logo: 'https://via.placeholder.com/50', // Placeholder logo
    ),
  ),
  MarketCoupon(
    id: 2,
    discount: '15',
    couponCode: 'DISCOUNT15',
    market: Market(
      name: 'متجر التقنية',
      logo: 'https://via.placeholder.com/50', // Placeholder logo
    ),
  ),
  MarketCoupon(
    id: 3,
    discount: '10',
    couponCode: 'OFFER10',
    market: Market(
      name: 'متجر الأزياء',
      logo: 'https://via.placeholder.com/50', // Placeholder logo
    ),
  ),
];

// CouponCardGrid widget
class CouponCardGrid extends StatelessWidget {
  final MarketCoupon coupon;
  final VoidCallback? onCopy;
  final VoidCallback? onTap;

  const CouponCardGrid({
    super.key,
    required this.coupon,
    this.onCopy,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.45; // 45% of screen width
    final cardHeight = cardWidth * 1.33; // Maintain 4:3 aspect ratio

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: cardWidth,
            height: cardHeight,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF00B4FF).withOpacity(0.3) : Color(0xFF00B4FF).withOpacity(0.1),
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
                padding: EdgeInsets.all(cardWidth * 0.06),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'discount'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: cardWidth * 0.11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black54,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              coupon.discount,
                              style: GoogleFonts.tajawal(
                                fontSize: cardWidth * 0.30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              '%',
                              style: GoogleFonts.tajawal(
                                fontSize: cardWidth * 0.11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            coupon.couponCode,
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.08,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
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

// CouponCardList widget
class CouponCardList extends StatelessWidget {
  final MarketCoupon coupon;
  final VoidCallback? onCopy;
  final VoidCallback? onTap;

  const CouponCardList({
    super.key,
    required this.coupon,
    this.onCopy,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9; // 90% of screen width for list view
    final cardHeight = screenHeight * 0.190; // Fixed height relative to screen

    final bool isArabic = Get.locale?.languageCode == 'ar';

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: cardWidth,
            height: cardHeight,
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF00B4FF).withOpacity(0.3) : Color(0xFF00B4FF).withOpacity(0.1),
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
                padding: EdgeInsets.all(cardWidth * 0.03),
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
                                radius: cardWidth * 0.07,
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
                                child: Text(
                                  coupon.market.name,
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'discount'.tr,
                              style: GoogleFonts.tajawal(
                                fontSize: cardWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black54,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              coupon.discount,
                              style: GoogleFonts.tajawal(
                                fontSize: cardWidth * 0.17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              '%',
                              style: GoogleFonts.tajawal(
                                fontSize: cardWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          coupon.couponCode,
                          style: GoogleFonts.tajawal(
                            fontSize: cardWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: cardWidth * 0.03),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: coupon.couponCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('code_copied'.tr)),
                            );
                            onCopy?.call();
                          },
                          child: SvgPicture.asset(
                            'assets/svg/copy.svg',
                            width: cardWidth * 0.05,
                            height: cardWidth * 0.05,
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

// _CouponCardPainter class (unchanged)
class _CouponCardPainter extends CustomPainter {
  final double cutoutRadius;
  final Color dashColor;
  final Color cutoutColor;
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
    final Paint cutoutPaint = Paint()..color = cutoutColor;

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