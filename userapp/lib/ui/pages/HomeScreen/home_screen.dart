import 'package:carousel_slider/carousel_slider.dart';
import 'package:dieaya_user/UI/pages/CouponsScreen/coupons_screen.dart';
import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/controllers/MarketControllers/best_market_controller.dart';
import 'package:dieaya_user/controllers/show_home_categories_controller.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/routes/app_routes.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_product_card_gird_view.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/main_app_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/view_products.dart';
import 'package:dieaya_user/ui/widgets/home_screen_widgets/show_home_screen_categories_products.dart';
import 'package:dieaya_user/utils/caching_sevice/shared_preferences.dart';
import 'package:dieaya_user/utils/notification/local_notification.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/BannersController/banners_controller.dart';
import '../../../controllers/CategoryController/category_controller.dart';
import '../../../controllers/CountsConroller/counts_controller.dart';
import '../../../controllers/Coupons_Controller/get_coupons_controller.dart';
import '../../../controllers/FavController/fav_controller.dart';
import '../../../controllers/ProductController/product_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/best_market_model.dart';
import '../../../models/categories_model.dart';
import '../../../models/coupons_model.dart';
import '../../../models/product_model.dart';
import '../../../utils/constants/image_constants.dart';
import '../../widgets/category_list.dart';
import '../../widgets/coupon_card.dart';
import '../../widgets/custom_sheets.dart';
import '../../widgets/offer_card.dart';
import '../../widgets/product_card.dart';
import '../../widgets/promo_banner.dart';
import '../../widgets/global_widgets/section_header.dart';
import '../../widgets/store_grid_widget.dart';
import '../NotificationsScreen/notifications_screen.dart';
import '../ProductsScreen/products_screen.dart';
import '../ProfileScreen/my_favs_screen.dart';
import '../StoresScreen/see_all_market.dart';
import '../StoresScreen/store_details.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _bannerCarouselController =
      CarouselSliderController();
  final CategoryController _categoryController = Get.put(CategoryController());
  final MarketCouponController _couponController =
      Get.put(MarketCouponController());
  final BestMarketsController _bestMarketsController =
      Get.put(BestMarketsController());
  final MostViewedMarketsController _mostViewedMarketsController =
      Get.put(MostViewedMarketsController());
  final ProductsController _productsController = Get.put(ProductsController());
  final BannersController _bannersController = Get.put(BannersController());
  final ViewCountController viewCountController =
      Get.put(ViewCountController());

  final ThemeController themeController =
      Get.put(ThemeController()); // Access ThemeController

  @override
  void initState() {
    if (kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message received');

        if (message.notification != null) {
          // Show the notification in the UI, e.g., in a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: CustomTextSolveIssue(
              '${'notification'.tr}/n'
              '${message.notification!.title!}'
              '${message.notification!.body!}',
              style: TextStyle(fontSize: 16.w),
            )),
          );
        }
      });
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPrefsConstants.isLoggedIn().then((isLoggedIn) {
        final favoriteController = Get.put(FavoriteController());
        if (isLoggedIn) {
          favoriteController.getFavorites();
        } else {
          favoriteController.errorMessage('');
          favoriteController.isLoading(false);
        }
      });
    });
  }

  List<Product> _getMixedProducts() {
    // Group products by category
    final Map<int, List<Product>> groupedProducts = {};
    for (var product in _productsController.products) {
      groupedProducts.putIfAbsent(1, () => []).add(product);
      print('product id =============>${product.id}');
    }

    // Select up to 4 products, prioritizing variety across categories
    final List<Product> mixedProducts = [];
    final List<int> categoryIds = groupedProducts.keys.toList();
    int productsToTake = 4; // Maximum number of products to display
    int productsPerCategory =
        ((productsToTake != 0) ? productsToTake : 1 / categoryIds.length)
            .ceil();

    for (var categoryId in categoryIds) {
      final categoryProducts =
          groupedProducts[categoryId]!.take(productsPerCategory).toList();
      mixedProducts.addAll(categoryProducts);
      if (mixedProducts.length >= productsToTake) break;
    }

    // If fewer than 4 products, add more from any category
    if (mixedProducts.length < productsToTake) {
      final remainingProducts = _productsController.products
          .where((p) => !mixedProducts.contains(p))
          .take(productsToTake - mixedProducts.length)
          .toList();
      mixedProducts.addAll(remainingProducts);
    }

    return mixedProducts.take(4).toList();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final isArabic = Get.locale?.languageCode == 'ar';
    return AdaptiveLayOut(mobile: Obx(
      () {
        bool isDark = themeController.themeMode.value == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  MainAppHeader(
                    onTap: () {
                      Get.to(() => ProductsScreen(
                            categoryId: '1',
                            fromSeeAll: true,
                          ));
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
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        _buildBannerCarousel(screenWidth, screenHeight),

                        //list of category
                        Column(
                          children: [
                            Obx(() => _categoryController.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : _buildHorizontalCategoryList(
                                    categories: _categoryController.categories,
                                    itemBuilder: (context, category) =>
                                        CircularCategoryItem(
                                      label: Get.locale?.languageCode == 'ar'
                                          ? category.nameAr
                                          : category.nameEn,
                                      imageUrl: category.image,
                                      backgroundColor:
                                          AppColors.lightBlueBackgroundContiner,
                                      isSelected: false,
                                      onTap: () {
                                        Get.to(() => ProductsScreen(
                                              categoryId:
                                                  category.id.toString(),
                                              fromSeeAll: true,
                                            ));
                                        debugPrint(
                                            'Category Tapped: ${category.nameEn}');
                                      },
                                    ),
                                  )),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        // best stores
                        Obx(() => _bestMarketsController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : _bestMarketsController
                                    .errorMessage.value.isNotEmpty
                                ? Center(
                                    child: CustomTextSolveIssue(
                                        'error_message'.tr))
                                : _buildStoreGridSection(
                                    homeGrid: true,
                                    logoHeight: 75.h,
                                    title: 'best_stores'.tr,
                                    markets: _bestMarketsController.markets
                                        .take(8)
                                        .toList(),
                                    onSeeAllTap: () {
                                      Get.to(() => AllMarketsScreen(
                                            controller: _bestMarketsController,
                                            title: 'best_stores'.tr,
                                            fromSeeAll: true,
                                          ));
                                    },
                                    screenWidth: screenWidth,
                                  )),

                        SizedBox(height: screenHeight * 0.025),

                        PromoBanner(location: 'top'),

                        SizedBox(height: screenHeight * 0.025),
                        // list of category products
                        Obx(
                          () => _productsController.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : _productsController
                                      .errorMessage.value.isNotEmpty
                                  ? Center(
                                      child: CustomTextSolveIssue(
                                          'error_message'.tr))
                                  : _buildProductGridSection(
                                      imageHeight: 200.h,
                                      showSwitchList: false,
                                      title: 'منتجات مختارة'.tr,
                                      //m
                                      products: _getMixedProducts(),
                                      onSeeAllTap: () {
                                        Get.to(() => ProductsScreen(
                                              fromSeeAll: true,
                                              categoryId: '1',
                                            )); // No specific categoryId
                                        debugPrint(
                                            'See All Mixed Products Tapped');
                                      },
                                      screenWidth: screenWidth,
                                    ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        OffersSection(),

                        SizedBox(height: screenHeight * 0.025),
                        //common stores
                        Obx(() => _mostViewedMarketsController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : _mostViewedMarketsController
                                    .errorMessage.value.isNotEmpty
                                ? Center(
                                    child: CustomTextSolveIssue(
                                        'error_message'.tr))
                                : _buildStoreGridSection(
                                    homeGrid: true,
                                    logoHeight: 75.h,
                                    title: 'popular_stores'.tr,
                                    markets: _mostViewedMarketsController
                                        .markets
                                        .take(8)
                                        .toList(),
                                    onSeeAllTap: () {
                                      Get.to(() => AllMarketsScreen(
                                            controller:
                                                _mostViewedMarketsController,
                                            title: 'popular_stores'.tr,
                                            fromSeeAll: true,
                                          ));
                                    },
                                    screenWidth: screenWidth,
                                  )),

                        // SizedBox(height: screenHeight * 0.015),
                        // coupons
                        Obx(() => _couponController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : _couponController.errorMessage.value.isNotEmpty
                                ? Center(
                                    child: CustomTextSolveIssue(
                                        'error_message'.tr))
                                : _buildCouponsSection(
                                    title: 'coupons'.tr,
                                    coupons: _couponController.coupons
                                        .take(6)
                                        .toList(),
                                    onSeeAllTap: () {
                                      Get.to(() =>
                                          CouponsScreen(fromSeeAll: true));
                                      debugPrint('See All Coupons Tapped');
                                    },
                                    screenHeight: screenHeight,
                                  )),
                        PromoBanner(location: 'bottom'),
                        // SizedBox(height: screenHeight * 0.025),
                        // show categories home screen
                        ShowCategoriesHomeScreen(),
                        //============================
                        // SizedBox(height: screenHeight * 0.025),
                        // Obx(() => _productsController.isLoading.value
                        //     ? const Center(child: CircularProgressIndicator())
                        //     : _productsController.errorMessage.value.isNotEmpty
                        //         ? Center(child: CustomTextSolveIssue('error_message'.tr))
                        //         : _buildProductGridSection(
                        //             title: 'التجميل'.tr,
                        //             products: _productsController.products
                        //                 .where((p) => p.categoryId == 9)
                        //                 .take(4)
                        //                 .toList(),
                        //             onSeeAllTap: () {
                        //               Get.to(() => ProductsScreen(
                        //                     categoryId: '9',
                        //                     fromSeeAll: true,
                        //                   ));
                        //               debugPrint('See All Perfumes Tapped');
                        //             },
                        //             screenWidth: screenWidth,
                        //           )),
                        SizedBox(height: screenHeight * 0.025),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ), desktop: Obx(
      () {
        bool isDark = themeController.themeMode.value == ThemeMode.dark;
        final isArabic = Get.locale?.languageCode == 'ar';
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  GlobalWebHeader(
                    scrollController: _scrollController,
                  ),
                  Expanded(
                    child: ListView(
                      controller: _scrollController,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 90.w),
                          child: Column(
                            children: [
                              SizedBox(height: 50.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child:
                                    _buildBannerCarousel(200.w, screenHeight),
                              ),
                              // SizedBox(height:24.h),
                              SizedBox(height: 50.h),
                              //list of category
                              Obx(() => _categoryController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _buildHorizontalCategoryList(
                                      physics: NeverScrollableScrollPhysics(),
                                      categories:
                                          _categoryController.categories,
                                      itemBuilder: (context, category) =>
                                          CircularCategoryItem(
                                        width: 130.w,
                                        label: Get.locale?.languageCode == 'ar'
                                            ? category.nameAr
                                            : category.nameEn,
                                        imageUrl: category.image,
                                        backgroundColor: AppColors
                                            .lightBlueBackgroundContiner,
                                        isSelected: false,
                                        onTap: () {
                                          Get.to(() => ProductsScreen(
                                                categoryId:
                                                    category.id.toString(),
                                                fromSeeAll: true,
                                              ));
                                          debugPrint(
                                              'Category Tapped: ${category.nameEn}');
                                        },
                                      ),
                                    )),
                              SizedBox(height: 40.h),
                              // best stores
                              Obx(() => _bestMarketsController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _bestMarketsController
                                          .errorMessage.value.isNotEmpty
                                      ? Center(
                                          child: CustomTextSolveIssue(
                                              'error_message'.tr))
                                      : _buildStoreGridSection(
                                          padding: EdgeInsets.only(top: 30.h),
                                          titleFontSize: 12.w,
                                          logoHeight: 50.h,
                                          title: 'best_stores'.tr,
                                          markets: _bestMarketsController
                                              .markets
                                              .take(8)
                                              .toList(),
                                          onSeeAllTap: () {
                                            Get.to(() => AllMarketsScreen(
                                                  controller:
                                                      _bestMarketsController,
                                                  title: 'best_stores'.tr,
                                                  fromSeeAll: true,
                                                ));
                                          },
                                          screenWidth: screenWidth,
                                        )),

                              SizedBox(height: 50.h),

                              PromoBanner(
                                location: 'top',
                                bannerHeight: 250.h,
                              ),

                              SizedBox(height: 50.h),
                              // list of category products
                              Obx(
                                () => _productsController.isLoading.value
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : _productsController
                                            .errorMessage.value.isNotEmpty
                                        ? Center(
                                            child: CustomTextSolveIssue(
                                                'error_message'.tr))
                                        : _buildProductGridSection(
                                            showSwitchList: false,
                                            imageHeight: 160.h,
                                            crossAxisCount: 4,
                                            priceCanceledFontSize: 10.w,
                                            storeFontSize: 12.w,
                                            priceFontSize: 18.w,
                                            descriptionFontSize: 10.w,
                                            cardRatio: 0.5,
                                            title: 'منتجات مختارة'.tr,
                                            products: _getMixedProducts(),
                                            onSeeAllTap: () {
                                              Get.to(() => ProductsScreen(
                                                    fromSeeAll: true,
                                                    categoryId: '1',
                                                  )); // No specific categoryId
                                              debugPrint(
                                                  'See All Mixed Products Tapped');
                                            },
                                            screenWidth: screenWidth,
                                          ),
                              ),

                              SizedBox(height: 50.h),

                              OffersSection(
                                offerCardHeight: 175.h,
                                offerCardWidth: 175.h,
                                logoHeight: 30.h,
                                marketNameSize: 20.sp,
                                offerFontSize: 24.w,
                                descriptionFontSize: 18.w,
                              ),

                              SizedBox(height: 50.h),
                              //common stores
                              Obx(() => _mostViewedMarketsController
                                      .isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _mostViewedMarketsController
                                          .errorMessage.value.isNotEmpty
                                      ? Center(
                                          child: CustomTextSolveIssue(
                                              'error_message'.tr))
                                      : _buildStoreGridSection(
                                          padding: EdgeInsets.only(top: 30.h),
                                          logoHeight: 60.h,
                                          titleFontSize: 12.w,
                                          title: 'popular_stores'.tr,
                                          markets: _mostViewedMarketsController
                                              .markets
                                              .take(8)
                                              .toList(),
                                          onSeeAllTap: () {
                                            Get.to(() => AllMarketsScreen(
                                                  controller:
                                                      _mostViewedMarketsController,
                                                  title: 'popular_stores'.tr,
                                                  fromSeeAll: true,
                                                ));
                                          },
                                          screenWidth: screenWidth,
                                        )),

                              SizedBox(height: 50.h),
                              // coupons
                              Obx(() => _couponController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _couponController
                                          .errorMessage.value.isNotEmpty
                                      ? Center(
                                          child: CustomTextSolveIssue(
                                              'error_message'.tr))
                                      : _buildCouponsSection(
                                          title: 'coupons'.tr,
                                          coupons: _couponController.coupons
                                              .take(6)
                                              .toList(),
                                          onSeeAllTap: () {
                                            Get.to(() => CouponsScreen(
                                                fromSeeAll: true));
                                            debugPrint(
                                                'See All Coupons Tapped');
                                          },
                                          screenHeight: screenHeight,
                                          logoHeight: 25.h)),
                              SizedBox(height: 50.h),
                              PromoBanner(location: 'bottom'),
                              // SizedBox(height: 50.h),
                              // show categories home screen
                              ShowCategoriesHomeScreen(),

                              SizedBox(height: 50.h),
                            ],
                          ),
                        ),
                        FooterWidget()
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ));
  }

  Widget _buildBannerCarousel(double screenWidth, double screenHeight,
      {EdgeInsetsGeometry? padding}) {
    final isArabic = Get.locale?.languageCode == 'ar';

    return Obx(() => Padding(
          padding: padding ?? EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            children: [
              _bannersController.isLoading.value
                  ? SizedBox(
                      height: screenHeight * 0.27,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : _bannersController.errorMessage.value.isNotEmpty ||
                          _bannersController.banners.isEmpty
                      ? SizedBox(
                          height: screenHeight * 0.27,
                          child: Center(
                            child: CustomTextSolveIssue(
                              'no_data'.tr,
                              style: GoogleFonts.tajawal(
                                fontSize: screenWidth * 0.045,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                      : CarouselSlider.builder(
                          carouselController: _bannerCarouselController,
                          options: CarouselOptions(
                            height: 254.h,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            enableInfiniteScroll:
                                _bannersController.banners.length > 1,
                          ),
                          itemCount: _bannersController.banners.length,
                          itemBuilder: (context, itemIndex, pageViewIndex) {
                            final banner =
                                _bannersController.banners[itemIndex];
                            final link = banner.link.trim() ?? '';
                            final hasValidLink = link.isNotEmpty &&
                                Uri.tryParse(link)?.hasScheme == true;

                            // handle extract percentage number from text
                            final String title = isArabic
                                ? banner.titleAr ?? ''
                                : banner.titleEn ?? '';
                            final regex = RegExp(r'(\d+(\.\d+)?)%');
                            final match = regex.firstMatch(
                              title,
                            );
                            final String titleWithoutPercentage =
                                title.replaceAll(match?.group(0) ?? '', '');

                            //============

                            return GestureDetector(
                              onTap: () async {
                                print(link);
                                if (link.isEmpty || link == null) {
                                  return;
                                }
                                print('Attempting to open link: $link');
                                // Normalize URL if scheme is missing
                                String normalizedUrl = link;
                                if (!link.startsWith(RegExp(r'https?://'))) {
                                  normalizedUrl = 'https://$link';
                                }
                                final uri = Uri.tryParse(normalizedUrl);
                                if (uri != null) {
                                  try {
                                    final canLaunch = await canLaunchUrl(uri);
                                    if (canLaunch) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                      print(
                                          'Successfully opened: $normalizedUrl');
                                    } else {
                                      print(
                                          'Cannot launch URL: $normalizedUrl');
                                      Get.snackbar(
                                        'خطأ',
                                        'لا يمكن فتح الرابط: الرابط غير مدعوم',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 3),
                                      );
                                    }
                                  } catch (e) {
                                    print('Error launching URL: $e');
                                    Get.snackbar(
                                      'خطأ',
                                      'حدث خطأ أثناء فتح الرابط: $e',
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 3),
                                    );
                                  }
                                } else {
                                  print('Invalid URL: $normalizedUrl');
                                  Get.snackbar(
                                    'خطأ',
                                    'الرابط غير صالح: $normalizedUrl',
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 3),
                                  );
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(kIsWeb
                                    ? screenWidth * 0.08
                                    : screenWidth * 0.03),
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Image.network(
                                        banner.image,
                                        fit: BoxFit.fill,
                                        height: 250.h,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              kIsWeb
                                                  ? screenWidth * 0.08
                                                  : screenWidth * 0.03),
                                          child: Image.asset(
                                            'assets/images/Rectangle 22489.png',
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                            height: 262.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //text discount

                                    Positioned(
                                      bottom: 60.h,
                                      right: 40,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CustomText(
                                                text: title,
                                                fontSizes: 17.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.red,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ));
  }

  Widget _buildStoreGridSection({
    required String title,
    required List<Market> markets,
    VoidCallback? onSeeAllTap,
    required double screenWidth,
    double? logoHeight,
    double? titleFontSize,
    bool? homeGrid = false,
    EdgeInsetsGeometry? padding,
  }) {
    int crossAxisCount = screenWidth > 600 ? 6 : 4;
    final isArabic = Get.locale?.languageCode == 'ar';
    return markets.isEmpty
        ? SizedBox.shrink(
            // child: Padding(
            //         padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
            //         child: Center(
            // child: CustomTextSolveIssue(
            //   'no_data'.tr,
            //   style: GoogleFonts.tajawal(
            //     fontSize: screenWidth * 0.04,
            //     color: Colors.black54,
            //   ),
            // ),
            //         ),
            //       ),
            )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextSolveIssue(
                      title,
                      style: GoogleFonts.tajawal(
                        // Consistent font
                        fontSize: 22, // Slightly larger header font
                        fontWeight: FontWeight.bold,
                        color: Color(0xff666565),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (onSeeAllTap != null)
                      Row(
                        children: [
                          TextButton(
                            onPressed: onSeeAllTap,
                            child: CustomTextSolveIssue(
                              'see_all'.tr,
                              style: GoogleFonts.tajawal(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors
                                    .grey, // Use primary color for action text
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              GridView.builder(
                padding: padding ?? EdgeInsets.zero,
                itemCount: homeGrid!
                    ? markets.length <= 8
                        ? markets.length
                        : 8
                    : markets.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.0,
                  // crossAxisSpacing: 10
                ),
                itemBuilder: (context, index) {
                  final market = markets[index];
                  return StoreGridItem(
                    //make width and height the 100% same value to rounded the container widget
                    width: logoHeight,
                    height: logoHeight,
                    titleFontSize: titleFontSize,
                    store: market,
                    onTap: () async {
                      final success = await viewCountController
                          .incrementMarketViews(market.id!);
                      debugPrint(
                          'Market Views Increment for ${market.name}: $success');
                      Get.to(() => StoreDetails(marketId: market.id));
                      debugPrint('Store Tapped: ${market.name}');
                    },
                    // onFavoriteTap: () {
                    //   debugPrint('Favorite status changed for market: ${market.id}');
                    // },
                  );
                },
              ),
            ],
          );
  }

  Widget _buildHorizontalCategoryList(
      {String? title,
      required List<kCategory> categories,
      required Widget Function(BuildContext, kCategory) itemBuilder,
      double itemHeight = kIsWeb ? 160 : 80,
      VoidCallback? onSeeAllTap,
      EdgeInsetsGeometry? padding,
      ScrollPhysics? physics}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            child: SectionHeader(
              title: title,
              actionText: onSeeAllTap != null ? 'view_all'.tr : null,
              onActionPressed: onSeeAllTap,
            ),
          ),
        categories.isEmpty
            ? SizedBox(
                height: itemHeight,
                child: Center(
                  child: CustomTextSolveIssue(
                    'no_data'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextSolveIssue(
                          'الفئات',
                          style: GoogleFonts.tajawal(
                            // Consistent font
                            fontSize: 22, // Slightly larger header font
                            fontWeight: FontWeight.bold,
                            color: Color(0xff666565),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.categoriesScreen,
                                    arguments: _categoryController.categories);
                              },
                              child: CustomTextSolveIssue(
                                'see_all'.tr,
                                style: GoogleFonts.tajawal(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors
                                      .grey, // Use primary color for action text
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: itemHeight,
                    child: ListView.builder(
                      physics: physics,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      padding: padding ??
                          EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.03),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01),
                          child: itemBuilder(context, categories[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildProductGridSection({
    required String title,
    required List<Product> products,
    VoidCallback? onSeeAllTap,
    required double screenWidth,
    double? cardRatio,
    double? priceFontSize,
    double? storeFontSize,
    double? descriptionFontSize,
    double? priceCanceledFontSize,
    double? imageHeight,
    int? crossAxisCount,
    bool? showSwitchList,
  }) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final isArabic = Get.locale?.languageCode == 'ar';
    return products.isEmpty
        ? SizedBox.shrink(
            // child: Padding(
            //         padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
            //         child: Center(
            // child: CustomTextSolveIssue(
            //   'لا يوجد حاليا',
            //   style: GoogleFonts.tajawal(
            //     fontSize: screenWidth * 0.04,
            //     color: Colors.black54,
            //   ),
            // ),
            //         ),
            //       ),
            )
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SectionHeader(
                  title: title,
                  actionText: onSeeAllTap != null ? 'see_all'.tr : null,
                  onActionPressed: onSeeAllTap,
                ),
              ),
              GlobalViewProducts(
                isDark,
                isArabic,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                products: products,
                crossAxisCount: crossAxisCount ?? 2,
                cardRatio: cardRatio ?? 0.63.h,
                imageHeight: imageHeight,
                priceCanceledFontSize: priceCanceledFontSize,
                descriptionFontSize: descriptionFontSize,
                priceFontSize: priceFontSize,
                storeFontSize: storeFontSize,
                showSwitchList: showSwitchList,
              )
            ],
          );
  }

  Widget _buildCouponsSection({
    required String title,
    required List<MarketCoupon> coupons,
    VoidCallback? onSeeAllTap,
    required double screenHeight,
    double? logoHeight,
  }) {
    return coupons.isEmpty
        ? SizedBox.shrink(
            // height: screenHeight * 0.3,
            // child: Center(
            //   child: CustomTextSolveIssue(
            //     'no_data'.tr,
            //     style: GoogleFonts.tajawal(
            //       fontSize: MediaQuery.of(context).size.width * 0.04,
            //       color: Colors.black54,
            //     ),
            //   ),
            // ),
            )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SectionHeader(
                  title: title,
                  actionText: onSeeAllTap != null ? 'see_all'.tr : null,
                  onActionPressed: onSeeAllTap,
                ),
              ),
              SizedBox(
                height: kIsWeb ? 230.h : screenHeight * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: coupons.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  itemBuilder: (context, index) {
                    final coupon = coupons[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.01),
                      child: CouponCardGrid(
                        logoHeight: logoHeight,
                        onTap: () {
                          // Get.to(() => CouponDetailsScreen(coupon: coupon));
                          debugPrint('Coupon Tapped: ${coupon.couponCode}');
                        },
                        coupon: coupon,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.025),

            ],
          );
  }
}
