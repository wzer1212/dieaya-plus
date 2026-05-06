import 'package:dieaya_user/Utils/app_colors.dart';
import 'package:dieaya_user/controllers/CountsConroller/counts_controller.dart';
import 'package:dieaya_user/controllers/show_home_categories_controller.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/pages/HomeScreen/home_screen.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/products_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_product_card_gird_view.dart';
import 'package:dieaya_user/ui/widgets/product_card.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/ProductsScreen/product_details.dart';
import '../../pages/ProfileScreen/my_favs_screen.dart';
import '../global_widgets/section_header.dart';

class ShowCategoriesHomeScreen extends StatelessWidget {
  ShowCategoriesHomeScreen({super.key});

  final ShowHomeCategoriesController showHomeCategoriesController =
      Get.put(ShowHomeCategoriesController()..getShowHomeCategoryProduct());
  final ViewCountController viewCountController =
      Get.put(ViewCountController());

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode == 'ar';
    return AdaptiveLayOut(
        mobile: Column(
          children: [
            Obx(
              () {
                switch (showHomeCategoriesController.status.value) {
                  case Status.loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case Status.success:
                    var categories = showHomeCategoriesController
                        .categoriesResponse.value?.data;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        var category = categories![index];
                        var products = category.products.data;
                        return products.isEmpty
                            ? SizedBox.shrink()
                            : Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: SectionHeader(
                                      title: category.nameAr,
                                      actionText: 'see_all'.tr,
                                      onActionPressed: () {
                                        print(category.id.toString());

                                        Get.to(() => ProductsScreen(
                                              fromSeeAll: true,
                                              categoryId:
                                                  category.id.toString(),

                                            )); // No specific categoryId
                                        debugPrint(
                                            'See All Mixed Products Tapped');
                                      },
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 9.w, vertical: 0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 9.w,
                                      mainAxisSpacing: 5.h,
                                      childAspectRatio: 0.63.h,
                                    ),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return GlobalProductCardGrid(
                                        imageHeight: AdaptiveLayOut.isDesktop()
                                            ? 160.h
                                            : 225.h,
                                        product: product,
                                        onTap: () async {
                                          final success =
                                              await viewCountController
                                                  .incrementProductViews(
                                                      product.id!);
                                          debugPrint(
                                              'Product Views Increment for ${product.nameAr}: $success');
                                          Get.to(() => ProductDetailScreen(
                                                product: product,
                                                logo: product.market.logo,
                                                title: product.market.nameAr,
                                                marketId: product.market.id,
                                              ));
                                          debugPrint(
                                              'Product Tapped: ${product.nameAr}');
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                      },
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categories!.length,
                    );
                  default:
                    return CustomText(
                        text: showHomeCategoriesController.errorMessage.value);
                }
              },
            )
          ],
        ),
        desktop: Column(
          children: [
            Obx(
              () {
                switch (showHomeCategoriesController.status.value) {
                  case Status.loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case Status.success:
                    var categories = showHomeCategoriesController
                        .categoriesResponse.value?.data;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        var category = categories![index];
                        var products = category.products.data;
                        return products.isEmpty
                            ? SizedBox.shrink()
                            : Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: SectionHeader(
                                      title: category.nameAr,
                                      actionText: 'see_all'.tr,
                                      onActionPressed: () {
                                        Get.to(() => ProductsScreen(
                                              fromSeeAll: true,
                                              categoryId:
                                                  category.id.toString(),
                                            )); // No specific categoryId
                                        debugPrint(
                                            'See All Mixed Products Tapped');
                                      },
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 9.w, vertical: 10.h),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 9.w,
                                      mainAxisSpacing: 5.h,
                                      childAspectRatio: 0.5,
                                    ),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return GlobalProductCardGrid(
                                        imageHeight: 160.h,
                                        priceCanceledFontSize: 10.w,
                                        storeFontSize: 12.w,
                                        priceFontSize: 18.w,
                                        descriptionFontSize: 10.w,
                                        product: product,
                                        onTap: () async {
                                          final success =
                                              await viewCountController
                                                  .incrementProductViews(
                                                      product.id!);
                                          debugPrint(
                                              'Product Views Increment for ${product.nameAr}: $success');
                                          Get.to(() => ProductDetailScreen(
                                                product: product,
                                                logo: product.market.logo,
                                                title: product.market.nameAr,
                                                marketId: product.market.id,
                                              ));
                                          debugPrint(
                                              'Product Tapped: ${product.nameAr}');
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                      },
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categories!.length,
                    );
                  default:
                    return CustomText(
                        text: showHomeCategoriesController.errorMessage.value);
                }
              },
            )
          ],
        ));
  }
}
