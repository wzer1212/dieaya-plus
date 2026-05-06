import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If using SVG icons
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../../../Utils/app_colors.dart';
import '../../Controllers/AuthController/login_controller.dart';
import '../../Controllers/AuthController/register_controller.dart';
import '../../Controllers/AuthController/verify_controller.dart';
import '../../Utils/app_sharedprefs_contants.dart';
import '../../Utils/app_text_field.dart';
import '../../controllers/FavController/fav_controller.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import '../../models/best_market_model.dart';
import 'buttons.dart';
import '../pages/dashboard/navbar.dart';
import 'custom_sheets.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';




class StoresCardGrid extends StatelessWidget {
  final Market market;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final double? logoHeight;
  final double? storeFontSize;
  final double? descriptionFontSize;
  final double? borderWidth;
  final double? storeCardWidth;
  final double? storeCardHeight;

  const StoresCardGrid({
    super.key,
    required this.market,
    this.onTap,
    this.onFavoriteTap, this.logoHeight, this.storeFontSize, this.descriptionFontSize, this.borderWidth, this.storeCardWidth, this.storeCardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45; // 45% of screen width
    final cardHeight = cardWidth * 1.2; // Maintain aspect ratio

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: storeCardWidth??cardWidth,
            height: storeCardHeight??cardHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark? [AppColors.primary, Colors.black]:[AppColors.primary, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(cardWidth * 0.08),
            ),
            padding: EdgeInsets.all(borderWidth??cardWidth * 0.008),
            child: Container(
              decoration: BoxDecoration(
                color: isDark? Colors.black:Colors.white,
                borderRadius: BorderRadius.circular(cardWidth * 0.08),
              ),
              child: Padding(
                padding: EdgeInsets.all(cardWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Image, Name, and Favorite Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: logoHeight??cardWidth * 0.2,
                              height:logoHeight?? cardWidth * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(cardWidth * 0.1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  market.logo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: cardWidth * 0.02),
                            Container(
                              constraints: BoxConstraints(maxWidth: 90.w),
                              child: CustomTextSolveIssue(
                                market.name,
                                style: GoogleFonts.tajawal(
                                  fontSize: storeFontSize??cardWidth * 0.08,
                                  fontWeight: FontWeight.bold,
                                  color: isDark? Colors.white: Color(0xff666565),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        FavoriteButton(
                          marketId: market.id,
                          onFavoriteTap: onFavoriteTap,
                        ),
                      ],
                    ),
                    // Store Info Section
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: cardHeight * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextSolveIssue(
                            market.description ?? '',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.tajawal(
                              fontSize: descriptionFontSize??cardWidth * 0.07,
                              color:isDark? Colors.white: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StoresCardList extends StatelessWidget {
  final Market market;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final double? logoHeight;
  final double? storeFontSize;
  final double? descriptionFontSize;
  final double? borderWidth;

  const StoresCardList({
    super.key,
    required this.market,
    this.onTap,
    this.onFavoriteTap, this.logoHeight, this.storeFontSize, this.descriptionFontSize, this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark? [AppColors.primary, Colors.black]:[AppColors.primary, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            padding: EdgeInsets.all(borderWidth??screenWidth * 0.005),
            child: Container(
              decoration: BoxDecoration(
                color: isDark? Colors.black: Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image and Title Section
                    SizedBox(width: screenWidth * 0.010),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width:logoHeight?? screenWidth * 0.12,
                            height: logoHeight??screenWidth * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(screenWidth * 0.06),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                market.logo,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.008),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.01),
                              // Subtitle (Amazon)
                              CustomTextSolveIssue(
                                market.name,
                                style: GoogleFonts.tajawal(
                                  fontSize: storeFontSize?? screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: isDark? Colors.white: Color(0xff666565),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              // Title
                              Container(
                                width: screenWidth * 0.6,
                                child: CustomTextSolveIssue(
                                  market.description ?? '',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.tajawal(
                                    fontSize:descriptionFontSize?? screenWidth * 0.030,
                                    // fontWeight: FontWeight.bold,
                                    color: isDark? Colors.white:Colors.black,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Favorite Button
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: screenHeight * 0.01),
                          FavoriteButton(
                            marketId: market.id,
                            onFavoriteTap: onFavoriteTap,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class FavoriteButton extends StatelessWidget {
  final int marketId;
  final VoidCallback? onFavoriteTap;

  const FavoriteButton({
    super.key,
    required this.marketId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(marketId: marketId);
      final isLoading = controller.isLoading.value;

      return GestureDetector(
        onTap: isLoading
            ? null // Disable tap during loading
            : () async {
          bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
          if (isLoggedIn) {
            await controller.toggleFavorite(marketId: marketId);
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
            isFavorite ? 'assets/svg/fullheart2.svg' : 'assets/svg/Heart 2.svg',
            width: 30,
            height: 30,
            colorFilter: isFavorite
                ? const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)
                : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
        ),
      );
    });
  }
}

