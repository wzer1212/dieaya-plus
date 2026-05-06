import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/app_colors.dart';
import 'package:get/get.dart';
import '../../controllers/CountsConroller/counts_controller.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import '../../models/market_banneers_model.dart';

class PromoBanner extends StatefulWidget {
  final String location;
  final double? bannerHeight;

  const PromoBanner({super.key, required this.location, this.bannerHeight});

  @override
  _PromoBannerState createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final MarketBannersController _marketBannersController = Get.put(
    MarketBannersController(),
    tag: UniqueKey().toString(),
  );

  final ViewCountController _viewCountController =
      Get.put(ViewCountController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _marketBannersController.fetchMarketBanners(location: widget.location);
    });
  }

  @override
  void dispose() {
    Get.delete<MarketBannersController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPromoBanner(context);
  }

  Widget _buildPromoBanner(BuildContext context) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() => Padding(
          // padding: EdgeInsets.all(screenWidth * 0.03),
          padding: EdgeInsets.only(
              right: screenWidth * 0.03, left: screenWidth * 0.03),
          child: Column(
            children: [
              _marketBannersController.isLoading.value
                  ? SizedBox(
                      height:
                          kIsWeb ? screenHeight * 0.60 : screenHeight * 0.27,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : _marketBannersController.errorMessage.value.isNotEmpty ||
                          _marketBannersController.banners.isEmpty
                      ? SizedBox.shrink(
                          // height: screenHeight * 0.27,
                          // child: Center(
                          //   child: CustomTextSolveIssue(
                          //     'no_data'.tr,
                          //     style: GoogleFonts.tajawal(
                          //       fontSize: screenWidth * 0.045,
                          //       color: Colors.black54,
                          //     ),
                          //   ),
                          // ),
                          )
                      : SizedBox(
                          height: kIsWeb
                              ? screenHeight * 0.60
                              : screenHeight * 0.27,
                          child: CarouselSlider.builder(
                            itemCount: _marketBannersController.banners.length,
                            itemBuilder: (context, index, realIndex) {
                              final banner =
                                  _marketBannersController.banners[index];
                              final link = banner.link.trim() ?? '';
                              final hasValidLink = link.isNotEmpty &&
                                  Uri.tryParse(link)?.hasScheme == true;

                              print(
                                  'PromoBanner ${banner.id}: link="$link", hasValidLink=$hasValidLink');

                              return Stack(
                                children: [
                                  // Background Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.10),
                                    child: Image.asset(
                                      'assets/images/continerBack.png',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        color: Colors.grey.shade200,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  // Main Banner Image
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.05),
                                      child: Image.network(
                                        banner.image,
                                        fit: BoxFit.cover,
                                        height: widget.bannerHeight ??
                                            (screenHeight * 0.25),
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/Rectangle 22489.png',
                                          fit: BoxFit.cover,
                                          height: kIsWeb
                                              ? screenHeight * 50
                                              : screenHeight * 0.25,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Store Logo and Name (Top Right)
                                  Positioned(
                                    top: screenHeight * 0.015,
                                    right: Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? screenWidth * 0.03
                                        : null,
                                    left: Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? null
                                        : screenWidth * 0.03,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: screenWidth * 0.04,
                                          backgroundImage: banner
                                                  .market.logo.isNotEmpty
                                              ? NetworkImage(banner.market.logo)
                                              : null,
                                          backgroundColor: Colors.white,
                                          child: banner.market.logo.isEmpty
                                              ? Image.asset(
                                                  'assets/images/Ellipse 14.png')
                                              : null,
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        CustomTextSolveIssue(
                                          banner.market.name,
                                          style: GoogleFonts.tajawal(
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 2.0,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                offset: const Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: screenHeight * 0.015,
                                    left: Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? screenWidth * 0.05
                                        : screenWidth * 0.05,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextSolveIssue(
                                          'اعلان',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  // Bottom Row with Text and Button
                                  Positioned(
                                    bottom: screenHeight * 0.04,
                                    left: screenWidth * 0.03,
                                    right: screenWidth * 0.03,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomTextSolveIssue(
                                            Get.locale?.languageCode == 'ar'
                                                ? banner.descriptionAr
                                                : banner.descriptionEn,
                                            textAlign:
                                                Directionality.of(context) ==
                                                        TextDirection.rtl
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.tajawal(
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.04,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: hasValidLink,
                                          child: Expanded(
                                            child: SizedBox(
                                              width: kIsWeb
                                                  ? screenWidth * 50
                                                  : screenWidth * 0.25,
                                              height: kIsWeb
                                                  ? screenHeight * 0.10
                                                  : screenHeight * 0.05,
                                              child: CustomButton(
                                                text: 'shop_now'.tr,
                                                textSize: 16,
                                                onPressed: () async {
                                                  print(
                                                      'Attempting to open link: $link');
                                                  // Normalize URL if scheme is missing
                                                  String normalizedUrl = link;
                                                  if (!link.startsWith(
                                                      RegExp(r'https?://'))) {
                                                    normalizedUrl =
                                                        'https://$link';
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
                                                        _viewCountController
                                                            .incrementMarketBannerViews(
                                                                banner.id);
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
                                                },
                                                textFontWeight: FontWeight.bold,
                                                textColor: AppColors.primary,
                                                color: Colors.white,
                                                iconPath:
                                                    'assets/svg/mynaui_click-solid.svg',
                                                iconSize: screenWidth * 0.06,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            options: CarouselOptions(
                              height: kIsWeb ? 275.h : screenHeight * 0.27,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.easeInOut,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: true,
                              reverse: Directionality.of(context) ==
                                  TextDirection.rtl,
                              onPageChanged: (index, reason) {
                                // Update current index if needed
                              },
                            ),
                          ),
                        ),
            ],
          ),
        ));
  }
}
