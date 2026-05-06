import 'package:dieaya_user/Routes/app_routes.dart';
import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/controllers/OffersControllers/get_offer_controller.dart'
    show MarketOffersController;
import 'package:dieaya_user/controllers/offer_visits_controllerz/offer_visits_controller.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/CountsConroller/counts_controller.dart';
import '../../../controllers/FavController/fav_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/offer_model.dart';
import '../../widgets/custom_sheets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class OfferDetailsScreenDeepLink extends StatefulWidget {
  final String offerId;
  final bool? isFromDeepLink;

  OfferDetailsScreenDeepLink(
      {super.key, required this.offerId, this.isFromDeepLink = false});

  @override
  State<OfferDetailsScreenDeepLink> createState() =>
      _OfferDetailsScreenDeepLinkState();
}

class _OfferDetailsScreenDeepLinkState
    extends State<OfferDetailsScreenDeepLink> {
  final OfferVisitsController offerVisitsController =
      Get.put(OfferVisitsController());
  final MarketOffersController offersController =
      Get.put(MarketOffersController());

  @override
  void initState() {
    offersController.getOfferDetails(widget.offerId);
    offerVisitsController.callOfferVisit(int.tryParse(widget.offerId) ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ThemeController themeController = Get.find<ThemeController>();
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final isArabic = Get.locale?.languageCode == 'ar';
    final ViewCountController viewCountController =
        Get.put(ViewCountController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Obx(
          () {
            if (offersController.isLoading.value) {
              return Column(
                children: [
                  SizedBox(
                    height: 400.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ],
              );
            }
            if (offersController.errorMessage.value.isNotEmpty) {
              return Column(
                children: [
                  SizedBox(
                    height: 400.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextSolveIssue(offersController.errorMessage.value),
                    ],
                  ),
                ],
              );
            }
            // final hasValidCouponCode =
            // offersController.offer.value.couponCode?.isNotEmpty;

            if (offersController.offer.value != null) {
              MarketOffer offerData = offersController.offer.value!;
              return Stack(
                children: [
                  Container(
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(50.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.8),
                                Colors.black,
                              ]
                            : [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.6),
                                Colors.white,
                              ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          top: 30, start: 8, end: 8, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (widget.isFromDeepLink!) {
                                Get.offAllNamed(AppRoutes.navbar);
                              } else {
                                Get.back();
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              child: SvgPicture.asset(
                                'assets/svg/backbutton.svg',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  var appLink =
                                      '🎁 عرض خاص من متجر ${offerData.market.name}\n\n'
                                      '📢 ${offerData.titleAr}\n\n'
                                      '${offerData.descriptionAr}\n\n'
                                      '📋 الشروط:\n${offerData.terms??'لا يوحد'}\n'
                                      '📋 الكود:\n${offerData.couponCode??'لا يوجد'}\n\n'
                                      '🔗 شاهد العرض الآن\n'
                                      '${ApiConstants.shareBaseUrl}/shop/offer/${offerData.id}\n\n'
                                      '#عروض #${offerData.market.name} #كوبونات';
                                  // var appLink = offerData.shareLink.isEmpty
                                  //     ? '${ApiConstants.baseUrl.replaceAll('/api', "")}/offer/${offerData.id}'
                                  //     : offerData.shareLink;

                                  final box = context.findRenderObject() as RenderBox?;
                                  final sharePositionOrigin = box != null
                                      ? box.localToGlobal(Offset.zero) & box.size
                                      : Rect.fromLTWH(0, 0, screenWidth, screenHeight / 2);

                                  Share.share(
                                    '$appLink',
                                    sharePositionOrigin: sharePositionOrigin,
                                  );
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: SvgPicture.asset(
                                    'assets/svg/share.svg',
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 5, vertical: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: isArabic
                                      ? Alignment.bottomLeft
                                      : Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              offerData.market.logo),
                                          fit: BoxFit.cover,
                                          onError: (exception, stackTrace) =>
                                              const AssetImage(
                                                  'assets/images/Ellipse 14.png'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                CustomTextSolveIssue(
                                  isArabic
                                      ? offerData.market.name ??
                                          offerData.market.name
                                      : offerData.market.name ??
                                          offerData.market.name,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xff666565),
                                  ),
                                ),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Column(
                              crossAxisAlignment: isArabic
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff9C9C9C)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: CustomTextSolveIssue(
                                    offerData.type == 'discount'
                                        ? (isArabic
                                            ? offerData.titleAr ?? 'no_data'.tr
                                            : (offerData.titleEn ??
                                                'no_data'.tr))
                                        : (isArabic
                                            ? (offerData.titleAr ??
                                                'no_description'.tr)
                                            : (offerData.titleAr ??
                                                'no_description'.tr)),
                                    style: GoogleFonts.tajawal(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.primary
                                          : offerData.type == 'discount'
                                              ? AppColors.primary
                                              : AppColors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextSolveIssue(
                                  'offer'.tr,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 10),
                                CustomTextSolveIssue(
                                  isArabic
                                      ? (offerData.descriptionAr ??
                                          'no_description'.tr)
                                      : (offerData.descriptionEn ??
                                          'no_description'.tr),
                                  textAlign: isArabic
                                      ? TextAlign.start
                                      : TextAlign.start,
                                  maxLines: 20,

                                  style: GoogleFonts.tajawal(
                                    fontSize: 14,
                                    color: isDark ? Colors.white : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextSolveIssue(
                                  'app_terms'.tr,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 10),
                                CustomTextSolveIssue(
                                  isArabic
                                      ? (offerData.terms ?? 'no_conditions'.tr)
                                      : (offerData.terms ?? 'no_conditions'.tr),
                                  textAlign: isArabic
                                      ? TextAlign.start
                                      : TextAlign.start,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 14,
                                    color: isDark ? Colors.white : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Visibility(
                                  visible:
                                      offerData.couponCode?.isNotEmpty ?? false,
                                  child: Column(
                                    crossAxisAlignment: isArabic
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.start,
                                    children: [
                                      CustomTextSolveIssue(
                                        'code'.tr,
                                        style: GoogleFonts.tajawal(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff9C9C9C)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomTextSolveIssue(
                                              offerData.couponCode ?? '',
                                              style: GoogleFonts.tajawal(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () async {
                                                final success =
                                                    await viewCountController
                                                        .incrementOfferViews(
                                                            offerData.id!);
                                                debugPrint(
                                                    'Offer Views Increment for ${offerData.couponCode}: $success');
                                                Clipboard.setData(ClipboardData(
                                                    text:
                                                        offerData.couponCode ??
                                                            ''));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content:
                                                          CustomTextSolveIssue(
                                                              'code_copied'
                                                                  .tr)),
                                                );
                                                print(
                                                    'Coupon code copied: ${offerData.couponCode}');
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
                                Center(
                                  child: CustomButton(
                                    width: 200,
                                    borderRadius: 30,
                                    onPressed: () async {
                                      final url = offerData.link;
                                      if (url != null && url.isNotEmpty) {
                                        final uri = Uri.tryParse(url);
                                        if (uri != null &&
                                            await canLaunchUrl(uri)) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                          print('Opening URL: $url');
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: CustomTextSolveIssue(
                                                    'cannot_open_link'.tr)),
                                          );
                                          print('Invalid URL: $url');
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: CustomTextSolveIssue(
                                                  'no_link_available'.tr)),
                                        );
                                        print(
                                            'No URL provided for offer: ${offerData.id}');
                                      }
                                    },
                                    text: 'buy_now'.tr,
                                    iconPath:
                                        'assets/svg/mynaui_click-solid.svg',
                                    iconColor: Colors.white,
                                    textSize: 18,
                                    textFontWeight: FontWeight.bold,
                                    iconSize: 25,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final int offerId;
  final VoidCallback? onFavoriteTap;

  const FavoriteButton({
    super.key,
    required this.offerId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(marketId: offerId);
      final isLoading = controller.isLoading.value;

      return GestureDetector(
        onTap: isLoading
            ? null // Disable tap during loading
            : () async {
                bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
                if (isLoggedIn) {
                  await controller.toggleFavorite(marketId: offerId);
                  onFavoriteTap?.call();
                } else {
                  CustomSheets.showLoginSheet(context);
                  debugPrint('Favorite Action - Showing Login Bottom Sheet');
                }
              },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: isLoading
              ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : SvgPicture.asset(
                  isFavorite
                      ? 'assets/svg/fullheart2.svg'
                      : 'assets/svg/Heart 2.svg',
                  width: 25,
                  height: 25,
                  colorFilter: isFavorite
                      ? const ColorFilter.mode(
                          AppColors.primary, BlendMode.srcIn)
                      : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
        ),
      );
    });
  }
}
