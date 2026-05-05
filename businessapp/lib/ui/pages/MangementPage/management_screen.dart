import 'dart:async';

import 'package:dieaya_market/ui/pages/MangementPage/product_details.dart';
import 'package:dieaya_market/ui/widgets/buttons.dart';
import 'package:dieaya_market/ui/widgets/global_widgets/main_app_header.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Routes/app_routes.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/BannerController/banner_controller.dart';
import '../../../controllers/CouponControllers/coupon_controller.dart';
import '../../../controllers/OfferController/offer_controller.dart';
import '../../../controllers/ProductsControllers/product_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/banner_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/offer_model.dart';
import '../../../models/product_model.dart';
import '../../../utils/app_snackbars.dart';
import '../../widgets/custom_sheets.dart';
import '../../widgets/section_header.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'banner_details_screen.dart';
import 'coupon_details.dart';
import 'offer_details.dart';

class Category {
  final String title;
  final String svgPath;

  Category({required this.title, required this.svgPath});
}

class ProductListPage extends StatefulWidget {
  final String? initialCategory;

  const ProductListPage({super.key, this.initialCategory});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with SingleTickerProviderStateMixin {
  bool _selectAll = false;
  String sortOrder = 'new_to_old';
  String _selectedSortOption = 'من الأحدث إلى الأقدم';
  late String _selectedType;
  final Set<dynamic> _selectedItems = {};
  dynamic _itemWithOpenActions;

  final ThemeController themeController = Get.put(ThemeController());
  final ProductController productController = Get.put(ProductController());
  final OfferController offerController = Get.put(OfferController());
  final CouponController couponController = Get.put(CouponController());
  final BannerController bannerController = Get.put(BannerController());

  // Search related variables
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _currentSearchKeyword = '';

  // New: Map to track if data for a category has been loaded
  final Map<String, bool> _dataLoaded = {
    'Products'.tr: false,
    'Offers'.tr: false,
    'Coupons'.tr: false,
    'Banners'.tr: false,
  };

  String _getStatusIcon(dynamic item, String selectedType) {
    if (selectedType == 'Products'.tr && item is Product) {
      return item.status == 1
          ? 'assets/svg/Shield Tick2.svg'
          : 'assets/svg/Shield Tick.svg';
    } else if (selectedType == 'Banners'.tr && item is BannerMarket) {
      return item.status == 1
          ? 'assets/svg/Shield Tick2.svg'
          : 'assets/svg/Shield Tick.svg';
    } else if (selectedType == 'Offers'.tr && item is Offer) {
      return item.status == 1
          ? 'assets/svg/Shield Tick2.svg'
          : 'assets/svg/Shield Tick.svg';
    } else if (selectedType == 'Coupons'.tr && item is Coupon) {
      return item.status == 1
          ? 'assets/svg/Shield Tick2.svg'
          : 'assets/svg/Shield Tick.svg';
    } else {
      return 'assets/svg/Shield Tick2.svg'; // Fallback
    }
  }

  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> _menuOptions = [
    {'label': 'عرض', 'color': AppColors.blue, 'icon': Icons.visibility},
    {'label': 'تعديل', 'color': AppColors.blue, 'icon': Icons.edit},
    {'label': 'حذف', 'color': Colors.grey, 'icon': Icons.delete},
  ];
  final Map<dynamic, GlobalKey> _iconKeys = {};
  int currentPage  =1;


  //*****************pagination*****************
  final ScrollController _scrollController = ScrollController();

  //********************************************
  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialCategory ?? 'Products'.tr;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only fetch the initial category's data on first load
      _fetchData(page: 1);
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _searchController.addListener(_onSearchChanged);



    //*****************pagination*****************
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Trigger next page fetch
        _fetchData(page: ++currentPage , keyword: _currentSearchKeyword);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _iconKeys.clear();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Always fetch when keyword changes, resetting page to 1
      _currentSearchKeyword = _searchController.text;
      _fetchData(
          page: 1,
          keyword: _currentSearchKeyword,
          forceFetch: true); // Force fetch on search
    });
  }

  // Modified _fetchData to include forceFetch
  void _fetchData({int page = 1, String? keyword, bool forceFetch = false}) {
    // Only fetch if data for this category hasn't been loaded OR if forced (e.g., search, refresh)
    if (!_dataLoaded[_selectedType]! || forceFetch || page > 1) {
      if (_selectedType == 'Products'.tr) {
        productController.fetchProducts(page: page, keyword: keyword);
      } else if (_selectedType == 'Offers'.tr) {
        offerController.fetchOffers(page: page, keyword: keyword);
      } else if (_selectedType == 'Coupons'.tr) {
        couponController.fetchCoupons(page: page, keyword: keyword);
      } else if (_selectedType == 'Banners'.tr) {
        bannerController.fetchBanners(page: page, keyword: keyword);
      }
      // Mark data as loaded for the current category, but only if it's the first page without a keyword
      if (page == 1 && (keyword == null || keyword.isEmpty)) {
        _dataLoaded[_selectedType] = true;
      }
    }

    setState(() {
      _selectedItems.clear();
      _selectAll = false;
      _itemWithOpenActions = null;
      _animationController.reverse();
    });
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      _selectedItems.clear();
      if (_selectAll) {
        final items = _getCurrentItems();
        _selectedItems.addAll(items);
      }
      _itemWithOpenActions = null;
      _animationController.reverse();
    });
  }

  List<dynamic> _getCurrentItems() {
    if (_selectedType == 'Products'.tr) {
      return productController.products;
    } else if (_selectedType == 'Offers'.tr) {
      return offerController.offers;
    } else if (_selectedType == 'Coupons'.tr) {
      return couponController.coupons;
    } else {
      return bannerController.banners;
    }
  }

  void _toggleMenu(dynamic item) {
    setState(() {
      if (_itemWithOpenActions == item) {
        _itemWithOpenActions = null;
        _animationController.reverse();
      } else {
        _itemWithOpenActions = item;
        _selectedItems.clear();
        _selectAll = false;
        _animationController.forward();
      }
    });
  }

  void _handleMenuAction(String action, dynamic item) {
    switch (action) {
      case 'عرض':
        if (item is Product) {
          Get.to(() => ProductDetailScreen(product: item));
        } else if (item is Offer) {
          Get.to(() => OfferDetailsScreen(offer: item));
        } else if (item is Coupon) {
          Get.to(() => CouponDetailsPage(coupon: item));
        } else if (item is BannerMarket) {
          Get.to(() => BannerDetailsPage(banner: item));
        }
        break;
      case 'تعديل':
        if (item is Product) {
          CustomSheets.showEditProductSheet(context, item);
        } else if (item is Offer) {
          CustomSheets.showAddOfferSheet(context, offer: item);
        } else if (item is Coupon) {
          CustomSheets.showAddCouponSheet(context, coupon: item);
        } else if (item is BannerMarket) {
          CustomSheets.showAddBannerSheet(context, banner: item);
        }
        break;
      case 'حذف':
        _confirmDelete(context, item);
        break;
    }
    setState(() {
      _itemWithOpenActions = null;
      _animationController.reverse();
    });
  }

  void _confirmDelete(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/social/deleteacc.svg',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 10),
              Text(
                'acceptMessageDelete'.tr,
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'sureDelete'.tr,
                style: GoogleFonts.tajawal(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  bool success = false;
                  if (item is Product) {
                    success =
                        await productController.deleteProduct(id: item.id);
                  } else if (item is Offer) {
                    success = await offerController.deleteOffer(id: item.id);
                  } else if (item is Coupon) {
                    success = await couponController.deleteCoupon(id: item.id);
                  } else if (item is BannerMarket) {
                    success = await bannerController.deleteBanner(id: item.id);
                  }
                  if (success) {
                    setState(() {
                      _selectedItems.remove(item);
                      _selectAll = false;
                      _itemWithOpenActions = null;
                    });
                    SnackBarConstantVersion1.showSuccessSnackbar(
                      'successApp'.tr,
                      item is Product
                          ? 'deleteProductSuccess'.tr
                          : item is Offer
                              ? 'deleteOfferSuccess'.tr
                              : item is Coupon
                                  ? 'deleteCouponSuccess'.tr
                                  : 'deleteBannerSuccess'.tr,
                    );
                    // Force re-fetch after delete to ensure data consistency
                    _fetchData(
                        page: 1,
                        keyword: _currentSearchKeyword,
                        forceFetch: true);
                  } else {
                    SnackBarConstantVersion1.showSuccessSnackbar(
                      'error'.tr,
                      item is Product
                          ? productController.errorMessage.value
                          : item is Offer
                              ? offerController.errorMessage.value
                              : item is Coupon
                                  ? couponController.errorMessage.value
                                  : bannerController.errorMessage.value,
                    );
                  }
                },
                text: 'deleteApp'.tr,
                textSize: 16,
                textFontWeight: FontWeight.bold,
                color: const Color(0xffAEAEAE),
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () => Navigator.pop(dialogContext),
                text: 'cancelApp'.tr,
                textSize: 16,
                textFontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBulkDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/social/deleteacc.svg',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 10),
              Text(
                '${'bulkMessage1'.tr} ${_selectedItems.length} ${'bulkMessage2'.tr}',
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'bulkMessage3'.tr,
                style: GoogleFonts.tajawal(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _handleBulkDelete();
                },
                text: 'deleteApp'.tr,
                textSize: 16,
                textFontWeight: FontWeight.bold,
                color:  AppColors.red,
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () => Navigator.pop(dialogContext),
                text: 'cancelApp'.tr,
                textSize: 16,
                textFontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleBulkDelete() async {
    bool allSuccess = true;
    List<dynamic> itemsToDelete = List.from(_selectedItems);

    for (var item in itemsToDelete) {
      bool success = false;
      if (item is Product) {
        success = await productController.deleteProduct(id: item.id);
      } else if (item is Offer) {
        success = await offerController.deleteOffer(id: item.id);
      } else if (item is Coupon) {
        success = await couponController.deleteCoupon(id: item.id);
      } else if (item is BannerMarket) {
        success = await bannerController.deleteBanner(id: item.id);
      }
      if (!success) {
        allSuccess = false;
      }
    }

    setState(() {
      _selectedItems.clear();
      _selectAll = false;
      _itemWithOpenActions = null;
    });

    SnackBarConstantVersion1.showSuccessSnackbar(
      allSuccess ? 'success'.tr : 'error'.tr,
      allSuccess
          ? 'تم حذف ${_selectedItems.length} عنصر بنجاح'.tr
          : 'فشل في حذف بعض العناصر'.tr,
    );

    // Force re-fetch after bulk delete to ensure data consistency
    _fetchData(page: 1, keyword: _currentSearchKeyword, forceFetch: true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final bool isArabic = Get.locale?.languageCode == 'ar';
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              MainAppHeader(
                showSuffixIcon: true,
                controller: _searchController,
                readOnly: false,
                fromSeeAll: true,
                onNotificationPressed: () {
                  Get.toNamed(AppRoutes.notifications);
                  print('Notifications Tapped');
                },
                onChanged:  (value) {
                  _debounce?.cancel();
                  _currentSearchKeyword = value;
                  _fetchData(
                      page: 1,
                      keyword: value,
                      forceFetch: true);
                  debugPrint('Search Submitted: $value');
                },
              ),
              // header bar

              _buildHorizontalCategoryList(itemHeight:  75.h),
              Container(
                color: isDark ? Colors.black : Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.all(8.0),
                      child: Row(
                        children: [
                          _buildFilterChip('sort'.tr, Icons.swap_vert),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'selectAll'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        Checkbox(
                          side: BorderSide(
                            color: AppColors.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            // ← this sets border radius
                            borderRadius: BorderRadius.circular(
                                6), // change the radius as needed
                          ),
                          checkColor: AppColors.white,
                          value: _selectAll,
                          onChanged: _toggleSelectAll,
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: isDark ? Colors.grey[600] : Color(0xffEBEBEB),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          _selectedType == 'Products'.tr
                              ? '-'
                              : _selectedType == 'Coupons'.tr
                                  ? '-'
                                  : _selectedType == 'Banners'.tr
                                      ? '-'
                                      : '-',
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          // textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          _selectedType == 'Products'.tr
                              ? 'product'.tr
                              : _selectedType == 'Coupons'.tr
                                  ? 'couponDiscount'.tr
                                  : _selectedType == 'Banners'.tr
                                      ? 'photo'.tr
                                      : 'descriptionApp'.tr,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Color(0xff666565),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _selectedType == 'Products'.tr
                              ? 'price'.tr
                              : _selectedType == 'Offers'.tr ||
                                      _selectedType == 'Coupons'.tr
                                  ? 'discount_code_header'.tr
                                  : _selectedType == 'Coupons'.tr
                                      ? 'descriptionApp'.tr
                                      : _selectedType == 'Banners'.tr
                                          ? 'descriptionApp'.tr
                                          : "",
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Color(0xff666565),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          // textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          _selectedType == 'Banners'.tr
                              ? 'statues'.tr
                              : 'statues'.tr,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Color(0xff666565),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          _selectedType == 'Banners'.tr ? '' : '',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Color(0xff666565),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  dynamic items;
                  var isLoading = false.obs;
                  var errorMessage = ''.obs;

                  if (_selectedType == 'Products'.tr) {
                    items = productController.products;
                    isLoading = productController.isLoading;
                    errorMessage = productController.errorMessage;
                  } else if (_selectedType == 'Offers'.tr) {
                    items = offerController.offers;
                    isLoading = offerController.isLoading;
                    errorMessage = offerController.errorMessage;
                  } else if (_selectedType == 'Coupons'.tr) {
                    items = couponController.coupons;
                    isLoading = couponController.isLoading;
                    errorMessage = couponController.errorMessage;
                  } else if (_selectedType == 'Banners'.tr) {
                    items = bannerController.banners;
                    isLoading = bannerController.isLoading;
                    errorMessage = bannerController.errorMessage;
                  }

                  if (items.isNotEmpty) {
                    _selectAll = _selectedItems.length == items.length &&
                        items.isNotEmpty;
                  } else {
                    _selectAll = false;
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _fetchData(
                          page: 1,
                          keyword: _currentSearchKeyword,
                          forceFetch: true);
                    },
                    child: isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : errorMessage.value.isNotEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      errorMessage.value,
                                      style: GoogleFonts.tajawal(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        _fetchData(
                                            page: 1,
                                            keyword: _currentSearchKeyword,
                                            forceFetch: true);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'retry'.tr,
                                        style: GoogleFonts.tajawal(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : items.isEmpty
                                ? Center(
                                    child: Text(
                                      'no_data'.tr,
                                      style: GoogleFonts.tajawal(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return Column(
                                        children: [
                                          if (index != 0)
                                            Divider(
                                              color: Colors.grey[300],
                                              thickness: 1,
                                              height: 1,
                                            ),
                                          _buildProductListItem(item),
                                        ],
                                      );
                                    },
                                  ),
                  );
                }),
              ),
              Obx(() {
                final pagination = _selectedType == 'Products'.tr
                    ? productController.pagination.value
                    : _selectedType == 'Offers'.tr
                        ? offerController.pagination.value
                        : _selectedType == 'Coupons'.tr
                            ? couponController.pagination.value
                            : bannerController.pagination.value;
                if (pagination == null) return const SizedBox.shrink();
                return Container(
                  color: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.grey),
                        onPressed: pagination.currentPage > 1
                            ? () {
                                _fetchData(
                                    page: pagination.currentPage - 1,
                                    keyword: _currentSearchKeyword,
                                    forceFetch:
                                        true); // Force fetch on page change
                              }
                            : null,
                      ),
                      const SizedBox(width: 8),
                      ...List.generate(
                        pagination.lastPage > 5 ? 5 : pagination.lastPage,
                        (index) {
                          final page = index + 1;
                          if (index == 4 && pagination.lastPage > 5) {
                            return Row(
                              children: [
                                const Text('.....'),
                                const SizedBox(width: 8),
                                _buildPaginationButton(
                                    pagination.lastPage.toString(),
                                    pagination.currentPage ==
                                        pagination.lastPage),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              _buildPaginationButton(page.toString(),
                                  pagination.currentPage == page),
                              const SizedBox(width: 8),
                            ],
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.grey),
                        onPressed: pagination.currentPage < pagination.lastPage
                            ? () {
                                _fetchData(
                                    page: pagination.currentPage + 1,
                                    keyword: _currentSearchKeyword,
                                    forceFetch:
                                        true); // Force fetch on page change
                              }
                            : null,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          if (_itemWithOpenActions != null)
            _buildMenuOverlay(_itemWithOpenActions),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 60.h),
          color: isDark ? Colors.black : Colors.white,
          width: double.infinity,
          height: _selectedItems.length == 1 ? 110 : 50,
          child: _selectedItems.isEmpty
              ? CustomButton(
                  onPressed: () {
                    if (_selectedType == 'Products'.tr) {
                      CustomSheets.showAddProductSheet(context);
                    } else if (_selectedType == 'Offers'.tr) {
                      CustomSheets.showAddOfferSheet(context);
                    } else if (_selectedType == 'Coupons'.tr) {
                      CustomSheets.showAddCouponSheet(context);
                    } else if (_selectedType == 'Banners'.tr) {
                      CustomSheets.showAddBannerSheet(context);
                    }
                    debugPrint('Add Item for type: $_selectedType');
                  },
                  text: _selectedType == 'Products'.tr
                      ? 'addProduct'.tr
                      : _selectedType == 'Offers'.tr
                          ? 'addOffer'.tr
                          : _selectedType == 'Coupons'.tr
                              ? 'addCoupon'.tr
                              : 'addBanner'.tr,
                  textSize: 16,
                  textFontWeight: FontWeight.bold,
                )
              : _selectedItems.length == 1
                  ? Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            _handleMenuAction(
                                'editApp'.tr, _selectedItems.first);
                          },
                          text: 'editApp'.tr,
                          textSize: 18,
                          textFontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          onPressed: () {
                            _confirmBulkDelete(context);
                          },
                          text: 'deleteApp'.tr,
                          textSize: 18,
                          textFontWeight: FontWeight.bold,
                          color: const Color(0xffAEAEAE),
                          textColor: Colors.white,
                        ),
                      ],
                    )
                  : CustomButton(
                      onPressed: () {
                        _confirmBulkDelete(context);
                      },
                      text: 'deleteApp'.tr,
                      textSize: 18,
                      textFontWeight: FontWeight.bold,
                      color:  AppColors.primary,
                      textColor: Colors.white,
                    ),
        ),
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
              print(value);
              setState(() {
                sortOrder = value;
                _selectedSortOption =
                    value == 'new_to_old' ? 'fromNew'.tr : 'fromOld'.tr;
                // Sorting logic based on selected type
                if (_selectedType == 'Products'.tr) {
                  productController.sortOrder.value = sortOrder;
                  productController.sortProducts(sortOrder);
                } else if (_selectedType == 'Offers'.tr) {
                  offerController.sortOrder.value = sortOrder;
                  offerController.sortOffers(sortOrder);
                } else if (_selectedType == 'Coupons'.tr) {
                  couponController.sortOrder.value = sortOrder;
                  couponController.sortCoupons(sortOrder);
                } else if (_selectedType == 'Banners'.tr) {
                  bannerController.sortOrder.value = sortOrder;
                  bannerController.sortBanner(sortOrder);
                }
                debugPrint('Sort order changed to: $sortOrder');
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<String>(
                      title: Text(
                        'fromNew'.tr,
                        style: GoogleFonts.tajawal(color: AppColors.black),
                      ),
                      value: 'new_to_old',
                      groupValue: sortOrder,
                      onChanged: (value) {
                        Navigator.pop(
                            context, value); // Pass value to onSelected
                      },
                      activeColor: AppColors.primary,
                    ),
                    RadioListTile<String>(
                      title: Text(
                        'fromOld'.tr,
                        style: GoogleFonts.tajawal(color: AppColors.black),
                      ),
                      value: 'old_to_new',
                      groupValue: sortOrder,
                      onChanged: (value) {
                        Navigator.pop(
                            context, value); // Pass value to onSelected
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
            child: Row(
              children: [
                Text(
                  label, // Use dynamic label
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
    );
  }

  Widget _buildHorizontalCategoryList({
    String? title,
    VoidCallback? onSeeAllTap,
    double itemHeight = 60,
  }) {
    final List<Category> categories = [
      Category(title: 'Products'.tr, svgPath: 'assets/svg/products.svg'),
      Category(title: 'Offers'.tr, svgPath: 'assets/svg/offers.svg'),
      Category(title: 'Coupons'.tr, svgPath: 'assets/svg/coupons.svg'),
      Category(title: 'Banners'.tr, svgPath: 'assets/svg/profile/bann.svg'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(Get.context!).size.width * 0.04),
            child: SectionHeader(
              title: title,
              actionText: onSeeAllTap != null ? 'عرض الكل' : null,
              onActionPressed: onSeeAllTap,
            ),
          ),
        SizedBox(
          height: itemHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) {
                if (index < categories.length) {
                  final category = categories[index];
                  final isSelected = _selectedType == category.title;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () {
                        // Only change category and fetch if it's a new selection
                        if (_selectedType != category.title) {
                          setState(() {
                            _selectedType = category.title;
                            _selectAll = false;
                            _selectedItems.clear();
                            _itemWithOpenActions = null;
                            _currentSearchKeyword =
                                ''; // Reset search keyword when category changes
                            _searchController.clear(); // Clear search field
                            // Fetch data for the newly selected category if not already loaded
                            _fetchData(
                                page: 1,
                                forceFetch: false); // Do not force fetch here
                          });
                        }
                      },
                      child: Container(
                        height: itemHeight,
                        width: MediaQuery.of(Get.context!).size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: isSelected ? 1 : 0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 0.5,
                              offset: Offset(0.5, 0.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              category.svgPath,
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? AppColors.primary
                                    : const Color(0xffB9B9B9),
                                BlendMode.srcIn,
                              ),
                              placeholderBuilder: (context) => const Icon(
                                Icons.error,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              category.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                fontSize:
                                    MediaQuery.of(Get.context!).size.width *
                                        0.030,
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xffB9B9B9),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductListItem(dynamic item) {
    bool areActionsOpen = _itemWithOpenActions == item;
    final iconKey = GlobalKey();
    _iconKeys[item] = iconKey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_selectedType == 'Products'.tr)
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedItems.contains(item)) {
                          _selectedItems.remove(item);
                        } else {
                          _selectedItems.add(item);
                        }
                        _selectAll =
                            _selectedItems.length == _getCurrentItems().length;
                        _itemWithOpenActions = null;
                        _animationController.reverse();
                      });
                    },
                    child: SvgPicture.asset(
                      _selectedItems.contains(item)
                          ? 'assets/svg/checkyes.svg'
                          : 'assets/svg/checkno.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        _selectedItems.contains(item)
                            ? AppColors.primary
                            : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item.images.isNotEmpty ? item.images[0].image : '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      (item as Product).nameAr,
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xff666565)),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          else if (_selectedType == 'Offers'.tr)
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedItems.contains(item)) {
                          _selectedItems.remove(item);
                        } else {
                          _selectedItems.add(item);
                        }
                        _selectAll =
                            _selectedItems.length == _getCurrentItems().length;
                        _itemWithOpenActions = null;
                        _animationController.reverse();
                      });
                    },
                    child: SvgPicture.asset(
                      _selectedItems.contains(item)
                          ? 'assets/svg/checkyes.svg'
                          : 'assets/svg/checkno.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        _selectedItems.contains(item)
                            ? AppColors.primary
                            : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (item as Offer).titleAr ?? '',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff666565),
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (_selectedType == 'Coupons'.tr)
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedItems.contains(item)) {
                          _selectedItems.remove(item);
                        } else {
                          _selectedItems.add(item);
                        }
                        _selectAll =
                            _selectedItems.length == _getCurrentItems().length;
                        _itemWithOpenActions = null;
                        _animationController.reverse();
                      });
                    },
                    child: SvgPicture.asset(
                      _selectedItems.contains(item)
                          ? 'assets/svg/checkyes.svg'
                          : 'assets/svg/checkno.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        _selectedItems.contains(item)
                            ? AppColors.primary
                            : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (item as Coupon).discount,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff666565),
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (_selectedType == 'Banners'.tr)
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedItems.contains(item)) {
                          _selectedItems.remove(item);
                        } else {
                          _selectedItems.add(item);
                        }
                        _selectAll =
                            _selectedItems.length == _getCurrentItems().length;
                        _itemWithOpenActions = null;
                        _animationController.reverse();
                      });
                    },
                    child: SvgPicture.asset(
                      _selectedItems.contains(item)
                          ? 'assets/svg/checkyes.svg'
                          : 'assets/svg/checkno.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        _selectedItems.contains(item)
                            ? AppColors.primary
                            : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            (item as BannerMarket).image,
                            width: 95,
                            height: 45,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[200],
                              child: const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _selectedType == 'Products'.tr
                        ? (item is Product &&
                                item.priceOffer != null &&
                                item.priceOffer!.isNotEmpty
                            ? '${item.priceOffer}'
                            : '${item.price}')
                        : _selectedType == 'Offers'.tr
                            ? (item as Offer).couponCode ?? '-'
                            : _selectedType == 'Coupons'.tr
                                ? (item as Coupon).couponCode
                                : (item as BannerMarket).descriptionAr,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff666565),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (_selectedType == 'Products'.tr) ...[
                  // const SizedBox(width: 4),
                  SvgPicture.asset('assets/svg/sa_currency.svg',
                      width: 12, height: 12),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SvgPicture.asset(
              _getStatusIcon(item, _selectedType),
              width: 20,
              height: 20,
            ),
          ),
          Expanded(
            flex: 1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transformAlignment: Alignment.center,
              transform: Matrix4.rotationZ(areActionsOpen ? math.pi / 4 : 0),
              child: IconButton(
                key: iconKey,
                icon: Icon(
                  areActionsOpen ? Icons.close : Icons.more_vert,
                  color: Colors.grey,
                  size: 24,
                ),
                onPressed: () => _toggleMenu(item),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOverlay(dynamic item) {
    final bool isArabic = Get.locale?.languageCode == 'ar';
    final RenderBox? renderBox =
        _iconKeys[item]?.currentContext?.findRenderObject() as RenderBox?;
    Offset iconPosition = Offset.zero;
    Size iconSize = Size.zero;
    if (renderBox != null) {
      iconPosition = renderBox.localToGlobal(Offset.zero);
      iconSize = renderBox.size;
    }

    return GestureDetector(
      onTap: () => _toggleMenu(item),
      child: Container(
        color: Colors.black12,
        child: Stack(
          children: [
            Positioned(
              right: isArabic
                  ? MediaQuery.of(context).size.width -
                      iconPosition.dx -
                      iconSize.width / 1 -
                      115
                  : MediaQuery.of(context).size.width -
                      iconPosition.dx -
                      iconSize.width / 1 -
                      0,
              top: iconPosition.dy - (_menuOptions.length * 0) - 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_menuOptions.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _buildMenuButton(index, item),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _toggleMenu(item),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(int index, dynamic item) {
    final option = _menuOptions[index];
    final isDelete = option['label'] == 'حذف';

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              -((_menuOptions.length - 1 - index) *
                  50 *
                  (1 - _animation.value)),
              0),
          child: Container(
            width: 120,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                _handleMenuAction(option['label'], item);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDelete ? Colors.grey[300] : AppColors.blue,
                foregroundColor: isDelete ? Colors.black54 : Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    option['icon'],
                    size: 18,
                    color: isDelete ? Colors.black54 : Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    option['label'],
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: isDelete ? Colors.black54 : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginationButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _fetchData(
            page: int.parse(text),
            keyword: _currentSearchKeyword,
            forceFetch: true);
        setState(() {
          _itemWithOpenActions = null;
          _animationController.reverse();
        });
      },
      child: Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: GoogleFonts.tajawal(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// class ProductListPage extends StatefulWidget {
//   final String? initialCategory;
//
//   const ProductListPage({super.key, this.initialCategory});
//
//   @override
//   State<ProductListPage> createState() => _ProductListPageState();
// }
//
// class _ProductListPageState extends State<ProductListPage>
//     with SingleTickerProviderStateMixin {
//   bool _selectAll = false;
//   String sortOrder = 'new_to_old';
//   String _selectedSortOption = 'من الأحدث إلى الأقدم';
//   late String _selectedType;
//   dynamic _selectedItem;
//   dynamic _itemWithOpenActions;
//
//   final ThemeController themeController = Get.find<ThemeController>();
//   final ProductController productController = Get.put(ProductController());
//   final OfferController offerController = Get.put(OfferController());
//   final CouponController couponController = Get.put(CouponController());
//   final BannerController bannerController = Get.put(BannerController());
//
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   final List<Map<String, dynamic>> _menuOptions = [
//     {'label': 'عرض', 'color': AppColors.blue, 'icon': Icons.visibility},
//     {'label': 'تعديل', 'color': AppColors.blue, 'icon': Icons.edit},
//     {'label': 'حذف', 'color': Colors.grey, 'icon': Icons.delete},
//   ];
//   final Map<dynamic, GlobalKey> _iconKeys = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedType = widget.initialCategory ?? 'المنتجات';
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchData(page: 1);
//     });
//
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _iconKeys.clear();
//     super.dispose();
//   }
//
//   void _fetchData({int page = 1}) {
//     if (_selectedType == 'المنتجات') {
//       productController.fetchProducts(page: page);
//     } else if (_selectedType == 'العروض') {
//       offerController.fetchOffers(page: page);
//     } else if (_selectedType == 'الكوبونات') {
//       couponController.fetchCoupons(page: page);
//     } else if (_selectedType == 'البانرات') {
//       bannerController.fetchBanners(page: page);
//     }
//   }
//
//   void _toggleMenu(dynamic item) {
//     setState(() {
//       if (_itemWithOpenActions == item) {
//         _itemWithOpenActions = null;
//         _animationController.reverse();
//       } else {
//         _itemWithOpenActions = item;
//         _selectedItem = null;
//         _animationController.forward();
//       }
//     });
//   }
//
//   void _handleMenuAction(String action, dynamic item) {
//     switch (action) {
//       case 'عرض':
//         if (item is Product) {
//           Get.to(() => ProductDetailScreen(product: item));
//         } else if (item is Offer) {
//           Get.to(() => OfferDetailsScreen(offer: item));
//         } else if (item is Coupon) {
//           Get.to(() => CouponDetailsPage(coupon: item));
//         } else if (item is BannerMarket) {
//           Get.to(() => BannerDetailsPage(banner: item));
//         }
//         break;
//       case 'تعديل':
//         if (item is Product) {
//           CustomSheets.showEditProductSheet(context, item);
//         } else if (item is Offer) {
//           CustomSheets.showAddOfferSheet(context, offer: item);
//         } else if (item is Coupon) {
//           CustomSheets.showAddCouponSheet(context, coupon: item);
//         } else if (item is BannerMarket) {
//           CustomSheets.showAddBannerSheet(context, banner: item);
//         }
//         break;
//       case 'حذف':
//         _confirmDelete(context, item);
//         break;
//     }
//     setState(() {
//       _itemWithOpenActions = null;
//       _animationController.reverse();
//     });
//   }
//
//   void _confirmDelete(BuildContext context, dynamic item) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: Text(
//           'هل تريد الحذف ؟'.tr,
//           style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           'متأكد من الحذف'.tr,
//           style: GoogleFonts.tajawal(fontSize: 16),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text(
//               'cancel'.tr,
//               style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey),
//             ),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(dialogContext);
//               bool success = false;
//               if (item is Product) {
//                 success = await productController.deleteProduct(id: item.id);
//               } else if (item is Offer) {
//                 success = await offerController.deleteOffer(id: item.id);
//               } else if (item is Coupon) {
//                 success = await couponController.deleteCoupon(id: item.id);
//               } else if (item is BannerMarket) {
//                 success = await bannerController.deleteBanner(id: item.id);
//               }
//               if (success) {
//                 setState(() {
//                   _selectedItem = null;
//                   _itemWithOpenActions = null;
//                 });
//                 SnackBarConstant.showSuccessSnackbar(
//                   'success'.tr,
//                   item is Product
//                       ? 'تم حذف المنتج بنجاح'.tr
//                       : item is Offer
//                       ? 'تم حذف العرض بنجاح'
//                       : item is Coupon
//                       ? 'تم حذف الكوبون بنجاح'
//                       : 'تم حذف البانر بنجاح',
//                 );
//               } else {
//                 SnackBarConstant.showSuccessSnackbar(
//                   'error'.tr,
//                   item is Product
//                       ? productController.errorMessage.value
//                       : item is Offer
//                       ? offerController.errorMessage.value
//                       : item is Coupon
//                       ? couponController.errorMessage.value
//                       : bannerController.errorMessage.value,
//                 );
//               }
//             },
//             child: Text(
//               'delete'.tr,
//               style: GoogleFonts.tajawal(fontSize: 16, color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     bool isDark = themeController.themeMode.value == ThemeMode.dark;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: isDark ? Colors.black :Colors.white,
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: isDark
//                           ? [AppColors.primary, AppColors.primary, Colors.black]
//                           : [AppColors.primary, AppColors.primary, Colors.white],
//                       stops: const [0.0, 0.0, 5.0],
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                       top: screenHeight * 0.06,
//                       bottom: screenHeight * 0.01,
//                       right: screenWidth * 0.05,
//                       left: screenWidth * 0.05,
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   Get.back();
//                                 },
//                                 child: Container(
//                                   width: 50,
//                                   height: 50,
//                                   child: SvgPicture.asset(
//                                     'assets/svg/backbutton.svg',
//                                     width: 50,
//                                     height: 50,
//                                   ),
//                                 ),
//                               ),
//                               Image.asset(
//                                 'assets/images/logodiaya.png',
//                                 width: 35,
//                                 height: 35,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(25),
//                                 color: Colors.white,
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 10),
//                                 child: Row(
//                                   children: [
//                                     Stack(
//                                       children: [
//                                         IconButton(
//                                           icon: SvgPicture.asset(
//                                             'assets/svg/notify.svg',
//                                             width: screenWidth * 0.06,
//                                             height: screenWidth * 0.06,
//                                             colorFilter: const ColorFilter.mode(
//                                               Colors.black54,
//                                               BlendMode.srcIn,
//                                             ),
//                                           ),
//                                           onPressed: () {
//                                             Get.toNamed(AppRoutes.notifications);
//                                             print('Notifications Tapped');
//                                           },
//                                         ),
//                                         Positioned(
//                                           right: screenWidth * 0.025,
//                                           top: screenHeight * 0.015,
//                                           child: Container(
//                                             padding: EdgeInsets.all(
//                                                 screenWidth * 0.005),
//                                             decoration: BoxDecoration(
//                                               color: Colors.red,
//                                               borderRadius:
//                                               BorderRadius.circular(6),
//                                             ),
//                                             constraints: BoxConstraints(
//                                               minWidth: screenWidth * 0.02,
//                                               minHeight: screenWidth * 0.02,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: screenWidth * 0.02),
//                             Expanded(
//                               child: Container(
//                                 height: screenHeight * 0.06,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(25),
//                                 ),
//                                 child: TextField(
//                                   onTap: () {},
//                                   readOnly: true,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.02,
//                                       vertical: screenHeight * 0.01,
//                                     ),
//                                     hintText: 'search_products'.tr,
//                                     hintStyle: GoogleFonts.tajawal(
//                                       color: Colors.grey,
//                                       fontSize: screenWidth * 0.035,
//                                     ),
//                                     suffixIcon: Padding(
//                                       padding:
//                                       EdgeInsets.all(screenWidth * 0.02),
//                                       child: Container(
//                                         width: screenWidth * 0.12,
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xFFEAEAEA),
//                                           borderRadius:
//                                           BorderRadius.circular(50),
//                                         ),
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: screenWidth * 0.02,
//                                             vertical: screenHeight * 0.01,
//                                           ),
//                                           child: SvgPicture.asset(
//                                             'assets/svg/Search 1.svg',
//                                             width: screenWidth * 0.06,
//                                             height: screenWidth * 0.06,
//                                             colorFilter: const ColorFilter.mode(
//                                               Color(0xff5D5C5C),
//                                               BlendMode.srcIn,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     border: InputBorder.none,
//                                     enabledBorder: InputBorder.none,
//                                     focusedBorder: InputBorder.none,
//                                   ),
//                                   onSubmitted: (value) {
//                                     debugPrint('Search Submitted: $value');
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 _buildHorizontalCategoryList(),
//                 Container(
//                   color: isDark ? Colors.black :Colors.white,
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsetsDirectional.all(8.0),
//                         child: Row(
//                           children: [
//                             _buildFilterChip('sort'.tr, Icons.swap_vert),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'تحديد الكل',
//                             style: GoogleFonts.tajawal(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           Checkbox(
//                             value: _selectAll,
//                             onChanged: (bool? newValue) {
//                               setState(() {
//                                 _selectAll = newValue ?? false;
//                                 if (!_selectAll) {
//                                   _selectedItem = null;
//                                 }
//                                 _itemWithOpenActions = null;
//                                 _animationController.reverse();
//                               });
//                             },
//                             activeColor: AppColors.primary,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   color: isDark ? Colors.black :Colors.grey[100],
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           _selectedType == 'المنتجات'
//                               ? '-'
//                               : _selectedType == 'الكوبونات'
//                               ? '-'
//                               : _selectedType == 'البانرات'
//                               ? '-'
//                               : '-',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white :Colors.black87,
//                           ),
//                           textAlign: TextAlign.right,
//                         ),
//                       ),
//                       Expanded(
//                         flex: 5,
//                         child: Text(
//                           _selectedType == 'المنتجات'
//                               ? 'المنتج'
//                               : _selectedType == 'الكوبونات'
//                               ? 'الخصم'
//                               : _selectedType == 'البانرات'
//                               ? 'البانر صورة'
//                               : 'الوصف',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white :Colors.black87,
//                           ),
//                           textAlign: TextAlign.right,
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           _selectedType == 'المنتجات'
//                               ? 'السعر'
//                               : _selectedType == 'العروض' ||
//                               _selectedType == 'الكوبونات'
//                               ? 'كود الخصم'
//                               : _selectedType == 'البانرات'
//                               ? 'الوصف'
//                               : '',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white :Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Expanded(
//                         flex: 4,
//                         child: Text(
//                           _selectedType == 'البانرات' ? 'الحالة' : 'الحالة',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white :Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Text(
//                           _selectedType == 'البانرات' ? '' : '',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isDark ? Colors.white :Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Obx(() {
//                     dynamic items;
//                     var isLoading = false.obs;
//                     var errorMessage = ''.obs;
//
//                     if (_selectedType == 'المنتجات') {
//                       items = productController.products;
//                       isLoading = productController.isLoading;
//                       errorMessage = productController.errorMessage;
//                     } else if (_selectedType == 'العروض') {
//                       items = offerController.offers;
//                       isLoading = offerController.isLoading;
//                       errorMessage = offerController.errorMessage;
//                     } else if (_selectedType == 'الكوبونات') {
//                       items = couponController.coupons;
//                       isLoading = couponController.isLoading;
//                       errorMessage = couponController.errorMessage;
//                     } else if (_selectedType == 'البانرات') {
//                       items = bannerController.banners;
//                       isLoading = bannerController.isLoading;
//                       errorMessage = bannerController.errorMessage;
//                     }
//
//                     return RefreshIndicator(
//                       onRefresh: () async {
//                         _fetchData(page: 1);
//                       },
//                       child: isLoading.value
//                           ? Center(
//                         child: CircularProgressIndicator(
//                           color: AppColors.primary,
//                         ),
//                       )
//                           : errorMessage.value.isNotEmpty
//                           ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               errorMessage.value,
//                               style: GoogleFonts.tajawal(
//                                 fontSize: 16,
//                                 color: Colors.red,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 10),
//                             ElevatedButton(
//                               onPressed: () {
//                                 _fetchData(page: 1);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.primary,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: Text(
//                                 'retry'.tr,
//                                 style: GoogleFonts.tajawal(
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                           : items.isEmpty
//                           ? Center(
//                         child: Text(
//                           'no_products'.tr,
//                           style: GoogleFonts.tajawal(
//                             fontSize: 18,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       )
//                           : ListView.builder(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0),
//                         itemCount: items.length,
//                         itemBuilder: (context, index) {
//                           final item = items[index];
//                           return Column(
//                             children: [
//                               if (index != 0)
//                                 Divider(
//                                   color: Colors.grey[300],
//                                   thickness: 1,
//                                   height: 1,
//                                 ),
//                               _buildProductListItem(item),
//                             ],
//                           );
//                         },
//                       ),
//                     );
//                   }),
//                 ),
//                 Obx(() {
//                   final pagination = _selectedType == 'المنتجات'
//                       ? productController.pagination.value
//                       : _selectedType == 'العروض'
//                       ? offerController.pagination.value
//                       : _selectedType == 'الكوبونات'
//                       ? couponController.pagination.value
//                       : bannerController.pagination.value;
//                   if (pagination == null) return const SizedBox.shrink();
//                   return Container(
//                     color:isDark ? Colors.black :Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_back_ios_rounded,
//                               color: Colors.grey),
//                           onPressed: pagination.currentPage > 1
//                               ? () {
//                             _fetchData(page: pagination.currentPage - 1);
//                           }
//                               : null,
//                         ),
//                         const SizedBox(width: 8),
//                         ...List.generate(
//                           pagination.lastPage > 5 ? 5 : pagination.lastPage,
//                               (index) {
//                             final page = index + 1;
//                             if (index == 4 && pagination.lastPage > 5) {
//                               return Row(
//                                 children: [
//                                   const Text('.....'),
//                                   const SizedBox(width: 8),
//                                   _buildPaginationButton(
//                                       pagination.lastPage.toString(),
//                                       pagination.currentPage ==
//                                           pagination.lastPage),
//                                 ],
//                               );
//                             }
//                             return Row(
//                               children: [
//                                 _buildPaginationButton(page.toString(),
//                                     pagination.currentPage == page),
//                                 const SizedBox(width: 8),
//                               ],
//                             );
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.arrow_forward_ios_rounded,
//                               color: Colors.grey),
//                           onPressed:
//                           pagination.currentPage < pagination.lastPage
//                               ? () {
//                             _fetchData(
//                                 page: pagination.currentPage + 1);
//                           }
//                               : null,
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ],
//             ),
//             if (_itemWithOpenActions != null)
//               _buildMenuOverlay(_itemWithOpenActions),
//           ],
//         ),
//         bottomNavigationBar: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Container(
//             color: isDark ? Colors.black :Colors.white,
//             width: double.infinity,
//             height: _selectedItem == null ? 50 : 110,
//             child: _selectedItem == null
//                 ? CustomButton(
//               onPressed: () {
//                 if (_selectedType == 'المنتجات') {
//                   CustomSheets.showAddProductSheet(context);
//                 } else if (_selectedType == 'العروض') {
//                   CustomSheets.showAddOfferSheet(context);
//                 } else if (_selectedType == 'الكوبونات') {
//                   CustomSheets.showAddCouponSheet(context);
//                 } else if (_selectedType == 'البانرات') {
//                   CustomSheets.showAddBannerSheet(context);
//                 }
//                 debugPrint('Add Item for type: $_selectedType');
//               },
//               text: _selectedType == 'المنتجات'
//                   ? 'اضافة منتج'
//                   : _selectedType == 'العروض'
//                   ? 'اضافة عرض'
//                   : _selectedType == 'الكوبونات'
//                   ? 'اضافة كوبون'
//                   : 'اضافة بانر',
//               textSize: 16,
//               textFontWeight: FontWeight.bold,
//             )
//                 : Column(
//               children: [
//                 CustomButton(
//                   onPressed: () {
//                     _handleMenuAction('تعديل', _selectedItem);
//                   },
//                   text: 'تعديل',
//                   textSize: 18,
//                   textFontWeight: FontWeight.bold,
//                 ),
//                 const SizedBox(height: 10),
//                 CustomButton(
//                   onPressed: () {
//                     _handleMenuAction('حذف', _selectedItem);
//                   },
//                   text: 'حذف',
//                   textSize: 18,
//                   textFontWeight: FontWeight.bold,
//                   color: const Color(0xffAEAEAE),
//                   textColor: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ),
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
//             style: GoogleFonts.tajawal(
//               color: AppColors.white,
//             ),
//             items: [
//               DropdownMenuItem(
//                 value: 'new_to_old',
//                 child: Text(
//                   'من الأحدث إلى الأقدم'.tr,
//                   style: GoogleFonts.tajawal(color: AppColors.white),
//                 ),
//               ),
//               DropdownMenuItem(
//                 value: 'old_to_new',
//                 child: Text(
//                   'من الأقدم إلى الأحدث'.tr,
//                   style: GoogleFonts.tajawal(color: AppColors.white),
//                 ),
//               ),
//             ],
//             onChanged: (value) {
//               setState(() {
//                 sortOrder = value!;
//                 _selectedSortOption = value == 'new_to_old'
//                     ? 'من الأحدث إلى الأقدم'
//                     : 'من الأقدم إلى الأحدث';
//                 if (_selectedType == 'المنتجات') {
//                   productController.sortOrder.value = sortOrder;
//                   productController.sortProducts(sortOrder);
//                 } else if (_selectedType == 'العروض') {
//                   offerController.sortOrder.value = sortOrder;
//                   offerController.sortOffers(sortOrder);
//                 } else if (_selectedType == 'الكوبونات') {
//                   couponController.sortOrder.value = sortOrder;
//                   couponController.sortCoupons(sortOrder);
//                 } else if (_selectedType == 'البانرات') {
//                   // bannerController.sortOrder.value = sortOrder;
//                   // bannerController.sortBanners(sortOrder);
//                 }
//                 debugPrint('Sort order changed to: $sortOrder');
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHorizontalCategoryList({
//     String? title,
//     VoidCallback? onSeeAllTap,
//     double itemHeight = 60,
//   }) {
//     final List<Category> categories = [
//       Category(title: 'المنتجات', svgPath: 'assets/svg/products.svg'),
//       Category(title: 'العروض', svgPath: 'assets/svg/offers.svg'),
//       Category(title: 'الكوبونات', svgPath: 'assets/svg/coupons.svg'),
//       Category(title: 'البانرات', svgPath: 'assets/svg/profile/bann.svg'),
//     ];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         if (title != null)
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(Get.context!).size.width * 0.04),
//             child: SectionHeader(
//               title: title,
//               actionText: onSeeAllTap != null ? 'عرض الكل' : null,
//               onActionPressed: onSeeAllTap,
//             ),
//           ),
//         SizedBox(
//           height: itemHeight,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               4,
//                   (index) {
//                 if (index < categories.length) {
//                   final category = categories[index];
//                   final isSelected = _selectedType == category.title;
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _selectedType = category.title;
//                           _selectAll = false;
//                           _selectedItem = null;
//                           _itemWithOpenActions = null;
//                           _fetchData(page: 1);
//                         });
//                       },
//                       child: Container(
//                         height: itemHeight,
//                         width: MediaQuery.of(Get.context!).size.width * 0.2,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(50),
//                           border: Border.all(
//                             color: isSelected
//                                 ? AppColors.primary
//                                 : Colors.transparent,
//                             width: isSelected ? 2 : 0,
//                           ),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 0.5,
//                               offset: Offset(0.5, 0.0),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SvgPicture.asset(
//                               category.svgPath,
//                               height: 20,
//                               width: 20,
//                               colorFilter: ColorFilter.mode(
//                                 isSelected
//                                     ? AppColors.primary
//                                     : const Color(0xffB9B9B9),
//                                 BlendMode.srcIn,
//                               ),
//                               placeholderBuilder: (context) => const Icon(
//                                 Icons.error,
//                                 size: 30,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               category.title,
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.tajawal(
//                                 fontSize:
//                                 MediaQuery.of(Get.context!).size.width *
//                                     0.030,
//                                 color: isSelected
//                                     ? AppColors.primary
//                                     : const Color(0xffB9B9B9),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProductListItem(dynamic item) {
//     bool areActionsOpen = _itemWithOpenActions == item;
//     final iconKey = GlobalKey();
//     _iconKeys[item] = iconKey;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           if (_selectedType == 'المنتجات')
//             Expanded(
//               flex: 3,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (_selectedItem == item) {
//                           _selectedItem = null;
//                         } else {
//                           _selectedItem = item;
//                           _selectAll = false;
//                         }
//                         _itemWithOpenActions = null;
//                         _animationController.reverse();
//                       });
//                     },
//                     child: SvgPicture.asset(
//                       _selectedItem == item
//                           ? 'assets/svg/checkyes.svg'
//                           : 'assets/svg/checkno.svg',
//                       width: 20,
//                       height: 20,
//                       colorFilter: ColorFilter.mode(
//                         _selectedItem == item ? AppColors.primary : Colors.grey,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: Image.network(
//                       item.images.isNotEmpty ? item.images[0].image : '',
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => Container(
//                         width: 50,
//                         height: 50,
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.error, color: Colors.red),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     (item as Product).nameAr,
//                     style: GoogleFonts.tajawal(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                     textAlign: TextAlign.right,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             )
//           else if (_selectedType == 'العروض')
//             Expanded(
//               flex: 3,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (_selectedItem == item) {
//                           _selectedItem = null;
//                         } else {
//                           _selectedItem = item;
//                           _selectAll = false;
//                         }
//                         _itemWithOpenActions = null;
//                         _animationController.reverse();
//                       });
//                     },
//                     child: SvgPicture.asset(
//                       _selectedItem == item
//                           ? 'assets/svg/checkyes.svg'
//                           : 'assets/svg/checkno.svg',
//                       width: 20,
//                       height: 20,
//                       colorFilter: ColorFilter.mode(
//                         _selectedItem == item ? AppColors.primary : Colors.grey,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         (item as Offer).titleAr ?? '',
//                         style: GoogleFonts.tajawal(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.right,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           else if (_selectedType == 'الكوبونات')
//               Expanded(
//                 flex: 3,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           if (_selectedItem == item) {
//                             _selectedItem = null;
//                           } else {
//                             _selectedItem = item;
//                             _selectAll = false;
//                           }
//                           _itemWithOpenActions = null;
//                           _animationController.reverse();
//                         });
//                       },
//                       child: SvgPicture.asset(
//                         _selectedItem == item
//                             ? 'assets/svg/checkyes.svg'
//                             : 'assets/svg/checkno.svg',
//                         width: 20,
//                         height: 20,
//                         colorFilter: ColorFilter.mode(
//                           _selectedItem == item ? AppColors.primary : Colors.grey,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 50),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           (item as Coupon).discount,
//                           style: GoogleFonts.tajawal(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                           textAlign: TextAlign.right,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             else if (_selectedType == 'البانرات')
//                 Expanded(
//                   flex: 3,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             if (_selectedItem == item) {
//                               _selectedItem = null;
//                             } else {
//                               _selectedItem = item;
//                               _selectAll = false;
//                             }
//                             _itemWithOpenActions = null;
//                             _animationController.reverse();
//                           });
//                         },
//                         child: SvgPicture.asset(
//                           _selectedItem == item
//                               ? 'assets/svg/checkyes.svg'
//                               : 'assets/svg/checkno.svg',
//                           width: 20,
//                           height: 20,
//                           colorFilter: ColorFilter.mode(
//                             _selectedItem == item ? AppColors.primary : Colors.grey,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 35),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8.0),
//                             child: Image.network(
//                               (item as BannerMarket).image,
//                               width: 50,
//                               height: 50,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     color: Colors.grey[200],
//                                     child: const Icon(Icons.error, color: Colors.red),
//                                   ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               _selectedType == 'المنتجات'
//                   ? (item is Product &&
//                   item.priceOffer != null &&
//                   item.priceOffer!.isNotEmpty
//                   ? '${item.priceOffer} ﷼'
//                   : '${item.price} ﷼')
//                   : _selectedType == 'العروض'
//                   ? (item as Offer).couponCode ?? 'N/A'
//                   : _selectedType == 'الكوبونات'
//                   ? (item as Coupon).couponCode
//                   : (item as BannerMarket).descriptionAr,
//               style: GoogleFonts.tajawal(
//                 fontSize: 16,
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: _selectedType == 'الكوبونات'
//                 ? SvgPicture.asset('assets/svg/Shield Tick2.svg')
//                 : _selectedType == 'البانرات'
//                 ? SvgPicture.asset('assets/svg/Shield Tick2.svg')
//                 : SvgPicture.asset('assets/svg/Shield Tick2.svg'),
//           ),
//           Expanded(
//             flex: 1,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               transformAlignment: Alignment.center,
//               transform: Matrix4.rotationZ(areActionsOpen ? math.pi / 4 : 0),
//               child: IconButton(
//                 key: iconKey,
//                 icon: Icon(
//                   areActionsOpen ? Icons.close : Icons.more_vert,
//                   color: Colors.grey,
//                   size: 24,
//                 ),
//                 onPressed: () => _toggleMenu(item),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuOverlay(dynamic item) {
//     final RenderBox? renderBox =
//     _iconKeys[item]?.currentContext?.findRenderObject() as RenderBox?;
//     Offset iconPosition = Offset.zero;
//     Size iconSize = Size.zero;
//     if (renderBox != null) {
//       iconPosition = renderBox.localToGlobal(Offset.zero);
//       iconSize = renderBox.size;
//     }
//
//     return GestureDetector(
//       onTap: () => _toggleMenu(item),
//       child: Container(
//         color: Colors.black12,
//         child: Stack(
//           children: [
//             Positioned(
//               right: MediaQuery.of(context).size.width -
//                   iconPosition.dx -
//                   iconSize.width / 1 -
//                   115,
//               top: iconPosition.dy - (_menuOptions.length * 0) - 70,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: List.generate(_menuOptions.length, (index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4),
//                         child: _buildMenuButton(index, item),
//                       );
//                     }),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: () => _toggleMenu(item),
//                     child: Container(
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey[300],
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.black54,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuButton(int index, dynamic item) {
//     final option = _menuOptions[index];
//     final isDelete = option['label'] == 'حذف';
//
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(
//               -((_menuOptions.length - 1 - index) *
//                   50 *
//                   (1 - _animation.value)),
//               0),
//           child: Container(
//             width: 120,
//             height: 40,
//             child: ElevatedButton(
//               onPressed: () {
//                 _handleMenuAction(option['label'], item);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isDelete ? Colors.grey[300] : AppColors.blue,
//                 foregroundColor: isDelete ? Colors.black54 : Colors.white,
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: EdgeInsets.zero,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     option['icon'],
//                     size: 18,
//                     color: isDelete ? Colors.black54 : Colors.white,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     option['label'],
//                     style: GoogleFonts.tajawal(
//                       fontSize: 14,
//                       color: isDelete ? Colors.black54 : Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPaginationButton(String text, bool isSelected) {
//     return GestureDetector(
//       onTap: () {
//         _fetchData(page: int.parse(text));
//         setState(() {
//           _itemWithOpenActions = null;
//           _animationController.reverse();
//         });
//       },
//       child: Container(
//         width: 35,
//         height: 35,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primary : Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           text,
//           style: GoogleFonts.tajawal(
//             color: isSelected ? Colors.white : Colors.grey[700],
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
