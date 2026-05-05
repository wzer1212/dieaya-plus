import 'package:dieaya_user/Routes/app_routes.dart';
import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/controllers/use_visits_controllers/market_visit_controllers.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/pages/OffersScreen/offers_details_screen.dart';
import 'package:dieaya_user/ui/widgets/custom_sheets.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_list_product_card.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_product_card_gird_view.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/view_products.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../controllers/FavController/fav_controller.dart';
import '../../../controllers/MarketControllers/market_details_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../widgets/coupon_card.dart';
import '../../widgets/offer_card.dart';
import '../../widgets/product_card.dart';
import '../ProductsScreen/product_details.dart';

import 'package:flutter_svg/svg.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

import '../ProfileScreen/my_favs_screen.dart';

class StoreDetails extends StatefulWidget {
  final int marketId;
  final bool? isFromDeepLink;

  const StoreDetails(
      {super.key, required this.marketId, this.isFromDeepLink = false});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails>
    with SingleTickerProviderStateMixin {
  String selectedTab = 'products';
  bool isGridView = true;
  late TabController _tabController;
  final MarketDetailsController _controller =
      Get.put(MarketDetailsController());
  final ThemeController themeController = Get.find<ThemeController>();
  final MarketVisitControllers marketVisitController =
      Get.put<MarketVisitControllers>(MarketVisitControllers());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    print('--------------------->${widget.marketId}');
    // _controller.fetchMarketDetails(marketId: widget.marketId);
    Future.delayed(
      Duration(
        seconds: 3,
      ),
      () {
        marketVisitController.callMarketVisit(widget.marketId);
      },
    );
    Future.delayed(
      Duration(
        seconds: 10,
      ),
      () {
        marketVisitController.callMarketSurfer(widget.marketId);
      },
    );
    Future.delayed(
      Duration(milliseconds: 60),
      () {
        _controller.fetchMarketDetails(marketId: widget.marketId);
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return AdaptiveLayOut(
        mobile: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Obx(
            () {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_controller.errorMessage.value.isNotEmpty ||
                  _controller.market.value == null) {
                return Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(vertical: 20.0),
                  child: Center(
                    child: CustomTextSolveIssue(
                      _controller.errorMessage.value.isNotEmpty
                          ? _controller
                              .errorMessage.value.tr // Assume translation key
                          : 'no_data_available'.tr,
                      style: GoogleFonts.getFont(
                        isArabic ? 'Tajawal' : 'Roboto',
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Stack(
                  children: [
                    Container(
                      height: 190.h,
                      // Increased height to accommodate the gradient and content
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(50.0),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isDark
                              ? [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.8),
                                  // Slightly darker for dark mode
                                  Colors.black,
                                ]
                              : [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.6),
                                  // Adjust opacity for a smoother transition
                                  Colors.white,
                                ],
                          stops: const [
                            0.0,
                            0.5,
                            1.0
                          ], // Adjusted stops for a smoother transition
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            spreadRadius: 0,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 30, start: 8, end: 8, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection:
                              isArabic ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (widget.isFromDeepLink!) {
                                  Get.offAllNamed(AppRoutes.navbar);
                                } else {
                                  Get.back();
                                }
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                child: SvgPicture.asset(
                                  'assets/svg/backbutton.svg',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                var market = _controller.market.value!;
                                var appLink =
                                    // _controller.market.value!.shareLink.isEmpty
                                    // ?
                                    '🛒${market.name}\n\n'
                                    '${market.description}\n\n'
                                    '🔗زورو المتجر الان \n'
                                    '${ApiConstants.shareBaseUrl}/shop/market/${market.id}\n\n'
                                    '#متجر #متجر ${market.name} #تسوق #عروض #كوبونات';
                                // : _controller.market.value!.shareLink;

                                final box =
                                    context.findRenderObject() as RenderBox?;
                                final sharePositionOrigin = box != null
                                    ? box.localToGlobal(Offset.zero) & box.size
                                    : Rect.fromLTWH(
                                        0, 0, screenWidth, screenHeight / 2);

                                Share.share(
                                  '$appLink',
                                  sharePositionOrigin: sharePositionOrigin,
                                );
                                marketVisitController
                                    .callMarketShareCountIncrease(
                                        widget.marketId);
                              }, // U
                              child: Container(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  'assets/svg/share.svg',
                                  width: 36,
                                  height: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 5, vertical: 15),
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: isArabic
                                        ? Alignment.bottomLeft
                                        : Alignment.bottomRight,
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                _controller.market.value!.logo),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) =>
                                                const AssetImage(
                                                    'assets/images/Ellipse 14.png'),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: FavoriteButton(
                                          marketId:
                                              _controller.market.value!.id,
                                          onFavoriteTap: () {
                                            _controller.fetchMarketDetails(
                                                marketId: widget.marketId);
                                            debugPrint(
                                                'Favorite status changed for market: ${_controller.market.value!.id}');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextSolveIssue(
                                    isArabic
                                        ? _controller.market.value!.name ??
                                            _controller.market.value!.name
                                        : _controller.market.value!.name ??
                                            _controller.market.value!.name,
                                    style: GoogleFonts.getFont(
                                      isArabic ? 'Tajawal' : 'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xff666565),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextSolveIssue(
                                    isArabic
                                        ? _controller
                                                .market.value!.description ??
                                            _controller
                                                .market.value!.description ??
                                            'no_description_available'.tr
                                        : _controller
                                                .market.value!.description ??
                                            _controller
                                                .market.value!.description ??
                                            'no_description_available'.tr,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont(
                                      isArabic ? 'Tajawal' : 'Roboto',
                                      fontSize: 14,
                                      color:
                                          isDark ? Colors.white70 : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Visibility(
                                    visible: _controller.market.value!.link !=
                                            null &&
                                        _controller
                                            .market.value!.link!.isNotEmpty,
                                    child: CustomButton(
                                      width: 200,
                                      onPressed: () async {
                                        final url =
                                            _controller.market.value!.link;
                                        if (url != null && url.isNotEmpty) {
                                          final uri = Uri.tryParse(url);
                                          if (uri != null &&
                                              await canLaunchUrl(uri)) {
                                            await launchUrl(
                                              uri,
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                            debugPrint('Opening URL: $url');
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: CustomTextSolveIssue(
                                                      'cannot_open_link'.tr)),
                                            );
                                            debugPrint('Invalid URL: $url');
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: CustomTextSolveIssue(
                                                    'no_link_available'.tr)),
                                          );
                                          debugPrint(
                                              'No URL provided for market: ${_controller.market.value!.id}');
                                        }
                                      },
                                      text: 'browse_store'.tr,
                                      iconPath:
                                          'assets/svg/mynaui_click-solid.svg',
                                      iconSize: 24,
                                      iconColor: Colors.white,
                                      borderRadius: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              children: [
                                _buildTabButton('products', 'products'.tr,
                                    isDark, isArabic),
                                const SizedBox(width: 10),
                                _buildTabButton(
                                    'offers', 'offers'.tr, isDark, isArabic),
                                const SizedBox(width: 10),
                                _buildTabButton(
                                    'coupons', 'coupons'.tr, isDark, isArabic),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildTabContent(
                              imageHeight: 225.h,
                              isDark,
                              isArabic,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        desktop: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Obx(
            () {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_controller.errorMessage.value.isNotEmpty ||
                  _controller.market.value == null) {
                return Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 125.h),
                  child: Center(
                    child: CustomTextSolveIssue(
                      _controller.errorMessage.value.isNotEmpty
                          ? _controller
                              .errorMessage.value.tr // Assume translation key
                          : 'no_data_available'.tr,
                      style: GoogleFonts.getFont(
                        isArabic ? 'Tajawal' : 'Roboto',
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  GlobalWebHeader(scrollController: _scrollController),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // Container(
                              //   height: 55.h,
                              //   // Increased height to accommodate the gradient and content
                              //   decoration: BoxDecoration(
                              //     borderRadius: const BorderRadius.vertical(
                              //       bottom: Radius.circular(50.0),
                              //     ),
                              //     gradient: LinearGradient(
                              //       begin: Alignment.topCenter,
                              //       end: Alignment.bottomCenter,
                              //       colors: isDark
                              //           ? [
                              //               AppColors.primary,
                              //               AppColors.primary.withOpacity(0.8),
                              //               // Slightly darker for dark mode
                              //               Colors.black,
                              //             ]
                              //           : [
                              //               AppColors.primary,
                              //               AppColors.primary.withOpacity(0.6),
                              //               // Adjust opacity for a smoother transition
                              //               Colors.white,
                              //             ],
                              //       stops: const [
                              //         0.0,
                              //         0.5,
                              //         1.0
                              //       ], // Adjusted stops for a smoother transition
                              //     ),
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.blue.withOpacity(0.4),
                              //         spreadRadius: 0,
                              //         blurRadius: 5,
                              //         offset: const Offset(0, 4),
                              //       ),
                              //     ],
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsetsDirectional.only(
                              //         top: 30, start: 8, end: 8, bottom: 0),
                              //     child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       textDirection: isArabic
                              //           ? TextDirection.rtl
                              //           : TextDirection.ltr,
                              //       children: [
                              //         GestureDetector(
                              //           onTap: () => Get.back(),
                              //           child: Container(
                              //             width: 40,
                              //             height: 40,
                              //             child: SvgPicture.asset(
                              //               'assets/svg/backbutton.svg',
                              //               width: 40,
                              //               height: 40,
                              //             ),
                              //           ),
                              //         ),
                              //         GestureDetector(
                              //           onTap: () {
                              //             const appLink =
                              //                 'https://play.google.com/store/apps/details?id=com.dieayaplus.user';
                              //             Share.share(
                              //     '$appLink',
                              //     sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
                              //   );
                              //           }, // U
                              //           child: Container(
                              //             width: 30,
                              //             height: 30,
                              //             child: SvgPicture.asset(
                              //               'assets/svg/share.svg',
                              //               width: 36,
                              //               height: 36,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 100,
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 5, vertical: 15),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 55.w),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    alignment: isArabic
                                                        ? Alignment.bottomLeft
                                                        : Alignment.bottomRight,
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        height: 90,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                _controller
                                                                    .market
                                                                    .value!
                                                                    .logo),
                                                            fit: BoxFit.cover,
                                                            onError: (exception,
                                                                    stackTrace) =>
                                                                const AssetImage(
                                                                    'assets/images/Ellipse 14.png'),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: FavoriteButton(
                                                          marketId: _controller
                                                              .market.value!.id,
                                                          onFavoriteTap: () {
                                                            _controller.fetchMarketDetails(
                                                                marketId: widget
                                                                    .marketId);
                                                            debugPrint(
                                                                'Favorite status changed for market: ${_controller.market.value!.id}');
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  CustomTextSolveIssue(
                                                    isArabic
                                                        ? _controller.market
                                                                .value!.name ??
                                                            _controller.market
                                                                .value!.name
                                                        : _controller.market
                                                                .value!.name ??
                                                            _controller.market
                                                                .value!.name,
                                                    style: GoogleFonts.getFont(
                                                      isArabic
                                                          ? 'Tajawal'
                                                          : 'Roboto',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDark
                                                          ? Colors.white
                                                          : const Color(
                                                              0xff666565),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  CustomTextSolveIssue(
                                                    isArabic
                                                        ? _controller
                                                                .market
                                                                .value!
                                                                .description ??
                                                            _controller
                                                                .market
                                                                .value!
                                                                .description ??
                                                            'no_description_available'
                                                                .tr
                                                        : _controller
                                                                .market
                                                                .value!
                                                                .description ??
                                                            _controller
                                                                .market
                                                                .value!
                                                                .description ??
                                                            'no_description_available'
                                                                .tr,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.getFont(
                                                      isArabic
                                                          ? 'Tajawal'
                                                          : 'Roboto',
                                                      fontSize: 14,
                                                      color: isDark
                                                          ? Colors.white70
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Visibility(
                                                    visible: _controller.market
                                                                .value!.link !=
                                                            null &&
                                                        _controller
                                                            .market
                                                            .value!
                                                            .link!
                                                            .isNotEmpty,
                                                    child: CustomButton(
                                                      width: 200,
                                                      onPressed: () async {
                                                        final url = _controller
                                                            .market.value!.link;
                                                        if (url != null &&
                                                            url.isNotEmpty) {
                                                          final uri =
                                                              Uri.tryParse(url);
                                                          if (uri != null &&
                                                              await canLaunchUrl(
                                                                  uri)) {
                                                            await launchUrl(
                                                              uri,
                                                              mode: LaunchMode
                                                                  .externalApplication,
                                                            );
                                                            debugPrint(
                                                                'Opening URL: $url');
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: CustomTextSolveIssue(
                                                                      'cannot_open_link'
                                                                          .tr)),
                                                            );
                                                            debugPrint(
                                                                'Invalid URL: $url');
                                                          }
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: CustomTextSolveIssue(
                                                                    'no_link_available'
                                                                        .tr)),
                                                          );
                                                          debugPrint(
                                                              'No URL provided for market: ${_controller.market.value!.id}');
                                                        }
                                                      },
                                                      text: 'browse_store'.tr,
                                                      iconPath:
                                                          'assets/svg/mynaui_click-solid.svg',
                                                      iconSize: 24,
                                                      iconColor: Colors.white,
                                                      borderRadius: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 25),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              textDirection: isArabic
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                              children: [
                                                _buildTabButton(
                                                    'products',
                                                    'products'.tr,
                                                    isDark,
                                                    isArabic),
                                                const SizedBox(width: 10),
                                                _buildTabButton(
                                                    'offers',
                                                    'offers'.tr,
                                                    isDark,
                                                    isArabic),
                                                const SizedBox(width: 10),
                                                _buildTabButton(
                                                    'coupons',
                                                    'coupons'.tr,
                                                    isDark,
                                                    isArabic),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            (selectedTab == 'products')
                                                ? GlobalViewProducts(
                                                    crossAxisCount: 4,
                                                    priceCanceledFontSize: 10.w,
                                                    storeFontSize: 12.w,
                                                    priceFontSize: 18.w,
                                                    descriptionFontSize: 10.w,
                                                    isDark,
                                                    isArabic,
                                                    isGrid: _controller.isGrid,
                                                    products:
                                                        _controller.products,
                                                  )
                                                : SizedBox.shrink(),
                                            selectedTab == 'offers'
                                                ? isGridView
                                                    ? _buildOffersGrid(
                                                        isDark,
                                                        isArabic,
                                                        marketNameSize: 20.w,
                                                        crossAxisCount: 3,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        cardRatio: 1.2,
                                                        logoHeight: 30.h,
                                                        offerFontSize: 24.w,
                                                        descriptionFontSize:
                                                            18.w,
                                                        borderWidth: 1.5.w,
                                                      )
                                                    : _buildOffersList(
                                                        isDark, isArabic,
                                                        logoHeight: 30.h,
                                                        offerFontSize: 24.w,
                                                        marketNameSize: 20.w)
                                                : SizedBox.shrink(),
                                            selectedTab == 'coupons'
                                                ? isGridView
                                                    ? _buildCouponsGrid(
                                                        isDark, isArabic,
                                                        logoHeight: kIsWeb
                                                            ? 30.h
                                                            : null)
                                                    : _buildCouponsList(
                                                        isDark,
                                                        isArabic,
                                                        spaceAboveCouponCode:
                                                            20.h,
                                                        couponCardHeight: 135.h,
                                                        storeNameFontSize: 21.w,
                                                        discountPercentageFontSize:
                                                            28.w,
                                                        discountFontSize: 18.w,
                                                        couponCodeFontSize:
                                                            18.sp,
                                                        logoHeight: 20.h,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                      )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          FooterWidget()
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildTabButton(
      String tabId, String label, bool isDark, bool isArabic) {
    final bool isSelected = selectedTab == tabId;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedTab = tabId;
        });
      },
      child: CustomTextSolveIssue(
        label,
        style: GoogleFonts.getFont(
          isArabic ? 'Tajawal' : 'Roboto',
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? AppColors.primary
              : (isDark ? Colors.white70 : AppColors.grey),
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : AppColors.primary,
        backgroundColor: isSelected ? Colors.transparent : Colors.transparent,
        side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.white70 : AppColors.white)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Widget _buildTabContent(bool isDark, bool isArabic, {double? imageHeight}) {
    switch (selectedTab) {
      case 'products':
        return isGridView
            ? _buildProductGrid(
                imageHeight: imageHeight,
                isDark,
                isArabic,
              )
            : _buildProductList(
                isDark,
                isArabic,
              );
      case 'offers':
        return isGridView
            ? _buildOffersGrid(isDark, isArabic, shrinkWrap: true)
            : _buildOffersList(isDark, isArabic);
      case 'coupons':
        return isGridView
            ? _buildCouponsGrid(isDark, isArabic,
                logoHeight: kIsWeb ? 30.h : null)
            : _buildCouponsList(
                isDark,
                isArabic,
              );
      default:
        return _buildProductGrid(
          isDark,
          isArabic,
        );
    }
  }

  Widget _buildProductGrid(
    bool isDark,
    bool isArabic, {
    double? cardRatio,
    double? priceFontSize,
    double? storeFontSize,
    double? descriptionFontSize,
    double? priceCanceledFontSize,
    double? imageHeight,
    int? crossAxisCount,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
        const SizedBox(height: 10),
        _controller.products.isEmpty
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
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 5.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount ?? 2,
                  crossAxisSpacing: 12.0.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: cardRatio ?? 0.60,
                ),
                itemCount: _controller.products.length,
                itemBuilder: (context, index) {
                  final product = _controller.market.value!.products[index];
                  final logo = _controller.market.value!.logo;
                  final title = _controller.market.value!.name;
                  final marketId = _controller.market.value!.id;
                  return GlobalProductCardGrid(
                    imageHeight: imageHeight,
                    priceCanceledFontSize: priceCanceledFontSize,
                    descriptionFontSize: descriptionFontSize,
                    priceFontSize: priceFontSize,
                    storeFontSize: storeFontSize,
                    product: product,
                    onTap: () {
                      print(product);
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
      ],
    );
  }

  Widget _buildProductList(
    bool isDark,
    bool isArabic, {
    double? priceFontSize,
    double? storeFontSize,
    double? descriptionFontSize,
    double? priceCanceledFontSize,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
        const SizedBox(height: 10),
        _controller.products.isEmpty
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
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 5.0),
                itemCount: _controller.products.length,
                itemBuilder: (context, index) {
                  final product = _controller.market.value!.products[index];
                  final logo = _controller.market.value!.logo;
                  final title = _controller.market.value!.name;
                  final marketId = _controller.market.value!.id;
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
    );
  }

  Widget _buildOffersGrid(
    bool isDark,
    bool isArabic, {
    double? logoHeight,
    double? offerFontSize,
    double? marketNameSize,
    double? descriptionFontSize,
    double? borderWidth,
    double? cardRatio,
    int? crossAxisCount,
    ScrollPhysics? physics,
    bool? shrinkWrap = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
        const SizedBox(height: 10),
        _controller.offers.isEmpty
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
                shrinkWrap: shrinkWrap!,
                physics: physics ?? const NeverScrollableScrollPhysics(),
                padding: const EdgeInsetsDirectional.all(3),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kIsWeb ? 3 : 2,
                  crossAxisSpacing: 12.0.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: cardRatio ?? 0.80,
                ),
                itemCount: _controller.offers.length,
                itemBuilder: (context, index) {
                  final offer = _controller.offers[index];
                  return OfferCardGrid(
                    descriptionFontSize: descriptionFontSize,
                    offerFontSize: offerFontSize,
                    logoHeight: logoHeight,
                    marketNameSize: marketNameSize,
                    borderWidth: borderWidth,
                    offer: offer,
                    onTap: () {
                      Get.to(() => OfferDetailsScreen(offer: offer));
                      debugPrint('Offer Tapped: ${offer.descriptionAr}');
                    },
                    onFavoriteTap: () {
                      debugPrint(
                          'Favorite status changed for offer: ${offer.id}');
                    },
                  );
                },
              ),
      ],
    );
  }

  Widget _buildOffersList(
    bool isDark,
    bool isArabic, {
    double? logoHeight,
    double? offerFontSize,
    double? marketNameSize,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
        const SizedBox(height: 10),
        _controller.offers.isEmpty
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
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 5.0),
                itemCount: _controller.offers.length,
                itemBuilder: (context, index) {
                  final offer = _controller.offers[index];
                  return OfferCardList(
                    offerFontSize: offerFontSize,
                    logoHeight: logoHeight,
                    marketNameSize: marketNameSize,
                    offer: offer,
                    onTap: () {
                      Get.to(() => OfferDetailsScreen(offer: offer));
                      debugPrint('Offer Tapped: ${offer.descriptionAr}');
                    },
                    onFavoriteTap: () {
                      debugPrint(
                          'Favorite status changed for offer: ${offer.id}');
                    },
                  );
                },
              ),
      ],
    );
  }

  Widget _buildCouponsGrid(bool isDark, bool isArabic, {double? logoHeight}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
        const SizedBox(height: 10),
        _controller.coupons.isEmpty
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
                padding: const EdgeInsetsDirectional.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kIsWeb ? 3 : 2,
                  crossAxisSpacing: 12.0.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.80,
                ),
                itemCount: _controller.coupons.length,
                itemBuilder: (context, index) {
                  final coupon = _controller.coupons[index];
                  return CouponCardGrid(
                    logoHeight: logoHeight,
                    coupon: coupon,
                    onTap: () {
                      debugPrint('Coupon Tapped: ${coupon.couponCode}');
                    },
                  );
                },
              ),
      ],
    );
  }

  Widget _buildCouponsList(bool isDark, bool isArabic,
      {ScrollPhysics? physics,
      bool? shrinkWrap = false,
      double? logoHeight,
      double? couponCodeFontSize,
      double? discountFontSize,
      double? discountPercentageFontSize,
      double? storeNameFontSize,
      double? spaceAboveCouponCode,
      double? couponCardHeight}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
        const SizedBox(height: 10),
        _controller.coupons.isEmpty
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
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 5.0),
                itemCount: _controller.coupons.length,
                itemBuilder: (context, index) {
                  final coupon = _controller.coupons[index];
                  return CouponCardList(
                    CouponCodeIcon: spaceAboveCouponCode,
                    couponCardHeight: couponCardHeight,
                    logoHeight: logoHeight,
                    couponCodeFontSize: couponCodeFontSize,
                    discountFontSize: discountFontSize,
                    discountPercentageFontSize: discountPercentageFontSize,
                    storeNameFontSize: storeNameFontSize,
                    coupon: coupon,
                    onTap: () {
                      debugPrint('Coupon Tapped: ${coupon.couponCode}');
                    },
                  );
                },
              ),
      ],
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final int marketId;
  final VoidCallback? onFavoriteTap;

  const FavoriteButton({
    super.key,
    required this.marketId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      final isFavorite = controller.isFavorite(marketId: marketId);
      final isLoading = controller.isLoading.value;

      return GestureDetector(
        onTap: isLoading
            ? null // Disable tap during loading
            : () async {
                bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
                if (isLoggedIn) {
                  await controller.toggleFavorite(marketId: marketId);
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
                  width: 25,
                  height: 25,
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
