import 'package:carousel_slider/carousel_slider.dart';
import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If using SVG icons
import 'package:flutter/services.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_texts.dart'; // For Clipboard
class CircularCategoryItem extends StatelessWidget {
  final String label;
  final String imageUrl; // Or IconData if using icons
  final Color backgroundColor;
  final VoidCallback? onTap;
  final bool isSelected;
  final double? height;
  final double? width;

  const CircularCategoryItem({
    super.key,
    required this.label,
    required this.imageUrl, // Replace with icon if needed
    this.backgroundColor = Colors.black, // Default from image
    this.onTap,
    required this.isSelected, this.height, this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 4.0), // Spacing between items
        child: Container(
          width: width??90,
          height: height,
          decoration: BoxDecoration(

              color: isSelected?AppColors.lightBlueBackgroundContiner: Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(imageUrl,width: 50,height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50);
                    }),
                // const SizedBox(height: 6),
                CustomTextSolveIssue(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    // Or your app's font
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
