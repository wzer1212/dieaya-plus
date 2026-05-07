import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - محسنة للتناسق والوضوح
  static const Color primary = Color(0xFF00B4FF);
  static const Color primaryDark = Color(0xFF2FAF97);
  static const Color primaryLight = Color(0xFFE3F2FD);
  static const Color primaryVariant = Color(0xFF0277BD);

  // Secondary Colors - محسنة
  static const Color secondary = Color(0xFF51F3A2);
  static const Color secondaryDark = Color(0xFF399F73);
  static const Color secondaryLight = Color(0xFFAAF7D0);
  static const Color secondaryVariant = Color(0xFF26A69A);

  // Background Colors - محسنة للوضع الفاتح والداكن
  static const Color lightGreyBackground = Color(0xFFF8F9FA);
  static const Color darkBlueBackground = Color(0xFF1A2634);
  static const Color lightBlueBackground = Color(0xFFF2FBFF);
  static const Color lightBlueBackgroundContiner = Color(0xFFE3F2FD);

  // Text Colors - محسنة للوضوح والتباين
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textPrice = Color(0xFF1565C0);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.white;

  // Grey Scale - محسنة ومنظمة
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Legacy Colors - محفوظة للتوافق
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color grey = Colors.grey;
  static const Color grey2 = Color(0xffEAEAEA);

  // Functional Colors - محسنة
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFF176);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // Special Colors - محسنة
  static const Color starColor = Color(0xFFFFC107);
  static const Color couponBorder = Color(0xFF64B5F6);
  static const Color couponCopyBackground = Color(0xFF42A5F5);

  // Accent Colors - محسنة ومنظمة
  static const Color red = Color(0xFFE53935);
  static const Color redLight = Color(0xFFEF5350);
  static const Color green = Color(0xFF4CAF50);
  static const Color greenLight = Color(0xFF81C784);
  static const Color blue = Color(0xFF00B4FF);
  static const Color blueLight = Color(0xFF64B5F6);
  static const Color yellow = Color(0xFFFFC107);
  static const Color yellowLight = Color(0xFFFFF176);
  static const Color orange = Color(0xFFFF7043);
  static const Color orangeLight = Color(0xFFFFAB91);
  static const Color purple = Color(0xFF9C27B0);
  static const Color purpleLight = Color(0xFFBA68C8);
  static const Color pink = Color(0xFFE91E63);
  static const Color pinkLight = Color(0xFFF06292);
  static const Color cyan = Color(0xFF00ACC1);
  static const Color cyanLight = Color(0xFF4DD0E1);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color deepOrangeLight = Color(0xFFFF8A65);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color indigoLight = Color(0xFF7986CB);
  static const Color teal = Color(0xFF00796B);
  static const Color tealLight = Color(0xFF4DB6AC);

  // Basic Colors
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color darkGrey = Color(0xFF424242);

  // Shadow Colors - جديدة للظلال المحسنة
  static Color shadowLight = Colors.black.withOpacity(0.08);
  static Color shadowMedium = Colors.black.withOpacity(0.12);
  static Color shadowDark = Colors.black.withOpacity(0.16);

  // Border Colors - جديدة للحدود
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF757575);

  // Surface Colors - جديدة للخلفيات
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // UI Colors
  static const Color background = Color(0xFFF0F2F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x40000000); // 25% opacity black
  // static const Color textPrimary = Color(0xFF212121);
  // static const Color textSecondary = Color(0xFF757575);
  static const Color disabled = Color(0xFFBDBDBD);


  static const Color textSecondary = Colors.grey;
  // Gradients (for buttons, backgrounds, etc.)
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF33AAA2), Color(0xFF2BB673)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF51F3A2), Color(0xFFAAF7D0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [Color(0xFF424242), Color(0xFF212121)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
