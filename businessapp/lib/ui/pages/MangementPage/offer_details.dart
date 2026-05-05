import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/OfferController/offer_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/offer_model.dart';
import '../../../utils/app_snackbars.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_sheets.dart';
import 'package:flutter_svg/svg.dart';


class OfferDetailsScreen extends StatefulWidget {
  final Offer offer;

  const OfferDetailsScreen({super.key, required this.offer});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  final OfferController offerController = Get.put(OfferController());

  void _confirmDelete(BuildContext context, Offer offer) {
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
                  bool success = await offerController.deleteOffer(id: offer.id!); // Ensure offer.id is not null
                  if (success) {
                    Get.back(); // Navigate back after deletion
                    SnackBarConstantVersion1.showSuccessSnackbar(
                      'success'.tr,
                      'deleteOfferSuccess'.tr,
                    );
                  } else {
                    SnackBarConstantVersion1.showErrorSnackbar( // Use showErrorSnackbar for error
                      'error'.tr,
                      offerController.errorMessage.value,
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
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final hasValidCouponCode = (widget.offer.couponCode?.isNotEmpty ?? false);
    final isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
        child: Column(
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
                    top: 60, start: 8, end: 8, bottom: 30),
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
                        //     print('Share tapped for offer: ${widget.offer.id}');
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
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment:
                isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      child: Image.asset('assets/images/coupon_dtails.png'),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'title'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff9C9C9C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isArabic ? (widget.offer.titleAr ?? 'no_data'.tr) : (widget.offer.titleEn ?? 'no_data'.tr),
                          style: GoogleFonts.tajawal(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'offer'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isArabic
                        ? (widget.offer.descriptionAr ?? 'no_description'.tr)
                        : (widget.offer.descriptionEn ?? 'no_description'.tr),
                    textAlign: isArabic ? TextAlign.end : TextAlign.start,
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'الشروط'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isArabic
                        ? (widget.offer.terms ?? 'no_conditions'.tr)
                        : (widget.offer.terms ?? 'no_conditions'.tr),
                    maxLines: 20,
                    textAlign: isArabic ? TextAlign.end : TextAlign.start,
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: hasValidCouponCode,
                    child: Column(
                      crossAxisAlignment:
                      isArabic ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'code'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xff9C9C9C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.offer.couponCode ?? 'no_code'.tr,
                                style: GoogleFonts.tajawal(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: widget.offer.couponCode ?? ''));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('code_copied'.tr)),
                                  );
                                  print('Coupon code copied: ${widget.offer.couponCode}');
                                },
                                child: SvgPicture.asset(
                                  'assets/svg/copy.svg',
                                  width: 20,
                                  height: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
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
                    CustomSheets.showAddOfferSheet(context, offer: widget.offer);
                  },
                  text: 'editApp'.tr,
                  textFontWeight: FontWeight.bold,
                  textSize: 18,
                  color: AppColors.blue,
                ),
                const SizedBox(height: 8), // Space between buttons
                CustomButton(
                  onPressed: () {
                    _confirmDelete(context, widget.offer);
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
