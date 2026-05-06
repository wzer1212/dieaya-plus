import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../../Utils/app_colors.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../controllers/ThemeController/theme_controller.dart';

// Simplified Product class with static data for testing
class Product {
  final int id;
  final String descriptionAr;
  final String descriptionEn;
  final String visitors;
  final List<ImageData> images;

  Product({
    required this.id,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.visitors,
    required this.images,
  });
}

class ImageData {
  final String image;

  ImageData({required this.image});
}

class Market {
  final String nameAr;

  Market({required this.nameAr});
}


class ProductCardGrid extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCardGrid({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        ),
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Container(
                    width: cardWidth * 0.75,
                    height: cardWidth * 0.75,
                    child: Image.asset(
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
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    '${product.visitors}',
                                    style: GoogleFonts.tajawal(
                                      fontSize: cardWidth * 0.13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    'visit'.tr,
                                    style: GoogleFonts.tajawal(
                                        color: Color(0xff666565),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Get.locale?.languageCode == 'ar'
                              ? product.descriptionAr
                              : product.descriptionEn,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.tajawal(
                            fontSize: cardWidth * 0.075,
                            color:
                                isDark ? Colors.white : const Color(0xff666565),
                          ),
                          maxLines: 3,
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
    );
  }
}
class FavoriteButton extends StatelessWidget {
  final int productId;
  final VoidCallback? onFavoriteTap;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    // Removed FavoriteController dependency
    bool isFavorite =
        productId % 2 == 0; // Static logic: even IDs are favorites

    return GestureDetector(
      onTap: () {
        // Handle favorite tap (static logic for testing)
        print('Favorite tapped for product ${productId}');
        onFavoriteTap?.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SvgPicture.asset(
          isFavorite ? 'assets/svg/fullheart2.svg' : 'assets/svg/Heart 2.svg',
          width: 30,
          height: 30,
          colorFilter: isFavorite
              ? const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)
              : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class ProductCardList extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCardList({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
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
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: cardWidth * 0.2,
                      height: cardWidth * 0.2,
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
                      Container(
                        width: cardWidth * 0.45,
                        child: Text(
                          Get.locale?.languageCode == 'ar'
                              ? product.descriptionAr
                              : product.descriptionEn,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.tajawal(
                            fontSize: cardWidth * 0.030,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${product.visitors.isNotEmpty ? product.visitors : product.visitors}',
                          style: GoogleFonts.tajawal(
                            fontSize: cardWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('visit'.tr)
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Removed FavoriteButton, replaced with static SVG
                    GestureDetector(
                      onTap: () {
                        // Handle favorite tap (static logic for testing)
                        print('Favorite tapped for product ${product.id}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset(
                          'assets/svg/Heart 2.svg', // Default heart
                          width: 30,
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                              Colors.grey, BlendMode.srcIn),
                        ),
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
  }
}

