import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final dynamic onPressed;
  final double? width;
  final double? height;
  final Color? color; // Button background color
  final Color? textColor; // Text color
  final double? textSize; // Text font size
  final FontWeight? textFontWeight; // Text font weight
  final IconData? icon; // Traditional IconData for font-based icons
  final String? iconPath; // Path to SVG asset
  final Color? iconColor; // Icon color (for IconData)
  final double? iconSize; // Icon size (for both Icon and SVG)
  final bool isLoading; // Loading state
  final bool? isBlock; // Loading state
  final Color? loadingColor; // Loading animation color
  final double? loadingSize; // Loading animation size
  final Color? borderColor; // Border color
  final double? borderWidth; // Border width
  final double? borderRadius; // Border radius
  final EdgeInsets? padding; // Internal padding for button content
  final EdgeInsets? margin; // External margin for the button
  final BoxShadow? boxShadow; // Optional shadow for elevation effect

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.textSize,
    this.textFontWeight,
    this.icon,
    this.iconPath,
    this.iconColor,
    this.iconSize,
    this.isLoading = false,
    this.loadingColor,
    this.loadingSize,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.margin,
    this.boxShadow,
    this.isBlock = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin ?? EdgeInsets.zero,
        width: width ?? double.infinity,
        height: height ?? 50,
        decoration: boxShadow != null
            ? BoxDecoration(
                boxShadow: [boxShadow!],
                borderRadius: BorderRadius.circular(borderRadius ?? 20),
              )
            : null,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          // keep ripple inside
          child: Container(
            width:100.w,
            height: height ?? 50,
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            margin: margin,
            decoration: BoxDecoration(
              color: isBlock!?AppColors.grey:color ?? AppColors.primary,
              borderRadius: BorderRadius.circular(borderRadius ?? 20),
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 0,
              ),
              boxShadow: boxShadow != null ? [boxShadow!] : null,
            ),
            alignment: Alignment.center,
            child: isLoading
                ? LoadingAnimationWidget.newtonCradle(
                    color: loadingColor ?? AppColors.primary,
                    size: loadingSize ?? 50,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextSolveIssue(
                        text,
                        style: GoogleFonts.tajawal(
                          color: textColor ?? Colors.white,
                          fontSize: textSize ?? 16,
                          fontWeight: textFontWeight ?? FontWeight.normal,
                        ),
                      ),
                      if (icon != null || iconPath != null) ...[
                        const SizedBox(width: 8),
                        if (iconPath != null)
                          SvgPicture.asset(
                            iconPath!,
                            width: iconSize ?? 20,
                            height: iconSize ?? 20,
                            colorFilter: iconColor != null
                                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                                : null,
                          )
                        else if (icon != null)
                          Icon(
                            icon,
                            color: iconColor ?? textColor ?? Colors.white,
                            size: iconSize ?? 20,
                          ),
                      ],
                    ],
                  ),
          ),
        ));
  }
}
