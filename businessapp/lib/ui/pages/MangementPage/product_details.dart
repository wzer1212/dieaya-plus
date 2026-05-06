import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/app_colors.dart';
import '../../../controllers/ProductsControllers/product_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/product_model.dart';
import '../../../utils/app_snackbars.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_sheets.dart';


class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  late PageController _pageController;
  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _confirmDelete(BuildContext context, Product product) {
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
                'assets/svg/social/deleteacc.svg', // Ensure this SVG asset exists
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 10),
              Text(
                'acceptMessageDelete'.tr, // Translated text for confirmation
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'sureDelete'.tr, // Translated text for confirmation message
                style: GoogleFonts.tajawal(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  Navigator.pop(dialogContext); // Dismiss the dialog
                  bool success = await productController.deleteProduct(id: product.id!); // Ensure product.id is not null
                  if (success) {
                    Get.back(); // Navigate back after deletion
                    SnackBarConstantVersion1.showSuccessSnackbar(
                      'success'.tr,
                      'deleteProductSuccess'.tr,
                    );
                  } else {
                    SnackBarConstantVersion1.showErrorSnackbar( // Use showErrorSnackbar for error
                      'error'.tr,
                      productController.errorMessage.value,
                    );
                  }
                },
                text: 'deleteApp'.tr, // Translated text for delete button
                textSize: 16,
                textFontWeight: FontWeight.bold,
                color: const Color(0xffAEAEAE), // Custom color for delete button
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () => Navigator.pop(dialogContext),
                text: 'cancelApp'.tr, // Translated text for cancel button
                textSize: 16,
                textFontWeight: FontWeight.bold,
                // Assuming default button style is sufficient or adjust as needed
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final productImages = widget.product.images.isNotEmpty
        ? widget.product.images.map((img) => img.image).toList()
        : ['assets/images/jaket.png'];

    final isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
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
                padding: const EdgeInsetsDirectional.only(top: 60, start: 8, end: 8, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: 36,
                    //   height: 36,
                    //   child: SvgPicture.asset(
                    //     'assets/svg/share.svg',
                    //     width: 36,
                    //     height: 36,
                    //   ),
                    // ),
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
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 40.0),
                          child: Image.network(
                            productImages[index],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, color: Colors.black),
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
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 25, start: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(productImages.length, (index) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic
                                  ? (widget.product.nameAr ?? 'no_name'.tr)
                                  : (widget.product.nameEn ?? 'no_name'.tr),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                color: isDark ? Colors.white : AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: 250,
                              child: Text(
                                isArabic
                                    ? (widget.product.descriptionAr ?? 'no_description'.tr)
                                    : (widget.product.descriptionEn ?? 'no_description'.tr),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white : AppColors.grey,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((widget.product.priceOffer?.isNotEmpty ?? false) &&
                              widget.product.priceOffer != widget.product.price)
                            Text(
                              widget.product.price ?? '0',
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
                              Text(
                                (widget.product.priceOffer?.isNotEmpty ?? false) &&
                                    widget.product.priceOffer != widget.product.price
                                    ? (widget.product.priceOffer ?? '0')
                                    : (widget.product.price ?? '0'),
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
                    Text(
                      'installmentWays'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xff5D5C5C),
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
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              width: 115,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(40),
                                // border: Border.all(
                                //   color: Colors.grey,
                                //   width: 0.5,
                                // ),
                                image: DecorationImage(
                                  image: NetworkImage(way.image),
                                  fit: BoxFit.scaleDown,
                                  scale: 0.65,
                                  onError: (exception, stackTrace) => const Icon(Icons.error),
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
          child: SizedBox(
            height: 120, // Increased height for two stacked buttons
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onPressed: () {
                    CustomSheets.showEditProductSheet(context, widget.product);
                  },
                  text: 'editApp'.tr,
                  textFontWeight: FontWeight.bold,
                  textSize: 18,
                  color: AppColors.blue,
                ),
                const SizedBox(height: 8), // Space between buttons
                CustomButton(
                  onPressed: () {
                    _confirmDelete(context, widget.product);
                  },
                  text: 'deleteApp'.tr,
                  textFontWeight: FontWeight.bold,
                  textSize: 18,
                  color:Color(0xffAEAEAE),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

