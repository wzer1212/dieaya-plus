import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_favourite_button.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_product_card_gird_view.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/view_products.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../UI/pages/ProductsScreen/product_details.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/FavController/fav_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../widgets/custom_sheets.dart';
import '../NotificationsScreen/notifications_screen.dart';
import '../StoresScreen/store_details.dart';

import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class MyFavScreen extends StatefulWidget {
  const MyFavScreen({super.key});

  @override
  State<MyFavScreen> createState() => _MyFavScreenState();
}

class _MyFavScreenState extends State<MyFavScreen> {
  String selectedTab = 'products'; // Default tab
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    // Schedule getFavorites() after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<FavoriteController>().getFavorites();
    });
  }

  final ThemeController themeController = Get.put(ThemeController());
  ScrollController _scrollController=ScrollController ();

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return AdaptiveLayOut(
        mobile: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [
                            AppColors.primary,
                            AppColors.primary,
                            Colors.black,
                          ]
                        : [
                            AppColors.primary,
                            AppColors.primary,
                            Colors.white,
                          ],
                    stops: [0.0, 0.0, 5.0],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenWidth * 0.15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: SvgPicture.asset(
                          'assets/svg/backbutton.svg',
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                      CustomTextSolveIssue(
                        'favorites_title'.tr, // Instead of 'قائمة المفضلة'
                        style: GoogleFonts.tajawal(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/svg/notify.svg',
                                width: screenWidth * 0.06,
                                height: screenWidth * 0.06,
                                colorFilter: const ColorFilter.mode(
                                    Colors.black54, BlendMode.srcIn),
                              ),
                              onPressed: () async {
                                bool isLoggedIn =
                                    await SharedPrefsConstants.isLoggedIn();
                                if (isLoggedIn) {
                                  Get.to(() => NotificationsScreen());
                                } else {
                                  CustomSheets.showLoginSheet(context);
                                  print(
                                      'Favorites Tapped - Showing Login Bottom Sheet');
                                }
                              },
                            ),
                            Positioned(
                              right: screenWidth * 0.025,
                              top: screenWidth * 0.025,
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.005),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: screenWidth * 0.02,
                                  minHeight: screenWidth * 0.02,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenWidth * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabButton('products', 'products_tab'.tr),
                    SizedBox(width: screenWidth * 0.03),
                    _buildTabButton('offers', 'offers_tab'.tr),
                    SizedBox(width: screenWidth * 0.03),
                    _buildTabButton('stores', 'stores_tab'.tr),
                  ],
                ),
              ),
             if( selectedTab != 'products')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
              ),
              Expanded(
                child: Obx(() => _buildTabContent(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),

                  imageHeight: 220.h,

                )),
              ),
            ],
          ),
        ),
        desktop: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Column(
            children: [
              GlobalWebHeader(scrollController: _scrollController),
              Expanded(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    children: [

                      SizedBox(
                        height: 60.h,
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 55.w),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenWidth * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTabButton('products', 'products_tab'.tr,
                                      labelFontSize: 16.w),
                                  SizedBox(width: 10.w),
                                  _buildTabButton('offers', 'offers_tab'.tr,
                                      labelFontSize: 16.w),
                                  SizedBox(width: 10.w),
                                  _buildTabButton('stores', 'stores_tab'.tr,
                                      labelFontSize: 16.w),
                                ],
                              ),
                            ),
                            if( selectedTab != 'products')
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                              ),
                            Obx(() {
                              final controller = Get.find<FavoriteController>();
                              if (controller.isLoading.value) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (controller.errorMessage.value.isNotEmpty) {
                                return Center(
                                  child: CustomTextSolveIssue(
                                    'no_items'.tr,
                                    style: GoogleFonts.tajawal(
                                      fontSize: 16.w,
                                      color: Colors.black54,
                                    ),
                                  ),
                                );
                              }
                              final favorites = controller.favorites.value;
                              final isArabic = Get.locale?.languageCode == 'ar';

                              if (favorites == null) {
                                return Center(
                                  child: CustomTextSolveIssue(
                                    'no_items'.tr,
                                    style: GoogleFonts.tajawal(
                                      fontSize: 16.w,
                                      color: Colors.black54,
                                    ),
                                  ),
                                );
                              }

                              switch (selectedTab) {
                                case 'products':
                                  return GlobalViewProducts(
                                    isDark,
                                    isArabic,
                                    products: favorites.products,
                                    imageHeight: 160.h,
                                    crossAxisCount: 4,
                                    priceCanceledFontSize: 10.w,
                                    storeFontSize: 12.w,
                                    priceFontSize: 18.w,
                                    descriptionFontSize: 10.w,
                                    cardRatio: 0.5,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    isGrid: controller.isGrid,
                                  );

                                case 'offers':
                                  return isGridView
                                      ? OfferGridView2(
                                          offers: favorites.offers,
                                          cardRation: 0.6,
                                          crossAxisCount: 4,
                                          emptyCaseFontSize: 18.w,
                                          logoHeight: 30.h,
                                          offerFontSize: 21.w,
                                          marketFontSize: 16.w,
                                          descriptionFontSize: 18.w,
                                        )
                                      : OfferListView2(offers: favorites.offers);
                                case 'stores':
                                  return isGridView
                                      ? StoreGridView(markets: favorites.markets)
                                      : StoreListView(markets: favorites.markets);
                                default:
                                  return GlobalViewProducts(
                                    isDark,
                                    isArabic,
                                    products: favorites.products,
                                    crossAxisCount: 4,
                                    priceCanceledFontSize: 14.w,
                                    storeFontSize: 16.w,
                                    priceFontSize: 21.w,
                                    descriptionFontSize: 14.w,
                                    cardRatio: 0.6,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    imageHeight: 165.h,
                                    isGrid: controller.isGrid,
                                  );
                                  ;
                              }
                            }

                                ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      FooterWidget()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTabButton(String tabId, String label, {double? labelFontSize}) {
    final bool isSelected = selectedTab == tabId;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedTab = tabId;
        });
      },
      child: CustomTextSolveIssue(
        label.tr,
        style: GoogleFonts.tajawal(
          fontSize: labelFontSize ?? MediaQuery.of(context).size.width * 0.04,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.grey,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : AppColors.primary,
        backgroundColor: isSelected ? Colors.transparent : Colors.transparent,
        side:
            BorderSide(color: isSelected ? AppColors.primary : AppColors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  Widget _buildTabContent({
    double? emptyCaseFontSize,
    final double? priceFontSize,
    final double? priceCanceledFontSize,
    final double? storeFontSize,
    final double? descriptionFontSize,
    final int? crossAxisCount,
    final double? cardRatio,
    final double? imageHeight,
    final double? productCardListHeight,
    final bool? shrinkWrap,
    final ScrollPhysics? physics,
  }) {
    final controller = Get.find<FavoriteController>();
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.errorMessage.value.isNotEmpty) {
      return Center(
        child: CustomTextSolveIssue(
          'no_items'.tr,
          style: GoogleFonts.tajawal(
            fontSize:
                emptyCaseFontSize ?? MediaQuery.of(context).size.width * 0.04,
            color: Colors.black54,
          ),
        ),
      );
    }
    final favorites = controller.favorites.value;
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final isArabic = Get.locale?.languageCode == 'ar';
    if (favorites == null) {
      return Center(
        child: CustomTextSolveIssue(
          'no_items'.tr,
          style: GoogleFonts.tajawal(
            fontSize:
                emptyCaseFontSize ?? MediaQuery.of(context).size.width * 0.04,
            color: Colors.black54,
          ),
        ),
      );
    }

    switch (selectedTab) {
      case 'products':
        return GlobalViewProducts(
          isDark,
          isArabic,
          imageHeight: imageHeight,
          products: favorites.products,
          crossAxisCount: crossAxisCount,
          priceCanceledFontSize: priceCanceledFontSize,
          storeFontSize: storeFontSize,
          priceFontSize: priceFontSize,
          descriptionFontSize: descriptionFontSize,
          cardRatio: cardRatio,
          shrinkWrap: shrinkWrap,
          physics: physics,
          isGrid:controller.isGrid
        );
      case 'offers':
        return isGridView
            ? OfferGridView2(offers: favorites.offers)
            : OfferListView2(offers: favorites.offers);
      case 'stores':
        return isGridView
            ? StoreGridView(markets: favorites.markets)
            : StoreListView(markets: favorites.markets);
      default:
        return isGridView
            ? ProductGridView(
                products: favorites.products,
                crossAxisCount: 4,
                priceCanceledFontSize: 10.w,
                storeFontSize: 14.w,
                priceFontSize: 16.w,
                descriptionFontSize: 12.w,
                cardRatio: 0.5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )
            : ProductListView(
                products: favorites.products,
                productCardListHeight: productCardListHeight,
                priceCanceledFontSize: priceCanceledFontSize,
                storeFontSize: storeFontSize,
                descriptionFontSize: descriptionFontSize,
                physics: physics,
                priceFontSize: priceFontSize,
              );
    }
  }
}

class ProductGridView extends StatelessWidget {
  final List<Product> products;
  final double? priceFontSize;
  final double? priceCanceledFontSize;
  final double? storeFontSize;
  final double? descriptionFontSize;
  final ScrollPhysics? physics;
  final int? crossAxisCount;
  final double? cardRatio;
  final bool? shrinkWrap;
  final double? imageHeight;

  const ProductGridView({
    super.key,
    required this.products,
    this.priceFontSize,
    this.priceCanceledFontSize,
    this.storeFontSize,
    this.descriptionFontSize,
    this.crossAxisCount,
    this.cardRatio,
    this.shrinkWrap,
    this.physics,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return products.isEmpty
        ? Center(
            child: CustomTextSolveIssue(
              'no_items'.tr,
              style: GoogleFonts.tajawal(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(screenWidth * 0.03),
            shrinkWrap: shrinkWrap ?? true,
            physics: physics ?? const ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount ?? 2,
              crossAxisSpacing: screenWidth * 0.03,
              mainAxisSpacing: screenWidth * 0.03,
              childAspectRatio: cardRatio ?? 0.60,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GlobalProductCardGrid(
                imageHeight: imageHeight,
                priceCanceledFontSize: priceCanceledFontSize,
                storeFontSize: storeFontSize,
                priceFontSize: priceFontSize,
                descriptionFontSize: descriptionFontSize,
                product: product,
                onTap: () {
                  Get.to(() => ProductDetailScreen(
                    product: product,
                    logo: product.market.logo,
                    title: product.market.nameAr,
                    marketId: product.market.id,
                  ));
                  debugPrint('Product Tapped: ${product.nameAr}');
                },
              );
            },
          );
  }
}

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final double? productCardListHeight;
  final double? priceFontSize;
  final double? priceCanceledFontSize;
  final double? storeFontSize;
  final double? descriptionFontSize;
  final ScrollPhysics? physics;

  const ProductListView(
      {super.key,
      required this.products,
      this.productCardListHeight,
      this.priceFontSize,
      this.priceCanceledFontSize,
      this.storeFontSize,
      this.descriptionFontSize,
      this.physics});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return products.isEmpty
        ? Center(
            child: CustomTextSolveIssue(
              'no_items'.tr,
              style: GoogleFonts.tajawal(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(screenWidth * 0.03),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCardList(
                productCardListHeight: productCardListHeight,
                physics: physics,
                descriptionFontSize: descriptionFontSize,
                storeFontSize: storeFontSize,
                priceCanceledFontSize: priceCanceledFontSize,
                priceFontSize: priceFontSize,
                product: product,
                onTap: () {
                  Get.to(() => ProductDetailScreen(
                    product: product,
                    logo: product.market.logo,
                    title: product.market.nameAr,
                    marketId: product.market.id,
                  ));
                  debugPrint('Product Tapped: ${product.nameAr}');
                },
              );
            },
          );
  }
}

class OfferGridView2 extends StatelessWidget {
  final List<MarketOfferFav> offers;
  final double? cardRation;
  final double? emptyCaseFontSize;
  final double? logoHeight;
  final double? marketFontSize;
  final double? offerFontSize;
  final double? descriptionFontSize;
  final int? crossAxisCount;

  const OfferGridView2(
      {super.key,
      required this.offers,
      this.cardRation,
      this.emptyCaseFontSize,
      this.crossAxisCount,
      this.logoHeight,
      this.marketFontSize,
      this.offerFontSize,
      this.descriptionFontSize});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return offers.isEmpty
        ? Center(
            child: CustomTextSolveIssue(
              'no_items'.tr,
              style: GoogleFonts.tajawal(
                fontSize: emptyCaseFontSize ?? screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(3),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount ?? 2,
              mainAxisSpacing: screenWidth * 0.02,
              childAspectRatio: cardRation ?? 0.80,
            ),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return OfferCardGrid2(
                descriptionFontSize: descriptionFontSize,
                offerFontSize: offerFontSize,
                logoHeight: logoHeight,
                marketFontSize: marketFontSize,
                offer: offer,
                // onTap: () {
                //   Get.to(() => OfferDetailsScreen(offer: offer));
                //   debugPrint('Offer Tapped: ${offer.descriptionAr}');
                // },
              );
            },
          );
  }
}

class OfferListView2 extends StatelessWidget {
  final List<MarketOfferFav> offers;

  const OfferListView2({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return offers.isEmpty
        ? Center(
            child: CustomTextSolveIssue(
              'no_items'.tr,
              style: GoogleFonts.tajawal(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(screenWidth * 0.03),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return OfferCardList2(
                offer: offer,
              );
            },
          );
  }
}

class StoreGridView extends StatelessWidget {
  final List<MarketFav> markets;

  const StoreGridView({super.key, required this.markets});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return markets.isEmpty
        ? Center(
            child: CustomTextSolveIssue(
              'no_items'.tr,
              style: GoogleFonts.tajawal(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(screenWidth * 0.03),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: screenWidth * 0.03,
              mainAxisSpacing: screenWidth * 0.03,
              childAspectRatio: 1.0,
            ),
            itemCount: markets.length,
            itemBuilder: (context, index) {
              final market = markets[index];
              return StoresCardGridFav(
                market: market,
                onTap: () {
                  Get.to(() => StoreDetails(marketId: market.id));
                  debugPrint('Store Tapped: ${market.name}');
                },
              );
            },
          );
  }
}

class StoreListView extends StatelessWidget {
  final List<MarketFav> markets;

  const StoreListView({super.key, required this.markets});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return markets.isEmpty
        ? Center(
            child: CustomTextSolveIssue(
              'no_items'.tr,
              style: GoogleFonts.tajawal(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(screenWidth * 0.03),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: markets.length,
            itemBuilder: (context, index) {
              final market = markets[index];
              return StoresCardListFav(
                market: market,
                onTap: () {
                  Get.to(() => StoreDetails(marketId: market.id));
                  debugPrint('Store Tapped: ${market.name}');
                },
              );
            },
          );
  }
}

class ProductCardList extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final double? productCardListHeight;
  final double? priceFontSize;
  final double? priceCanceledFontSize;
  final double? storeFontSize;
  final double? descriptionFontSize;
  final ScrollPhysics? physics;

  const ProductCardList({
    super.key,
    required this.product,
    this.onTap,
    this.productCardListHeight,
    this.priceFontSize,
    this.priceCanceledFontSize,
    this.storeFontSize,
    this.descriptionFontSize,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: productCardListHeight,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.primary, Colors.black]
                : [AppColors.primary, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      child: Image.network(
                        product.images.isNotEmpty
                            ? product.images[0].image
                            : '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      CustomTextSolveIssue(
                        product.market.nameAr,
                        style: GoogleFonts.tajawal(
                          fontSize: storeFontSize ?? cardWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Color(0xff666565),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: cardWidth * 0.45,
                        child: CustomTextSolveIssue(
                          Get.locale?.languageCode == 'ar'
                              ? product.descriptionAr
                              : product.descriptionEn,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.tajawal(
                            fontSize: descriptionFontSize ?? cardWidth * 0.030,
                            // fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        if (product.priceOffer.isNotEmpty &&
                            product.priceOffer != product.price)
                          CustomTextSolveIssue(
                            '${product.price}',
                            style: GoogleFonts.tajawal(
                              fontSize:
                                  priceCanceledFontSize ?? cardWidth * 0.035,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        CustomTextSolveIssue(
                          '${product.priceOffer.isNotEmpty ? product.priceOffer : product.price}',
                          style: GoogleFonts.tajawal(
                            fontSize: priceFontSize ?? cardWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Image.asset(
                          'assets/images/saCurancy.png',
                          height: cardWidth * 0.04,
                          color: isDark ? Colors.white : Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GlobalFavoriteButton(
                      productId: product.id,
                      onFavoriteTap: () {
                        debugPrint(
                            'Favorite status changed for product: ${product.id}');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OfferCardGrid2 extends StatelessWidget {
  final MarketOfferFav offer;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;
  final double? logoHeight;
  final double? marketFontSize;
  final double? offerFontSize;
  final double? descriptionFontSize;

  const OfferCardGrid2({
    super.key,
    required this.offer,
    this.onFavoriteTap,
    this.onTap,
    this.logoHeight,
    this.marketFontSize,
    this.offerFontSize,
    this.descriptionFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.5;
    final cardHeight = cardWidth * 0.6;

    // Extract discount value from descriptionAr or titleAr
    String discountValue = '';
    String discountLabel = 'خصم';
    if (offer.descriptionAr != null) {
      discountValue = offer.descriptionAr!.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = offer.descriptionAr!.replaceAll(discountValue, '').trim();
    } else if (offer.titleAr != null) {
      discountValue = offer.titleAr!.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = offer.titleAr!.replaceAll(discountValue, '').trim();
    }
    if (discountLabel.isEmpty && discountValue.isNotEmpty) {
      discountLabel = 'خصم';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/offergrid2.png',
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            Positioned.fill(
              child: Image.asset(
                'assets/images/OFFER.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
            Positioned(
              top: kIsWeb ? 50.h : cardHeight * 0.05,
              bottom: cardHeight * 0.05,
              left: 15,
              right: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(screenWidth * 0.20),
                        child: Image.network(
                          offer.market.logo,
                          width: logoHeight ?? cardWidth * 0.15,
                          height: logoHeight ?? cardWidth * 0.15,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: cardWidth * 0.15,
                            height: cardWidth * 0.15,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: CustomTextSolveIssue(
                          offer.market.name,
                          style: GoogleFonts.tajawal(
                            fontSize: marketFontSize ?? cardWidth * 0.075,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CustomTextSolveIssue(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          // offer.titleAr ?? 'خصم 50 %',
                          (Get.locale?.languageCode == 'ar'
                                  ? offer.titleAr
                                  : offer.titleEn) ??
                              '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: offerFontSize ?? cardWidth * 0.12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.05),
                    child: CustomTextSolveIssue(
                      // offer.descriptionAr ?? offer.titleAr ?? 'لا يوجد وصف',
                      (Get.locale?.languageCode == 'ar'
                              ? offer.descriptionAr
                              : offer.descriptionEn) ??
                          '',

                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: descriptionFontSize ?? cardWidth * 0.055,
                        color: Colors.grey,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50.h,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary,
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: FavoriteButtonOff(
                  marketOfferId: offer.id,
                  onFavoriteTap: onFavoriteTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferCardList2 extends StatelessWidget {
  final MarketOfferFav offer;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const OfferCardList2({
    super.key,
    required this.offer,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final bool isArabic = Get.locale?.languageCode == 'ar';
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4;
    final cardHeight = cardWidth * 0.56;

    // Extract discount value and label based on language
    String discountValue = '';
    String discountLabel = 'discount'.tr;
    final description = isArabic ? offer.descriptionAr : offer.descriptionEn;
    final title = isArabic ? offer.titleAr : offer.titleEn;

    if (description != null) {
      discountValue = description.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = description.replaceAll(discountValue, '').trim();
    } else if (title != null) {
      discountValue = title.replaceAll(RegExp(r'[^0-9]'), '');
      discountLabel = title.replaceAll(discountValue, '').trim();
    }
    if (discountLabel.isEmpty && discountValue.isNotEmpty) {
      discountLabel = 'discount'.tr;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/offerlist1.png',
                fit: BoxFit.contain,
                width: screenWidth * 0.2,
                height: cardHeight,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            Positioned.fill(
              top: cardHeight * 0.05,
              child: Image.asset(
                'assets/images/offerlist2.png',
                fit: BoxFit.cover,
                width: screenWidth * 0.2,
                height: cardHeight,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
            Positioned(
              left: isArabic ? cardHeight * -0.0 : cardHeight * 3.7,
              // right: isArabic? cardHeight * -0.0:cardHeight * -1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary,
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: FavoriteButtonOff(
                  marketOfferId: offer.id,
                  onFavoriteTap: onFavoriteTap,
                ),
              ),
            ),
            Positioned(
              top: cardHeight * 0.15,
              bottom: cardHeight * 0.08,
              left: isArabic ? cardWidth * 0.40 : cardWidth * 0.10,
              right: isArabic ? cardWidth * 0.05 : cardWidth * 0.30,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: cardWidth * 0.85,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              offer.market.logo,
                              width: cardWidth * 0.30,
                              height: cardWidth * 0.30,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: cardWidth * 0.15,
                                height: cardWidth * 0.15,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextSolveIssue(
                                  offer.market.name,
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.095,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: CustomTextSolveIssue(
                                    (Get.locale?.languageCode == 'ar'
                                            ? offer.descriptionAr
                                            : offer.descriptionEn) ??
                                        '',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.tajawal(
                                      fontSize: cardWidth * 0.075,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextSolveIssue(
                            (isArabic
                                    ? offer.descriptionAr
                                    : offer.descriptionEn) ??
                                '',
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextSolveIssue(
                                discountValue.isNotEmpty ? discountValue : '0',
                                style: GoogleFonts.tajawal(
                                  fontSize: cardWidth * 0.14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 2),
                              CustomTextSolveIssue(
                                '%',
                                style: GoogleFonts.tajawal(
                                  fontSize: cardWidth * 0.055,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoresCardGridFav extends StatelessWidget {
  final MarketFav market;
  final VoidCallback? onTap;

  const StoresCardGridFav({
    super.key,
    required this.market,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;
    final cardHeight = cardWidth * 1.2;
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.primary, Colors.black]
                    : [AppColors.primary, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(cardWidth * 0.08),
            ),
            padding: EdgeInsets.all(cardWidth * 0.005),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(cardWidth * 0.08),
              ),
              child: Padding(
                padding: EdgeInsets.all(cardWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Image, Name, and Favorite Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // Wrap the nested Row with Expanded to prevent overflow
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: cardWidth * 0.2,
                                height: cardWidth * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(cardWidth * 0.1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    market.logo,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: cardWidth * 0.02),
                              Expanded(
                                // Use Expanded for the text to take available space and handle overflow
                                child: CustomTextSolveIssue(
                                  market.name,
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.08,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Color(0xff666565),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FavoriteButton(
                          marketId: market.id,
                          onFavoriteTap: () {
                            debugPrint(
                                'Favorite status changed for market: ${market.id}');
                          },
                        ),
                      ],
                    ),
                    // Store Info Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: cardHeight * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextSolveIssue(
                            market.description ?? '',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.07,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StoresCardListFav extends StatelessWidget {
  final MarketFav market;
  final VoidCallback? onTap;

  const StoresCardListFav({
    super.key,
    required this.market,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.15;
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.primary, Colors.black]
                    : [AppColors.primary, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            padding: EdgeInsets.all(screenWidth * 0.005),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image and Title Section
                    SizedBox(width: screenWidth * 0.010),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.06),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              market.logo,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.008),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.01),
                            // Subtitle (Amazon)
                            CustomTextSolveIssue(
                              market.name,
                              style: GoogleFonts.tajawal(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark ? Colors.white : Color(0xff666565),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            // Title
                            Container(
                              width: screenWidth * 0.6,
                              child: CustomTextSolveIssue(
                                market.description ?? '',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.tajawal(
                                  fontSize: screenWidth * 0.035,
                                  // fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.grey,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Favorite Button
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: screenHeight * 0.01),
                          FavoriteButton(
                            marketId: market.id,
                            onFavoriteTap: () {
                              debugPrint(
                                  'Favorite status changed for market: ${market.id}');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// class ProductDetailScreen extends StatefulWidget {
//   final Product product; // Add product parameter
//
//   const ProductDetailScreen({super.key, required this.product});
//
//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }
//
// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   // --- State for Image Carousel ---
//   int _currentImageIndex = 0;
//   late PageController _pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // --- Get screen dimensions ---
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final ThemeController themeController =
//         Get.put(ThemeController()); // Access ThemeController
//     bool isDark = themeController.themeMode.value == ThemeMode.dark;
//
//     // Use product data from widget.product
//     final productImages = widget.product.images.isNotEmpty
//         ? widget.product.images.map((img) => img.image).toList()
//         : ['assets/images/jaket.png']; // Fallback image
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: SingleChildScrollView(
//         physics: ClampingScrollPhysics(),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: isDark
//                       ? [
//                           AppColors.primary,
//                           AppColors.primary,
//                           Colors.black,
//                         ]
//                       : [
//                           AppColors.primary,
//                           AppColors.primary,
//                           Colors.white,
//                         ],
//                   stops: [0.0, 0.0, 5.0],
//                 ),
//               ),
//               child: Padding(
//                 padding:
//                     EdgeInsets.only(top: 60, left: 8, right: 8, bottom: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         child: SvgPicture.asset(
//                           'assets/svg/backbutton.svg',
//                           width: 40,
//                           height: 40,
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         const appLink =
//                             'https://play.google.com/store/apps/details?id=com.dieayaplus.user';
//                         Share.share(
//                           '$appLink',
//                           sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
//                         );
//                       }, // U
//                       child: Container(
//                         width: 30,
//                         height: 30,
//                         child: SvgPicture.asset(
//                           'assets/svg/share.svg',
//                           width: 30,
//                           height: 30,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: isDark ? AppColors.black : Colors.white,
//                 borderRadius: const BorderRadius.vertical(
//                   bottom: Radius.circular(50.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.4),
//                     spreadRadius: 0,
//                     blurRadius: 5,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: screenHeight * 0.3,
//                     child: PageView.builder(
//                       controller: _pageController,
//                       itemCount: productImages.length,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentImageIndex = index;
//                         });
//                       },
//                       itemBuilder: (context, index) {
//                         return Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                           child: Image.network(
//                             productImages[index],
//                             fit: BoxFit.contain,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(Icons.error, color: Colors.black),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.all(25.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(50),
//                                 child: Image.network(
//                                   widget.product.market.logo, // Market logo
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       const Center(
//                                     child: Icon(
//                                       Icons.broken_image,
//                                       color: Colors.grey,
//                                       size: 40,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             CustomTextSolveIssue(
//                               widget.product.market.nameAr, // Market name
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color:
//                                     isDark ? Colors.white : Color(0xff666565),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 25, left: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children:
//                                 List.generate(productImages.length, (index) {
//                               return Container(
//                                 width: 8.0,
//                                 height: 8.0,
//                                 margin:
//                                     const EdgeInsets.symmetric(horizontal: 4.0),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: _currentImageIndex == index
//                                       ? AppColors.primary
//                                       : Colors.grey.withOpacity(0.5),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomTextSolveIssue(
//                               Get.locale?.languageCode == 'ar'
//                                   ? widget.product.nameAr
//                                   : widget.product.nameEn,
//                               textAlign: TextAlign.right,
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 color: isDark ? Colors.white : AppColors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 15),
//                             Container(
//                               width: 250,
//                               child: CustomTextSolveIssue(
//                                 Get.locale?.languageCode == 'ar'
//                                     ? widget.product.descriptionAr
//                                     : widget.product.descriptionEn,
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: isDark ? Colors.white : AppColors.grey,
//                                   height: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (widget.product.priceOffer.isNotEmpty &&
//                               widget.product.priceOffer != widget.product.price)
//                             CustomTextSolveIssue(
//                               widget.product.price,
//                               // Original price (strikethrough)
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: AppColors.grey,
//                                 decoration: TextDecoration.lineThrough,
//                               ),
//                             ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               CustomTextSolveIssue(
//                                 widget.product.priceOffer.isNotEmpty &&
//                                         widget.product.priceOffer !=
//                                             widget.product.price
//                                     ? widget.product.priceOffer
//                                     : widget.product.price, // Current price
//                                 style: TextStyle(
//                                   fontSize: 36,
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.bold,
//                                   height: 1.1,
//                                 ),
//                               ),
//                               Image.asset(
//                                 'assets/images/saCurancy.png',
//                                 color: isDark ? Colors.white : Colors.grey,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (widget.product.installmentWays.isNotEmpty)
//               CustomTextSolveIssue(
//                 'installmentWays'.tr,
//                 style: GoogleFonts.tajawal(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   // color: isDark ? Colors.white : const Color(0xff5D5C5C),
//                 ),
//               ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 80,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: widget.product.installmentWays.length,
//                 itemBuilder: (context, index) {
//                   final way = widget.product.installmentWays[index];
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: Container(
//                       width: 115,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Color(0xffF6F6F6),
//                         borderRadius: BorderRadius.circular(40),
//                         border: Border.all(
//                           color: Colors.grey,
//                           width: 0.5,
//                         ),
//                         image: DecorationImage(
//                           image: NetworkImage(way.image),
//                           fit: BoxFit.contain,
//                           onError: (exception, stackTrace) =>
//                               const Icon(Icons.error),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25.0),
//           ),
//           child: CustomButton(
//             onPressed: () async {
//               print('Attempting to open link: ${widget.product.link}');
//               // Normalize URL if scheme is missing
//               String normalizedUrl = widget.product.link;
//               if (!widget.product.link.startsWith(RegExp(r'https?://'))) {
//                 normalizedUrl = 'https://$widget.product.link';
//               }
//               final uri = Uri.tryParse(normalizedUrl);
//               if (uri != null) {
//                 try {
//                   final canLaunch = await canLaunchUrl(uri);
//                   print('Can launch URL: $canLaunch');
//                   if (canLaunch) {
//                     await launchUrl(
//                       uri,
//                       mode: LaunchMode.externalApplication,
//                     );
//                     print('Successfully opened: $normalizedUrl');
//                     // _viewCountController.incrementMarketBannerViews(banner.id);
//                   } else {
//                     print('Cannot launch URL: $normalizedUrl');
//                     Get.snackbar(
//                       'خطأ',
//                       'لا يمكن فتح الرابط: الرابط غير مدعوم',
//                       snackPosition: SnackPosition.BOTTOM,
//                       duration: const Duration(seconds: 3),
//                     );
//                   }
//                 } catch (e) {
//                   print('Error launching URL: $e');
//                   Get.snackbar(
//                     'خطأ',
//                     'حدث خطأ أثناء فتح الرابط: $e',
//                     snackPosition: SnackPosition.BOTTOM,
//                     duration: const Duration(seconds: 3),
//                   );
//                 }
//               } else {
//                 print('Invalid URL: $normalizedUrl');
//                 Get.snackbar(
//                   'خطأ',
//                   'الرابط غير صالح: $normalizedUrl',
//                   snackPosition: SnackPosition.BOTTOM,
//                   duration: const Duration(seconds: 3),
//                 );
//               }
//             },
//             text: 'shop_now'.tr,
//             textFontWeight: FontWeight.bold,
//             textSize: 22,
//             iconPath: 'assets/svg/mynaui_click-solid.svg',
//             iconColor: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }

class FavoriteButtonOff extends StatelessWidget {
  final int marketOfferId;
  final VoidCallback? onFavoriteTap;

  const FavoriteButtonOff({
    super.key,
    required this.marketOfferId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(marketOfferId: marketOfferId);
      final isLoading = controller.isLoading.value;

      return GestureDetector(
        onTap: isLoading
            ? null // Disable tap during loading
            : () async {
                bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
                if (isLoggedIn) {
                  await controller.toggleFavorite(marketOfferId: marketOfferId);
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
