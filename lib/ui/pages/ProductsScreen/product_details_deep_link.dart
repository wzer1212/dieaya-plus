import 'package:dieaya_user/Routes/app_routes.dart';
import 'package:dieaya_user/UI/pages/HomeScreen/home_screen.dart';
import 'package:dieaya_user/UI/pages/dashboard/navbar.dart';
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


class ProductScreenDeepLink extends StatefulWidget {
  final String productId;

  const ProductScreenDeepLink({super.key, required this.productId});

  @override
  State<ProductScreenDeepLink> createState() => _ProductScreenDeepLinkState();
}

class _ProductScreenDeepLinkState extends State<ProductScreenDeepLink> {
  int _currentImageIndex = 0;

  final ProductDetailsController _productDetails = Get.put<
      ProductDetailsController>(ProductDetailsController());
  final PageController _pageController = PageController();
  final ProductVisit productVisit = Get.put<ProductVisit>(ProductVisit());


  @override
  void initState() {
    super.initState();
    _productDetails.getProductDetails(widget.productId);
    productVisit.callProductVisit(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // final productImages = widget.product.images.isNotEmpty
    //     ? widget.product.images.map((img) => img.image).toList()
    //     : ['assets/images/jaket.png'];

    final isArabic = Get.locale?.languageCode == 'ar';
    return Scaffold(
      backgroundColor:  isDark ? Colors.black : Colors.white,
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
                        Get.offAllNamed(AppRoutes.navbar);
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
                        var product = _productDetails.product.value;
                        var appLink =
                            "🛍️${product.nameAr}\n\n${product.descriptionAr}\n\n🏬${product.market.nameAr}\n\n💰سعر المنتج:${product.price}\n\n${ApiConstants.shareBaseUrl}/shop/product/${product.id}";

                        // var appLink = _productDetails.product.value.shareLink.isNotEmpty?_productDetails.product.value.shareLink:
                        //     'https://play.google.com/store/apps/details?id=com.dieayaplus.user';

                        final box = context.findRenderObject() as RenderBox?;
                        final sharePositionOrigin = box != null
                            ? box.localToGlobal(Offset.zero) & box.size
                            : Rect.fromLTWH(0, 0, screenWidth, screenHeight / 2);

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
            Obx(() {
              if (_productDetails.loading.value) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 300.h,),
                    Center(child: CircularProgressIndicator(),),
                  ],
                );
              }
              if (_productDetails.errorMessage.isNotEmpty) {
                return Column(
                  children: [
                    SizedBox(height: 300.h,),
                    Center(child: CustomTextSolveIssue(
                        _productDetails.errorMessage.value),),
                  ],
                );
              }
              return Column(
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
                          height: screenHeight * 0.40,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _productDetails.product.value.images.length,
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
                                    _productDetails.product.value.images[index].image,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error,
                                        color: Colors.black),
                                  ),
                                ),
                              );;
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoreDetails(
                                                    marketId: _productDetails.product.value.market.id),
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
                                          _productDetails.product.value.market.logo,
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
                                    _productDetails.product.value.market.nameAr,
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
                                  children: List.generate(_productDetails.product.value.images.length,
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
                        Column(children: [
                          CustomTextSolveIssue(
                            isArabic
                                ? _productDetails.product.value.nameAr
                                : _productDetails.product.value.nameEn,
                            maxLines: 4,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22,
                              color:
                              isDark ? Colors.white : AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],),
                        const SizedBox(height: 20),


                        CustomTextSolveIssue(
                          isArabic
                              ? (_productDetails.product.value.descriptionAr ??
                              'no_description'.tr)
                              : (_productDetails.product.value.descriptionEn ??
                              'no_description'.tr),
                          textAlign: TextAlign.start,
                          maxLines: 20,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.white
                                : AppColors.grey,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_productDetails.product.value.priceOffer.isNotEmpty &&
                                    _productDetails.product.value.priceOffer !=
                                        _productDetails.product.value.price)
                                  CustomTextSolveIssue(
                                    _productDetails.product.value.price,
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
                                    CustomTextSolveIssue(
                                      _productDetails.product.value.priceOffer.isNotEmpty &&
                                          _productDetails.product.value.priceOffer !=
                                              _productDetails.product.value.price
                                          ? _productDetails.product.value.priceOffer
                                          : _productDetails.product.value.price,
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
                                      color: isDark ? Colors.white : Colors
                                          .grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (_productDetails.product.value.installmentWays.isNotEmpty)
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
                            itemCount: _productDetails.product.value.installmentWays.length,
                            itemBuilder: (context, index) {
                              final way = _productDetails.product.value.installmentWays[index];
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
              );
            },),
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
              print('Attempting to open link: ${_productDetails.product.value.link}');
              // Normalize URL if scheme is missing
              String normalizedUrl = _productDetails.product.value.link;
              if (!_productDetails.product.value.link.startsWith(RegExp(r'https?://'))) {
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
    );
  }
}
