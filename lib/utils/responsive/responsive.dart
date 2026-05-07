import 'dart:math';
import 'package:flutter/material.dart';

class ResponsiveService {
  // تحسين حجم التصميم الأساسي ليكون أكثر دقة للأجهزة المختلفة
  static const Size _mobileDesignSize = Size(375, 812); // iPhone X
  static const Size _tabletDesignSize = Size(768, 1024); // iPad
  static const Size _desktopDesignSize = Size(1440, 900); // Desktop

  static const bool _splitScreenMode = false;
  static final MediaQueryData _mediaQueryData = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first);

  // تحسين اختيار حجم التصميم بناءً على نوع الجهاز
  static Size _getDesignSize() {
    final screenWidth = _mediaQueryData.size.width;

    if (screenWidth >= 1024) {
      return _desktopDesignSize;
    } else if (screenWidth >= 600) {
      return _tabletDesignSize;
    } else {
      return _mobileDesignSize;
    }
  }

  static double fullScreenHeight({double ratio = 1}) =>
      _mediaQueryData.size.height * ratio;

  static double fullScreenWidth({double ratio = 1}) =>
      _mediaQueryData.size.width * ratio;

  static double availableScreenHeight({double ratio = 1}) =>
      (_mediaQueryData.size.height - _mediaQueryData.viewPadding.vertical) *
      ratio;

  static double availableScreenWidth({double ratio = 1}) =>
      (_mediaQueryData.size.width - _mediaQueryData.viewPadding.horizontal) *
      ratio;

  static Orientation orientation() => _mediaQueryData.orientation;

  static double deviceTopPadding() => _mediaQueryData.padding.top;

  static double deviceBottomPadding() => _mediaQueryData.padding.bottom;

  static double deviceBottomViewPadding() => _mediaQueryData.viewPadding.bottom;

  static double deviceKeyboardHeight() => _mediaQueryData.viewInsets.bottom;

  static double textScaleFactor() => _mediaQueryData.textScaleFactor;

  static double devicePixelRatio() => _mediaQueryData.devicePixelRatio;

  // تحسين حساب المقاسات للأجهزة المختلفة
  static double scaleWidth() =>
      availableScreenWidth() / _getDesignSize().width;

  static double scaleHeight() =>
      (_splitScreenMode
          ? max(availableScreenHeight(), _getDesignSize().height)
          : availableScreenHeight()) /
      _getDesignSize().height;

  static double scaleRadius() => min(scaleWidth(), scaleHeight());

  static double scaleCustomTextSolveIssue() => min(scaleWidth(), scaleHeight());

  // إضافة دوال مساعدة للكشف عن نوع الجهاز
  static bool isMobile() => _mediaQueryData.size.width < 600;
  static bool isTablet() => _mediaQueryData.size.width >= 600 && _mediaQueryData.size.width < 1024;
  static bool isDesktop() => _mediaQueryData.size.width >= 1024;

  // إضافة دوال للحصول على مقاسات محسنة للبطاقات
  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1024) {
      return screenWidth * 0.22; // 5 بطاقات في الصف للكمبيوتر
    } else if (screenWidth >= 600) {
      return screenWidth * 0.45; // 2 بطاقات في الصف للأيباد
    } else {
      return screenWidth * 0.45; // 2 بطاقات في الصف للجوال
    }
  }

  static double getCardHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1024) {
      return 280; // ارتفاع ثابت للكمبيوتر
    } else if (screenWidth >= 600) {
      return 260; // ارتفاع للأيباد
    } else {
      return 240; // ارتفاع للجوال
    }
  }

  // تحسين حجم الخط للأجهزة المختلفة
  static double getFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor;

    if (screenWidth >= 1024) {
      scaleFactor = 1.2; // تكبير للكمبيوتر
    } else if (screenWidth >= 600) {
      scaleFactor = 1.1; // تكبير قليل للأيباد
    } else {
      scaleFactor = 1.0; // الحجم الأساسي للجوال
    }

    return baseSize * scaleFactor * scaleCustomTextSolveIssue();
  }
}
