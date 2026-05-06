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
      MediaQuery.sizeOf(context).width < 500;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 500 &&
          MediaQuery.sizeOf(context).width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1050) {
          return desktop;
        } else if (constraints.maxWidth >= 800 && constraints.maxWidth < 1050) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
