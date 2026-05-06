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

  static bool isMobile(BuildContext context) =>
      1.fullWidth < 800;

  static bool isTablet(BuildContext context) =>
      1.fullWidth>= 650 &&
          1.fullWidth < 1200;

  static bool isDesktop() =>
      1.fullWidth >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return desktop;
        } else if (constraints.maxWidth >= 800 && constraints.maxWidth <= 1023) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
