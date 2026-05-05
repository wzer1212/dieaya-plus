import 'package:carousel_slider/carousel_slider.dart';
import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If using SVG icons
import 'package:flutter/services.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/app_texts.dart'; // For Clipboard
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Reduced vertical padding
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomTextSolveIssue(
              title,
              style: GoogleFonts.tajawal(
                // Consistent font
                fontSize: 22, // Slightly larger header font
                fontWeight: FontWeight.bold,
                color: Color(0xff666565),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionText != null && onActionPressed != null)
            // InkWell(
            //   onTap: onActionPressed,
            //   child: Padding(
            //     padding: const EdgeInsets.only(
            //         left: 8.0), // Add padding for touch target
            //     child: Row(
            //       children: [
            //
            //         CustomTextSolveIssue(
            //           actionText!,
            //           style: GoogleFonts.tajawal(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w500,
            //             color:
            //             AppColors.grey, // Use primary color for action text
            //           ),
            //         ),
            //         Icon(Icons.arrow_forward_ios_rounded,size: 16,color: Colors.grey,),
            //       ],
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: onActionPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTextSolveIssue(
                    'see_all'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          AppColors.grey, // Use primary color for action text
                    ),
                  ),
                  SizedBox(width: 10.w,),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
