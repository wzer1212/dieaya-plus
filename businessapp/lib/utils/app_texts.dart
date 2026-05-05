import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ThemeController/theme_controller.dart';
import 'app_colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final int? maxCharacters; // New optional parameter for character limit


  const AppText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.color,
    this.maxCharacters, // Add this to constructor

  });

  @override
  Widget build(BuildContext context) {
    String displayText = (maxCharacters != null && text.length > maxCharacters!)
        ? '${text.substring(0, maxCharacters!)}...' // Add ellipsis for truncation
        : text;

    return Text(
      displayText,
      textAlign: textAlign,
      style: style.copyWith(color: color ?? style.color),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis, // Ensures text doesn't break layout
    );
  }
}





class AppTextStyles {
  static final ThemeController themeController = Get.put(ThemeController());

  static Color _getColor(Color lightColor, Color darkColor) {
    return themeController.themeMode.value == ThemeMode.dark ? darkColor : lightColor;
  }

  static TextStyle title() => GoogleFonts.tajawal(
    fontSize: 26.0,
    color: _getColor(AppColors.primary, AppColors.white),
  );

  static TextStyle subtitle() => GoogleFonts.tajawal(
    fontSize: 16.0,
    color: _getColor(AppColors.darkGrey, AppColors.lightGrey),
  );

  static TextStyle body() => GoogleFonts.tajawal(
    fontSize: 12.0,
    color: _getColor(AppColors.black, AppColors.white),
  );

  static TextStyle caption() => GoogleFonts.tajawal(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: _getColor(AppColors.grey, AppColors.lightGrey),
  );

  static TextStyle button() => GoogleFonts.tajawal(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.white, // Keep button text color static
  );

  static TextStyle profile() => GoogleFonts.tajawal(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: _getColor(AppColors.black, AppColors.white),
  );

  static TextStyle headline() => GoogleFonts.tajawal(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    color: _getColor(AppColors.primaryDark, AppColors.white),
  );

  static TextStyle label() => GoogleFonts.tajawal(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: _getColor(AppColors.darkGrey, AppColors.lightGrey),
  );

  static TextStyle error() => GoogleFonts.tajawal(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.red,
  );

  static TextStyle success() => GoogleFonts.tajawal(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.green,
  );

  static TextStyle warning() => GoogleFonts.tajawal(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.orange,
  );

  static TextStyle link() => GoogleFonts.tajawal(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: _getColor(AppColors.blue, AppColors.cyan),
    decoration: TextDecoration.underline,
  );

  static TextStyle disabled() => GoogleFonts.tajawal(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: _getColor(AppColors.lightGrey, AppColors.darkGrey),
  );

  static TextStyle small() => GoogleFonts.tajawal(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    color: _getColor(AppColors.grey, AppColors.lightGrey),
  );

  static TextStyle medium() => GoogleFonts.tajawal(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: _getColor(AppColors.black, AppColors.white),
  );

  static TextStyle large() => GoogleFonts.tajawal(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: _getColor(AppColors.black, AppColors.white),
  );

  static TextStyle light() => GoogleFonts.tajawal(
    fontSize: 16.0,
    fontWeight: FontWeight.w300,
    color: _getColor(AppColors.darkGrey, AppColors.lightGrey),
  );

  static TextStyle semiBold() => GoogleFonts.tajawal(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: _getColor(AppColors.black, AppColors.white),
  );
}
