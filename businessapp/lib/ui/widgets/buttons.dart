import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart'; // Add this import


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
    this.icon, // Keep for backward compatibility
    this.iconPath, // New property for SVG path
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero, // Apply margin if provided
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white, // Ripple effect color
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 25),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
          ),
          elevation: boxShadow != null ? 0 : null, // Disable default elevation if shadow is custom
          shadowColor: boxShadow != null ? Colors.transparent : null,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? LoadingAnimationWidget.newtonCradle(
          color: loadingColor ?? AppColors.primary,
          size: loadingSize ?? 50,
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.tajawal(
                color: textColor ?? Colors.white,
                fontSize: textSize ?? 16,
                fontWeight: textFontWeight ?? FontWeight.normal,
              ),
            ),
            if (icon != null || iconPath != null) ...[
              const SizedBox(width: 8), // Space between text and icon
              if (iconPath != null)
                SvgPicture.asset(
                  iconPath!,
                  width: iconSize ?? 20,
                  height: iconSize ?? 20,
                  colorFilter: iconColor != null
                      ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                      : null, // Apply color to SVG if provided
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
    );
  }
}