import 'dart:async';

import 'package:dieaya_user/UI/pages/NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_user/models/best_market_model.dart';
import 'package:dieaya_user/ui/widgets/coupons_screen/coupon_card_grid_shimmer.dart';
import 'package:dieaya_user/ui/widgets/coupons_screen/coupon_card_list_shimmer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/grid_cart_shimmer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/list_cart_shimmer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/main_app_header.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/CategoryController/category_controller.dart';
import '../../../controllers/Coupons_Controller/get_coupons_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/coupons_model.dart';
import '../../../utils/constants/image_constants.dart';
import '../../widgets/category_list.dart';
import '../../widgets/coupon_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/custom_sheets.dart';
import '../ProfileScreen/my_favs_screen.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class CouponsScreen extends StatefulWidget {
  final bool fromSeeAll;

  const CouponsScreen({
    super.key,
    this.fromSeeAll = false,
  });

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final CategoryController categoryController = Get.put(CategoryController());
  final MarketCouponController couponController =
      Get.put(MarketCouponController());
  final TextEditingController _searchController = TextEditingController();
  String selectedCategoryId = '1'; // Default to 'all' category
  String selectedTab = 'products'; // Default to products
  bool isGridView = true; // Default to grid view
  String sortOrder = 'new_to_old'; // Default sort order: new to old
  final Duration _debounceDuration = const Duration(milliseconds: 300);
  Timer? _debounceTimer;
  final ThemeController themeController = Get.put(ThemeController());

  int couponsPage = 1;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
  final ScrollController _controller = ScrollController();
  

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return AdaptiveLayOut(
        mobile: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Column(
            children: [
              MainAppHeader(
                readOnly: false,
                fromSeeAll: widget.fromSeeAll,
                controller: _searchController,
                onChanged: (value) {
                  _debounceTimer?.cancel();
                  _debounceTimer = Timer(_debounceDuration, () {
                    couponController.searchCoupons(value);
                    print('Search Typing: $value');
                  });
                },
                onNotificationPressed: () async {
                  bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
                  if (isLoggedIn) {
                    Get.to(() => NotificationsScreen());
                  } else {
                    CustomSheets.showLoginSheet(context);
                    print('Favorites Tapped - Showing Login Bottom Sheet');
                  }
                },
                onFavoritePressed: () async {
                  bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
                  if (isLoggedIn) {
                    Get.to(() => MyFavScreen());
                  } else {
                    CustomSheets.showLoginSheet(context);
                    print('Favorites Tapped - Showing Login Bottom Sheet');
                  }
                },
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 10.w),
              //   width: 600.w,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: isDark
              //           ? [AppColors.primary, AppColors.primary, Colors.black]
              //           : [AppColors.primary, AppColors.primary, Colors.white],
              //       stops: const [0.0, 0.0, 1.0],
              //     ),
              //   ),
              //   child: Column(
              //     children: [
              //       SizedBox(
              //         height: 50.h,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           widget.fromSeeAll
              //               ? IconButton(
              //             icon:  Icon(
              //               Icons.arrow_back_ios,
              //               color: AppColors.white,
              //               size: 34.h,
              //             ),
              //             onPressed: () {
              //               Get.back(); // Navigate back
              //             },
              //           )
              //               : Image.asset(
              //             'assets/images/logodiaya.png',
              //             width: 30,
              //             height: 30,
              //           ),
              //           SizedBox(
              //             width: 10.w,
              //           ),
              //           Expanded(
              //             child: Container(
              //               // height: 50,
              //               // decoration: BoxDecoration(
              //               //   color: Colors.white,
              //               //   borderRadius: BorderRadius.circular(25),
              //               // ),
              //               child:TextFormField(
              //                 controller: _searchController,
              //                 textAlignVertical: TextAlignVertical.center,
              //                 textAlign: TextAlign.start,
              //                 decoration: InputDecoration(
              //                   suffixIcon: Padding(
              //                     padding: EdgeInsets.all(3.w),
              //                     child: CircleAvatar(
              //                       backgroundColor: AppColors.grey2,
              //                       child: SvgPicture.asset(
              //                         ImageConstants.search,
              //                         width: 30.w,
              //                         height: 28.h,
              //                         colorFilter: const ColorFilter.mode(
              //                           Color(0xff5D5C5C),
              //                           BlendMode.srcIn,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   filled: true,
              //                   fillColor: AppColors.white,
              //                   hintText: 'search'.tr,
              //                   hintStyle: TextStyle(color: Colors.grey),
              //                   border: InputBorder.none,
              //                   enabledBorder: OutlineInputBorder(
              //                       borderRadius: BorderRadius.circular(23.r),
              //                       borderSide: BorderSide.none),
              //                   focusedBorder: OutlineInputBorder(
              //                       borderRadius: BorderRadius.circular(23.r),
              //                       borderSide: BorderSide.none),
              //                   contentPadding: EdgeInsets.symmetric(horizontal: 20),
              //                 ),
              //                 onChanged: (value) {
              //                   _debounceTimer?.cancel();
              //                   _debounceTimer = Timer(_debounceDuration, () {
              //                     couponController.searchCoupons(value);
              //                     print('Search Typing: $value');
              //                   });
              //                 },
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             width: 10.w,
              //           ),
              //           Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               CircleAvatar(
              //                 backgroundColor: AppColors.white,
              //                 child: IconButton(
              //                   icon: SvgPicture.asset(
              //                     'assets/svg/notify.svg',
              //                     width: 24.w,
              //                     height: 24.h,
              //                     colorFilter: const ColorFilter.mode(
              //                       Colors.black54,
              //                       BlendMode.srcIn,
              //                     ),
              //                   ),
              //                   onPressed: () async {
              //                     bool isLoggedIn =
              //                     await SharedPrefsConstants.isLoggedIn();
              //                     if (isLoggedIn) {
              //                       Get.to(() => NotificationsScreen());
              //                     } else {
              //                       CustomSheets.showLoginSheet(context);
              //                       print(
              //                           'Favorites Tapped - Showing Login Bottom Sheet');
              //                     }
              //                   },
              //                 ),
              //               ),
              //               SizedBox(
              //                 width: 10.w,
              //               ),
              //               CircleAvatar(
              //                 backgroundColor: AppColors.white,
              //                 child: IconButton(
              //                   icon: SvgPicture.asset(
              //                     'assets/svg/Heart 2.svg',
              //                     width: 24,
              //                     height: 24,
              //                     colorFilter: const ColorFilter.mode(
              //                       Colors.black54,
              //                       BlendMode.srcIn,
              //                     ),
              //                   ),
              //                   onPressed: () async {
              //                     bool isLoggedIn =
              //                     await SharedPrefsConstants.isLoggedIn();
              //                     if (isLoggedIn) {
              //                       Get.to(() => MyFavScreen());
              //                     } else {
              //                       CustomSheets.showLoginSheet(context);
              //                       print(
              //                           'Favorites Tapped - Showing Login Bottom Sheet');
              //                     }
              //                   },
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 30.h,
              //       ),
              //
              //     ],
              //   ),
              // ),

              Expanded(
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    Obx(() => categoryController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : _buildHorizontalCategoryList()),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildFilterChip('sort'.tr, Icons.swap_vert),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() => isGridView = false);
                                  debugPrint('List View Tapped');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  // decoration: BoxDecoration(
                                  //   color: !isGridView ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
                                  //   borderRadius: BorderRadius.circular(8),
                                  // ),
                                  child: SvgPicture.asset(
                                    'assets/svg/listview.svg',
                                    width: 22,
                                    height: 22,
                                    colorFilter: ColorFilter.mode(
                                      !isGridView
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
                                  setState(() => isGridView = true);
                                  debugPrint('Grid View Tapped');
                                },
                                child: Container(
                                  // padding: const EdgeInsets.all(8),
                                  // decoration: BoxDecoration(
                                  //   color: isGridView ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
                                  //   borderRadius: BorderRadius.circular(8),
                                  // ),
                                  child: SvgPicture.asset(
                                    'assets/svg/gridview.svg',
                                    width: 22,
                                    height: 22,
                                    colorFilter: ColorFilter.mode(
                                      isGridView
                                          ? AppColors.primary
                                          : Colors.grey,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (couponController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (couponController.errorMessage.value.isNotEmpty) {
                        return Center(
                            child: CustomTextSolveIssue('error_message'.tr));
                      }
                      if (couponController.coupons.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: CustomTextSolveIssue(
                              'no_data'.tr,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        );
                      }
                      List<MarketCoupon> filteredCoupons = selectedCategoryId ==
                              '1'
                          ? couponController.coupons.toList()
                          : couponController.coupons
                              .where((coupon) =>
                                  coupon.categoryId.toString() ==
                                  selectedCategoryId)
                              .toList();

                      filteredCoupons.sort((a, b) {
                        final dateA = _parseDate(a.createdAt) ?? DateTime.now();
                        final dateB = _parseDate(b.createdAt) ?? DateTime.now();
                        return sortOrder == 'new_to_old'
                            ? dateB.compareTo(dateA)
                            : dateA.compareTo(dateB);
                      });

                      return selectedTab == 'products'
                          ? (isGridView
                              ? _buildProductGrid(
                                  coupons: filteredCoupons,
                                  pagination: couponController.pagination.value)
                              : _buildProductList(
                                  coupons: filteredCoupons,
                                  pagination:
                                      couponController.pagination.value))
                          : const SizedBox();
                    }),
                    const SizedBox(height: 20),
                  ],
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
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 55.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 70.h,
                            ),
                            Obx(() => categoryController.isLoading.value
                                ? const Center(child: CircularProgressIndicator())
                                : _buildHorizontalCategoryList(padding: EdgeInsets.symmetric())),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 16.0, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      _buildFilterChip('sort'.tr, Icons.swap_vert),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() => isGridView = false);
                                          debugPrint('List View Tapped');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          // decoration: BoxDecoration(
                                          //   color: !isGridView ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
                                          //   borderRadius: BorderRadius.circular(8),
                                          // ),
                                          child: SvgPicture.asset(
                                            'assets/svg/listview.svg',
                                            width: 22,
                                            height: 22,
                                            colorFilter: ColorFilter.mode(
                                              !isGridView
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
                                          setState(() => isGridView = true);
                                          debugPrint('Grid View Tapped');
                                        },
                                        child: Container(
                                          child: SvgPicture.asset(
                                            'assets/svg/gridview.svg',
                                            width: 22,
                                            height: 22,
                                            colorFilter: ColorFilter.mode(
                                              isGridView
                                                  ? AppColors.primary
                                                  : Colors.grey,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              if (couponController.isLoading.value) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (couponController.errorMessage.value.isNotEmpty) {
                                return Center(
                                    child: CustomTextSolveIssue('error_message'.tr));
                              }
                              if (couponController.coupons.isEmpty) {
                                return Padding(
                                  padding:  EdgeInsets.symmetric(vertical: 125.h),
                                  child: Center(
                                    child: CustomTextSolveIssue(
                                      'no_data'.tr,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                  ),
                                );
                              }
                              List<MarketCoupon> filteredCoupons =
                                  selectedCategoryId == '1'
                                      ? couponController.coupons.toList()
                                      : couponController.coupons
                                          .where((coupon) =>
                                              coupon.categoryId.toString() ==
                                              selectedCategoryId)
                                          .toList();

                              filteredCoupons.sort((a, b) {
                                final dateA =
                                    _parseDate(a.createdAt) ?? DateTime.now();
                                final dateB =
                                    _parseDate(b.createdAt) ?? DateTime.now();
                                return sortOrder == 'new_to_old'
                                    ? dateB.compareTo(dateA)
                                    : dateA.compareTo(dateB);
                              });

                              return selectedTab == 'products'
                                  ? (isGridView
                                      ? _buildProductGrid(
                                          cardRatio: 0.9,
                                          logoHeight: 25.h,
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          coupons: filteredCoupons,
                                          pagination:
                                              couponController.pagination.value)
                                      : _buildProductList(
                                          spaceAboveCouponCode: 20.h,
                                          couponCardHeight: 135.h,
                                          storeNameFontSize: 21.w,
                                          discountPercentageFontSize: 28.w,
                                          discountFontSize: 18.w,
                                          couponCodeFontSize: 18.sp,
                                          logoHeight: 20.h,
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          coupons: filteredCoupons,
                                          pagination:
                                              couponController.pagination.value))
                                  : const SizedBox();
                            }),
                            const SizedBox(height: 20),
                          ],
                        ),
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

  DateTime? _parseDate(dynamic createdAt) {
    print('createdAt: $createdAt, type: ${createdAt.runtimeType}');
    if (createdAt == null) return null;
    try {
      if (createdAt is String) {
        return DateTime.parse(createdAt);
      } else if (createdAt is DateTime) {
        return createdAt;
      }
    } catch (e) {
      print('Error parsing createdAt: $e');
    }
    return null;
  }

  Widget _buildHorizontalCategoryList({EdgeInsetsGeometry? padding}) {
    return categoryController.isLoading.value
        ? const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          )
        : categoryController.errorMessage.value.isNotEmpty ||
                categoryController.categories.isEmpty
            ? SizedBox(
                height: 120,
                child: Center(
                  child: CustomTextSolveIssue(
                    'no_data'.tr,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              )
            : SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:padding??
                      const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    final bool isSelected =
                        category.id.toString() == selectedCategoryId;
                    return Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category.id.toString();
                            print('Category selected: ${category.nameEn}');
                          });
                        },
                        child: CircularCategoryItem(
                          label: Get.locale?.languageCode == 'ar'
                              ? category.nameAr
                              : category.nameEn,
                          imageUrl: category.image,
                          backgroundColor: isSelected
                              ? AppColors.primary.withOpacity(0.3)
                              : AppColors.lightBlueBackgroundContiner,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  },
                ),
              );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortOrder = value;
                debugPrint('Sort order changed to: $sortOrder');
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: CustomTextSolveIssue(
                        'new_to_old'.tr,
                        style: GoogleFonts.tajawal(color: AppColors.black),
                      ),
                      value: 'new_to_old',
                      groupValue: sortOrder,
                      onChanged: (value) {
                        Navigator.pop(context, value); // Close menu and select
                      },
                      activeColor: AppColors.primary,
                    ),
                    RadioListTile<String>(
                      title: CustomTextSolveIssue(
                        'old_to_new'.tr,
                        style: GoogleFonts.tajawal(color: AppColors.black),
                      ),
                      value: 'old_to_new',
                      groupValue: sortOrder,
                      onChanged: (value) {
                        Navigator.pop(context, value); // Close menu and select
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
            child: Row(
              children: [
                CustomTextSolveIssue(
                  'الترتيب', // Static label
                  style: GoogleFonts.tajawal(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
            color: AppColors.white,
            // White background for dropdown
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
            elevation: 4,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildProductGrid({
    required List<MarketCoupon> coupons,
    required Pagination pagination,
    ScrollPhysics? physics,
    bool? shrinkWrap = false,
    double? logoHeight,
    double? cardRatio,
  }) {
    return Container(
      height: kIsWeb ? null : 540.h,
      child: GridView.builder(
        padding: const EdgeInsets.all(5),
        shrinkWrap: shrinkWrap!,
        physics: physics,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? 3 : 2,
          crossAxisSpacing: 9.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: cardRatio ?? 0.80,
        ),
        itemCount: coupons.length + 1,
        itemBuilder: (context, index) {
          /// TODO Make Pagination
          if (index == coupons.length) {
            if (pagination.currentPage < pagination.lastPage) {
              print(
                  'pagenation.currentPage = ${pagination.currentPage}\npagenation.lastPage = ${pagination.lastPage} ');
              // Load next page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                couponController.fetchCoupons(
                    page: ++couponsPage, isFromPaginationUi: true);
              });
              return CouponCardGridShimmer();
            }
            return SizedBox.shrink();
          }
          final coupon = coupons[index];
          return CouponCardGrid(
            logoHeight: logoHeight,
            onTap: () {
              print(
                  'Coupon Tapped: ${coupon.descriptionAr ?? 'No description'}');
            },
            coupon: coupon,
          );
        },
      ),
    );
  }

  Widget _buildProductList(
      {required List<MarketCoupon> coupons,
      required Pagination pagination,
      ScrollPhysics? physics,
      bool? shrinkWrap = false,
      double? logoHeight,
      double? couponCodeFontSize,
      double? discountFontSize,
      double? discountPercentageFontSize,
      double? storeNameFontSize,
      double? spaceAboveCouponCode,
      double? couponCardHeight}) {
    return Container(
      height: kIsWeb ? null : 540.h,
      child: ListView.builder(
        physics: physics,
        shrinkWrap: shrinkWrap!,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
        itemCount: coupons.length + 1,
        itemBuilder: (context, index) {
          /// TODO Make Pagination
          if (index == coupons.length) {
            if (pagination.currentPage < pagination.lastPage) {
              print(
                  'pagenation.currentPage = ${pagination.currentPage}\npagenation.lastPage = ${pagination.lastPage} ');
              // Load next page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                couponController.fetchCoupons(
                    page: ++couponsPage, isFromPaginationUi: true);
              });
              return CouponListCardShimmer();
            }
            return SizedBox.shrink();
          }
          final coupon = coupons[index];
          return CouponCardList(
            CouponCodeIcon: spaceAboveCouponCode,
            couponCardHeight: couponCardHeight,
            logoHeight: logoHeight,
            couponCodeFontSize: couponCodeFontSize,
            discountFontSize: discountFontSize,
            discountPercentageFontSize: discountPercentageFontSize,
            storeNameFontSize: storeNameFontSize,
            onTap: () {
              print(
                  'Coupon Tapped: ${coupon.descriptionAr ?? 'No description'}');
            },
            coupon: coupon,
          );
        },
      ),
    );
  }
}

// class CouponsScreen extends StatefulWidget {
//   const CouponsScreen({super.key});
//
//   @override
//   State<CouponsScreen> createState() => _CouponsScreenState();
// }
//
// class _CouponsScreenState extends State<CouponsScreen> {
//   final CategoryController categoryController = Get.put(CategoryController());
//   final MarketCouponController couponController = Get.put(MarketCouponController());
//   final TextEditingController _searchController = TextEditingController();
//   String selectedCategoryId = '1'; // Default to 'all' category
//   String selectedTab = 'products'; // Default to 'المنتجات'
//   bool isGridView = true; // Default to grid view
//   String sortOrder = 'new_to_old'; // Default sort order: new to old
//   final Duration _debounceDuration = const Duration(milliseconds: 300);
//   Timer? _debounceTimer;
//   final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
//
//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = themeController.themeMode.value == ThemeMode.dark;
//     return Scaffold(
//       backgroundColor: isDark? Colors.black : Colors.white,
//       body: ListView(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: isDark? [
//                   AppColors.primary,
//                   AppColors.primary,
//                   Colors.black,
//                 ]: [   AppColors.primary,
//                   AppColors.primary,
//                   Colors.white,],
//                 stops: const [0.0, 0.5, 1.0], // Fixed stops
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 20, bottom: 10, right: 20, left: 20),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Image.asset(
//                         'assets/images/logodiaya.png',
//                         width: 30,
//                         height: 30,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(25),
//                           color: Colors.white,
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Stack(
//                               children: [
//                                 IconButton(
//                                   icon: SvgPicture.asset(
//                                     'assets/svg/notify.svg',
//                                     width: 24,
//                                     height: 24,
//                                     colorFilter: const ColorFilter.mode(
//                                       Colors.black54,
//                                       BlendMode.srcIn,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     print('Notifications Tapped');
//                                   },
//                                 ),
//                                 Positioned(
//                                   right: 11,
//                                   top: 14,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(2),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                     constraints: const BoxConstraints(
//                                       minWidth: 8,
//                                       minHeight: 8,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             IconButton(
//                               icon: SvgPicture.asset(
//                                 'assets/svg/Heart 2.svg',
//                                 width: 24,
//                                 height: 24,
//                                 colorFilter: const ColorFilter.mode(
//                                   Colors.black54,
//                                   BlendMode.srcIn,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 print('Favorites Tapped');
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           child: Obx(() => TextField(
//                             controller: _searchController,
//                             textAlignVertical: TextAlignVertical.center,
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
//                               hintText: selectedTab == 'products'
//                                   ? 'ابحث عن افضل المنتجات'
//                                   : 'ابحث عن المتاجر',
//                               hintStyle: GoogleFonts.tajawal(color: Colors.grey, fontSize: 14),
//                               suffixIcon: couponController.isLoading.value
//                                   ? const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: SizedBox(
//                                   width: 26,
//                                   height: 26,
//                                   child: CircularProgressIndicator(strokeWidth: 2),
//                                 ),
//                               )
//                                   : Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   width: 50,
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFEAEAEA),
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
//                                     child: SvgPicture.asset(
//                                       'assets/svg/Search 1.svg',
//                                       width: 26,
//                                       height: 26,
//                                       colorFilter: const ColorFilter.mode(
//                                         Color(0xff5D5C5C),
//                                         BlendMode.srcIn,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               prefixIcon: couponController.searchQuery.value.isNotEmpty
//                                   ? IconButton(
//                                 icon: const Icon(Icons.clear, color: Colors.grey),
//                                 onPressed: () {
//                                   _searchController.clear();
//                                   couponController.clearSearch();
//                                 },
//                               )
//                                   : null,
//                               border: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                             ),
//                             onChanged: (value) {
//                               _debounceTimer?.cancel();
//                               _debounceTimer = Timer(_debounceDuration, () {
//                                 couponController.searchCoupons(value);
//                                 print('Search Typing: $value');
//                               });
//                             },
//                           )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Obx(() => categoryController.isLoading.value
//               ? const Center(child: CircularProgressIndicator())
//               : _buildHorizontalCategoryList()),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     // _buildTabButton('products', 'المنتجات'),
//                     // const SizedBox(width: 10),
//                     // _buildTabButton('stores', 'المتاجر'),
//                     // const SizedBox(width: 10),
//                     _buildFilterChip('الترتيب', Icons.swap_vert),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         setState(() => isGridView = true);
//                         print('Grid View Tapped');
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: isGridView
//                               ? AppColors.primary.withOpacity(0.3)
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: SvgPicture.asset(
//                           'assets/svg/gridview.svg',
//                           width: 20,
//                           height: 20,
//                           colorFilter: ColorFilter.mode(
//                             isGridView ? AppColors.primary : Colors.grey,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     InkWell(
//                       onTap: () {
//                         setState(() => isGridView = false);
//                         print('List View Tapped');
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: !isGridView
//                               ? AppColors.primary.withOpacity(0.3)
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: SvgPicture.asset(
//                           'assets/svg/listview.svg',
//                           width: 20,
//                           height: 20,
//                           colorFilter: ColorFilter.mode(
//                             !isGridView ? AppColors.primary : Colors.grey,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Obx(() {
//             if (couponController.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (couponController.errorMessage.value.isNotEmpty) {
//               return Center(child: CustomTextSolveIssue('يوجد مشكلة حاليا'));
//             }
//             if (couponController.coupons.isEmpty) {
//               return const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20.0),
//                 child: Center(
//                   child: CustomTextSolveIssue(
//                     'لا يوجد حاليا',
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                 ),
//               );
//             }
//             // Filter coupons by selected category
//             List<MarketCoupon> filteredCoupons = selectedCategoryId == '1'
//                 ? couponController.coupons.toList()
//                 : couponController.coupons
//                 .where((coupon) => coupon.categoryId.toString() == selectedCategoryId)
//                 .toList();
//
//             // Sort coupons based on createdAt
//             filteredCoupons.sort((a, b) {
//               final dateA = _parseDate(a.createdAt) ?? DateTime.now();
//               final dateB = _parseDate(b.createdAt) ?? DateTime.now();
//               return sortOrder == 'new_to_old'
//                   ? dateB.compareTo(dateA)
//                   : dateA.compareTo(dateB);
//             });
//
//             return selectedTab == 'products'
//                 ? (isGridView
//                 ? _buildProductGrid(coupons: filteredCoupons)
//                 : _buildProductList(coupons: filteredCoupons))
//                 : const SizedBox(); // TODO: Add markets rendering for 'stores' tab if needed
//           }),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   // Helper method to parse createdAt to DateTime
//   DateTime? _parseDate(dynamic createdAt) {
//     print('createdAt: $createdAt, type: ${createdAt.runtimeType}');
//     if (createdAt == null) return null;
//     try {
//       if (createdAt is String) {
//         return DateTime.parse(createdAt);
//       } else if (createdAt is DateTime) {
//         return createdAt;
//       }
//     } catch (e) {
//       print('Error parsing createdAt: $e');
//     }
//     return null;
//   }
//
//   Widget _buildHorizontalCategoryList() {
//     return categoryController.isLoading.value
//         ? const SizedBox(
//       height: 120,
//       child: Center(child: CircularProgressIndicator()),
//     )
//         : categoryController.errorMessage.value.isNotEmpty || categoryController.categories.isEmpty
//         ? const SizedBox(
//       height: 120,
//       child: Center(
//         child: CustomTextSolveIssue(
//           'لا يوجد حاليا',
//           style: TextStyle(fontSize: 16, color: Colors.black54),
//         ),
//       ),
//     )
//         : SizedBox(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//         itemCount: categoryController.categories.length,
//         itemBuilder: (context, index) {
//           final category = categoryController.categories[index];
//           final bool isSelected = category.id.toString() == selectedCategoryId;
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedCategoryId = category.id.toString();
//                   print('Category selected: ${category.nameEn}');
//                 });
//               },
//               child: CircularCategoryItem(
//                 label: category.nameAr,
//                 imageUrl: category.image,
//                 backgroundColor: isSelected
//                     ? AppColors.primary.withOpacity(0.3)
//                     : AppColors.lightBlueBackgroundContiner,
//                 isSelected: isSelected,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//
//   Widget _buildFilterChip(String label, IconData icon) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.primary.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(width: 8),
//           DropdownButton<String>(
//             value: sortOrder,
//             icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
//             underline: const SizedBox(), // Remove default underline
//             dropdownColor: AppColors.primary,
//             style: GoogleFonts.tajawal(
//               color: AppColors.white,
//             ),
//             items: [
//               DropdownMenuItem(
//                 value: 'new_to_old',
//                 child: CustomTextSolveIssue(
//                   'من الأحدث إلى الأقدم',
//                   style: GoogleFonts.tajawal(color: AppColors.white),
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'old_to_new',
//                 child: CustomTextSolveIssue(
//                   'من الأقدم إلى الأحدث',
//                   style: GoogleFonts.tajawal(color: AppColors.white),
//                 ),
//               ),
//             ],
//             onChanged: (value) {
//               setState(() {
//                 sortOrder = value!;
//                 print('Sort order changed to: $sortOrder');
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductGrid({required List<MarketCoupon> coupons}) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.all(5),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         // crossAxisSpacing: 0.0,
//         mainAxisSpacing: 8.0,
//         childAspectRatio: 0.80,
//       ),
//       itemCount: coupons.length,
//       itemBuilder: (context, index) {
//         final coupon = coupons[index];
//         return CouponCardGrid(
//           onTap: () {
//             // Get.to(() => CouponDetailsScreen(coupon: coupon));
//             print('Coupon Tapped: ${coupon.descriptionAr ?? 'No description'}');
//           },
//           coupon: coupon,
//         );
//       },
//     );
//   }
//
//   Widget _buildProductList({required List<MarketCoupon> coupons}) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       itemCount: coupons.length,
//       itemBuilder: (context, index) {
//         final coupon = coupons[index];
//         return CouponCardList(
//           onTap: () {
//             // Get.to(() => CouponDetailsScreen(coupon: coupon));
//             print('Coupon Tapped: ${coupon.descriptionAr ?? 'No description'}');
//           },
//           coupon: coupon,
//         );
//       },
//     );
//   }
// }
