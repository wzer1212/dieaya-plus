import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/list_cart_shimmer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/main_app_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/grid_cart_shimmer.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/CategoryController/category_controller.dart';
import '../../../controllers/CountsConroller/counts_controller.dart';
import '../../../controllers/OffersControllers/get_offer_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/offer_model.dart';
import '../../../utils/constants/image_constants.dart';
import '../../widgets/category_list.dart';
import '../../widgets/custom_sheets.dart';
import '../../widgets/offer_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'offers_details_screen.dart';
import '../NotificationsScreen/notifications_screen.dart';
import '../ProfileScreen/my_favs_screen.dart';

class OffersScreen extends StatefulWidget {
  final bool fromSeeAll;

  const OffersScreen({
    super.key,
    this.fromSeeAll = false,
  });

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  String selectedCategoryId = '1'; // Default to 'all' categories
  String selectedTab = 'products'; // Default to products
  bool isGridView = true; // Default to grid view
  String sortOrder = 'new_to_old'; // Default sort order: new to old
  final TextEditingController _searchController = TextEditingController();
  final CategoryController categoryController = Get.find<CategoryController>();
  final MarketOffersController _marketOffersController =
      Get.find<MarketOffersController>();
  final ViewCountController viewCountController =
      Get.put(ViewCountController());
  int offersPage = 1;
  ScrollController _controller =ScrollController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  _marketOffersController.searchMarketOffers(value);
                  print('Search Typing: $value');
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
              Expanded(
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    if (selectedTab == 'products')
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
                      if (_marketOffersController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (_marketOffersController
                          .errorMessage.value.isNotEmpty) {
                        return Center(
                            child: CustomTextSolveIssue('error_message'.tr));
                      }
                      if (_marketOffersController.marketOffers.isEmpty) {
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
                      List<MarketOffer> filteredCoupons =
                          selectedCategoryId == '1'
                              ? _marketOffersController.marketOffers.toList()
                              : _marketOffersController.marketOffers
                                  .where((coupon) =>
                                      coupon.categoryId.toString() ==
                                      selectedCategoryId)
                                  .toList();

                      filteredCoupons.sort((a, b) {
                        final dateA = a.createdAt ?? DateTime.now();
                        final dateB = b.createdAt ?? DateTime.now();
                        return sortOrder == 'new_to_old'
                            ? dateB.compareTo(dateA)
                            : dateA.compareTo(dateB);
                      });

                      return selectedTab == 'products'
                          ? (isGridView
                              ? _buildProductGrid(
                                  offers: filteredCoupons,
                                  pagination:
                                      _marketOffersController.pagination.value,
                                  logoHeight: 30.h,
                                  offerFontSize: 24.w,
                                  descriptionFontSize: 18.w,
                                  marketNameSize: 20.sp,
                                )
                              : _buildProductList(
                                  offers: filteredCoupons,
                                  pagination:
                                      _marketOffersController.pagination.value))
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
                child: ListView(
                  controller: _controller,
                  physics: ClampingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 70.h,
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: Column(
                        children: [

                          if (selectedTab == 'products')
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
                            if (_marketOffersController.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (_marketOffersController
                                .errorMessage.value.isNotEmpty) {
                              return Center(
                                  child: CustomTextSolveIssue('error_message'.tr));
                            }
                            if (_marketOffersController.marketOffers.isEmpty) {
                              return Padding(
                                padding:  EdgeInsets.symmetric(vertical: 125.0.h),
                                child: Center(
                                  child: CustomTextSolveIssue(
                                    'no_data'.tr,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  ),
                                ),
                              );
                            }
                            List<MarketOffer> filteredCoupons =
                                selectedCategoryId == '1'
                                    ? _marketOffersController.marketOffers.toList()
                                    : _marketOffersController.marketOffers
                                        .where((coupon) =>
                                            coupon.categoryId.toString() ==
                                            selectedCategoryId)
                                        .toList();

                            filteredCoupons.sort((a, b) {
                              final dateA = a.createdAt ?? DateTime.now();
                              final dateB = b.createdAt ?? DateTime.now();
                              return sortOrder == 'new_to_old'
                                  ? dateB.compareTo(dateA)
                                  : dateA.compareTo(dateB);
                            });

                            return selectedTab == 'products'
                                ? (isGridView
                                    ? _buildProductGrid(
                                        crossAxisCount: 4,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        cardRatio: 1.2,
                                        marketNameSize: 14.w,
                                        logoHeight: 20.h,
                                        offerFontSize: 21.w,
                                        descriptionFontSize: 12.w,
                                        borderWidth: 1.5.w,
                                        offers: filteredCoupons,
                                        pagination:
                                            _marketOffersController.pagination.value)
                                    : _buildProductList(
                                        marketNameSize: 20.w,
                                        logoHeight: 40.h,
                                        offerFontSize: 24.w,
                                        descriptionFontSize: 18.w,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        offers: filteredCoupons,
                                        pagination:
                                            _marketOffersController.pagination.value))
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
            ],
          ),
        ));
  }

  Widget _buildHorizontalCategoryList() {
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
                  padding:
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
                              ? AppColors.primary.withOpacity(0.1)
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
    required List<MarketOffer> offers,
    required PaginationOffer pagination,
    double? logoHeight,
    double? offerFontSize,
    double? marketNameSize,
    double? borderWidth,
    double? descriptionFontSize,
    double? cardRatio,
    int? crossAxisCount,
    ScrollPhysics? physics,
    bool? shrinkWrap =false,
  }) {
    return Container(
      height: kIsWeb ? null : 560.h,
      child: GridView.builder(
        shrinkWrap: shrinkWrap??false,
        padding: const EdgeInsets.all(3),
        physics: physics,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount ?? 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: cardRatio ?? 0.8,
        ),
        itemCount: offers.length + 1,
        itemBuilder: (context, index) {
          /// TODO Make Pagination
          if (index == offers.length) {
            print(
                'pagenation.currentPage = ${pagination.currentPage}\npagenation.lastPage = ${pagination.lastPage} ');

            if (pagination.currentPage < pagination.lastPage) {
              // Load next page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _marketOffersController.fetchMarketOffers(
                    page: ++offersPage, isFromPaginationUi: true);
              });
              return GridCardShimmer();
            }
            return SizedBox.shrink();
          }
          final offer = offers[index];
          return OfferCardGrid(
            descriptionFontSize: descriptionFontSize,
            offerFontSize: offerFontSize,
            logoHeight: logoHeight,
            borderWidth: borderWidth,
            marketNameSize: marketNameSize,
            offer: offer,
            onTap: () async {
              final success =
                  await viewCountController.incrementOfferViews(offer.id!);
              debugPrint(
                  'Offer Views Increment for ${offer.couponCode}: $success');
              Get.to(() => OfferDetailsScreen(offer: offer));
              print('Offer Tapped: ${offer.descriptionAr ?? 'No description'}');
            },
          );
        },
      ),
    );
  }

  Widget _buildProductList(
      {required List<MarketOffer> offers,
      required PaginationOffer pagination,
      double? logoHeight,
      double? offerFontSize,
      double? marketNameSize,
      double? borderWidth,
      double? descriptionFontSize,
      ScrollPhysics? physics,
      bool? shrinkWrap = false}) {
    return Container(
      height: 540.h,
      child: ListView.builder(
        physics: physics,
        shrinkWrap: shrinkWrap!,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
        itemCount: offers.length + 1,
        itemBuilder: (context, index) {
          /// TODO Make Pagination
          if (index == offers.length) {
            print(
                'pagenation.currentPage = ${pagination.currentPage}\npagenation.lastPage = ${pagination.lastPage} ');

            if (pagination.currentPage < pagination.lastPage) {
              // Load next page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _marketOffersController.fetchMarketOffers(
                    page: ++offersPage, isFromPaginationUi: true);
              });
              return ListCardShimmer();
            }
            return SizedBox.shrink();
          }
          final offer = offers[index];
          return OfferCardList(
            logoHeight: logoHeight,
            marketNameSize: marketNameSize,
            offerFontSize: offerFontSize,
            borderWidth: borderWidth,
            offer: offer,
            onTap: () async {
              final success =
                  await viewCountController.incrementOfferViews(offer.id!);
              debugPrint(
                  'Offer Views Increment for ${offer.couponCode}: $success');
              Get.to(() => OfferDetailsScreen(offer: offer));
              print('Offer Tapped: ${offer.descriptionAr ?? 'No description'}');
            },
          );
        },
      ),
    );
  }
}

// class OffersScreen extends StatefulWidget {
//   const OffersScreen({super.key});
//
//   @override
//   State<OffersScreen> createState() => _OffersScreenState();
// }
//
// class _OffersScreenState extends State<OffersScreen> {
//   final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
//   String selectedCategoryId = '1'; // Default to 'all' categories
//   String selectedTab = 'products'; // Default to 'المنتجات'
//   bool isGridView = true; // Default to grid view
//   String sortOrder = 'new_to_old'; // Default sort order: new to old
//   final TextEditingController _searchController = TextEditingController();
//
//   final CategoryController categoryController = Get.find<CategoryController>();
//   final MarketOffersController _marketOffersController = Get.find<MarketOffersController>();
//
//   // Show sort options dialog
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDark = themeController.themeMode.value == ThemeMode.dark;
//
//     final screenWidth = MediaQuery.of(context).size.width;
//
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
//                               hintText: selectedTab == 'products' ? 'ابحث عن افضل العروض' : 'ابحث عن المتاجر',
//                               hintStyle: GoogleFonts.tajawal(color: Colors.grey, fontSize: 14),
//                               suffixIcon: _marketOffersController.isLoading.value
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
//                               prefixIcon: _marketOffersController.searchQuery.value.isNotEmpty
//                                   ? IconButton(
//                                 icon: const Icon(Icons.clear, color: Colors.grey),
//                                 onPressed: () {
//                                   _searchController.clear();
//                                   _marketOffersController.clearSearch();
//                                 },
//                               )
//                                   : null,
//                               border: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                             ),
//                             onChanged: (value) {
//                               _marketOffersController.searchMarketOffers(value);
//                               print('Search Typing: $value');
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
//           if (selectedTab == 'products') Obx(() => _buildHorizontalCategoryList()),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
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
//                           color: isGridView ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
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
//                           color: !isGridView ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
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
//             if (_marketOffersController.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (_marketOffersController.errorMessage.value.isNotEmpty) {
//               return Center(child: CustomTextSolveIssue('يوجد مشكلة حاليا'));
//             }
//             if (_marketOffersController.marketOffers.isEmpty) {
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
//             List<MarketOffer> filteredCoupons = selectedCategoryId == '1'
//                 ? _marketOffersController.marketOffers.toList()
//                 : _marketOffersController.marketOffers
//                 .where((coupon) => coupon.categoryId.toString() == selectedCategoryId)
//                 .toList();
//
//             // Sort coupons based on createdAt
//             filteredCoupons.sort((a, b) {
//               final dateA = a.createdAt ?? DateTime.now();
//               final dateB = b.createdAt ?? DateTime.now();
//               return sortOrder == 'new_to_old'
//                   ? dateB.compareTo(dateA)
//                   : dateA.compareTo(dateB);
//             });
//
//             return selectedTab == 'products'
//                 ? (isGridView
//                 ? _buildProductGrid(offers: filteredCoupons)
//                 : _buildProductList(offers: filteredCoupons))
//                 : const SizedBox();
//           }),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHorizontalCategoryList() {
//     return SizedBox(
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
//                     ? AppColors.primary.withOpacity(0.1)
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
// // Remove the _showSortDialog method entirely, as it’s no longer needed.
//
// // Update _buildFilterChip to use a DropdownButton
//   Widget _buildFilterChip(String label, IconData icon) {
//     return Container(
//       // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//       decoration: BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.primary.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Icon(icon, size: 18, color: AppColors.white),
//           const SizedBox(width: 8),
//           DropdownButton<String>(
//             value: sortOrder,
//             icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
//             underline: const SizedBox(), // Remove default underline
//             dropdownColor: AppColors.primary,
//             style: GoogleFonts.tajawal(
//               color: AppColors.white,
//               // fontWeight: FontWeight.w600,
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
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildProductGrid({required List<MarketOffer> offers}) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.all(3),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//         childAspectRatio: 0.8,
//       ),
//       itemCount: offers.length,
//       itemBuilder: (context, index) {
//         final offer = offers[index];
//         return OfferCardGrid(
//           offer: offer,
//           onTap: () {
//             Get.to(() => OfferDetailsScreen(offer: offer));
//             print('Offer Tapped: ${offer.descriptionAr ?? 'No description'}');
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildProductList({required List<MarketOffer> offers}) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       itemCount: offers.length,
//       itemBuilder: (context, index) {
//         final offer = offers[index];
//         return OfferCardList(
//           offer: offer,
//           onTap: () {
//             Get.to(() => OfferDetailsScreen(offer: offer));
//             print('Offer Tapped: ${offer.descriptionAr ?? 'No description'}');
//           },
//         );
//       },
//     );
//   }
// }
