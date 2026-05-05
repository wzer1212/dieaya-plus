import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_list_product_card.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_product_card_gird_view.dart';
import 'package:dieaya_user/ui/widgets/product_card.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../UI/widgets/product_card.dart';
import '../../../Utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_svg/svg.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

import '../../pages/ProductsScreen/product_details.dart';
import '../../pages/ProfileScreen/my_favs_screen.dart';

class GlobalViewProducts extends StatelessWidget {
  final bool isDark;
  final bool isArabic;
  final double? cardRatio;
  final double? priceFontSize;
  final double? storeFontSize;
  final double? descriptionFontSize;
  final double? priceCanceledFontSize;
  final double? imageHeight;
  final int? crossAxisCount;
  final List<Product> products;
  Rx<bool>? isGrid;
  final bool? showSwitchList;
  final bool? shrinkWrap;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  GlobalViewProducts(this.isDark, this.isArabic,
      {this.storeFontSize,
      this.cardRatio,
      this.priceFontSize,
      this.descriptionFontSize,
      this.priceCanceledFontSize,
      this.imageHeight,
      this.crossAxisCount,
      required this.products,
      this.isGrid,
      this.showSwitchList = true,
      this.padding,
      this.physics,
      this.shrinkWrap}) {
    isGrid ??= true.obs;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            showSwitchList!
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            isGrid!.value = false;
                            debugPrint('List View Tapped');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/svg/listview.svg',
                              width: 22,
                              height: 22,
                              colorFilter: ColorFilter.mode(
                                !isGrid!.value
                                    ? AppColors.primary
                                    : Colors.grey,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            isGrid!.value = true;
                            debugPrint('Grid View Tapped');
                          },
                          child: Container(
                            child: SvgPicture.asset(
                              'assets/svg/gridview.svg',
                              width: 22,
                              height: 22,
                              colorFilter: ColorFilter.mode(
                                isGrid!.value ? AppColors.primary : Colors.grey,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(height: 10),
            products.isEmpty
                ? Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 20.0),
                    child: Center(
                      child: CustomTextSolveIssue(
                        'no_data_available'.tr,
                        style: GoogleFonts.getFont(
                          isArabic ? 'Tajawal' : 'Roboto',
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  )
                : isGrid!.value
                    ? GridView.builder(
                        shrinkWrap: shrinkWrap ?? true,
                        physics:
                            physics ?? const NeverScrollableScrollPhysics(),
                        padding: padding ??
                            const EdgeInsetsDirectional.symmetric(
                                horizontal: 5.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount ?? 2,
                          crossAxisSpacing: 12.0.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: cardRatio ?? 0.60,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final logo = product.market.logo;
                          final title = product.market.nameAr;
                          final marketId = product.market.id;
                          return GlobalProductCardGrid(
                            imageHeight: imageHeight,
                            priceCanceledFontSize: priceCanceledFontSize,
                            descriptionFontSize: descriptionFontSize,
                            priceFontSize: priceFontSize,
                            storeFontSize: storeFontSize,
                            product: product,
                            onTap: () {
                              print(product.id);
                              print(product.market.id);
                              print(product.market.nameAr);
                              Get.to(() => ProductDetailScreen(
                                    product: product,
                                    logo: product.market.logo,
                                    title: product.market.nameAr,
                                    marketId: product.market.id,
                                  ));
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: shrinkWrap ?? true,
                        physics:
                            physics ?? const NeverScrollableScrollPhysics(),
                        padding: padding ??
                            const EdgeInsetsDirectional.symmetric(
                                horizontal: 5.0),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final logo = product.market.logo;
                          final title = product.market.nameAr;
                          final marketId = product.market.id;
                          return GlobalListProductCard(
                            priceCanceledFontSize: priceCanceledFontSize,
                            descriptionFontSize: descriptionFontSize,
                            priceFontSize: priceFontSize,
                            productFontSize: storeFontSize,
                            product: product,
                            onTap: () {
                              Get.to(() => ProductDetailScreen(
                                  product: product,
                                  logo: logo,
                                  title: title,
                                  marketId: marketId,
                              ));
                            },
                            onFavoriteTap: () {
                              debugPrint(
                                  'Favorite status changed for product: ${product.id}');
                            },
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
