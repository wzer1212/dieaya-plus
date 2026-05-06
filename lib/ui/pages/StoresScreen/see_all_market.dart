import 'dart:async';
import 'package:dieaya_user/controllers/MarketControllers/best_market_controller.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/main_app_header.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If using SVG icons
import 'package:flutter/services.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/CategoryController/category_controller.dart';
import '../../../controllers/CountsConroller/counts_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/best_market_model.dart';
import '../../../utils/constants/image_constants.dart';
import '../../widgets/category_list.dart';
import '../../widgets/custom_sheets.dart';
import '../../widgets/stores_card.dart';
import '../NotificationsScreen/notifications_screen.dart';
import '../ProfileScreen/my_favs_screen.dart';
import '../StoresScreen/store_details.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class AllMarketsScreen extends StatefulWidget {
  final GetxController
      controller; // BestMarketsController or MostViewedMarketsController
  final String title;
  final bool fromSeeAll;

  const AllMarketsScreen({
    super.key,
    required this.controller,
    required this.title,
    this.fromSeeAll = false,
  });

  @override
  State<AllMarketsScreen> createState() => _AllMarketsScreenState();
}

class _AllMarketsScreenState extends State<AllMarketsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CategoryController categoryController = Get.find<CategoryController>();
  final ViewCountController viewCountController =
      Get.put(ViewCountController());

  String selectedCategoryId = '';
  bool isGridView = true;
  String sortOrder = 'new_to_old';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await categoryController.fetchCategories();
      if (categoryController.categories.isNotEmpty) {
        setState(() {
          selectedCategoryId =
              categoryController.categories.first.id.toString();
        });
        _refreshMarkets();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isArabic = Get.locale?.languageCode == 'ar';
    ScrollController _scrollController =ScrollController();

    return AdaptiveLayOut(
        mobile: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                MainAppHeader(
                  controller: _searchController,
                  fromSeeAll: true,
                  onChanged: (value) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 300), () {
                      _refreshMarkets();
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
                  readOnly: false,
                ),
                const SizedBox(height: 16),
                _buildHorizontalCategoryList(isDark, isArabic),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: isArabic
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilterChip(
                        'sort'.tr, Icons.swap_vert, isDark, isArabic),
                    _buildViewToggle(isDark, isArabic),
                  ],
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Obx(() {
                  List<Market> markets = [];
                  bool isLoading = false;
                  String errorMessage = '';

                  if (widget.controller is BestMarketsController) {
                    final bestController =
                        widget.controller as BestMarketsController;
                    markets = bestController.markets;
                    isLoading = bestController.isLoading.value;
                    errorMessage = bestController.errorMessage.value;
                  } else if (widget.controller is MostViewedMarketsController) {
                    final mostViewedController =
                        widget.controller as MostViewedMarketsController;
                    markets = mostViewedController.markets;
                    isLoading = mostViewedController.isLoading.value;
                    errorMessage = mostViewedController.errorMessage.value;
                  }

                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (errorMessage.isNotEmpty) {
                    return Center(
                      child: CustomTextSolveIssue(
                        errorMessage
                            .tr, // Assume errorMessage is a translation key
                        style: GoogleFonts.getFont(
                          isArabic ? 'Tajawal' : 'Roboto',
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    );
                  }

                  final filteredMarkets = markets.toList()
                    ..sort((a, b) {
                      final dateA = _parseDate(a.createdAt) ?? DateTime.now();
                      final dateB = _parseDate(b.createdAt) ?? DateTime.now();
                      return sortOrder == 'new_to_old'
                          ? dateB.compareTo(dateA)
                          : dateA.compareTo(dateB);
                    });

                  return Column(
                    children: [
                      isGridView
                          ? _buildStoresGrid(
                              markets: filteredMarkets,
                              isDark: isDark,
                              isArabic: isArabic)
                          : _buildStoresList(
                              markets: filteredMarkets,
                              isDark: isDark,
                              isArabic: isArabic),
                      if (filteredMarkets.isNotEmpty)
                        _buildLoadMoreButton(isDark, isArabic),
                    ],
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        desktop: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Column(
            children: [
              GlobalWebHeader(scrollController: _scrollController),
              SizedBox(
                height: 70.h,
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 75.w),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildHorizontalCategoryList(isDark, isArabic),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: isArabic
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                _buildFilterChip(
                                    'sort'.tr, Icons.swap_vert, isDark, isArabic),
                                _buildViewToggle(isDark, isArabic),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 16),
                            Obx(() {
                              List<Market> markets = [];
                              bool isLoading = false;
                              String errorMessage = '';

                              if (widget.controller is BestMarketsController) {
                                final bestController =
                                    widget.controller as BestMarketsController;
                                markets = bestController.markets;
                                isLoading = bestController.isLoading.value;
                                errorMessage = bestController.errorMessage.value;
                              } else if (widget.controller
                                  is MostViewedMarketsController) {
                                final mostViewedController =
                                    widget.controller as MostViewedMarketsController;
                                markets = mostViewedController.markets;
                                isLoading = mostViewedController.isLoading.value;
                                errorMessage =
                                    mostViewedController.errorMessage.value;
                              }

                              if (isLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (errorMessage.isNotEmpty) {
                                return Center(
                                  child: CustomTextSolveIssue(
                                    errorMessage.tr,
                                    // Assume errorMessage is a translation key
                                    style: GoogleFonts.getFont(
                                      isArabic ? 'Tajawal' : 'Roboto',
                                      fontSize: 16,
                                      color: isDark ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                );
                              }

                              final filteredMarkets = markets.toList()
                                ..sort((a, b) {
                                  final dateA =
                                      _parseDate(a.createdAt) ?? DateTime.now();
                                  final dateB =
                                      _parseDate(b.createdAt) ?? DateTime.now();
                                  return sortOrder == 'new_to_old'
                                      ? dateB.compareTo(dateA)
                                      : dateA.compareTo(dateB);
                                });

                              return Column(
                                children: [
                                  isGridView
                                      ? _buildStoresGrid(
                                      crossAxisCount:3,
                                      logoHeight: 25.h,
                                      borderWidth: 1.5.w,
                                          cardRatio: 1.2,
                                          storeFontSize: 21.w,
                                          descriptionFontSize: 18.w,
                                          markets: filteredMarkets,
                                          isDark: isDark,
                                          isArabic: isArabic)
                                      : _buildStoresList(
                                          markets: filteredMarkets,
                                          isDark: isDark,
                                          isArabic: isArabic,
                                          logoHeight: 55.h,
                                          storeFontSize: 24.w,
                                          descriptionFontSize: 18.w,
                                          borderWidth: 1.5.w,
                                        ),
                                  if (filteredMarkets.isNotEmpty)
                                    _buildLoadMoreButton(isDark, isArabic),
                                ],
                              );
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



  Widget _buildHorizontalCategoryList(bool isDark, bool isArabic) {
    return Obx(() => categoryController.isLoading.value
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
                    'no_data_available'.tr,
                    style: GoogleFonts.getFont(
                      isArabic ? 'Tajawal' : 'Roboto',
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 120,
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
                          });
                          _refreshMarkets();
                          debugPrint('Category selected: ${category.nameEn}');
                        },
                        child: CircularCategoryItem(
                          label: isArabic
                              ? category.nameAr
                              : (category.nameEn ?? category.nameAr),
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
              ));
  }

  Widget _buildViewToggle(bool isDark, bool isArabic) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isArabic ? MainAxisAlignment.start : MainAxisAlignment.end,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                  !isGridView ? AppColors.primary : Colors.grey,
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
                  isGridView ? AppColors.primary : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label, IconData icon, bool isDark, bool isArabic) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                            style: GoogleFonts.getFont(
                              isArabic ? 'Tajawal' : 'Roboto',
                              color: AppColors.black,
                            ),
                          ),
                          value: 'new_to_old',
                          groupValue: sortOrder,
                          onChanged: (value) {
                            Navigator.pop(context, value); // close and select
                          },
                          activeColor: AppColors.primary,
                        ),
                        RadioListTile<String>(
                          title: CustomTextSolveIssue(
                            'old_to_new'.tr,
                            style: GoogleFonts.getFont(
                              isArabic ? 'Tajawal' : 'Roboto',
                              color: AppColors.black,
                            ),
                          ),
                          value: 'old_to_new',
                          groupValue: sortOrder,
                          onChanged: (value) {
                            Navigator.pop(context, value); // close and select
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
                      label,
                      style: GoogleFonts.getFont(
                        isArabic ? 'Tajawal' : 'Roboto',
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ],
                ),
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                ),
                elevation: 4,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoresGrid({
    required List<Market> markets,
    required bool isDark,
    required bool isArabic,
    double? cardRatio,
    double? storeFontSize,
    double? descriptionFontSize,
    double? borderWidth,
    double? logoHeight,
    int? crossAxisCount,
  }) {
    return markets.isEmpty
        ? Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 20.0),
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
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount??2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: cardRatio ?? 1,
            ),
            itemCount: markets.length,
            itemBuilder: (context, index) {
              final market = markets[index];
              return StoresCardGrid(
                logoHeight: logoHeight,
                borderWidth: borderWidth,
                descriptionFontSize: descriptionFontSize,
                storeFontSize: storeFontSize,
                market: market,
                onTap: () async {
                  final success = await viewCountController
                      .incrementMarketViews(market.id!);
                  debugPrint(
                      'Market Views Increment for ${market.id}: $success');
                  Get.to(() => StoreDetails(marketId: market.id));
                  debugPrint('Store Tapped: ${market.name}');
                },
                onFavoriteTap: () {
                  debugPrint(
                      'Favorite status changed for market: ${market.id}');
                },
              );
            },
          );
  }

  Widget _buildStoresList(
      {required List<Market> markets,
      required bool isDark,
      required bool isArabic,
        double? logoHeight,
        double? storeFontSize,
        double? descriptionFontSize,
        double? borderWidth}) {
    return markets.isEmpty
        ? Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 20.0),
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
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
            itemCount: markets.length,
            itemBuilder: (context, index) {
              final market = markets[index];
              return StoresCardList(
                borderWidth: borderWidth,
                storeFontSize: storeFontSize,
                descriptionFontSize: descriptionFontSize,
                logoHeight: logoHeight,
                market: market,
                onTap: () async {
                  final success = await viewCountController
                      .incrementMarketViews(market.id!);
                  debugPrint(
                      'Offer Views Increment for ${market.id}: $success');
                  Get.to(() => StoreDetails(marketId: market.id));
                  debugPrint('Store Tapped: ${market.name}');
                },
                onFavoriteTap: () {
                  debugPrint(
                      'Favorite status changed for market: ${market.id}');
                },
              );
            },
          );
  }

  Widget _buildLoadMoreButton(bool isDark, bool isArabic) {
    return Obx(() {
      bool canLoadMore = false;
      if (widget.controller is BestMarketsController) {
        final bestController = widget.controller as BestMarketsController;
        canLoadMore = bestController.pagination.value.currentPage <
            bestController.pagination.value.lastPage;
      } else if (widget.controller is MostViewedMarketsController) {
        final mostViewedController =
            widget.controller as MostViewedMarketsController;
        canLoadMore = mostViewedController.pagination.value.currentPage <
            mostViewedController.pagination.value.lastPage;
      }

      if (!canLoadMore) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 20.0),
        child: ElevatedButton(
          onPressed: () {
            if (widget.controller is BestMarketsController) {
              final bestController = widget.controller as BestMarketsController;
              bestController.fetchBestMarkets(
                page: bestController.pagination.value.currentPage + 1,
                categoryId: selectedCategoryId,
                keyword: _searchController.text,
              );
            } else if (widget.controller is MostViewedMarketsController) {
              final mostViewedController =
                  widget.controller as MostViewedMarketsController;
              mostViewedController.fetchMostViewedMarkets(
                page: mostViewedController.pagination.value.currentPage + 1,
                categoryId: selectedCategoryId,
                keyword: _searchController.text,
              );
            }
          },
          child: CustomTextSolveIssue(
            'load_more'.tr,
            style: GoogleFonts.getFont(
              isArabic ? 'Tajawal' : 'Roboto',
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }

  void _refreshMarkets() {
    if (widget.controller is BestMarketsController) {
      (widget.controller as BestMarketsController).fetchBestMarkets(
        categoryId: selectedCategoryId,
        keyword: _searchController.text,
      );
    } else if (widget.controller is MostViewedMarketsController) {
      (widget.controller as MostViewedMarketsController).fetchMostViewedMarkets(
        categoryId: selectedCategoryId,
        keyword: _searchController.text,
      );
    }
  }

  DateTime? _parseDate(dynamic createdAt) {
    if (createdAt == null) return null;
    try {
      if (createdAt is String) {
        return DateTime.parse(createdAt);
      } else if (createdAt is DateTime) {
        return createdAt;
      }
    } catch (e) {
      debugPrint('Error parsing createdAt: $e');
    }
    return null;
  }
}

// class AllMarketsScreen extends StatefulWidget {
//   final GetxController controller; // BestMarketsController or MostViewedMarketsController
//   final String title;
//
//   const AllMarketsScreen({
//     super.key,
//     required this.controller,
//     required this.title,
//   });
//
//   @override
//   State<AllMarketsScreen> createState() => _AllMarketsScreenState();
// }
//
// class _AllMarketsScreenState extends State<AllMarketsScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final CategoryController categoryController = Get.put(CategoryController());
//   String selectedCategoryId = ''; // Initialize empty, set after categories load
//   bool isGridView = true; // Default to grid view
//   String sortOrder = 'new_to_old'; // Default sort order: new to old
//   Timer? _debounce; // For debouncing search input
//
//   @override
//   void initState() {
//     super.initState();
//     // Delay fetch until after the build phase
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await categoryController.fetchCategories();
//       if (categoryController.categories.isNotEmpty) {
//         setState(() {
//           selectedCategoryId = categoryController.categories.first.id.toString();
//         });
//         _refreshMarkets();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ListView(
//         children: [
//           _buildHeader(screenWidth),
//           const SizedBox(height: 16),
//           _buildHorizontalCategoryList(),
//           const SizedBox(height: 16),
//           _buildViewToggle(),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 _buildFilterChip('الترتيب', Icons.swap_vert),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Obx(() {
//             List<Market> markets = [];
//             bool isLoading = false;
//             String errorMessage = '';
//
//             if (widget.controller is BestMarketsController) {
//               final bestController = widget.controller as BestMarketsController;
//               markets = bestController.markets;
//               isLoading = bestController.isLoading.value;
//               errorMessage = bestController.errorMessage.value;
//             } else if (widget.controller is MostViewedMarketsController) {
//               final mostViewedController = widget.controller as MostViewedMarketsController;
//               markets = mostViewedController.markets;
//               isLoading = mostViewedController.isLoading.value;
//               errorMessage = mostViewedController.errorMessage.value;
//             }
//
//             if (isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (errorMessage.isNotEmpty) {
//               return Center(child: CustomTextSolveIssue(errorMessage));
//             }
//
//             // Sort markets based on createdAt
//             final filteredMarkets = markets.toList()
//               ..sort((a, b) {
//                 final dateA = _parseDate(a.createdAt) ?? DateTime.now();
//                 final dateB = _parseDate(b.createdAt) ?? DateTime.now();
//                 return sortOrder == 'new_to_old'
//                     ? dateB.compareTo(dateA)
//                     : dateA.compareTo(dateB);
//               });
//
//             return Column(
//               children: [
//                 isGridView
//                     ? _buildStoresGrid(markets: filteredMarkets)
//                     : _buildStoresList(markets: filteredMarkets),
//                 if (filteredMarkets.isNotEmpty) _buildLoadMoreButton(),
//               ],
//             );
//           }),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(double screenWidth) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             AppColors.primary,
//             AppColors.primary,
//             Colors.white,
//           ],
//           stops: [0.0, 0.0, 5.0],
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 20, bottom: 10, right: 20, left: 20),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Image.asset(
//                   'assets/images/logodiaya.png',
//                   width: 30,
//                   height: 30,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(25),
//                     color: Colors.white,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Stack(
//                         children: [
//                           IconButton(
//                             icon: SvgPicture.asset(
//                               'assets/svg/notify.svg',
//                               width: 24,
//                               height: 24,
//                               colorFilter: const ColorFilter.mode(
//                                 Colors.black54,
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                             onPressed: () {
//                               debugPrint('Notifications Tapped');
//                             },
//                           ),
//                           Positioned(
//                             right: 11,
//                             top: 14,
//                             child: Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               constraints: const BoxConstraints(
//                                 minWidth: 8,
//                                 minHeight: 8,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       IconButton(
//                         icon: SvgPicture.asset(
//                           'assets/svg/Heart 2.svg',
//                           width: 24,
//                           height: 24,
//                           colorFilter: const ColorFilter.mode(
//                             Colors.black54,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                         onPressed: () {
//                           debugPrint('Favorites Tapped');
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: FutureBuilder(
//                       future: Future.delayed(Duration.zero),
//                       builder: (context, snapshot) {
//                         return Obx(() {
//                           bool isLoading = widget.controller is BestMarketsController
//                               ? (widget.controller as BestMarketsController).isLoading.value
//                               : (widget.controller as MostViewedMarketsController).isLoading.value;
//                           return TextField(
//                             controller: _searchController,
//                             textAlignVertical: TextAlignVertical.center,
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
//                               hintText: 'ابحث عن المتاجر',
//                               hintStyle: GoogleFonts.tajawal(color: Colors.grey, fontSize: 14),
//                               suffixIcon: isLoading
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
//                               prefixIcon: _searchController.text.isNotEmpty
//                                   ? IconButton(
//                                 icon: const Icon(Icons.clear, color: Colors.grey),
//                                 onPressed: () {
//                                   _searchController.clear();
//                                   _refreshMarkets();
//                                 },
//                               )
//                                   : null,
//                               border: InputBorder.none,
//                               enabledBorder: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                             ),
//                             onChanged: (value) {
//                               _debounce?.cancel();
//                               _debounce = Timer(const Duration(milliseconds: 300), () {
//                                 _refreshMarkets();
//                               });
//                             },
//                           );
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHorizontalCategoryList() {
//     return Obx(() => categoryController.isLoading.value
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
//                 });
//                 _refreshMarkets();
//                 debugPrint('Category selected: ${category.nameEn}');
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
//     ));
//   }
//
//   Widget _buildViewToggle() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           InkWell(
//             onTap: () {
//               setState(() => isGridView = true);
//               debugPrint('Grid View Tapped');
//             },
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isGridView ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: SvgPicture.asset(
//                 'assets/svg/gridview.svg',
//                 width: 20,
//                 height: 20,
//                 colorFilter: ColorFilter.mode(
//                   isGridView ? AppColors.primary : Colors.grey,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           InkWell(
//             onTap: () {
//               setState(() => isGridView = false);
//               debugPrint('List View Tapped');
//             },
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: !isGridView ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: SvgPicture.asset(
//                 'assets/svg/listview.svg',
//                 width: 20,
//                 height: 20,
//                 colorFilter: ColorFilter.mode(
//                   !isGridView ? AppColors.primary : Colors.grey,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
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
//             underline: const SizedBox(),
//             dropdownColor: AppColors.primary,
//             style: GoogleFonts.tajawal(color: AppColors.white),
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
//                 debugPrint('Sort order changed to: $sortOrder');
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStoresGrid({required List<Market> markets}) {
//     return markets.isEmpty
//         ? const Padding(
//       padding: EdgeInsets.symmetric(vertical: 20.0),
//       child: Center(
//         child: CustomTextSolveIssue(
//           'لا يوجد حاليا',
//           style: TextStyle(fontSize: 16, color: Colors.black54),
//         ),
//       ),
//     )
//         : GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12.0,
//         mainAxisSpacing: 12.0,
//         childAspectRatio: 1,
//       ),
//       itemCount: markets.length,
//       itemBuilder: (context, index) {
//         final market = markets[index];
//         return StoresCardGrid(
//           market: market,
//           onTap: () {
//             Get.to(() => StoreDetails(marketId: market.id));
//             debugPrint('Store Tapped: ${market.name}');
//           },
//           onFavoriteTap: () {
//             debugPrint('Favorite status changed for market: ${market.id}');
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildStoresList({required List<Market> markets}) {
//     return markets.isEmpty
//         ? const Padding(
//       padding: EdgeInsets.symmetric(vertical: 20.0),
//       child: Center(
//         child: CustomTextSolveIssue(
//           'لا يوجد حاليا',
//           style: TextStyle(fontSize: 16, color: Colors.black54),
//         ),
//       ),
//     )
//         : ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       itemCount: markets.length,
//       itemBuilder: (context, index) {
//         final market = markets[index];
//         return StoresCardList(
//           market: market,
//           onTap: () {
//             Get.to(() => StoreDetails(marketId: market.id));
//             debugPrint('Store Tapped: ${market.name}');
//           },
//           onFavoriteTap: () {
//             debugPrint('Favorite status changed for market: ${market.id}');
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildLoadMoreButton() {
//     return Obx(() {
//       bool canLoadMore = false;
//       if (widget.controller is BestMarketsController) {
//         final bestController = widget.controller as BestMarketsController;
//         canLoadMore = bestController.pagination.value.currentPage <
//             bestController.pagination.value.lastPage;
//       } else if (widget.controller is MostViewedMarketsController) {
//         final mostViewedController = widget.controller as MostViewedMarketsController;
//         canLoadMore = mostViewedController.pagination.value.currentPage <
//             mostViewedController.pagination.value.lastPage;
//       }
//
//       if (!canLoadMore) return const SizedBox.shrink();
//
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20.0),
//         child: ElevatedButton(
//           onPressed: () {
//             if (widget.controller is BestMarketsController) {
//               final bestController = widget.controller as BestMarketsController;
//               bestController.fetchBestMarkets(
//                 page: bestController.pagination.value.currentPage + 1,
//                 categoryId: selectedCategoryId,
//                 keyword: _searchController.text,
//               );
//             } else if (widget.controller is MostViewedMarketsController) {
//               final mostViewedController = widget.controller as MostViewedMarketsController;
//               mostViewedController.fetchMostViewedMarkets(
//                 page: mostViewedController.pagination.value.currentPage + 1,
//                 categoryId: selectedCategoryId,
//                 keyword: _searchController.text,
//               );
//             }
//           },
//           child: CustomTextSolveIssue(
//             'تحميل المزيد',
//             style: GoogleFonts.tajawal(fontSize: 16),
//           ),
//         ),
//       );
//     });
//   }
//
//   void _refreshMarkets() {
//     if (widget.controller is BestMarketsController) {
//       (widget.controller as BestMarketsController).fetchBestMarkets(
//         categoryId: selectedCategoryId,
//         keyword: _searchController.text,
//       );
//     } else if (widget.controller is MostViewedMarketsController) {
//       (widget.controller as MostViewedMarketsController).fetchMostViewedMarkets(
//         categoryId: selectedCategoryId,
//         keyword: _searchController.text,
//       );
//     }
//   }
//
//   DateTime? _parseDate(dynamic createdAt) {
//     if (createdAt == null) return null;
//     try {
//       if (createdAt is String) {
//         return DateTime.parse(createdAt);
//       } else if (createdAt is DateTime) {
//         return createdAt;
//       }
//     } catch (e) {
//       debugPrint('Error parsing createdAt: $e');
//     }
//     return null;
//   }
// }
