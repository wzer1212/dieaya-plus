


import 'package:dieaya_user/utils/responsive/responsive.dart';

extension SizeExtension on num {
  double get w => ResponsiveService.scaleWidth() * this;

  double get fullWidth => ResponsiveService.fullScreenWidth() ;
  double get fullHeight => ResponsiveService.fullScreenHeight() ;

  double get h => ResponsiveService.scaleHeight() * this;

  double get r => ResponsiveService.scaleRadius() * this;

  double get sp => ResponsiveService.scaleCustomTextSolveIssue() * this;
}
 