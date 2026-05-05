

import 'package:dieaya_market/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_market/utils/app_colors.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';

class SubscriptionLineWidget extends StatelessWidget {
  const SubscriptionLineWidget({
    super.key, required this.title,
  });
  final String title;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: AppColors.primary,
        ),
        SizedBox(
          width: 20.w,
        ),
        CustomText(
          text: title,
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
          color: AppColors.grey2,
        ),
      ],
    );
  }
}
