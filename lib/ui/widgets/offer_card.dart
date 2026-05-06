import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/section_header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/app_colors.dart';
import '../../Utils/app_sharedprefs_contants.dart';
import '../../controllers/CountsConroller/counts_controller.dart';
import '../../controllers/FavController/fav_controller.dart';
import '../../controllers/OffersControllers/get_offer_controller.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import '../../models/offer_model.dart';
import '../pages/OffersScreen/offers_details_screen.dart';
import 'package:get/get.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../pages/OffersScreen/offers_screen.dart';
import 'custom_sheets.dart';

class OffersSection extends StatelessWidget {
  const OffersSection(
      {super.key,
      this.offerCardWidth,
      this.offerCardHeight,
      this.logoHeight,
      this.marketNameSize,
      this.offerFontSize,
      this.descriptionFontSize});

  final double? offerCardWidth;
  final double? offerCardHeight;
  final double? logoHeight;
  final double? marketNameSize;
  final double? offerFontSize;
  final double? descriptionFontSize;

  @override
  Widget build(BuildContext context) {
    final MarketOffersController marketOffersController =
        Get.put(MarketOffersController());
    final ViewCountController viewCountController =
        Get.put(ViewCountController());

    return Obx(() =>

    marketOffersController.marketOffers.isEmpty?
        SizedBox.shrink():
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: SectionHeader(
                title: 'best_offers'.tr,
                actionText: 'see_all'.tr,
                onActionPressed: () {
                  Get.to(() => OffersScreen(
                        fromSeeAll: true,
                      ));
                },
              ),
            ),
            marketOffersController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : marketOffersController.errorMessage.value.isNotEmpty
                    ? Center(
                        child: CustomTextSolveIssue(
                            marketOffersController.errorMessage.value))
                    : SizedBox(
                        height: kIsWeb ? offerCardHeight : 300.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: kIsWeb
                              ? EdgeInsets.zero
                              : const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                          itemCount: marketOffersController.marketOffers.length,
                          itemBuilder: (context, index) {
                            final offer =
                                marketOffersController.marketOffers[index];
                            return Padding(
                              padding: kIsWeb
                                  ? EdgeInsets.symmetric(horizontal: 30.w)
                                  : const EdgeInsets.only(left: 8.0),
                              child: OfferCardGrid(
                                logoHeight: logoHeight,
                                offerCardHeight: offerCardHeight,
                                offerCardWidth: offerCardWidth,
                                marketNameSize: marketNameSize,
                                offerFontSize: offerFontSize,
                                descriptionFontSize: descriptionFontSize,
                                offer: offer,
                                onTap: () async {
                                  final success = await viewCountController
                                      .incrementOfferViews(offer.id);
                                  debugPrint(
                                      'Offer Views Increment for ${offer.couponCode}: $success');
                                  Get.to(
                                      () => OfferDetailsScreen(offer: offer));
                                  debugPrint(
                                      'Offer Tapped: ${offer.descriptionAr ?? 'No description'}');
                                },
                                onFavoriteTap: () {
                                  debugPrint(
                                      'Favorite status changed for offer: ${offer.id}');
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ));
  }
}

class OfferCardList extends StatelessWidget {
  final MarketOffer offer;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;
  final double? offerCardHeight;
  final double? logoHeight;
  final double? marketNameSize;
  final double? offerFontSize;
  final double? borderWidth;

  const OfferCardList({
    super.key,
    required this.offer,
    this.onFavoriteTap,
    this.onTap,
    this.offerCardHeight,
    this.logoHeight,
    this.marketNameSize,
    this.offerFontSize,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final bool isArabic = Get.locale?.languageCode == 'ar';
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4;
    final cardHeight = cardWidth * 0.56;

    // Extract discount value and label based on language
    String discountValue = '';
    String discountLabel = 'discount'.tr;
    final description = isArabic ? offer.descriptionAr : offer.descriptionEn;
    final title = isArabic ? offer.titleAr : offer.titleEn;

    if (description != null) {
      discountValue = description.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = description.replaceAll(discountValue, '').trim();
    } else if (title != null) {
      discountValue = title.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = title.replaceAll(discountValue, '').trim();
    }
    if (discountLabel.isEmpty && discountValue.isNotEmpty) {
      discountLabel = 'discount'.tr;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: kIsWeb
            ? EdgeInsets.symmetric(horizontal: 100.w, vertical: 25.h)
            : null,
        margin: kIsWeb ? null : const EdgeInsets.only(bottom: 15),
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/offerlist1.png',
                fit: BoxFit.contain,
                width: screenWidth * 0.2,
                height: cardHeight,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            Positioned.fill(
              top: cardHeight * 0.05,
              child: Image.asset(
                'assets/images/offerlist2.png',
                fit: BoxFit.cover,
                width: screenWidth * 0.2,
                height: cardHeight,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
            Positioned(
              left: isArabic ? cardHeight * -0.0 : cardHeight * 3.7,
              // right: isArabic? cardHeight * -0.0:cardHeight * -1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary,
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: FavoriteButton(
                  marketOfferId: offer.id,
                  onFavoriteTap: onFavoriteTap,
                ),
              ),
            ),
            Positioned(
              top: cardHeight * 0.15,
              bottom: cardHeight * 0.08,
              left: isArabic ? cardWidth * 0.40 : cardWidth * 0.10,
              right: isArabic ? cardWidth * 0.05 : cardWidth * 0.30,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: cardWidth * 0.85,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              offer.market.logo,
                              width: logoHeight ?? cardWidth * 0.30,
                              height: logoHeight ?? cardWidth * 0.30,
                              fit: kIsWeb ? BoxFit.cover : BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: logoHeight ?? cardWidth * 0.15,
                                height: logoHeight ?? cardWidth * 0.15,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextSolveIssue(
                                  offer.market.name,
                                  style: GoogleFonts.tajawal(
                                    fontSize: marketNameSize ?? cardWidth * 0.1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: CustomTextSolveIssue(
                                    (Get.locale?.languageCode == 'ar'
                                            ? offer.titleAr
                                            : offer.titleEn) ??
                                        '',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.tajawal(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          offerFontSize ?? cardWidth * 0.08,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferCardGrid extends StatelessWidget {
  final MarketOffer offer;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;
  final double? offerCardWidth;
  final double? offerCardHeight;
  final double? logoHeight;
  final double? marketNameSize;
  final double? offerFontSize;
  final double? borderWidth;
  final double? descriptionFontSize;

  const OfferCardGrid({
    super.key,
    required this.offer,
    this.onFavoriteTap,
    this.onTap,
    this.offerCardWidth,
    this.offerCardHeight,
    this.logoHeight,
    this.marketNameSize,
    this.offerFontSize,
    this.descriptionFontSize,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.5;
    final cardHeight = cardWidth * 0.6;

    // Extract discount value from descriptionAr or titleAr
    String discountValue = '';
    String discountLabel = 'خصم';
    if (offer.descriptionAr != null) {
      discountValue = offer.descriptionAr!.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = offer.descriptionAr!.replaceAll(discountValue, '').trim();
    } else if (offer.titleAr != null) {
      discountValue = offer.titleAr!.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = offer.titleAr!.replaceAll(discountValue, '').trim();
    }
    if (discountLabel.isEmpty && discountValue.isNotEmpty) {
      discountLabel = 'خصم';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        width: offerCardWidth ?? cardWidth,
        height: offerCardHeight ?? cardHeight,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned(
              child: Image.asset(
                'assets/images/OFFER.png',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20.w),
                    SizedBox(
                      width: logoHeight ?? cardWidth * 0.18,
                      height: logoHeight ?? cardWidth * 0.18,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(screenWidth * 0.20),
                        child: Image.network(
                          offer.market.logo,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: cardWidth * 0.15,
                            height: cardWidth * 0.15,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: CustomTextSolveIssue(
                        offer.market.name,
                        style: GoogleFonts.tajawal(
                          fontSize: marketNameSize ?? cardWidth * 0.075,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomTextSolveIssue(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        (Get.locale?.languageCode == 'ar'
                                ? offer.titleAr
                                : offer.titleEn) ??
                            '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: offerFontSize ?? cardWidth * 0.12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.05),
                  child: CustomTextSolveIssue(
                    // offer.descriptionAr ?? offer.titleAr ?? 'لا يوجد وصف',
                    (Get.locale?.languageCode == 'ar'
                            ? offer.descriptionAr
                            : offer.descriptionEn) ??
                        '',

                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      fontSize: descriptionFontSize ?? cardWidth * 0.065,
                      color: Colors.grey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: FavoriteButton(
                    marketOfferId: offer.id,
                    onFavoriteTap: onFavoriteTap,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final int marketOfferId;
  final VoidCallback? onFavoriteTap;

  const FavoriteButton({
    super.key,
    required this.marketOfferId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(marketOfferId: marketOfferId);
      final isLoading = controller.isLoading.value;

      return GestureDetector(
        onTap: isLoading
            ? null // Disable tap during loading
            : () async {
                bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
                if (isLoggedIn) {
                  await controller.toggleFavorite(marketOfferId: marketOfferId);
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
                  width: 30,
                  height: 30,
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
