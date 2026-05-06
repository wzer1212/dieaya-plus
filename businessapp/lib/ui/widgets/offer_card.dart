import 'package:dieaya_market/ui/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/app_colors.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import 'package:get/get.dart';



// Define MarketOffer class for static data
class MarketOffer {
  final int id;
  final String? titleAr;
  final String? titleEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final Market market;

  MarketOffer({
    required this.id,
    this.titleAr,
    this.titleEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.market,
  });
}

class Market {
  final String name;
  final String logo;

  Market({required this.name, required this.logo});
}

// Static test data for offers
final List<MarketOffer> testOffers = [
  MarketOffer(
    id: 1,
    titleAr: 'خصم 50%',
    titleEn: '50% Discount',
    descriptionAr: 'خصم 50% على جميع المنتجات',
    descriptionEn: '50% discount on all products',
    market: Market(
      name: 'متجر التوفير',
      logo: 'https://via.placeholder.com/50', // Placeholder logo
    ),
  ),
  MarketOffer(
    id: 2,
    titleAr: 'خصم 30%',
    titleEn: '30% Discount',
    descriptionAr: 'خصم 30% على الأجهزة الإلكترونية',
    descriptionEn: '30% discount on electronics',
    market: Market(
      name: 'متجر التقنية',
      logo: 'https://via.placeholder.com/50', // Placeholder logo
    ),
  ),
];

// OffersSection widget displaying only 2 offers
class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2; // Responsive grid

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          child: SectionHeader(
            title: 'العروض الاكثر استخداما'.tr,
          ),
        ),
        SizedBox(
          height: 270, // Adjusted height to fit 2 items in grid
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              // crossAxisSpacing: screenWidth * 0.02,
              // mainAxisSpacing: screenWidth * 0.00,
              childAspectRatio: 0.90, // Adjust aspect ratio to fit card content
            ),
            itemCount: 2, // Limit to 2 items
            itemBuilder: (context, index) {
              final offer = testOffers[index];
              return OfferCardGrid(
                offer: offer,
                onTap: () {
                  debugPrint('Offer Tapped: ${offer.descriptionAr ?? 'No description'}');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
class OfferCardGrid extends StatelessWidget {
  final MarketOffer offer;
  final VoidCallback? onTap;

  const OfferCardGrid({
    super.key,
    required this.offer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.6;
    final cardHeight = cardWidth * 0.4;

    // Extract discount value from descriptionAr or titleAr
    String discountValue = '';
    String discountLabel = 'discount'.tr;
    if (offer.descriptionAr != null) {
      discountValue = offer.descriptionAr!.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = offer.descriptionAr!.replaceAll(discountValue, '').trim();
    } else if (offer.titleAr != null) {
      discountValue = offer.titleAr!.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = offer.titleAr!.replaceAll(discountValue, '').trim();
    }
    if (discountLabel.isEmpty && discountValue.isNotEmpty) {
      discountLabel = 'discount'.tr;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Positioned.fill(
            //   bottom: 15,
            //   left: 8,
            //   child: Image.asset(
            //     fit: BoxFit.contain,
            //     'assets/images/offergrid2.png',
            //     errorBuilder: (context, error, stackTrace) => Container(
            //       color: Colors.grey.shade200,
            //     ),
            //   ),
            // ),
            Positioned.fill(
              child: Image.asset(
                'assets/images/OFFER.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
            Positioned(
              top: cardHeight * 0.05,
              bottom: cardHeight * 0.05,
              left: 15,
              right: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        (Get.locale?.languageCode == 'ar' ? offer.titleAr : offer.titleEn) ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: cardWidth * 0.12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.05),
                    child: Text(
                      (Get.locale?.languageCode == 'ar' ? offer.descriptionAr : offer.descriptionEn) ?? '',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: cardWidth * 0.065,
                        color: Colors.grey,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferCardList extends StatelessWidget {
  final MarketOffer offer;
  final VoidCallback? onTap;

  const OfferCardList({
    super.key,
    required this.offer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
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
        margin: const EdgeInsets.only(bottom: 15),
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
                              width: cardWidth * 0.30,
                              height: cardWidth * 0.30,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: cardWidth * 0.15,
                                height: cardWidth * 0.15,
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
                                Text(
                                  offer.market.name,
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.09,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    (Get.locale?.languageCode == 'ar' ? offer.descriptionAr : offer.descriptionEn) ?? '',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.tajawal(
                                      fontSize: cardWidth * 0.07,
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
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            (isArabic ? offer.descriptionAr : offer.descriptionEn) ?? '',
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                discountValue.isNotEmpty ? discountValue : '0',
                                style: GoogleFonts.tajawal(
                                  fontSize: cardWidth * 0.14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '%',
                                style: GoogleFonts.tajawal(
                                  fontSize: cardWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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




