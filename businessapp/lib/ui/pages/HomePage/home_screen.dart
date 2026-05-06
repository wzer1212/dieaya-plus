import 'package:dieaya_market/controllers/LoginController/send_otp_controller.dart';
import 'package:dieaya_market/ui/widgets/global_widgets/main_app_header.dart';
import 'package:dieaya_market/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Routes/app_routes.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/HomeController/home_controller.dart';
import '../../../controllers/ProfileController/profile_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/home_model.dart';
import '../../widgets/custom_verify_sheets.dart';
import '../../widgets/section_header.dart';
import '../MangementPage/management_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Category {
  final String title;
  final String svgPath;

  Category({required this.title, required this.svgPath});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeController themeController = Get.put(ThemeController());
  final ProfileController profileController = Get.put(ProfileController());
  final HomeController homeController = Get.put(HomeController());
  final RxBool showVerificationHint = true.obs;


  @override
  void initState() {
    super.initState();
    if (profileController.profile.value == null) {
      profileController.fetchProfile();
    }
    homeController.fetchHomeData(); // Already fetching data here
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await homeController.fetchHomeData();
        },
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainAppHeader(
                onTap: () {
                  Get.to(
                    () => ProductListPage(),
                  );
                },
                onNotificationPressed: () {
                  Get.toNamed(AppRoutes.notifications);
                  print('Notifications Tapped');
                },
              ),
              Obx(() {
                if (showVerificationHint.value &&
                    !profileController.isLoading.value &&
                    profileController.profile.value != null &&
                    profileController.profile.value!.verified == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFD5353),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                showVerificationHint.value = false;
                              },
                              child: Icon(Icons.close,
                                  color: const Color(0xFFFF8F8F),
                                  size: screenWidth * 0.07),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'verification_hint_part1'.tr,
                                        style: GoogleFonts.tajawal(
                                          color: const Color(0xffFF8F8F),
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () async {
                                            // final sendOtpController = Get.put(SendOtpController());

                                            final String? phoneNumber =
                                                profileController
                                                    .profile.value?.phone;

                                            if (phoneNumber != null &&
                                                phoneNumber.isNotEmpty) {
                                              // final success = await sendOtpController.sendOtp(phoneNumber);

                                              CustomSheetsVerify
                                                  .showOTPSheetVerify(context,
                                                      phoneNumber: phoneNumber);
                                            }
                                          },
                                          child: Text(
                                            'activate_now'.tr,
                                            style: GoogleFonts.tajawal(
                                              color: AppColors.primary,
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color(0xFFFD5353),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Icon(Icons.info,
                                  color: const Color(0xffFF8F8F),
                                  size: screenWidth * 0.08),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 16),
              Container(
                key: const ValueKey('categories_section'),
                child: _buildHorizontalCategoryList(),
              ),
              const SizedBox(height: 24),
              Container(
                key: const ValueKey('statistics_title_section'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'statistics'.tr,
                  style: GoogleFonts.tajawal(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Container(
                key: const ValueKey('statistics_subtitle_section'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'data_analysis'.tr,
                  style: GoogleFonts.tajawal(
                    fontSize: 12,
                    color: isDark ? Colors.grey : Colors.grey,
                  ),
                ),
              ),
              Container(
                key: const ValueKey('statistics_grid_section'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Obx(() => _buildStatisticsGrid()),
              ),
              const SizedBox(height: 24),
              Container(
                key: const ValueKey('top_products_section'),
                child: Obx(() => _buildProductGridSection(
                      title: 'top_visited_products'.tr,
                      products: homeController
                              .homeData.value?.message?.mostViewedProducts ??
                          [],
                      screenWidth: screenWidth,
                    )),
              ),
              Container(
                key: const ValueKey('banners_section'),
                child: Obx(() => _buildBannerSection(
                      title: 'most_viewed_banners'.tr,
                      banners: homeController.homeData.value?.message
                              ?.mostViewedMarketBanners ??
                          [],
                      screenWidth: screenWidth,
                    )),
              ),
              // Container(
              //   key: const ValueKey('offers_section'),
              //   child: Obx(() => OffersSection(
              //         offers: homeController
              //                 .homeData.value?.message?.mostViewedOffers ??
              //             [],
              //       )),
              // ),
              // Container(
              //   key: const ValueKey('top_coupons_section'),
              //   child: Obx(() => _buildCouponGridSection(
              //         title: 'most_used_coupons'.tr,
              //         coupons: homeController
              //                 .homeData.value?.message?.mostViewedCoupons ??
              //             [],
              //         screenHeight: screenHeight,
              //       )),
              // ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection({
    required String title,
    required List<MarketBanner> banners,
    required double screenWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SectionHeader(
            title: title,
            // actionText: 'SeeAll'.tr,
            // onActionPressed: () {
            //   debugPrint('See all banners tapped');
            // },
          ),
        ),
        banners.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'no_data'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 220, // Adjusted height to accommodate grid layout
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  // Disable scrolling
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Display 2 items per row
                    mainAxisSpacing: 8, // Spacing between items horizontally
                    crossAxisSpacing: 8, // Spacing between items vertically
                    childAspectRatio:
                        0.5, // Adjust aspect ratio for banner cards
                  ),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return BannerCard(
                      banner: banner,
                      onTap: () async {
                        if (banner.id != null) {
                          // final success = await viewCountController.incrementBannerViews(banner.id!);
                          // debugPrint('Banner Views Increment for ${banner.descriptionAr}: $success');
                        } else {
                          debugPrint(
                              'Error: Banner ID is null for ${banner.descriptionAr}');
                        }
                        debugPrint('Banner Tapped: ${banner.descriptionAr}');
                      },
                    );
                  },
                ),
              ),
      ],
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
              actionText: onSeeAllTap != null ? 'view_all'.tr : null,
              onActionPressed: onSeeAllTap,
            ),
          ),
        SizedBox(
          height: 100.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) {
                if (index < categories.length) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildCategoryItem(category, itemHeight),
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

  Widget _buildCategoryItem(Category category, double itemHeight) {
    return GestureDetector(
      onTap: () {
        print(category.title);
        Get.to(() => ProductListPage(initialCategory: category.title));
      },
      child: Container(
        height: 75.h,
        width: MediaQuery.of(Get.context!).size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
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
              colorFilter: const ColorFilter.mode(
                Color(0xffB9B9B9),
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
                fontSize: MediaQuery.of(Get.context!).size.width * 0.030,
                color: const Color(0xffB9B9B9),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    final homeController = Get.find<HomeController>();
    final themeController = Get.find<ThemeController>();

    if (homeController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (homeController.errorMessage.value.isNotEmpty) {
      return Center(
        child: Text(
          homeController.errorMessage.value,
          style: GoogleFonts.tajawal(fontSize: 16, color: Colors.red),
        ),
      );
    }
    final homeData = homeController.homeData.value?.message;
    if (homeData == null) {
      return Center(
        child: Text(
          'no_data'.tr,
          style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard(
          'visitors'.tr,
          homeData.visitors?.today?.toStringAsFixed(0) ?? '0',
          homeData.visitors?.percentage ?? 0.0,
          homeData.visitors?.type,
        ),
        _buildStatCard(
          'surfers'.tr,
          homeData.surfers?.today?.toStringAsFixed(0) ?? '0',
          homeData.surfers?.percentage ?? 0.0,
          homeData.surfers?.type,
        ),
        _buildStatCard(
          'shares'.tr,
          homeData.shares?.today?.toStringAsFixed(0) ?? '0',
          homeData.shares?.percentage ?? 0.0,
          homeData.shares?.type,
        ),
        _buildStatCard(
          'favorites'.tr,
          homeData.favorites?.today?.toStringAsFixed(0) ?? '0',
          homeData.favorites?.percentage ?? 0.0,
          homeData.favorites?.type,
        ),
        _buildStatCard(
          'offersFavorites'.tr,
          homeData.offersFavorites?.today?.toStringAsFixed(0) ?? '0',
          homeData.offersFavorites?.percentage ?? 0.0,
          homeData.offersFavorites?.type,
        ),
        _buildStatCard(
          'productFavorites'.tr,
          homeData.productFavorites?.today?.toStringAsFixed(0) ?? '0',
          homeData.productFavorites?.percentage ?? 0.0,
          homeData.productFavorites?.type,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, double percentage, String? type) {
    final themeController = Get.find<ThemeController>();
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final bool isPositive = type == '+';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/mask.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isPositive
                            ? AppColors.primary
                            : const Color(0xffFF8F8F),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          isPositive
                              ? Icons.trending_up_sharp
                              : Icons.trending_down_sharp,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.tajawal(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(2)}%',
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isPositive
                            ? (isDark ? Colors.green[300] : Colors.green[700])
                            : (isDark ? Colors.red[300] : Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridSection({
    required String title,
    required List<ProductHome> products,
    VoidCallback? onSeeAll,
    required double screenWidth,
  }) {
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: title,
            actionText: onSeeAll != null ? 'SeeAll'.tr : null,
            onActionPressed: onSeeAll,
          ),
        ),
        products.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'no_products'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio:
                      AdaptiveLayOut.isTablet(context) ? 0.4 : 0.6,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCardGrid(
                    product: product,
                    onTap: () {
                      debugPrint('Product Tapped: ${product.nameAr}');
                    },
                  );
                },
              ),
      ],
    );
  }

  Widget _buildCouponGridSection({
    required String title,
    required List<CouponHome> coupons,
    VoidCallback? onSeeAll,
    required double screenHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: title,
            actionText: onSeeAll != null ? 'SeeAll'.tr : null,
            onActionPressed: onSeeAll,
          ),
        ),
        coupons.isEmpty
            ? SizedBox(
                height: screenHeight * 0.2,
                child: Center(
                  child: Text(
                    'no_data'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: screenHeight * 0.3,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: coupons.length > 2 ? 2 : coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = coupons[index];
                    return CouponCardGrid(
                      coupon: coupon,
                      onTap: () {
                        debugPrint('Coupon Tapped: ${coupon.couponCode}');
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class CouponCardGrid extends StatelessWidget {
  final CouponHome coupon;
  final VoidCallback? onCopy;
  final VoidCallback? onTap;

  const CouponCardGrid({
    super.key,
    required this.coupon,
    this.onCopy,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth / 2 - 30;
    final cardHeight = cardWidth * 1.0;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                width: cardWidth,
                height: cardHeight,
                // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: isDark
                      ? Color(0xFF00B4FF).withOpacity(0.3)
                      : Color(0xFF00B4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(cardWidth * 0.08),
                ),
                child: CustomPaint(
                  painter: _CouponCardPainter(
                    cutoutColor: isDark ? Colors.black : Colors.white,
                    cutoutRadius: cardWidth * 0.08,
                    dashColor: Colors.white,
                    dashWidth: cardWidth * 0.020,
                    dashSpace: cardWidth * 0.015,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(cardWidth * 0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'discount'.tr,
                              style: GoogleFonts.tajawal(
                                fontSize: cardWidth * 0.11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black54,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  coupon.discount ?? '',
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '%',
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.11,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: cardWidth * 0.05),
                        Text(
                          coupon.couponCode ?? '',
                          style: GoogleFonts.tajawal(
                            fontSize: cardWidth * 0.08,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: 1.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // SizedBox(height: cardWidth * 0.07),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${coupon.viewsCount ?? 0}',
                    style: GoogleFonts.tajawal(
                      fontSize: cardWidth * 0.16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'استخدام',
                    style: GoogleFonts.tajawal(
                      fontSize: cardWidth * 0.10,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.grey[400] : Color(0xff666565),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CouponCardPainter extends CustomPainter {
  final double cutoutRadius;
  final Color dashColor;
  final Color cutoutColor;
  final double dashWidth;
  final double dashSpace;

  _CouponCardPainter({
    required this.cutoutRadius,
    required this.dashColor,
    required this.cutoutColor,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dashColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final double dashLineY = size.height * 0.70; // Position the dashed line
    final double startX = cutoutRadius;
    final double endX = size.width - cutoutRadius;

    // Draw Dashed Line
    double currentX = startX;
    while (currentX < endX) {
      canvas.drawLine(
        Offset(currentX, dashLineY),
        Offset(currentX + dashWidth, dashLineY),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }

    // Draw Cutouts
    final Paint cutoutPaint = Paint()..color = cutoutColor;

    // Left Cutout
    canvas.drawCircle(
      Offset(0, dashLineY),
      cutoutRadius,
      cutoutPaint,
    );

    // Right Cutout
    canvas.drawCircle(
      Offset(size.width, dashLineY),
      cutoutRadius,
      cutoutPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class OffersSection extends StatelessWidget {
  final List<OfferHome> offers;

  const OffersSection({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SectionHeader(
            title: 'most_used_offers'.tr,
          ),
        ),
        offers.isEmpty
            ? SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'no_data'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 280,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.70,
                  ),
                  itemCount: offers.length > 2 ? 2 : offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return OfferCardGrid(
                      offer: offer,
                      onTap: () {
                        debugPrint(
                            'Offer Tapped: ${offer.titleAr ?? offer.descriptionAr}');
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class OfferCardGrid extends StatelessWidget {
  final OfferHome offer;
  final VoidCallback? onTap;

  const OfferCardGrid({
    super.key,
    required this.offer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.6;
    final cardHeight = cardWidth * 0.4;

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
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: cardWidth,
              height: cardHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Positioned.fill(
                  //   bottom: 15,
                  //   left: 8,
                  //   child: Image.asset(
                  //     fit: BoxFit.contain,
                  //     'assets/images/offergrid2.png',
                  //     errorBuilder: (context, error, stackTrace) => Container(
                  //       color: Colors.grey.shade200,
                  //     ),
                  //   ),
                  // ),
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/OFFER.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(),
                    ),
                  ),
                  Positioned(
                    top: cardHeight * 0.05,
                    bottom: cardHeight * 0.05,
                    left: 15,
                    right: 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              (Get.locale?.languageCode == 'ar'
                                      ? offer.titleAr
                                      : offer.titleEn) ??
                                  '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                fontSize: cardWidth * 0.09,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: cardWidth * 0.05),
                          child: Text(
                            (Get.locale?.languageCode == 'ar'
                                    ? offer.descriptionAr
                                    : offer.descriptionEn) ??
                                '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.065,
                              color: Colors.grey,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${offer.viewsCount ?? 0}',
                style: GoogleFonts.tajawal(
                  fontSize: cardWidth * 0.12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(width: 8),
              Text(
                'استخدام',
                style: GoogleFonts.tajawal(
                  fontSize: cardWidth * 0.08,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff666565),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductCardGrid extends StatelessWidget {
  final ProductHome product;
  final VoidCallback? onTap;

  const ProductCardGrid({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;
    final bool isArabic = Get.locale?.languageCode == 'ar';

    final String imageUrl = product.images?.isNotEmpty == true
        ? product.images!.first.image ?? 'assets/images/placeholder.png'
        : 'assets/images/placeholder.png';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.primary, Colors.black]
                : [AppColors.primary, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Container(
                    width: cardWidth * 0.75,
                    height: cardWidth * 0.75,
                    child: Image.network(
                      imageUrl, // Use a default image
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
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${isArabic?product.nameAr:product.nameEn}',
                              maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.tajawal(
                                  color: const Color(0xff666565),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${product.viewsCount ?? 0}',
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'visit'.tr,
                                  style: GoogleFonts.tajawal(
                                    color: const Color(0xff666565),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                Get.locale?.languageCode == 'ar'
                                    ? (product.descriptionAr ?? 'لا يوجد وصف')
                                    : (product.descriptionEn ?? 'No description'),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.tajawal(
                                  fontSize: cardWidth * 0.075,
                                  color:
                                      isDark ? Colors.white : const Color(0xff666565),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
    );
  }
}

class BannerCard extends StatelessWidget {
  final MarketBanner banner;
  final VoidCallback? onTap;

  const BannerCard({
    super.key,
    required this.banner,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.75;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          color: isDark ? Colors.grey[800] : Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (banner.image != null)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    banner.image!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Get.locale?.languageCode == 'ar'
                          ? (banner.descriptionAr ?? '')
                          : (banner.descriptionEn ?? ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${banner.viewsCount ?? 0}',
                          style: GoogleFonts.tajawal(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'زيارة',
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? Colors.grey[400] : Color(0xff666565),
                          ),
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
    );
  }
}

// class Category {
//   final String title;
//   final String svgPath; // Store SVG path instead of IconData
//
//   Category({required this.title, required this.svgPath});
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final ThemeController themeController = Get.put(ThemeController());
//   final ProfileController profileController = Get.put(ProfileController()); // Get an instance of your ProfileController
//   final RxBool showVerificationHint = true.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch profile when the screen initializes, if it hasn't been fetched yet
//     if (profileController.profile.value == null) {
//       profileController.fetchProfile();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     bool isDark = themeController.themeMode.value == ThemeMode.dark;
//
//     return Scaffold(
//       backgroundColor: isDark ? Colors.black : Colors.white,
//       body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               key: const ValueKey('header_section'),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: isDark
//                       ? [AppColors.primary, AppColors.primary, Colors.black]
//                       : [AppColors.primary, AppColors.primary, Colors.white],
//                   stops: const [0.0, 0.0, 5.0],
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   top: screenHeight * 0.06,
//                   bottom: screenHeight * 0.01,
//                   right: screenWidth * 0.05,
//                   left: screenWidth * 0.05,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25),
//                         color: Colors.white,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Row(
//                           children: [
//                             Stack(
//                               children: [
//                                 IconButton(
//                                   icon: SvgPicture.asset(
//                                     'assets/svg/notify.svg',
//                                     width: screenWidth * 0.06,
//                                     height: screenWidth * 0.06,
//                                     colorFilter: const ColorFilter.mode(
//                                       Colors.black54,
//                                       BlendMode.srcIn,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     Get.toNamed(AppRoutes.notifications);
//                                     print('Notifications Tapped');
//                                   },
//                                 ),
//                                 Positioned(
//                                   right: screenWidth * 0.025,
//                                   top: screenHeight * 0.015,
//                                   child: Container(
//                                     padding:
//                                     EdgeInsets.all(screenWidth * 0.005),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                     constraints: BoxConstraints(
//                                       minWidth: screenWidth * 0.02,
//                                       minHeight: screenWidth * 0.02,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.02),
//                     Expanded(
//                       child: Container(
//                         height: screenHeight * 0.06,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: TextField(
//                           onTap: () {
//                             Get.to(() => ProductListPage());
//
//                             // Get.to(() => ProductsScreen(categoryId: '1'));
//                           },
//                           readOnly: true,
//                           textAlignVertical: TextAlignVertical.center,
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: screenWidth * 0.02,
//                               vertical: screenHeight * 0.01,
//                             ),
//                             hintText: 'search_products'.tr,
//                             hintStyle: GoogleFonts.tajawal(
//                               color: Colors.grey,
//                               fontSize: screenWidth * 0.035,
//                             ),
//                             suffixIcon: Padding(
//                               padding: EdgeInsets.all(screenWidth * 0.02),
//                               child: Container(
//                                 width: screenWidth * 0.12,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFEAEAEA),
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: screenWidth * 0.02,
//                                     vertical: screenHeight * 0.01,
//                                   ),
//                                   child: SvgPicture.asset(
//                                     'assets/svg/Search 1.svg',
//                                     width: screenWidth * 0.06,
//                                     height: screenWidth * 0.06,
//                                     colorFilter: const ColorFilter.mode(
//                                       Color(0xff5D5C5C),
//                                       BlendMode.srcIn,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             border: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                           ),
//                           onSubmitted: (value) {
//                             debugPrint('Search Submitted: $value');
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.02),
//                     Image.asset(
//                       'assets/images/logodiaya.png',
//                       width: 35,
//                       height: 35,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Obx(() {
//               // Only show the hint if showVerificationHint is true,
//               // not loading, and verified is 0
//               if (showVerificationHint.value &&
//                   !profileController.isLoading.value &&
//                   profileController.profile.value != null &&
//                   profileController.profile.value!.verified == 0) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: screenWidth * 0.03,
//                       vertical: screenHeight * 0.01),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: const Color(0xFFFD5353), // Using the red border color
//                         width: 1,
//                       ),
//                     ),
//                     padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.03,
//                         vertical: screenHeight * 0.01),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Top right close button
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: GestureDetector(
//                             onTap: () {
//                               showVerificationHint.value = false; // Dismiss the hint
//                             },
//                             child: Icon(Icons.close,
//                                 color: const Color(0xFFFF8F8F), // Matching icon color
//                                 size: screenWidth * 0.07),
//                           ),
//                         ),
//                         SizedBox(height: screenHeight * 0.005), // Small space after close button
//                         Row(
//                           children: [
//                             Expanded(
//                               child: RichText(
//                                 text: TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text:
//                                       'verification_hint_part1'.tr,
//                                       style: GoogleFonts.tajawal(
//                                         color: const Color(0xffFF8F8F), // Text color
//                                         fontSize: screenWidth * 0.035,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     // Make "تفعيل الان" clickable using WidgetSpan
//                                     WidgetSpan(
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           final String? phoneNumber = profileController.profile.value?.phone;
//                                           if (phoneNumber != null && phoneNumber.isNotEmpty) {
//                                             CustomSheetsVerify.showOTPSheetVerify(context, phoneNumber: phoneNumber);
//                                           } else {
//                                             // Get.snackbar(
//                                             //   'Error',
//                                             //   'Phone number not available for verification.',
//                                             //   snackPosition: SnackPosition.BOTTOM,
//                                             //   backgroundColor: Colors.red,
//                                             //   colorText: Colors.white,
//                                             // );
//                                           }
//                                         },
//                                         child: Text(
//                                           'activate_now'.tr, // Keep space if desired
//                                           style: GoogleFonts.tajawal(
//                                             color: AppColors.primary, // Primary color for the link
//                                             fontSize: screenWidth * 0.035,
//                                             fontWeight: FontWeight.bold,
//                                             decoration: TextDecoration.underline,
//                                             decorationColor: const Color(0xFFFD5353), // Underline color
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Icon(Icons.info, // Info icon on the left
//                                 color: const Color(0xffFF8F8F), // Matching icon color
//                                 size: screenWidth * 0.08),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//             const SizedBox(height: 10),
//             Container(
//               key: const ValueKey('categories_section'),
//               child: _buildHorizontalCategoryList(),
//             ),
//             const SizedBox(height: 24),
//             Container(
//               key: const ValueKey('statistics_title_section'),
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child:  Text(
//                 'statistics'.tr,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black54,
//                 ),
//               ),
//             ),
//             Container(
//               key: const ValueKey('statistics_subtitle_section'),
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child:  Text(
//                 'data_analysis'.tr,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black38,
//                 ),
//               ),
//             ),
//             Container(
//               key: const ValueKey('statistics_grid_section'),
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: _buildStatisticsGrid(),
//             ),
//             const SizedBox(height: 24),
//             Container(
//               key: const ValueKey('top_products_section'),
//               child: _buildProductGridSection(
//                 title: 'top_visited_products'.tr,
//                 products: testProducts.reversed.toList(),
//                 screenWidth: screenWidth,
//               ),
//             ),
//             Container(
//               key: const ValueKey('offers_section'),
//               child: OffersSection(),
//             ),
//             Container(
//               key: const ValueKey('top_coupons_section'),
//               child: _buildCouponsSection(
//                 title: 'most_used_coupons'.tr,
//                 coupons: testCoupons,
//                 screenHeight: screenHeight,
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
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
//       Category(title: 'Products'.tr, svgPath: 'assets/svg/products.svg'),
//       Category(title: 'Offers'.tr, svgPath: 'assets/svg/offers.svg'),
//       Category(title: 'Coupons'.tr, svgPath: 'assets/svg/coupons.svg'),
//       Category(title: 'Banners'.tr, svgPath: 'assets/svg/profile/bann.svg'),
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
//               actionText: onSeeAllTap != null ? 'view_all'.tr : null,
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
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: _buildCategoryItem(category, itemHeight),
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
//   Widget _buildCategoryItem(Category category, double itemHeight) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => ProductListPage(initialCategory: category.title));
//       },
//       child: Container(
//         height: itemHeight,
//         width: MediaQuery.of(Get.context!).size.width * 0.2,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(50),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 0.5,
//               offset: Offset(0.5, 0.0),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               category.svgPath,
//               height: 20,
//               width: 20,
//               colorFilter: const ColorFilter.mode(
//                 Color(0xffB9B9B9),
//                 BlendMode.srcIn,
//               ),
//               placeholderBuilder: (context) => const Icon(
//                 Icons.error,
//                 size: 30,
//                 color: Colors.red,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               category.title,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.tajawal(
//                 fontSize: MediaQuery.of(Get.context!).size.width * 0.030,
//                 color: const Color(0xffB9B9B9),
//                 fontWeight: FontWeight.bold,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatisticsGrid() {
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 8,
//       mainAxisSpacing: 8,
//       childAspectRatio: 1.6,
//       children: [
//         _buildStatCard('الزوار', '185', 14, true),
//         _buildStatCard('المتصفحين', '883', -10, false),
//         _buildStatCard('المشاركات', '492', 11, true),
//         _buildStatCard('يفضلون المتجر', '540', 10, true),
//         _buildStatCard('يفضلون العروض', '623', 11, true),
//         _buildStatCard('يفضلون المنتجات', '148', 10, true),
//       ],
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, int percentage, bool isPositive) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Stack(
//         children: [
//           Image.asset(
//             'assets/images/mask.png',
//             width: double.infinity,
//             height: double.infinity,
//             fit: BoxFit.contain,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     Container(
//                       width: 30,
//                       height: 30,
//                       decoration: const BoxDecoration(
//                         color: Colors.blue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.arrow_upward,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       value,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           isPositive ? Icons.arrow_upward : Icons.arrow_downward,
//                           color: isPositive ? Colors.green : Colors.red,
//                           size: 14,
//                         ),
//                         Text(
//                           '${isPositive ? '+' : ''}$percentage%',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: isPositive ? Colors.green : Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductGridSection({
//     required String title,
//     required List<Product> products,
//     VoidCallback? onSeeAllTap,
//     required double screenWidth,
//   }) {
//     int crossAxisCount = screenWidth > 600 ? 3 : 2;
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//           child: SectionHeader(
//             title: title,
//             actionText: onSeeAllTap != null ? 'see_all'.tr : null,
//             onActionPressed: onSeeAllTap,
//           ),
//         ),
//         products.isEmpty
//             ? Padding(
//           padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
//           child: Center(
//             child: Text(
//               'no_products'.tr,
//               style: GoogleFonts.tajawal(
//                 fontSize: screenWidth * 0.04,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         )
//             : GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: crossAxisCount,
//             crossAxisSpacing: screenWidth * 0.03,
//             mainAxisSpacing: screenWidth * 0.03,
//             childAspectRatio: 0.60,
//           ),
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];
//             return ProductCardGrid(
//               product: product,
//               onTap: () {
//                 debugPrint('Product Tapped: ${product.visitors}');
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCouponsSection({
//     required String title,
//     required List<MarketCoupon> coupons,
//     VoidCallback? onSeeAllTap,
//     required double screenHeight,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width * 0.04),
//           child: SectionHeader(
//             title: title,
//             actionText: onSeeAllTap != null ? 'see_all'.tr : null,
//             onActionPressed: onSeeAllTap,
//           ),
//         ),
//         coupons.isEmpty
//             ? SizedBox(
//           height: screenHeight * 0.3,
//           child: Center(
//             child: Text(
//               'no_data'.tr,
//               style: GoogleFonts.tajawal(
//                 fontSize: MediaQuery.of(context).size.width * 0.04,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         )
//             : SizedBox(
//           height: screenHeight * 0.25,
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 1.1,
//             ),
//             itemCount: 2,
//             itemBuilder: (context, index) {
//               final coupon = coupons[index];
//               return CouponCardGrid(
//                 onTap: () {
//                   debugPrint('Coupon Tapped: ${coupon.couponCode}');
//                 },
//                 coupon: coupon,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
