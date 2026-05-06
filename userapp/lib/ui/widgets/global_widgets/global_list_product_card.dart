import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

import '../../../UI/pages/ProductsScreen/products_screen.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/product_model.dart';
import 'package:flutter_svg/svg.dart';

class GlobalListProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final double? priceFontSize;
  final double? priceCanceledFontSize;
  final double? productFontSize;
  final double? descriptionFontSize;

  const GlobalListProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.priceFontSize,
    this.priceCanceledFontSize,
    this.productFontSize,
    this.descriptionFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.primary, Colors.black]
                : [AppColors.primary, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
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
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: cardWidth * 0.2,
                      height: cardWidth * 0.2,
                      // color: Colors.white,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 150.w,
                        child: CustomTextSolveIssue(
                          // product.market.nameAr,
                          Get.locale?.languageCode == 'ar'
                              ? product.nameAr
                              : product.nameEn,
                          style: GoogleFonts.tajawal(
                            fontSize: productFontSize ?? cardWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Color(0xff666565),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: cardWidth * 0.45,
                        child: CustomTextSolveIssue(
                          // product.descriptionAr,
                          Get.locale?.languageCode == 'ar'
                              ? product.descriptionAr
                              : product.descriptionEn,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.tajawal(
                            fontSize: descriptionFontSize ?? cardWidth * 0.030,
                            // fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 130.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(width: 4),
                            if (product.priceOffer.isNotEmpty &&
                                product.priceOffer != product.price)
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Flexible(
                                  flex: 1,
                                  child: CustomTextSolveIssue(
                                    '${double.tryParse(product.price)?.round()}',
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.tajawal(
                                      fontSize: priceCanceledFontSize ??
                                          cardWidth * 0.04,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            SizedBox(width: 2.w,),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Flexible(
                                flex: 2,
                                child: CustomTextSolveIssue(
                                  '${double.tryParse(product.priceOffer.isNotEmpty ? product.priceOffer : product.price)?.round()}',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.tajawal(
                                    fontSize: priceFontSize ?? cardWidth * 0.07,
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
                              height: cardWidth * 0.04,
                              color: isDark ? Colors.white : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      FavoriteButton(
                        productId: product.id,
                        onFavoriteTap: onFavoriteTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
