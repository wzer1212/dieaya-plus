import 'package:dieaya_market/controllers/subscription_controllers/subscription_details_controller.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/components/subscription_line_widget.dart';
import 'package:dieaya_market/ui/widgets/buttons.dart';
import 'package:dieaya_market/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_market/utils/app_colors.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionDetails extends StatelessWidget {
  SubscriptionDetails({super.key});

  SubscriptionDetailsController subscriptionDetailsController =
      Get.put(SubscriptionDetailsController()..getUsageDetails());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        switch (subscriptionDetailsController.status.value) {
          case Status.loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          case Status.failure:
            return Center(
              child: CustomText(
                text: subscriptionDetailsController.errorMessage.value,
                color: AppColors.red,
                fontSize: 16.sp,
              ),
            );
          case Status.success:
            var usageData =
                subscriptionDetailsController.usageDetails.value!.usageInfo;
            if ((subscriptionDetailsController
                    .usageDetails.value?.usageInfo.packageName) ==
                null)
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                child: Column(
                  children: [
                    CustomText(
                      text: subscriptionDetailsController
                          .usageDetails.value?.usageInfo.packageName ??
                          "no_package_currently".tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: 'current_package'.tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: ' :'.tr,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        text: subscriptionDetailsController
                                .usageDetails.value?.usageInfo.packageName ??
                            "no_package_currently".tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        print(usageData.data[index].remaining);

                        if (usageData.data[index].total == 'none') {
                          print(usageData.data[index].total);
                          return SizedBox.shrink();
                        }
                        return SubscriptionLineWidget(
                          title: usageData.data[index].total != null
                              ? 'k_${usageData.data[index].tag}'.trParams({
                                  "remaining": ((usageData.data[index].total ??
                                              0) -
                                          (usageData.data[index].remaining ??
                                              0))
                                      .toString(),
                                  'total':
                                      usageData.data[index].total.toString(),
                                })
                              : 'unlimited_service'.trParams(
                                  {"var": usageData.data[index].tag.tr}),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10.h,
                          ),
                      itemCount: usageData.data.length),
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'remaining_days'.trParams({
                          "remaining": usageData.remainDurationUsage.toString(),
                          "total": usageData.totalDuration.toString(),
                        }),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: usageData.totalDuration.toString(),
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                          CustomText(
                            text: 'day'.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey2,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          default:
            return Center(
              child: CustomText(
                text: 'error'.tr,
                color: AppColors.red,
                fontSize: 16.sp,
              ),
            );
        }
        ;
      },
    );
  }
}
