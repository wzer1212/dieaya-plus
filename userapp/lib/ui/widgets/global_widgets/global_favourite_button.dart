import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/FavController/fav_controller.dart';
import '../../widgets/custom_sheets.dart';


class GlobalFavoriteButton extends StatelessWidget {
  final int productId;
  final VoidCallback? onFavoriteTap;

  const GlobalFavoriteButton({
    super.key,
    required this.productId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(productId: productId);
      final isLoading = controller.isLoading.value;

      return GestureDetector(
        onTap: isLoading
            ? null // Disable tap during loading
            : () async {
          bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
          if (isLoggedIn) {
            await controller.toggleFavorite(productId: productId);
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