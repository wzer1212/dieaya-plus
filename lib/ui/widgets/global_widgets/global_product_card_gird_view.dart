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

    // تحسينات للأجهزة المختلفة
    final isMobile = ResponsiveService.isMobile();
    final isTablet = ResponsiveService.isTablet();
    final isDesktop = ResponsiveService.isDesktop();

    // تحسين المسافات حسب الجهاز
    final cardMargin = EdgeInsets.symmetric(
      horizontal: isMobile ? 6.w : isTablet ? 8.w : 10.w,
      vertical: isMobile ? 6.h : isTablet ? 8.h : 10.h,
    );

    final contentPadding = EdgeInsets.all(isMobile ? 8.w : isTablet ? 10.w : 12.w);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        constraints: BoxConstraints(
          minHeight: cardHeight,
          maxHeight: cardHeight + 50, // مرونة إضافية
        ),
        margin: cardMargin,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.primary.withOpacity(0.8), Colors.black.withOpacity(0.9)]
                : [AppColors.primary.withOpacity(0.9), Colors.white.withOpacity(0.95)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(isMobile ? 12 : isTablet ? 14 : 16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.15),
              blurRadius: isMobile ? 6 : isTablet ? 8 : 10,
              offset: Offset(0, isMobile ? 2 : isTablet ? 3 : 4),
              spreadRadius: isMobile ? 1 : isTablet ? 1.5 : 2,
            ),
            if (!isDark) BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isMobile ? 12 : isTablet ? 14 : 16),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //image + favourite button
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: imageHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(isMobile ? 12 : isTablet ? 14 : 16),
                        topLeft: Radius.circular(isMobile ? 12 : isTablet ? 14 : 16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(isMobile ? 12 : isTablet ? 14 : 16),
                        topLeft: Radius.circular(isMobile ? 12 : isTablet ? 14 : 16),
                      ),
                      child: Image.network(
                        product.images.isNotEmpty
                            ? product.images[0].image
                            : '',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                        Container(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey[500],
                              size: isMobile ? 32 : isTablet ? 40 : 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: isMobile ? 8 : isTablet ? 10 : 12,
                    right: isMobile ? 8 : isTablet ? 10 : 12,
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
                padding: contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المتجر
                    CustomTextSolveIssue(
                      product.market.nameAr,
                      style: GoogleFonts.tajawal(
                        fontSize: ResponsiveService.getFontSize(context, isMobile ? 12 : isTablet ? 14 : 16),
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white.withOpacity(0.9) : Color(0xff666565),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isMobile ? 4 : isTablet ? 6 : 8),

                    // اسم المنتج
                    CustomTextSolveIssue(
                      Get.locale?.languageCode == 'ar'
                          ? product.nameAr
                          : product.nameEn,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.tajawal(
                        fontSize: ResponsiveService.getFontSize(context, isMobile ? 14 : isTablet ? 16 : 18),
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Color(0xff333333),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isMobile ? 8 : isTablet ? 10 : 12),
                    // الأسعار
                    if (product.priceOffer.isNotEmpty &&
                        product.priceOffer != product.price)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // السعر القديم
                          Flexible(
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: CustomTextSolveIssue(
                                '${product.price}',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.tajawal(
                                  fontSize: ResponsiveService.getFontSize(context, isMobile ? 12 : isTablet ? 14 : 16),
                                  color: Colors.grey[600],
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(width: isMobile ? 4 : isTablet ? 6 : 8),

                          // السعر الجديد
                          Flexible(
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: CustomTextSolveIssue(
                                '${product.priceOffer}',
                                style: GoogleFonts.tajawal(
                                  fontSize: ResponsiveService.getFontSize(context, isMobile ? 16 : isTablet ? 18 : 20),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          // العملة
                          Padding(
                            padding: EdgeInsets.only(left: isMobile ? 2 : isTablet ? 3 : 4),
                            child: Image.asset(
                              'assets/images/saCurancy.png',
                              height: ResponsiveService.getFontSize(context, isMobile ? 12 : isTablet ? 14 : 16),
                              color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[700],
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Flexible(
                              child: CustomTextSolveIssue(
                                '${double.tryParse(product.price)?.toStringAsFixed(2) ?? 'no price'}',
                                style: GoogleFonts.tajawal(
                                  fontSize: ResponsiveService.getFontSize(context, isMobile ? 16 : isTablet ? 18 : 20),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: isMobile ? 2 : isTablet ? 3 : 4),
                            child: Image.asset(
                              'assets/images/saCurancy.png',
                              height: ResponsiveService.getFontSize(context, isMobile ? 12 : isTablet ? 14 : 16),
                              color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[700],
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