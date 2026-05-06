
import 'package:dieaya_user/Utils/app_colors.dart';
import 'package:dieaya_user/routes/app_routes.dart';
import 'package:dieaya_user/ui/pages/CouponsScreen/coupons_screen.dart';
import 'package:dieaya_user/ui/pages/OffersScreen/offers_screen.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/products_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FooterSectionBullet extends StatelessWidget {
  const FooterSectionBullet({
    super.key,
    this.onTap,
    required this.title,
  });

  final void Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomTextSolveIssue(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10.w,
            color: AppColors.white),
      ),
    );
  }
}
