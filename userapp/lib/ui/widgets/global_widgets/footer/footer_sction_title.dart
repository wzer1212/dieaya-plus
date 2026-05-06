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


class FooterSectionsTitle extends StatelessWidget {
  const FooterSectionsTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomTextSolveIssue(
      title,
      style: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 13.w, color: AppColors.white),
    );
  }
}
