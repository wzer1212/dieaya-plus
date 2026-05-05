import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/CouponControllers/coupon_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/coupon_model.dart';
import '../../../utils/app_snackbars.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_sheets.dart';

class CouponDetailsPage extends StatelessWidget {
  final Coupon coupon;

  const CouponDetailsPage({Key? key, required this.coupon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final CouponController couponController = Get.put(CouponController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9; // Larger card for details page
    final cardHeight = cardWidth * 0.8;
    void _confirmDelete(BuildContext context, Coupon coupon) {
      showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/social/deleteacc.svg', // Ensure this SVG asset exists
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 10),
                Text(
                  'acceptMessageDelete'.tr, // Translated text for confirmation
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'sureDelete'.tr, // Translated text for confirmation message
                  style: GoogleFonts.tajawal(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext); // Dismiss the dialog
                    bool success = await couponController.deleteCoupon(id: coupon.id!); // Ensure coupon.id is not null
                    if (success) {
                      Get.back(); // Navigate back after deletion
                      SnackBarConstantVersion1.showSuccessSnackbar(
                        'successApp'.tr,
                        'deleteCouponSuccess'.tr, // Specific success message for coupon
                      );
                    } else {
                      SnackBarConstantVersion1.showErrorSnackbar( // Use showErrorSnackbar for error
                        'error'.tr,
                        couponController.errorMessage.value,
                      );
                    }
                  },
                  text: 'deleteApp'.tr, // Translated text for delete button
                  textSize: 16,
                  textFontWeight: FontWeight.bold,
                  color: const Color(0xffAEAEAE), // Custom color for delete button
                  textColor: Colors.white,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  text: 'cancelApp'.tr, // Translated text for cancel button
                  textSize: 16,
                  textFontWeight: FontWeight.bold,
                  // Assuming default button style is sufficient or adjust as needed
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                    AppColors.primary,
                    AppColors.primary,
                    Colors.black,
                  ]
                      : [
                    AppColors.primary,
                    AppColors.primary,
                    Colors.white,
                  ],
                  stops: const [0.0, 0.0, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 60,
                  start: 8,
                  end: 8,
                  bottom: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     // Implement share functionality if needed
                        //     print('Share tapped for coupon: ${coupon.id}');
                        //   },
                        //   child: Container(
                        //     width: 36,
                        //     height: 36,
                        //     child: SvgPicture.asset(
                        //       'assets/svg/share.svg',
                        //       width: 25,
                        //       height: 25,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Coupon Card
            Container(
              width: cardWidth,
              height: cardHeight,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'couponDiscount'.tr,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            coupon.couponCode,
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.08,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Color(0xff666565),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsetsDirectional.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: SizedBox(
            height: 120, // Increased height for two stacked buttons
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onPressed: () {
                    CustomSheets.showAddCouponSheet(context, coupon: coupon);
                  },
                  text: 'editApp'.tr,
                  textFontWeight: FontWeight.bold,
                  textSize: 18,
                  color: AppColors.blue,
                ),
                const SizedBox(height: 8), // Space between buttons
                CustomButton(
                  onPressed: () {
                    _confirmDelete(context, coupon);
                  },
                  text: 'deleteApp'.tr,
                  textFontWeight: FontWeight.bold,
                  textSize: 18,
                  color: Color(0xffAEAEAE),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CouponCardPainter (unchanged)
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

    final double dashLineY = size.height * 0.70;
    final double startX = cutoutRadius;
    final double endX = size.width - cutoutRadius;

    double currentX = startX;
    while (currentX < endX) {
      canvas.drawLine(
        Offset(currentX, dashLineY),
        Offset(currentX + dashWidth, dashLineY),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }

    final Paint cutoutPaint = Paint()..color = cutoutColor;

    canvas.drawCircle(
      Offset(0, dashLineY),
      cutoutRadius,
      cutoutPaint,
    );

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