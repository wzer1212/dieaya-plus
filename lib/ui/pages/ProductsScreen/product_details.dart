import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/controllers/ProductController/product_details_controller.dart';
import 'package:dieaya_user/controllers/product_visit/profuct_visit.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

import '../../../Utils/app_colors.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/product_model.dart';
import 'package:flutter_svg/svg.dart';

import '../StoresScreen/store_details.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String logo;
  final String title;
  final int marketId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.logo,
    required this.title,
    required this.marketId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  late PageController _pageController;
  final ProductVisit productVisit = Get.put<ProductVisit>(ProductVisit());

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    productVisit.callProductVisit(widget.product.id);
  }

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final productImages = widget.product.images.isNotEmpty
        ? widget.product.images.map((img) => img.image).toList()
        : ['assets/images/jaket.png'];

    final isArabic = Get.locale?.languageCode == 'ar';

    return AdaptiveLayOut(
        mobile: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
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
                      stops: const [0.0, 0.0, 5.0],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        top: 60, start: 8, end: 8, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
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
                            var appLink =
                                "🛍️${widget.product.nameAr}\n\n${widget.product.descriptionAr}\n\n🏬${widget.product.market.nameAr}\n\n💰سعر المنتج:${widget.product.price}\n\n${ApiConstants.shareBaseUrl}/shop/product/${widget.product.id}";

                            // widget.product.shareLink.isNotEmpty
                            // ? widget.product.shareLink
                            // :

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
                          }, // U
                          child: Container(
                            width: 30,
                            height: 30,
                            child: SvgPicture.asset(
                              'assets/svg/share.svg',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(50.0),
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.40,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: productImages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  productImages[index],
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error,
                                          color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsetsDirectional.all(25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print(widget.marketId);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StoreDetails(
                                              marketId: widget.marketId),
                                        ));

                                    // Get.to(() => StoreDetails(marketId:widget.marketId));
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        widget.logo,
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
                                ),
                                const SizedBox(width: 8),
                                CustomTextSolveIssue(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xff666565),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  top: 25, start: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(productImages.length,
                                    (index) {
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentImageIndex == index
                                          ? AppColors.primary
                                          : Colors.grey.withOpacity(0.5),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsetsDirectional.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CustomTextSolveIssue(
                            isArabic
                                ? widget.product.nameAr
                                : widget.product.nameEn,
                            textAlign: TextAlign.start,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: 22,
                              color: isDark ? Colors.white : AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextSolveIssue(
                        isArabic
                            ? (widget.product.descriptionAr ??
                                'no_description'.tr)
                            : (widget.product.descriptionEn ??
                                'no_description'.tr),
                        textAlign: TextAlign.start,
                        maxLines: 20,
                        style: TextStyle(
                          overflow: TextOverflow.fade,
                          fontSize: 14,
                          color: isDark ? Colors.white : AppColors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.product.priceOffer.isNotEmpty &&
                                  widget.product.priceOffer !=
                                      widget.product.price)
                                CustomTextSolveIssue(
                                  widget.product.price,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 360.w,
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: CustomTextSolveIssue(
                                        widget.product.priceOffer.isNotEmpty &&
                                                widget.product.priceOffer !=
                                                    widget.product.price
                                            ? double.parse(widget.product.priceOffer).toStringAsFixed(2)
                                            : widget.product.price,
                                        style: const TextStyle(
                                          fontSize: 36,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                    Image.asset(
                                      'assets/images/saCurancy.png',
                                      color: isDark ? Colors.white : Colors.grey,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (widget.product.installmentWays.isNotEmpty)
                        CustomTextSolveIssue(
                          'installmentWays'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: isDark ? Colors.white : const Color(0xff5D5C5C),
                          ),
                        ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.product.installmentWays.length,
                          itemBuilder: (context, index) {
                            final way = widget.product.installmentWays[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                width: 90,
                                height: 80,
                                decoration: BoxDecoration(
                                  // color: Color(0xffF6F6F6),
                                  // borderRadius: BorderRadius.circular(40),
                                  // border: Border.all(
                                  //   color: Colors.grey,
                                  //   width: 0.5,
                                  // ),
                                  image: DecorationImage(
                                    image: NetworkImage(way.image),
                                    fit: BoxFit.contain,
                                    onError: (exception, stackTrace) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsetsDirectional.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: CustomButton(
                onPressed: () async {
                  print('Attempting to open link: ${widget.product.link}');
                  // Normalize URL if scheme is missing
                  String normalizedUrl = widget.product.link;
                  if (!widget.product.link.startsWith(RegExp(r'https?://'))) {
                    normalizedUrl = 'https://$widget.product.link';
                  }
                  final uri = Uri.tryParse(normalizedUrl);
                  if (uri != null) {
                    try {
                      final canLaunch = await canLaunchUrl(uri);
                      print('Can launch URL: $canLaunch');
                      if (canLaunch) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                        print('Successfully opened: $normalizedUrl');
                        // _viewCountController.incrementMarketBannerViews(banner.id);
                      } else {
                        print('Cannot launch URL: $normalizedUrl');
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
                text: 'shop_now'.tr,
                textFontWeight: FontWeight.bold,
                textSize: 22,
                iconPath: 'assets/svg/mynaui_click-solid.svg',
                iconColor: Colors.white,
              ),
            ),
          ),
        ),
        desktop: Scaffold(
          extendBodyBehindAppBar: true,
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
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black : Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(50.0),
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
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.3,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: productImages.length,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentImageIndex = index;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(horizontal: 40.0),
                                          child: Image.network(
                                            productImages[index],
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error,
                                                        color: Colors.black),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.all(25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          StoreDetails(
                                                              marketId: widget
                                                                  .marketId),
                                                    ));

                                                // Get.to(() => StoreDetails(marketId:widget.marketId));
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    widget.logo,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
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
                                            const SizedBox(width: 8),
                                            CustomTextSolveIssue(
                                              widget.title,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xff666565),
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  top: 25, start: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                                productImages.length, (index) {
                                              return Container(
                                                width: 8.0,
                                                height: 8.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _currentImageIndex ==
                                                          index
                                                      ? AppColors.primary
                                                      : Colors.grey
                                                          .withOpacity(0.5),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsetsDirectional.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomTextSolveIssue(
                                              isArabic
                                                  ? widget.product.nameAr
                                                  : widget.product.nameEn,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: isDark
                                                    ? Colors.white
                                                    : AppColors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Container(
                                              width: 250,
                                              child: CustomTextSolveIssue(
                                                isArabic
                                                    ? (widget.product
                                                            .descriptionAr ??
                                                        'no_description'.tr)
                                                    : (widget.product
                                                            .descriptionEn ??
                                                        'no_description'.tr),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: isDark
                                                      ? Colors.white
                                                      : AppColors.grey,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (widget.product.priceOffer
                                                  .isNotEmpty &&
                                              widget.product.priceOffer !=
                                                  widget.product.price)
                                            CustomTextSolveIssue(
                                              widget.product.price,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              CustomTextSolveIssue(
                                                widget.product.priceOffer
                                                            .isNotEmpty &&
                                                        widget.product
                                                                .priceOffer !=
                                                            widget.product.price
                                                    ? widget.product.priceOffer
                                                    : widget.product.price,
                                                style: const TextStyle(
                                                  fontSize: 36,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.1,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Image.asset(
                                                'assets/images/saCurancy.png',
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  if (widget.product.installmentWays.isNotEmpty)
                                    CustomTextSolveIssue(
                                      'installmentWays'.tr,
                                      style: GoogleFonts.tajawal(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        // color: isDark ? Colors.white : const Color(0xff5D5C5C),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          widget.product.installmentWays.length,
                                      itemBuilder: (context, index) {
                                        final way = widget
                                            .product.installmentWays[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                            width: 115,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Color(0xffF6F6F6),
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5,
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(way.image),
                                                fit: BoxFit.contain,
                                                onError:
                                                    (exception, stackTrace) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.all(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: CustomButton(
                                  width: 250.w,
                                  onPressed: () async {
                                    print(
                                        'Attempting to open link: ${widget.product.link}');
                                    // Normalize URL if scheme is missing
                                    String normalizedUrl = widget.product.link;
                                    if (!widget.product.link
                                        .startsWith(RegExp(r'https?://'))) {
                                      normalizedUrl =
                                          'https://$widget.product.link';
                                    }
                                    final uri = Uri.tryParse(normalizedUrl);
                                    if (uri != null) {
                                      try {
                                        final canLaunch =
                                            await canLaunchUrl(uri);
                                        print('Can launch URL: $canLaunch');
                                        if (canLaunch) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                          print(
                                              'Successfully opened: $normalizedUrl');
                                          // _viewCountController.incrementMarketBannerViews(banner.id);
                                        } else {
                                          print(
                                              'Cannot launch URL: $normalizedUrl');
                                          Get.snackbar(
                                            'خطأ',
                                            'لا يمكن فتح الرابط: الرابط غير مدعوم',
                                            snackPosition: SnackPosition.BOTTOM,
                                            duration:
                                                const Duration(seconds: 3),
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
                                  text: 'shop_now'.tr,
                                  textFontWeight: FontWeight.bold,
                                  textSize: 22,
                                  iconPath: 'assets/svg/mynaui_click-solid.svg',
                                  iconColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FooterWidget(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
