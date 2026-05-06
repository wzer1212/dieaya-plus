import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If using SVG icons
import 'package:flutter/services.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_texts.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

import '../../controllers/ThemeController/theme_controller.dart';
import '../../models/best_market_model.dart'; // For Clipboard
// class Store {
//   final String id;
//   final String name;
//   final String imageUrl;
//   Store({required this.id, required this.name, required this.imageUrl});
// }
// final List<Store> dummyStores = List.generate(
//     8,
//         (index) => Store(
//         id: 'store$index',
//         name: 'نمشي${index + 1}',
//         imageUrl:
//         'assets/images/Ellipse 14.png')); // Use appropriate placeholder
//

class StoreGridItem extends StatelessWidget {
  final Market store;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? titleFontSize;

  const StoreGridItem(
      {Key? key, required this.store, this.onTap, this.width, this.height, this.titleFontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize = screenWidth * 0.16; // 15% of screen width for image

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: CachedNetworkImage(
                    imageUrl: store.logo,
                    fit: BoxFit.fill,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.store,
                            color: Colors.grey,
                            size: itemSize * 0.5,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.020),
            CustomTextSolveIssue(
              store.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xff666565)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}
