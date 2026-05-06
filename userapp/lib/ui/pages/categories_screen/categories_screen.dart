import 'package:cached_network_image/cached_network_image.dart';
import 'package:dieaya_user/UI/pages/NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_user/UI/pages/ProfileScreen/my_favs_screen.dart';
import 'package:dieaya_user/UI/widgets/custom_sheets.dart';
import 'package:dieaya_user/Utils/app_sharedprefs_contants.dart';
import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/models/categories_model.dart';
import 'package:dieaya_user/ui/pages/ProductsScreen/products_screen.dart';
import 'package:dieaya_user/ui/widgets/category_screen_widgets/header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/main_app_header.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/constants/image_constants.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({super.key, this.categoryCartRario});

  final double? categoryCartRario;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<kCategory> categories = Get.arguments as List<kCategory>;
  final TextEditingController searchController = TextEditingController();
  late List<kCategory> categoriesSearchAble;

  @override
  void initState() {
    categoriesSearchAble = categories;
    super.initState();
  }

  final ThemeController themeController = Get.put(ThemeController());
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return AdaptiveLayOut(
        mobile: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Column(
            children: [
              MainAppHeader(
                readOnly: false,
                width: MediaQuery.of(context).size.width,
                controller: searchController,
                onChanged: (query) {
                  setState(() {
                    categoriesSearchAble = categories
                        .where(
                          (element) =>
                              element.nameAr.contains(query.toLowerCase()) ||
                              element.nameEn.contains(query.toLowerCase()),
                        )
                        .toList();
                  });
                },
                fromSeeAll: true,
              ),
              Expanded(
                child: GridView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
                  itemCount: categoriesSearchAble.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.85.w,
                  ),
                  itemBuilder: (context, index) {
                    final category = categoriesSearchAble[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductsScreen(
                              categoryId: category.id.toString(),
                              fromSeeAll: true,
                            ));
                        debugPrint('Category Tapped: ${category.nameEn}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: AppColors.grey,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: category.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 8.h),
                            CustomText(
                              text: category.nameAr,
                              textAlign: TextAlign.center,
                              fontSizes: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.black : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        desktop: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Column(
            children: [
              GlobalWebHeader(scrollController: _controller),
              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
                        itemCount: categoriesSearchAble.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 2.2,
                        ),
                        itemBuilder: (context, index) {
                          final category = categoriesSearchAble[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => ProductsScreen(
                                    categoryId: category.id.toString(),
                                    fromSeeAll: true,
                                  ));
                              debugPrint('Category Tapped: ${category.nameEn}');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: isDark
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: AppColors.grey,
                                            blurRadius: 4,
                                            offset: Offset(0, 3),
                                          ),
                                        ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: category.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomText(
                                    text: category.nameAr,
                                    textAlign: TextAlign.center,
                                    fontSizes: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.black : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      FooterWidget(),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ));
  }
}
