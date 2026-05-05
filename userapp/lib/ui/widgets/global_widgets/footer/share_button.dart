import 'package:dieaya_user/Utils/app_colors.dart';
import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/routes/app_routes.dart';
import 'package:dieaya_user/ui/pages/CouponsScreen/coupons_screen.dart';
import 'package:dieaya_user/ui/pages/OffersScreen/offers_screen.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/products_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer_sction_title.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer_section_bullet.dart';
import 'package:dieaya_user/utils/constants/image_constants.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class shareButton extends StatelessWidget {
  const shareButton({
    super.key,
    required this.icon,
  });

  final String icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      width: 85.w,
      child: SvgPicture.asset(
        icon,
      ),
    );
  }
}