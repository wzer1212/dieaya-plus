import 'package:dieaya_user/UI/pages/HomeScreen/home_screen.dart';
import 'package:dieaya_user/UI/pages/NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_user/UI/widgets/stores_card.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_list_product_card.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_product_card_gird_view.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/main_app_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/grid_cart_shimmer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/list_cart_shimmer.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../UI/pages/ProductsScreen/product_details.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/CategoryController/category_controller.dart';
import '../../../controllers/CountsConroller/counts_controller.dart';
import '../../../controllers/FavController/fav_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/best_market_model.dart';
import '../../../models/market_product_model.dart';
import '../../../utils/constants/image_constants.dart';
import '../../widgets/buttons.dart';
import '../../widgets/category_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/custom_sheets.dart';
import '../ProfileScreen/my_favs_screen.dart';
import '../StoresScreen/store_details.dart';

class ProductsScreen extends StatefulWidget {
  final String categoryId;
  final bool fromSeeAll;


  const ProductsScreen({
    super.key,
    required this.categoryId,
    this.fromSeeAll = false,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late String selectedCategoryId;
  String selectedTab = 'products';
  bool isGridView = true;
  String sortOrder = 'new_to_old';
  final  CategoryDetailsController _controller  = CategoryDetailsController() ;

  final CategoryController categoryController = Get.put(CategoryController());
  final TextEditingController _searchController = TextEditingController();
  final ThemeController themeController = Get.put(ThemeController());
  final ViewCountController viewCountController =
      Get.put(ViewCountController());
  int productPage = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.categoryId;
    _controller.selectedCategoryId = selectedCategoryId;

    _controller.fetchCategoryDetails(
      categoryId: int.parse(
        selectedCategoryId,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
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
                  _controller.searchCategoryDetails(value);
                  debugPrint('Search Typing: $value');
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
                    Obx(() => categoryController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : categoryController.errorMessage.value.isNotEmpty
                            ? Center(
                                child: CustomTextSolveIssue('error_message'.tr))
                            : _buildHorizontalCategoryList()),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTabsAndViewToggle(),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildFilterChip('sort'.tr, Icons.swap_vert),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (_controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (_controller.errorMessage.isNotEmpty) {
                        return Center(
                            child: CustomTextSolveIssue('error_message'.tr));
                      }

                      List<Product> filteredProducts = selectedCategoryId == '1'
                          ? _controller.products.toList()
                          : _controller.products
                              .where((product) =>
                                  product.categoryId.toString() ==
                                  selectedCategoryId)
                              .toList();

                      List<Market> filteredMarkets = selectedCategoryId == '1'
                          ? _controller.markets.toList()
                          : _controller.markets
                              .where((market) => market.categories.any(
                                  (category) =>
                                      category.id.toString() ==
                                      selectedCategoryId))
                              .toList();

                      filteredProducts.sort((a, b) {
                        final dateA = _parseDate(a.createdAt) ?? DateTime.now();
                        final dateB = _parseDate(b.createdAt) ?? DateTime.now();
                        return sortOrder == 'new_to_old'
                            ? dateB.compareTo(dateA)
                            : dateA.compareTo(dateB);
                      });

                      filteredMarkets.sort((a, b) {
                        final dateA = _parseDate(a.createdAt) ?? DateTime.now();
                        final dateB = _parseDate(b.createdAt) ?? DateTime.now();
                        return sortOrder == 'new_to_old'
                            ? dateB.compareTo(dateA)
                            : dateA.compareTo(dateB);
                      });

                      return selectedTab == 'products'
                          ? (isGridView
                              ? _buildProductGrid(
                                  imageHeight: 225.h,
                                  products: filteredProducts,
                                  pagination:
                                      _controller.productsPagination.value)
                              : _buildProductList(
                                  products: filteredProducts,
                                  pagination:
                                      _controller.productsPagination.value))
                          : (isGridView
                              ? _buildStoresGrid(markets: filteredMarkets)
                              : _buildStoresList(markets: filteredMarkets));
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
              GlobalWebHeader(scrollController: _scrollController),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 75.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70.h,
                          ),
                          Obx(() => categoryController.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : categoryController.errorMessage.value.isNotEmpty
                                  ? Center(
                                      child: CustomTextSolveIssue(
                                          'error_message'.tr))
                                  : _buildHorizontalCategoryList()),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildTabsAndViewToggle(),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildFilterChip('sort'.tr, Icons.swap_vert),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(() {
                            if (_controller.isLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (_controller.errorMessage.isNotEmpty) {
                              return Center(
                                  child:
                                      CustomTextSolveIssue('error_message'.tr));
                            }

                            List<Product> filteredProducts =
                                selectedCategoryId == '1'
                                    ? _controller.products.toList()
                                    : _controller.products
                                        .where((product) =>
                                            product.categoryId.toString() ==
                                            selectedCategoryId)
                                        .toList();

                            List<Market> filteredMarkets = selectedCategoryId ==
                                    '1'
                                ? _controller.markets.toList()
                                : _controller.markets
                                    .where((market) => market.categories.any(
                                        (category) =>
                                            category.id.toString() ==
                                            selectedCategoryId))
                                    .toList();

                            filteredProducts.sort((a, b) {
                              final dateA =
                                  _parseDate(a.createdAt) ?? DateTime.now();
                              final dateB =
                                  _parseDate(b.createdAt) ?? DateTime.now();
                              return sortOrder == 'new_to_old'
                                  ? dateB.compareTo(dateA)
                                  : dateA.compareTo(dateB);
                            });

                            filteredMarkets.sort((a, b) {
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
                                        imageHeight: 160.h,
                                        crossAxisCount: 4,
                                        cardRatio: 0.6,
                                        priceCanceledFontSize: 14.w,
                                        storeFontSize: 14.w,
                                        priceFontSize: 16.w,
                                        descriptionFontSize: 10.w,
                                        products: filteredProducts,
                                        pagination: _controller
                                            .productsPagination.value)
                                    : _buildProductList(
                                        priceCanceledFontSize: 14.w,
                                        storeFontSize: 14.w,
                                        priceFontSize: 24.w,
                                        descriptionFontSize: 12.w,
                                        products: filteredProducts,
                                        pagination: _controller
                                            .productsPagination.value))
                                : (isGridView
                                    ? _buildStoresGrid(
                                        markets: filteredMarkets,
                                        logoHeight: 40.h,
                                        storeFontSize: 20.w,
                                        descriptionFontSize: 14.w,
                                        borderWidth: 1.5.w,
                                      )
                                    : _buildStoresList(
                                        markets: filteredMarkets,
                                        logoHeight: 55.h,
                                        storeFontSize: 24.w,
                                        descriptionFontSize: 18.w,
                                        borderWidth: 1.5.w,
                                      ));
                          }),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    FooterWidget()
                  ],
                ),
              ),
            ],
          ),
        ));
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

  Widget _buildHorizontalCategoryList() {
    return Obx(() => categoryController.isLoading.value
        ? const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          )
        : categoryController.errorMessage.value.isNotEmpty ||
                categoryController.categories.isEmpty
            ? SizedBox(
                height: 100,
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
                            _controller.selectedCategoryId = selectedCategoryId;
                            _controller.products.value.clear();

                            _controller.fetchCategoryDetails(
                                categoryId: int.parse(selectedCategoryId));
                            debugPrint('Category selected: ${category.nameEn}');
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
              ));
  }

  Widget _buildTabsAndViewToggle() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildTabButton('stores', 'stores'.tr),
              // const SizedBox(width: 10),
              _buildTabButton('products', 'products'.tr),
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
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabId, String label) {
    final bool isSelected = selectedTab == tabId;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedTab = tabId;
        });
      },
      child: CustomTextSolveIssue(
        label,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.tajawal(
          color: isSelected ? AppColors.primary : AppColors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : AppColors.primary,
        backgroundColor: isSelected ? Colors.transparent : Colors.transparent,
        side:
            BorderSide(color: isSelected ? AppColors.primary : AppColors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildProductGrid({
    required List<Product> products,
    required Pagination pagination,
    double? cardRatio,
    double? priceFontSize,
    double? storeFontSize,
    double? descriptionFontSize,
    double? priceCanceledFontSize,
    double? imageHeight,
    int? crossAxisCount,
  }) {
    return products.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CustomTextSolveIssue(
                'no_data'.tr,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          )
        : Container(
            height: 500.h,
            child: GridView.builder(
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount ?? 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: cardRatio ?? 0.55,
              ),
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                //  Pagination
                if (index == products.length) {
                  if (pagination.currentPage < pagination.lastPage) {
                    // Load next page
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _controller.fetchCategoryDetails(
                          categoryId: int.parse(
                            selectedCategoryId,
                          ),
                          page: ++productPage,
                          isFromPaginationUi: true);
                    });
                    return GridCardShimmer();
                  }
                  return SizedBox.shrink();
                }

                final product = products[index];
                return GlobalProductCardGrid(
                  imageHeight: imageHeight,
                  priceCanceledFontSize: priceCanceledFontSize,
                  descriptionFontSize: descriptionFontSize,
                  priceFontSize: priceFontSize,
                  storeFontSize: storeFontSize,
                  product: product,
                  onTap: () async {
                    final success = await viewCountController
                        .incrementProductViews(product.id!);
                    Get.to(() => ProductDetailScreen(
                          product: product,
                          logo: product.market.logo,
                          title: product.market.nameAr,
                          marketId: product.market.id,
                        ));
                  },
                );
              },
            ),
          );
  }

  Widget _buildProductList({
    required List<Product> products,
    required Pagination pagination,
    double? priceFontSize,
    double? storeFontSize,
    double? descriptionFontSize,
    double? priceCanceledFontSize,
  }) {
    return products.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CustomTextSolveIssue(
                'no_data'.tr,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          )
        : Container(
            height: 500.h,
            child: ListView.builder(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index == products.length) {
                  if (pagination.currentPage < pagination.lastPage) {
                    print(
                        'pagination.currentPage = ${pagination.currentPage}\npagination.lastPage = ${pagination.lastPage} ');
                    // Load next page
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _controller.fetchCategoryDetails(
                          categoryId: int.parse(
                            selectedCategoryId,
                          ),
                          page: ++productPage,
                          isFromPaginationUi: true);
                    });
                    return ListCardShimmer();
                  }
                  return SizedBox.shrink();
                }

                final product = products[index];
                return GlobalListProductCard(
                  priceCanceledFontSize: priceCanceledFontSize,
                  descriptionFontSize: descriptionFontSize,
                  priceFontSize: priceFontSize,
                  productFontSize: storeFontSize,
                  // storeFontSize: storeFontSize,
                  product: product,
                  onTap: () async {
                    final success = await viewCountController
                        .incrementProductViews(product.id!);
                    debugPrint(
                        'Product Views Increment for ${product.nameAr}: $success');
                    Get.to(() => ProductDetailScreen(
                          product: product,
                          logo: product.market.logo,
                          title: product.market.nameAr,
                          marketId: product.market.id,
                        ));
                    debugPrint('Product Tapped: ${product.nameAr}');
                  },
                  onFavoriteTap: () {
                    debugPrint(
                        'Favorite status changed for product: ${product.id}');
                  },
                );
              },
            ),
          );
  }

  Widget _buildStoresGrid({
    required List<Market> markets,
    double? logoHeight,
    double? storeFontSize,
    double? descriptionFontSize,
    double? borderWidth,
  }) {
    return markets.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CustomTextSolveIssue(
                'no_data'.tr,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: kIsWeb ? 3 : 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: kIsWeb ? 1.2 : 1,
            ),
            itemCount: markets.length,
            itemBuilder: (context, index) {
              final store = markets[index];
              return StoresCardGrid(
                descriptionFontSize: descriptionFontSize,
                storeFontSize: storeFontSize,
                logoHeight: logoHeight,
                borderWidth: borderWidth,
                market: store,
                onTap: () async {
                  final success =
                      await viewCountController.incrementMarketViews(store.id!);
                  debugPrint(
                      'Market Views Increment for ${store.name}: $success');
                  Get.to(() => StoreDetails(marketId: store.id));
                  debugPrint('Store Tapped: ${store.name}');
                },
                onFavoriteTap: () {
                  debugPrint('Favorite status changed for market: ${store.id}');
                },
              );
            },
          );
  }

  Widget _buildStoresList({
    required List<Market> markets,
    double? logoHeight,
    double? storeFontSize,
    double? descriptionFontSize,
    double? borderWidth,
  }) {
    return markets.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CustomTextSolveIssue(
                'no_data'.tr,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
            itemCount: markets.length,
            itemBuilder: (context, index) {
              final store = markets[index];
              return StoresCardList(
                descriptionFontSize: descriptionFontSize,
                storeFontSize: storeFontSize,
                logoHeight: logoHeight,
                borderWidth: borderWidth,
                market: store,
                onTap: () async {
                  final success =
                      await viewCountController.incrementMarketViews(store.id!);
                  debugPrint(
                      'Market Views Increment for ${store.name}: $success');
                  Get.to(() => StoreDetails(marketId: store.id));
                  debugPrint('Store Tapped: ${store.name}');
                },
                onFavoriteTap: () {
                  debugPrint('Favorite status changed for market: ${store.id}');
                },
              );
            },
          );
  }
}

//
// class ProductDetailScreen extends StatefulWidget {
//   final Product product;
//
//   const ProductDetailScreen({super.key, required this.product});
//
//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }
//
// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   int _currentImageIndex = 0;
//   late PageController _pageController;
//
//   final ScrollController _scrollController  = ScrollController();
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     final productImages = widget.product.images.isNotEmpty
//         ? widget.product.images.map((img) => img.image).toList()
//         : ['assets/images/jaket.png'];
//
//     final isArabic = Get.locale?.languageCode == 'ar';
//     final ThemeController themeController =
//         Get.put(ThemeController()); // Access ThemeController
//     bool isDark = themeController.themeMode.value == ThemeMode.dark;
//     return AdaptiveLayOut(
//         mobile: Scaffold(
//           // appBar: AppBar(
//           //   backgroundColor: AppColors.primary,
//           //   shadowColor: AppColors.primary,
//           //   scrolledUnderElevation: 0,
//           //   toolbarHeight:1,
//           //   elevation: 0,
//           // ),
//           extendBodyBehindAppBar: true,
//           body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: isDark
//                           ? [
//                               AppColors.primary,
//                               AppColors.primary,
//                               Colors.black,
//                             ]
//                           : [
//                               AppColors.primary,
//                               AppColors.primary,
//                               Colors.white,
//                             ],
//                       stops: [0.0, 0.0, 5.0],
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsetsDirectional.only(
//                         top: 60, start: 8, end: 8, bottom: 30),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             child: SvgPicture.asset(
//                               'assets/svg/backbutton.svg',
//                               width: 40,
//                               height: 40,
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             var appLink = widget.product.shareLink.isNotEmpty?widget.product.shareLink:
//                             'https://play.google.com/store/apps/details?id=com.dieayaplus.user';
//                             Share.share(
//                               '$appLink',
//                               sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
//                             );
//                           }, // U
//                           child: Container(
//                             width: 30,
//                             height: 30,
//                             child: SvgPicture.asset(
//                               'assets/svg/share.svg',
//                               width: 36,
//                               height: 36,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: isDark ? Colors.black : Colors.white,
//                     borderRadius: const BorderRadius.vertical(
//                       bottom: Radius.circular(50.0),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.4),
//                         spreadRadius: 0,
//                         blurRadius: 5,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: screenHeight * 0.3,
//                         child: PageView.builder(
//                           controller: _pageController,
//                           itemCount: productImages.length,
//                           onPageChanged: (index) {
//                             setState(() {
//                               _currentImageIndex = index;
//                             });
//                           },
//                           itemBuilder: (context, index) {
//                             return Container(
//                               padding: const EdgeInsetsDirectional.symmetric(
//                                   horizontal: 40.0),
//                               child: Image.network(
//                                 productImages[index],
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Icon(Icons.error,
//                                         color: Colors.black),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Padding(
//                         padding: const EdgeInsetsDirectional.all(25.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     Get.to(() => StoreDetails(
//                                         marketId: widget.product.market.id));
//                                   },
//                                   child: Container(
//                                     width: 50,
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(25),
//                                       child: Image.network(
//                                         widget.product.market.logo,
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) =>
//                                                 const Center(
//                                           child: Icon(
//                                             Icons.broken_image,
//                                             color: Colors.grey,
//                                             size: 40,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 CustomTextSolveIssue(
//                                   isArabic
//                                       ? widget.product.market.nameAr
//                                       : widget.product.market.nameAr,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     // color: Color(0xff666565),
//                                   ),
//                                   textAlign: TextAlign.start,
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsetsDirectional.only(
//                                   top: 25, start: 10),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: List.generate(productImages.length,
//                                     (index) {
//                                   return Container(
//                                     width: 8.0,
//                                     height: 8.0,
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 4.0),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: _currentImageIndex == index
//                                           ? AppColors.primary
//                                           : Colors.grey.withOpacity(0.5),
//                                     ),
//                                   );
//                                 }),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsetsDirectional.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         children: [
//                           CustomTextSolveIssue(
//                             isArabic
//                                 ? widget.product.nameAr
//                                 : widget.product.nameEn,
//                             maxLines: 4,
//                             textAlign: TextAlign.start,
//                             style: const TextStyle(
//                               fontSize: 22,
//                               // color: AppColors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextSolveIssue(
//
//                         isArabic
//                             ? (widget.product.descriptionAr ??
//                             'no_description'.tr)
//                             : (widget.product.descriptionEn ??
//                             'no_description'.tr),
//                         textAlign: TextAlign.start,
//                         maxLines: 20,
//                         style: TextStyle(
//
//                           overflow: TextOverflow.fade,
//                           fontSize: 14,
//                           color: isDark
//                               ? Colors.white
//                               : AppColors.grey,
//                           height: 1.5,
//                         ),
//                       ),
//
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (widget.product.priceOffer.isNotEmpty &&
//                                   widget.product.priceOffer !=
//                                       widget.product.price)
//                                 CustomTextSolveIssue(
//                                   widget.product.price,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     color: AppColors.grey,
//                                     decoration: TextDecoration.lineThrough,
//                                   ),
//                                   textAlign: TextAlign.start,
//                                 ),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   SizedBox(
//                                     width: 350.w,
//                                     child: CustomTextSolveIssue(
//                                       widget.product.priceOffer.isNotEmpty &&
//                                           widget.product.priceOffer !=
//                                               widget.product.price
//                                           ? widget.product.priceOffer
//                                           : widget.product.price,
//                                       style: const TextStyle(
//                                         fontSize: 36,
//                                         color: AppColors.primary,
//                                         fontWeight: FontWeight.bold,
//                                         height: 1.1,
//                                       ),
//                                       textAlign: TextAlign.start,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   Image.asset('assets/images/saCurancy.png'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 20),
//                       if (widget.product.installmentWays.isNotEmpty)
//                         CustomTextSolveIssue(
//                           'installmentWays'.tr,
//                           style: GoogleFonts.tajawal(
//                             fontSize: 16,
//                             // fontWeight: FontWeight.bold,
//                             // color: isDark ? Colors.white : const Color(0xff5D5C5C),
//                           ),
//                         ),
//                       const SizedBox(height: 10),
//                       SizedBox(
//                         height: 80,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: widget.product.installmentWays.length,
//                           itemBuilder: (context, index) {
//                             final way = widget.product.installmentWays[index];
//                             return Container(
//                               // width: 115,
//                               // height: 80,
//                               decoration: BoxDecoration(
//                                   // color: Color(0xffF6F6F6),
//                                   // borderRadius: BorderRadius.circular(40),
//                                   // border: Border.all(
//                                   //   color: Colors.grey,
//                                   //   width: 0.5,
//                                   // ),
//                                   // image: DecorationImage(
//                                   //   image: NetworkImage(way.image),
//                                   //   fit: BoxFit.cover
//                                   //   ,
//                                   //   scale: 5,
//                                   //   onError: (exception, stackTrace) => const Icon(Icons.error),
//                                   // ),
//                                   ),
//                               child: Image.network(way.image),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: Padding(
//             padding: const EdgeInsetsDirectional.all(15.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//               child: CustomButton(
//                 onPressed: () async {
//                   print('Attempting to open link: ${widget.product.link}');
//                   // Normalize URL if scheme is missing
//                   String normalizedUrl = widget.product.link;
//                   if (!widget.product.link.startsWith(RegExp(r'https?://'))) {
//                     normalizedUrl = 'https://$widget.product.link';
//                   }
//                   final uri = Uri.tryParse(normalizedUrl);
//                   if (uri != null) {
//                     try {
//                       final canLaunch = await canLaunchUrl(uri);
//                       print('Can launch URL: $canLaunch');
//                       if (canLaunch) {
//                         await launchUrl(
//                           uri,
//                           mode: LaunchMode.externalApplication,
//                         );
//                         print('Successfully opened: $normalizedUrl');
//                         // _viewCountController.incrementMarketBannerViews(banner.id);
//                       } else {
//                         print('Cannot launch URL: $normalizedUrl');
//                         Get.snackbar(
//                           'خطأ',
//                           'لا يمكن فتح الرابط: الرابط غير مدعوم',
//                           snackPosition: SnackPosition.BOTTOM,
//                           duration: const Duration(seconds: 3),
//                         );
//                       }
//                     } catch (e) {
//                       print('Error launching URL: $e');
//                       Get.snackbar(
//                         'خطأ',
//                         'حدث خطأ أثناء فتح الرابط: $e',
//                         snackPosition: SnackPosition.BOTTOM,
//                         duration: const Duration(seconds: 3),
//                       );
//                     }
//                   } else {
//                     print('Invalid URL: $normalizedUrl');
//                     Get.snackbar(
//                       'خطأ',
//                       'الرابط غير صالح: $normalizedUrl',
//                       snackPosition: SnackPosition.BOTTOM,
//                       duration: const Duration(seconds: 3),
//                     );
//                   }
//                 },
//                 text: 'shop_now'.tr,
//                 textFontWeight: FontWeight.bold,
//                 textSize: 22,
//                 iconPath: 'assets/svg/mynaui_click-solid.svg',
//                 iconColor: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         desktop: Scaffold(
//           extendBodyBehindAppBar: true,
//           body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: Column(
//               children: [
//                 GlobalWebHeader(scrollController: _scrollController),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 55.w),
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: isDark ? Colors.black : Colors.white,
//                           borderRadius: const BorderRadius.vertical(
//                             bottom: Radius.circular(50.0),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.blue.withOpacity(0.4),
//                               spreadRadius: 0,
//                               blurRadius: 5,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: screenHeight * 0.3,
//                               child: PageView.builder(
//                                 controller: _pageController,
//                                 itemCount: productImages.length,
//                                 onPageChanged: (index) {
//                                   setState(() {
//                                     _currentImageIndex = index;
//                                   });
//                                 },
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     padding:
//                                         const EdgeInsetsDirectional.symmetric(
//                                             horizontal: 40.0),
//                                     child: Image.network(
//                                       productImages[index],
//                                       fit: BoxFit.contain,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               const Icon(Icons.error,
//                                                   color: Colors.black),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Padding(
//                               padding: const EdgeInsetsDirectional.all(25.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           Get.to(() => StoreDetails(
//                                               marketId:
//                                                   widget.product.market.id));
//                                         },
//                                         child: Container(
//                                           width: 50,
//                                           height: 50,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(25),
//                                             child: Image.network(
//                                               widget.product.market.logo,
//                                               fit: BoxFit.cover,
//                                               errorBuilder: (context, error,
//                                                       stackTrace) =>
//                                                   const Center(
//                                                 child: Icon(
//                                                   Icons.broken_image,
//                                                   color: Colors.grey,
//                                                   size: 40,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       CustomTextSolveIssue(
//                                         isArabic
//                                             ? widget.product.market.nameAr
//                                             : widget.product.market.nameAr,
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           // color: Color(0xff666565),
//                                         ),
//                                         textAlign: TextAlign.start,
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsetsDirectional.only(
//                                         top: 25, start: 10),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: List.generate(
//                                           productImages.length, (index) {
//                                         return Container(
//                                           width: 8.0,
//                                           height: 8.0,
//                                           margin: const EdgeInsets.symmetric(
//                                               horizontal: 4.0),
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: _currentImageIndex == index
//                                                 ? AppColors.primary
//                                                 : Colors.grey.withOpacity(0.5),
//                                           ),
//                                         );
//                                       }),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsetsDirectional.all(20.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Flexible(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       CustomTextSolveIssue(
//                                         isArabic
//                                             ? widget.product.nameAr
//                                             : widget.product.nameEn,
//                                         textAlign: TextAlign.start,
//                                         style: const TextStyle(
//                                           fontSize: 22,
//                                           // color: AppColors.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 15),
//                                       Container(
//                                         width: 250,
//                                         child: CustomTextSolveIssue(
//                                           isArabic
//                                               ? (widget.product.descriptionAr ??
//                                                   'no_description'.tr)
//                                               : (widget.product.descriptionEn ??
//                                                   'no_description'.tr),
//                                           textAlign: TextAlign.start,
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             color: AppColors.grey,
//                                             height: 1.5,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     if (widget.product.priceOffer.isNotEmpty &&
//                                         widget.product.priceOffer !=
//                                             widget.product.price)
//                                       CustomTextSolveIssue(
//                                         widget.product.price,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           color: AppColors.grey,
//                                           decoration:
//                                               TextDecoration.lineThrough,
//                                         ),
//                                         textAlign: TextAlign.start,
//                                       ),
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         CustomTextSolveIssue(
//                                           widget.product.priceOffer
//                                                       .isNotEmpty &&
//                                                   widget.product.priceOffer !=
//                                                       widget.product.price
//                                               ? widget.product.priceOffer
//                                               : widget.product.price,
//                                           style: const TextStyle(
//                                             fontSize: 36,
//                                             color: AppColors.primary,
//                                             fontWeight: FontWeight.bold,
//                                             height: 1.1,
//                                           ),
//                                           textAlign: TextAlign.start,
//                                         ),
//                                         Image.asset(
//                                             'assets/images/saCurancy.png'),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             if (widget.product.installmentWays.isNotEmpty)
//                               CustomTextSolveIssue(
//                                 'installmentWays'.tr,
//                                 style: GoogleFonts.tajawal(
//                                   fontSize: 16,
//                                   // fontWeight: FontWeight.bold,
//                                   // color: isDark ? Colors.white : const Color(0xff5D5C5C),
//                                 ),
//                               ),
//                             const SizedBox(height: 10),
//                             SizedBox(
//                               height: 80,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount:
//                                     widget.product.installmentWays.length,
//                                 itemBuilder: (context, index) {
//                                   final way =
//                                       widget.product.installmentWays[index];
//                                   return Container(
//                                     // width: 115,
//                                     // height: 80,
//                                     decoration: BoxDecoration(
//                                         // color: Color(0xffF6F6F6),
//                                         // borderRadius: BorderRadius.circular(40),
//                                         // border: Border.all(
//                                         //   color: Colors.grey,
//                                         //   width: 0.5,
//                                         // ),
//                                         // image: DecorationImage(
//                                         //   image: NetworkImage(way.image),
//                                         //   fit: BoxFit.cover
//                                         //   ,
//                                         //   scale: 5,
//                                         //   onError: (exception, stackTrace) => const Icon(Icons.error),
//                                         // ),
//                                         ),
//                                     child: Image.network(way.image),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                           padding: const EdgeInsetsDirectional.all(15.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25.0),
//                             ),
//                             child: CustomButton(
//                               width: 250.w,
//                               onPressed: () async {
//                                 print(
//                                     'Attempting to open link: ${widget.product.link}');
//                                 // Normalize URL if scheme is missing
//                                 String normalizedUrl = widget.product.link;
//                                 if (!widget.product.link
//                                     .startsWith(RegExp(r'https?://'))) {
//                                   normalizedUrl =
//                                       'https://$widget.product.link';
//                                 }
//                                 final uri = Uri.tryParse(normalizedUrl);
//                                 if (uri != null) {
//                                   try {
//                                     final canLaunch = await canLaunchUrl(uri);
//                                     print('Can launch URL: $canLaunch');
//                                     if (canLaunch) {
//                                       await launchUrl(
//                                         uri,
//                                         mode: LaunchMode.externalApplication,
//                                       );
//                                       print(
//                                           'Successfully opened: $normalizedUrl');
//                                       // _viewCountController.incrementMarketBannerViews(banner.id);
//                                     } else {
//                                       print(
//                                           'Cannot launch URL: $normalizedUrl');
//                                       Get.snackbar(
//                                         'خطأ',
//                                         'لا يمكن فتح الرابط: الرابط غير مدعوم',
//                                         snackPosition: SnackPosition.BOTTOM,
//                                         duration: const Duration(seconds: 3),
//                                       );
//                                     }
//                                   } catch (e) {
//                                     print('Error launching URL: $e');
//                                     Get.snackbar(
//                                       'خطأ',
//                                       'حدث خطأ أثناء فتح الرابط: $e',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                       duration: const Duration(seconds: 3),
//                                     );
//                                   }
//                                 } else {
//                                   print('Invalid URL: $normalizedUrl');
//                                   Get.snackbar(
//                                     'خطأ',
//                                     'الرابط غير صالح: $normalizedUrl',
//                                     snackPosition: SnackPosition.BOTTOM,
//                                     duration: const Duration(seconds: 3),
//                                   );
//                                 }
//                               },
//                               text: 'shop_now'.tr,
//                               textFontWeight: FontWeight.bold,
//                               textSize: 22,
//                               iconPath: 'assets/svg/mynaui_click-solid.svg',
//                               iconColor: Colors.white,
//                             ),
//                           )),
//                     ],
//                   ),
//                 ),
//                 FooterWidget(),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }

class FavoriteButton extends StatelessWidget {
  final int productId;
  final VoidCallback? onFavoriteTap;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(productId: productId);
      final isLoading = controller.isLoading.value;

      return GestureDetector(
        onTap: isLoading
            ? null // Disable tap during loading
            : () async {
                bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
                if (isLoggedIn) {
                  await controller.toggleFavorite(productId: productId);
                  onFavoriteTap?.call();
                } else {
                  CustomSheets.showLoginSheet(context);
                  debugPrint('Favorite Action - Showing Login Bottom Sheet');
                }
              },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: isLoading
              ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : SvgPicture.asset(
                  isFavorite
                      ? 'assets/svg/fullheart2.svg'
                      : 'assets/svg/Heart 2.svg',
                  width: 30,
                  height: 30,
                  colorFilter: isFavorite
                      ? const ColorFilter.mode(
                          AppColors.primary, BlendMode.srcIn)
                      : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
        ),
      );
    });
  }
}
