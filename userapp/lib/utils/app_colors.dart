import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF00B4FF);
  static const Color primaryDark = Color(0xFF2FAF97);
  // static const Color primaryLight = Color(0x7100B0FF);
  static const Color lightGreyBackground = Color(0xFFF5F5F5);

  // Secondary Colors
  static const Color secondary = Color(0xFF51F3A2);
  static const Color secondaryDark = Color(0xFF399F73);
  static const Color secondaryLight = Color(0xFFAAF7D0);

  static const darkBlueBackground = Color(0xFF1A2634); // Example dark theme color
  static const Color textPrimary = Colors.black87;
  static const Color textPrice = Colors.blue; // Example
  static const Color lightBlueBackgroundContiner = Color(0xFFE3F2FD); // Example light blue
  static const Color lightGrey = Color(0xFFf5f5f5);
  static const Color grey = Colors.grey;
  static const Color grey2 = Color(0xffEAEAEA);
  static const Color starColor = Colors.amber;
  static const Color couponBorder = Colors.lightBlueAccent; // Example
  static const Color couponCopyBackground = Colors.blueAccent; // Example


  static const Color lightBlueBackground = Color(0xFFF2FBFF); // Example light blue for background
  // Neutral Colors
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color darkGrey = Color(0xFF424242);

  // Functional Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Accent Colors
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF4CAF50);
  static const Color blue = Color(0xFF00B4FF);
  static const Color yellow = Color(0xFFFFC107);
  static const Color orange = Color(0xFFFF7043);
  static const Color purple = Color(0xFF9C27B0);
  static const Color pink = Color(0xFFE91E63);
  static const Color cyan = Color(0xFF00ACC1);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color teal = Color(0xFF00796B);

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
