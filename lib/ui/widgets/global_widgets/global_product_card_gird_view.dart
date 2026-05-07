import 'package:dieaya_user/controllers/FavController/fav_controller.dart';
import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_favourite_button.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';


import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class GlobalProductCardGrid extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  final double? priceFontSize;
  final double? priceCanceledFontSize;
  final double? storeFontSize;
  final double? descriptionFontSize;
  final double? imageHeight;

   GlobalProductCardGrid({
    super.key,
    required this.product,
    this.onTap,
    this.priceFontSize,
    this.priceCanceledFontSize,
    this.storeFontSize,
    this.descriptionFontSize,
    this.imageHeight ,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
    Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    // استخدام المقاسات المحسنة من ResponsiveService
    final cardWidth = ResponsiveService.getCardWidth(context);
    final cardHeight = ResponsiveService.getCardHeight(context);
    final imageHeight = imageHeight ?? cardHeight * 0.6;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        constraints: BoxConstraints(
          minHeight: cardHeight,
          maxHeight: cardHeight + 50, // مرونة إضافية
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveService.isMobile() ? 8.w : 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.primary, Colors.black]
                : [AppColors.primary, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //image + favourite button
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: imageHeight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                          child: Image.network(
                            product.images.isNotEmpty
                                ? product.images[0].image
                                : '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: GlobalFavoriteButton(
                      productId: product.id,
                      onFavoriteTap: () {
                        debugPrint(
                            'Favorite status changed for product: ${product.id}');
                      },
                    ),
                  ),
                ],
              ),
              // store + product name + prices
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextSolveIssue(
                                product.market.nameAr,
                                style: GoogleFonts.tajawal(
                                  fontSize: storeFontSize ?? cardWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  isDark ? Colors.white : Color(0xff666565),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 4),
                        CustomTextSolveIssue(
                          Get.locale?.languageCode == 'ar'
                              ? product.nameAr
                              : product.nameEn,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.tajawal(
                            fontSize: descriptionFontSize ?? cardWidth * 0.075,
                            color: isDark ? Colors.white : Color(0xff666565),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (product.priceOffer.isNotEmpty &&
                            product.priceOffer != product.price)
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: CustomTextSolveIssue(
                                      '${product.price}',
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.tajawal(
                                        fontSize: priceCanceledFontSize ??
                                            cardWidth * 0.085,
                                        color: Colors.grey,
                                        decoration:
                                        TextDecoration.lineThrough,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: CustomTextSolveIssue(
                                    '${product.priceOffer}',
                                    style: GoogleFonts.tajawal(
                                      fontSize:
                                      priceFontSize ?? cardWidth * 0.13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),

                                    maxLines: 1,

                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/saCurancy.png',
                                  height: cardWidth * 0.06,
                                  color:
                                  isDark ? Colors.white : Colors.grey,
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Flexible(
                                    child: CustomTextSolveIssue(
                                      '${double.tryParse(product.price)?.toStringAsFixed(2)??'no price'}',
                                      style: GoogleFonts.tajawal(
                                        fontSize:
                                        priceFontSize ?? cardWidth * 0.13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/saCurancy.png',
                                  height: cardWidth * 0.06,
                                  color:
                                  isDark ? Colors.white : Colors.grey,
                                ),
                              ],
                            ),
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
    );
  }
}