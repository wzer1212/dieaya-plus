

import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHoverButton extends StatelessWidget {
  const CustomHoverButton({super.key, this.onTap, required this.title});

  final void Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        hoverColor: Colors.white.withValues(alpha: 0.2),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: CustomTextSolveIssue(
            title,
            style: GoogleFonts.tajawal(
              fontSize: 12.w,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}