import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';

class AdaptiveLayOut extends StatelessWidget {
  const AdaptiveLayOut({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  // تحسين الكشف عن الأجهزة للكمبيوتر والأيباد والجوال
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  // إضافة كشف للأجهزة الصغيرة جداً (مثل الهواتف الصغيرة)
  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  // إضافة كشف للأجهزة الكبيرة (مثل الأيباد برو والكمبيوتر الكبير)
  static bool isLargeTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1440;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // تحسين المنطق للكشف عن الأجهزة
    if (screenWidth >= 1024) {
      return desktop;
    } else if (screenWidth >= 600 && screenWidth < 1024) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
