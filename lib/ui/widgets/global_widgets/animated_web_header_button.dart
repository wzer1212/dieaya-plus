import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class AnimatedWebHeaderButton extends StatefulWidget {
  AnimatedWebHeaderButton({
    super.key, this.onTap, required this.title,
  });

  final void Function()? onTap;
  final String title;

  @override
  State<AnimatedWebHeaderButton> createState() => _AnimatedWebHeaderButtonState();
}

class _AnimatedWebHeaderButtonState extends State<AnimatedWebHeaderButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter:(event) => setState(() {
        isHovering = true;
      }),
      onExit:(event) => setState(() {
        isHovering = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: isHovering?Colors.white.withValues(alpha: 0.2):null,
            borderRadius: BorderRadius.circular(10.r)
        ),
        child: InkWell(

          onTap:
          widget.onTap,
          child: CustomTextSolveIssue(widget.title, style:
          GoogleFonts.tajawal(
            fontSize: 12.w,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),),
        ),
      ),
    );
  }
}