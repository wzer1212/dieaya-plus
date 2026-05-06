import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/animated_web_header_button.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/dropdown_item.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/web_header_dropdown.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WebDropDownItem extends StatelessWidget {
  const WebDropDownItem({
    super.key,
    required this.isDark,
    this.onTap, required this.title, required this.icon,
  });

  final void Function()? onTap;
  final bool isDark;
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(6.r),
        onTap: onTap,
        hoverColor:isDark?Colors.white.withValues(alpha: 0.2): Colors.blue.withValues(alpha: 220),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              SvgPicture.asset(icon),
              SizedBox(width: 5.w,),
              CustomTextSolveIssue(
                title,
                style: GoogleFonts.tajawal(
                  fontSize: 10.w,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
            ],
          ),
        ));
  }
}