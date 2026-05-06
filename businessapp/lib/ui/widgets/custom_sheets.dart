import 'dart:io';
import 'package:dieaya_market/routes/app_routes.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/android_subscription.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/ios_subscriptions_screen.dart';
import 'package:dieaya_market/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:dieaya_market/utils/simple_custom_text_field.dart';
import 'package:dieaya_market/utils/validation/global_validator_key.dart';
import 'package:dieaya_market/utils/validation/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/app_colors.dart';
import '../../controllers/BannerController/banner_controller.dart';
import '../../controllers/CategoryController/category_controller.dart';
import '../../controllers/CouponControllers/coupon_controller.dart';
import '../../controllers/InsallmentController/get_installemnet_controller.dart';
import '../../controllers/OfferController/offer_controller.dart';
import '../../controllers/PackgesController/use_packge_controller.dart';
import '../../controllers/ProductsControllers/product_controller.dart';
import '../../controllers/ProfileController/profile_controller.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import '../../models/banner_model.dart';
import '../../models/coupon_model.dart';
import '../../models/offer_model.dart';
import '../../models/product_model.dart';
import '../../models/use_packge_model.dart';
import '../../utils/app_snackbars.dart';
import '../../utils/app_text_field.dart';
import 'buttons.dart';
import 'package:path/path.dart' as path;

class Market {
  final String name;
  final String logo;

  Market({required this.name, required this.logo});
}

class ImageModel {
  final String image;

  ImageModel({required this.image});
}

class ProductAdd {
  final String id;
  final Market? market;
  final String price;
  final String priceOffer;
  final String descriptionAr;
  final String descriptionEn;
  final List<ImageModel> images;

  ProductAdd({
    required this.id,
    this.market,
    required this.price,
    required this.priceOffer,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.images,
  });
}

class CouponCardGrid extends StatelessWidget {
  final Coupon coupon;
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
    final CouponController couponController = Get.put(CouponController());
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;
    final cardHeight = cardWidth * 1.33;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: cardWidth,
            height: cardHeight,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                dashWidth: cardWidth * 0.025,
                dashSpace: cardWidth * 0.015,
              ),
              child: Padding(
                padding: EdgeInsets.all(cardWidth * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: cardWidth * 0.1,
                          backgroundColor: Colors.grey[300],
                          child: coupon.market.logo.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    coupon.market.logo,
                                    fit: BoxFit.cover,
                                    width: cardWidth * 0.2,
                                    height: cardWidth * 0.2,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.store,
                                                color: Colors.grey),
                                  ),
                                )
                              : const Icon(Icons.store, color: Colors.grey),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: Text(
                            coupon.market.name,
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.08,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            Obx(
                              () => Expanded(
                                child: Text(
                                  couponController
                                      .discountAmountCopounCart.value,
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              '%',
                              style: GoogleFonts.tajawal(
                                fontSize: cardWidth * 0.11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: coupon.couponCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('code_copied'.tr)),
                              );
                              onCopy?.call();
                            },
                            child: SvgPicture.asset(
                              'assets/svg/copy.svg',
                              width: cardWidth * 0.10,
                              height: cardWidth * 0.10,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: cardWidth * 0.05),
                          Text(
                            coupon.couponCode,
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.08,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: 1.5,
                            ),
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

class AddOfferController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  Future<bool> addOffer({
    required String titleAr,
    required String titleEn,
    String? descriptionAr,
    String? descriptionEn,
    String? conditionsAr,
    String? conditionsEn,
    String? discountCode,
    String? offerLink,
    required String category,
    required bool isActive,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    await Future.delayed(const Duration(seconds: 1));
    successMessage.value = 'offer_added_successfully'.tr;
    isLoading.value = false;
    return true;
  }
}

class FavoriteController extends GetxController {
  final RxMap<int, bool> favorites = <int, bool>{}.obs;
  final isLoading = false.obs;

  bool isFavorite({required int marketOfferId}) =>
      favorites[marketOfferId] ?? false;

  Future<void> toggleFavorite({required int marketOfferId}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    favorites[marketOfferId] = !(favorites[marketOfferId] ?? false);
    isLoading.value = false;
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

    final double dashLineY = size.height * 0.70;
    final double startX = cutoutRadius;
    final double endX = size.width - cutoutRadius;

    double currentX = startX;
    while (currentX < endX) {
      canvas.drawLine(
        Offset(currentX, dashLineY),
        Offset(currentX + dashWidth, dashLineY),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }

    final Paint cutoutPaint = Paint()..color = cutoutColor;

    canvas.drawCircle(
      Offset(0, dashLineY),
      cutoutRadius,
      cutoutPaint,
    );

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

class OfferCardGrid extends StatefulWidget {
  final Offer offer;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const OfferCardGrid({
    super.key,
    required this.offer,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  State<OfferCardGrid> createState() => _OfferCardGridState();
}

class _OfferCardGridState extends State<OfferCardGrid> {
  final OfferController offerController = Get.put(OfferController());
  final bool isArabic = Get.locale?.languageCode == 'ar';

  @override
  void initState() {
    offerController.showOfferDescriptionInOfferCardGrid.value = isArabic
        ? widget.offer.descriptionAr ?? ''
        : widget.offer.descriptionEn ?? '';
    offerController.showOfferTitleInOfferCardGrid.value =
        isArabic ? widget.offer.titleAr ?? '' : widget.offer.titleEn ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.5;
    final cardHeight = cardWidth * 1.2;

    String discountValue = '';
    String discountLabel = 'discount'.tr;

    discountValue =
        widget.offer.descriptionAr.replaceAll(RegExp(r'[^0-9]'), '');
    discountLabel =
        widget.offer.descriptionAr.replaceAll(discountValue, '').trim();
    if (discountLabel.isEmpty && discountValue.isNotEmpty) {
      discountLabel = 'discount'.tr;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              bottom: 10,
              child: Image.asset(
                'assets/images/offergrid2.png',
                fit: BoxFit.contain,
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
              top: cardHeight * 0.05,
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
                          widget.offer.market.logo,
                          width: cardWidth * 0.15,
                          height: cardWidth * 0.15,
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
                        child: Text(
                          widget.offer.market.name,
                          style: GoogleFonts.tajawal(
                            fontSize: cardWidth * 0.075,
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
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            offerController.showOfferTitleInOfferCardGrid.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                              fontSize: cardWidth * 0.12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: cardWidth * 0.05),
                      child: Text(
                        offerController
                            .showOfferDescriptionInOfferCardGrid.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          fontSize: cardWidth * 0.065,
                          color: Colors.grey,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
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
                child: FavoriteButton(
                  productId: widget.offer.id.toString(),
                  onFavoriteTap: widget.onFavoriteTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final BannerMarket banner;
  final bool? isClick;

  const PromoBanner({super.key, required this.banner, this.isClick = true});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final link = banner.link.trim();
    final hasValidLink =
        link.isNotEmpty && Uri.tryParse(link)?.hasScheme == true;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.00),
      child: SizedBox(
        height: screenHeight * 0.27,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.10),
              child: Image.asset(
                'assets/images/continerBack.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
              child: banner.image.startsWith('http')
                  ? Image.network(
                      banner.image,
                      fit: BoxFit.cover,
                      height: screenHeight * 0.25,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/Rectangle 22489.png',
                        fit: BoxFit.cover,
                        height: screenHeight * 0.25,
                        width: double.infinity,
                      ),
                    )
                  : Image.file(
                      File(banner.image),
                      fit: BoxFit.cover,
                      height: screenHeight * 0.25,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/Rectangle 22489.png',
                        fit: BoxFit.cover,
                        height: screenHeight * 0.25,
                        width: double.infinity,
                      ),
                    ),
            ),
            Positioned(
              top: screenHeight * 0.015,
              right: Directionality.of(context) == TextDirection.rtl
                  ? screenWidth * 0.03
                  : null,
              left: Directionality.of(context) == TextDirection.rtl
                  ? null
                  : screenWidth * 0.03,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.04,
                    backgroundImage: banner.market.logo.isNotEmpty
                        ? NetworkImage(banner.market.logo)
                        : null,
                    backgroundColor: Colors.white,
                    child: banner.market.logo.isEmpty
                        ? Image.asset('assets/images/Ellipse 14.png')
                        : null,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    banner.market.name,
                    style: GoogleFonts.tajawal(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.04,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      Get.locale?.languageCode == 'ar'
                          ? banner.descriptionAr
                          : banner.descriptionEn,
                      textAlign: Directionality.of(context) == TextDirection.rtl
                          ? TextAlign.right
                          : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: hasValidLink,
                    child: Expanded(
                      child: SizedBox(
                        width: screenWidth * 0.25,
                        height: screenHeight * 0.05,
                        child: CustomButton(
                          text: 'shop_now'.tr,
                          textSize: 12,
                          onPressed: isClick!
                              ? () async {
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
                                      } else {
                                        Get.snackbar(
                                          'error_title'.tr,
                                          'cannot_open_unsupported_link'.tr,
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: const Duration(seconds: 3),
                                        );
                                      }
                                    } catch (e) {
                                      Get.snackbar(
                                        'error_title'.tr,
                                        '${'error_opening_link_exception'.tr}: $e',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 3),
                                      );
                                    }
                                  } else {
                                    Get.snackbar(
                                      'error_title'.tr,
                                      '${'invalid_link_format'.tr}: $normalizedUrl',
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 3),
                                    );
                                  }
                                }
                              : () {},
                          textFontWeight: FontWeight.bold,
                          textColor: AppColors.primary,
                          color: Colors.white,
                          iconPath: 'assets/svg/mynaui_click-solid.svg',
                          iconSize: screenWidth * 0.06,
                        ),
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
}

class CustomStatusDropdown extends StatelessWidget {
  final RxInt status; // Changed from RxBool to RxInt
  final bool isDark;

  const CustomStatusDropdown({
    Key? key,
    required this.status,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'statues'.tr, // Status label
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xff5D5C5C),
                    ),
                  ),
                  TextSpan(
                    text: ' *',
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: status.value,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? Colors.grey[700] : Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    // borderSide: BorderSide(
                    //   color: isDark ? Colors.grey : Colors.grey[300]!,
                    // ),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              dropdownColor: isDark ? Colors.grey[800] : Colors.white,
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text(
                    'active'.tr, // Active
                    style: GoogleFonts.tajawal(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 0,
                  child: Text(
                    'notActive'.tr, // Inactive
                    style: GoogleFonts.tajawal(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  status.value = value;
                }
              },
            ),
          ],
        ));
  }
}

class CustomSingleDropdown extends StatefulWidget {
  final List<Category> categories;
  final Rxn<int> selectedCategoryId;
  final bool isDark;
  final String? errorText;
  final String? label;
  final bool isRequired;

  const CustomSingleDropdown({
    Key? key,
    required this.categories,
    required this.selectedCategoryId,
    required this.isDark,
    this.errorText,
    this.label,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<CustomSingleDropdown> createState() => _CustomSingleDropdownState();
}

class _CustomSingleDropdownState extends State<CustomSingleDropdown> {
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;
  late OverlayEntry _overlayEntry;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus && _isDropdownOpen) {
          _removeOverlay();
          setState(() {
            _isDropdownOpen = false;
          });
        }
      });
    });
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
      _focusNode.unfocus();
    } else {
      _showOverlay();
      _focusNode.requestFocus();
    }

    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    _overlayEntry.remove();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeOverlay();
          setState(() {
            _isDropdownOpen = false;
            _focusNode.unfocus();
          });
        },
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(12),
                  color: widget.isDark ? Colors.grey[850] : Colors.white,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 250,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) {
                        final category = widget.categories[index];
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          title: Text(
                            category.nameAr,
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              color:
                                  widget.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          onTap: () {
                            widget.selectedCategoryId.value = category.id;
                            _removeOverlay();
                            setState(() {
                              _isDropdownOpen = false;
                              _focusNode.unfocus();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isDropdownOpen) {
      _removeOverlay();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.label!,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Color(0xff5D5C5C),
                    ),
                  ),
                  if (widget.isRequired)
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Focus(
              focusNode: _focusNode,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: widget.isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color:
                        widget.errorText != null ? Colors.red : AppColors.white,
                  ),
                ),
                child: Stack(
                  children: [
                    Obx(() => widget.selectedCategoryId.value == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 50.0),
                            child: Text(
                              'selectCategory'.tr,
                              style: GoogleFonts.tajawal(
                                fontSize: 16,
                                color: widget.isDark
                                    ? Colors.grey[400]
                                    : Colors.grey,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 30, top: 10, bottom: 10),
                            child: Text(
                              widget.categories
                                  .firstWhere(
                                    (cat) =>
                                        cat.id ==
                                        widget.selectedCategoryId.value,
                                    orElse: () => Category(
                                        id: 0,
                                        nameAr: '',
                                        nameEn: '',
                                        image: ''),
                                  )
                                  .nameAr,
                              style: GoogleFonts.tajawal(
                                fontSize: 16,
                                color:
                                    widget.isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Icon(
                        _isDropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: widget.isDark ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 12),
            child: Text(
              widget.errorText!,
              style: GoogleFonts.tajawal(fontSize: 12, color: Colors.red),
            ),
          ),
      ],
    );
  }
}

class CustomLocationDropdown extends StatefulWidget {
  final List<String> locations;
  final RxString selectedLocation;
  final bool isDark;
  final String? errorText;

  const CustomLocationDropdown({
    Key? key,
    required this.locations,
    required this.selectedLocation,
    required this.isDark,
    this.errorText,
  }) : super(key: key);

  @override
  State<CustomLocationDropdown> createState() => _CustomLocationDropdownState();
}

class _CustomLocationDropdownState extends State<CustomLocationDropdown> {
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;
  late OverlayEntry _overlayEntry;
  final _focusNode = FocusNode();

  // Mapping of English location values to localized display labels
  static Map<String, String> get locationDisplayMap => {
        'top': 'banner_location_top'.tr,
        // 'middle': 'منتصف',
        'bottom': 'banner_location_bottom'.tr,
      };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus && _isDropdownOpen) {
          _removeOverlay();
          setState(() {
            _isDropdownOpen = false;
          });
        }
      });
    });
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
      _focusNode.unfocus();
    } else {
      _showOverlay();
      _focusNode.requestFocus();
    }

    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    _overlayEntry.remove();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeOverlay();
          setState(() {
            _isDropdownOpen = false;
            _focusNode.unfocus();
          });
        },
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(12),
                  color: widget.isDark ? Colors.grey[850] : Colors.white,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 150, // Adjusted for three options
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: widget.locations.map((location) {
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          title: Text(
                            locationDisplayMap[location] ?? location,
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              color:
                                  widget.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          onTap: () {
                            widget.selectedLocation.value = location;
                            _removeOverlay();
                            setState(() {
                              _isDropdownOpen = false;
                              _focusNode.unfocus();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isDropdownOpen) {
      _removeOverlay();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'place'.tr,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: widget.isDark ? Colors.white70 : Colors.grey,
                ),
              ),
              TextSpan(
                text: ' *',
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Focus(
              focusNode: _focusNode,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: widget.errorText != null
                        ? Colors.red
                        : widget.isDark
                            ? Colors.grey[600]!
                            : Colors.grey[400]!,
                  ),
                ),
                child: Stack(
                  children: [
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 30, top: 10, bottom: 10),
                          child: Text(
                            locationDisplayMap[widget.selectedLocation.value] ??
                                widget.selectedLocation.value,
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              color:
                                  widget.isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Icon(
                        _isDropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: widget.isDark ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 12),
            child: Text(
              widget.errorText!,
              style: GoogleFonts.tajawal(fontSize: 12, color: Colors.red),
            ),
          ),
      ],
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final String productId;
  final VoidCallback? onFavoriteTap;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        'assets/svg/Heart 2.svg',
        width: 30,
        height: 30,
      ),
    );
  }
}

class ProductCardGrid extends StatelessWidget {
  final ProductAdd product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  ProductCardGrid({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
  });

  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45;

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
        padding: const EdgeInsets.all(1.5),
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
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(
                      child: Container(
                        width: cardWidth * 0.75,
                        height: cardWidth * 0.75,
                        child: product.images.isNotEmpty
                            ? _buildImage(product.images[0].image)
                            : Center(
                                child: Icon(
                                  Icons.image,
                                  color: AppColors.primary,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: FavoriteButton(
                      productId: product.id,
                      onFavoriteTap: onFavoriteTap,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  Get.locale?.languageCode == 'ar'
                                      ? productController
                                              .addProductModalSheetCardTitle
                                              .isEmpty
                                          ? product.market?.name ?? ''
                                          : productController
                                              .addProductModalSheetCardTitle
                                              .value
                                      : productController
                                              .addProductModalSheetCardTitle
                                              .isEmpty
                                          ? product.market?.name ?? ''
                                          : productController
                                              .addProductModalSheetCardTitle
                                              .value,
                                  style: GoogleFonts.tajawal(
                                    fontSize: cardWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xff666565),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (product.priceOffer.isNotEmpty &&
                                  product.priceOffer != product.price)
                                Container(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '${product.price}',
                                          style: GoogleFonts.tajawal(
                                            fontSize: cardWidth * 0.08,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${product.priceOffer}',
                                        style: GoogleFonts.tajawal(
                                          fontSize: cardWidth * 0.13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Image.asset(
                                        'assets/images/saCurancy.png',
                                        height: cardWidth * 0.06,
                                        color:
                                            isDark ? Colors.white : Colors.grey,
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        '${product.price}',
                                        style: GoogleFonts.tajawal(
                                          fontSize: cardWidth * 0.13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Image.asset(
                                        'assets/images/saCurancy.png',
                                        height: cardWidth * 0.06,
                                        color:
                                            isDark ? Colors.white : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Get.locale?.languageCode == 'ar'
                              ? product.descriptionAr
                              : product.descriptionEn,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.tajawal(
                            fontSize: cardWidth * 0.075,
                            color:
                                isDark ? Colors.white : const Color(0xff666565),
                          ),
                          maxLines: 3,
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
    );
  }

  Widget _buildImage(String imagePath) {
    // Check if the image path is a network URL or a local file path
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(
            Icons.image,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(
            Icons.image,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    }
  }
}

class CustomSheets {
  static const double kDefaultPadding = 16.0;
  static const double kInputHeight = 60.0;

  static double get kBottomSheetHeight =>
      MediaQuery.of(Get.context!).size.height * 0.85;
  static bool isIOs = Platform.isIOS;

  // static void showAddBannerSheet(BuildContext context, {BannerMarket? banner}) {
  //   final ThemeController themeController = Get.put(ThemeController());
  //   bool isDark = themeController.themeMode.value == ThemeMode.dark;
  //   final BannerController bannerController = Get.put(BannerController());
  //   final ProfileController profileController = Get.put(ProfileController());
  //   final descriptionArController = TextEditingController(text: banner?.descriptionAr ?? '');
  //   final descriptionEnController = TextEditingController(text: banner?.descriptionEn ?? '');
  //   final linkController = TextEditingController(text: banner?.link ?? '');
  //   final couponCodeController = TextEditingController(text: banner?.couponCode ?? '');
  //   final uploadedImage = Rxn<File>();
  //   final selectedLocation = (banner?.location ?? 'top').obs;
  //   final locations = ['top', 'bottom'];
  //   final descriptionArError = ''.obs;
  //   final descriptionEnError = ''.obs;
  //   final linkError = ''.obs;
  //   final statusError = ''.obs; // Add for status errors
  //   final status = (banner?.status ?? 1).obs; // Initialize with banner status
  //   final couponCodeError = ''.obs;
  //   final imageError = ''.obs;
  //   final locationError = ''.obs;
  //   var staticMarket = MarketBanner(
  //     id: banner?.market.id ?? 2,
  //     name: profileController.profile.value?.name ?? 'متجر مثالي',
  //     logo: profileController.profile.value?.logo ?? 'https://couponatnoon.net/images/store_1716831527.png',
  //   );
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: kBottomSheetHeight,
  //       padding: EdgeInsets.only(
  //         left: kDefaultPadding,
  //         right: kDefaultPadding,
  //         top: kDefaultPadding,
  //         bottom: MediaQuery.of(context).viewInsets.bottom + 10,
  //       ),
  //       decoration: BoxDecoration(
  //         color: isDark ? Colors.black : Colors.white,
  //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Obx(() {
  //         final previewBanner = BannerMarket(
  //           id: banner?.id ?? 0,
  //           marketId: staticMarket.id,
  //           market: staticMarket,
  //           image: uploadedImage.value != null
  //               ? uploadedImage.value!.path
  //               : (banner?.image ?? 'https://couponatnoon.net/images/store_1716831527.png'),
  //           descriptionAr: descriptionArController.text.isEmpty ? 'وصف البانر' : descriptionArController.text,
  //           descriptionEn: descriptionEnController.text.isEmpty ? 'Banner Description' : descriptionEnController.text,
  //           link: linkController.text.isEmpty ? 'https://example.com' : linkController.text,
  //           location: selectedLocation.value,
  //           couponCode: couponCodeController.text.isEmpty ? null : couponCodeController.text,
  //           status: status.value, // Use status.value
  //           createdAt: banner?.createdAt ?? '05-11-2025',
  //           updatedAt: banner?.updatedAt ?? '05-11-2025',
  //         );
  //
  //         return SingleChildScrollView(
  //           physics: ClampingScrollPhysics(),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildSheetHeader(context, banner == null ? 'addBanner'.tr : 'editBanner'.tr),
  //               const SizedBox(height: 20),
  //               Text(
  //                 'preview'.tr,
  //                 style: GoogleFonts.tajawal(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: isDark ? Colors.white : Colors.black,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               SizedBox(
  //                 width: MediaQuery.of(context).size.width,
  //                 height: MediaQuery.of(context).size.height * 0.27,
  //                 child: PromoBanner(banner: previewBanner),
  //               ),
  //               const SizedBox(height: 20),
  //               Text(
  //                 'bannerImage'.tr,
  //                 style: GoogleFonts.tajawal(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: isDark ? Colors.white : Colors.black,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Container(
  //                 height: 150,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color: isDark ? Colors.grey[700] : Colors.grey[200],
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(color: isDark ? Colors.grey : Colors.grey),
  //                 ),
  //                 child: Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       IconButton(
  //                         icon: const Icon(Icons.cloud_upload_sharp, size: 40),
  //                         color: AppColors.primary,
  //                         onPressed: () async {
  //                           final picker = ImagePicker();
  //                           final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //                           if (pickedFile != null) {
  //                             uploadedImage.value = File(pickedFile.path);
  //                             imageError.value = '';
  //                           }
  //                         },
  //                       ),
  //                       Text(
  //                         'selectImage'.tr,
  //                         style: GoogleFonts.tajawal(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.normal,
  //                           color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //                         ),
  //                       ),
  //                       Text(
  //                         banner == null ? 'atLeastImage'.tr : 'atLeastImage'.tr,
  //                         style: GoogleFonts.tajawal(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.normal,
  //                           color: isDark ? Colors.white : const Color(0xffC2C73A),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               if (uploadedImage.value != null)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 10),
  //                   child: Stack(
  //                     children: [
  //                       Container(
  //                         width: 80,
  //                         height: 100,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10),
  //                           image: DecorationImage(
  //                             image: FileImage(uploadedImage.value!),
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ),
  //                       Positioned(
  //                         top: 5,
  //                         right: 5,
  //                         child: IconButton(
  //                           icon: const Icon(Icons.remove_circle, color: Colors.red),
  //                           onPressed: () => uploadedImage.value = null,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               if (imageError.value.isNotEmpty)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0),
  //                   child: Text(
  //                     imageError.value,
  //                     style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
  //                   ),
  //                 ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'descriptionApp'.tr,
  //                 hintText: '',
  //                 controller: descriptionArController,
  //                 errorText: descriptionArError.value.isNotEmpty ? descriptionArError.value : null,
  //                 onChanged: (value) => descriptionArError.value = '',
  //               ),
  //               // const SizedBox(height: 20),
  //               // CustomTextField(
  //               //   label: 'description_en'.tr,
  //               //   hintText: 'Banner Description',
  //               //   controller: descriptionEnController,
  //               //   errorText: descriptionEnError.value.isNotEmpty ? descriptionEnError.value : null,
  //               //   onChanged: (value) => descriptionEnError.value = '',
  //               // ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'bannerLink'.tr,
  //                 hintText: '',
  //                 controller: linkController,
  //                 keyboardType: TextInputType.url,
  //                 errorText: linkError.value.isNotEmpty ? linkError.value : null,
  //                 onChanged: (value) => linkError.value = '',
  //               ),
  //               // const SizedBox(height: 20),
  //               // CustomTextField(
  //               //   label: 'coupon_code'.tr,
  //               //   hintText: 'XXXX-XXXX (optional)',
  //               //   controller: couponCodeController,
  //               //   errorText: couponCodeError.value.isNotEmpty ? couponCodeError.value : null,
  //               //   onChanged: (value) => couponCodeError.value = '',
  //               // ),
  //               const SizedBox(height: 20),
  //               // Column(
  //               //   crossAxisAlignment: CrossAxisAlignment.start,
  //               //   children: [
  //               //     Text(
  //               //       'مكان العرض'.tr,
  //               //       style: GoogleFonts.tajawal(
  //               //         fontSize: 16,
  //               //         color: isDark ? Colors.white70 : Colors.grey,
  //               //       ),
  //               //     ),
  //               //     const SizedBox(height: 8),
  //               //     Container(
  //               //       padding: const EdgeInsets.symmetric(horizontal: 12),
  //               //       decoration: BoxDecoration(
  //               //         color: isDark ? Colors.grey[800] : Colors.white,
  //               //         border: Border.all(color: isDark ? Colors.grey : Colors.grey),
  //               //         borderRadius: BorderRadius.circular(50),
  //               //       ),
  //               //       child: DropdownButtonHideUnderline(
  //               //         child: DropdownButton<String>(
  //               //           value: selectedLocation.value,
  //               //           isExpanded: true,
  //               //           items: locations.map((String location) {
  //               //             return DropdownMenuItem<String>(
  //               //               value: location,
  //               //               child: Text(
  //               //                 location.tr,
  //               //                 style: GoogleFonts.tajawal(
  //               //                   fontSize: 16,
  //               //                   color: isDark ? Colors.white : Colors.black,
  //               //                 ),
  //               //               ),
  //               //             );
  //               //           }).toList(),
  //               //           onChanged: (String? newValue) {
  //               //             if (newValue != null) {
  //               //               selectedLocation.value = newValue;
  //               //               locationError.value = '';
  //               //             }
  //               //           },
  //               //           style: GoogleFonts.tajawal(
  //               //             color: isDark ? Colors.white : Colors.black,
  //               //           ),
  //               //           dropdownColor: isDark ? Colors.grey[800] : Colors.white,
  //               //           icon: Icon(
  //               //             Icons.arrow_drop_down,
  //               //             color: isDark ? Colors.grey : Colors.black54,
  //               //           ),
  //               //         ),
  //               //       ),
  //               //     ),
  //               //     if (locationError.value.isNotEmpty)
  //               //       Padding(
  //               //         padding: const EdgeInsets.only(top: 8.0),
  //               //         child: Text(
  //               //           locationError.value,
  //               //           style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
  //               //         ),
  //               //       ),
  //               //   ],
  //               // ),
  //               CustomLocationDropdown(
  //                 locations: locations,
  //                 selectedLocation: selectedLocation,
  //                 isDark: isDark,
  //                 errorText: locationError.value.isNotEmpty ? locationError.value : null,
  //               ),
  //               const SizedBox(height: 20),
  //               CustomStatusDropdown(
  //                 status: status,
  //                 isDark: isDark,
  //               ),
  //               const SizedBox(height: 30),
  //
  //               CustomButton(
  //                 text: bannerController.isLoading.value
  //                     ? 'progress'.tr
  //                     : banner == null
  //                     ? 'add'.tr
  //                     : 'editApp'.tr,
  //                 textSize: 22,
  //                 textFontWeight: FontWeight.bold,
  //                 onPressed: bannerController.isLoading.value
  //                     ? null
  //                     : () async {
  //                   print('Add/Update Banner button clicked at ${DateTime.now()}');
  //
  //                   descriptionArError.value = '';
  //                   descriptionEnError.value = '';
  //                   linkError.value = '';
  //                   couponCodeError.value = '';
  //                   imageError.value = '';
  //                   locationError.value = '';
  //                   statusError.value = '';
  //                   print('Input values:');
  //                   print('  descriptionAr: ${descriptionArController.text}');
  //                   print('  descriptionEn: ${descriptionEnController.text}');
  //                   print('  link: ${linkController.text}');
  //                   print('  couponCode: ${couponCodeController.text}');
  //                   print('  location: ${selectedLocation.value}');
  //                   print('  image: ${uploadedImage.value?.path ?? 'null'}');
  //
  //                   if (descriptionArController.text.isEmpty) {
  //                     descriptionArError.value = 'descRequired'.tr;
  //                     print('Validation error: description_ar_required');
  //                     return;
  //                   }
  //                   // if (descriptionEnController.text.isEmpty) {
  //                   //   descriptionEnError.value = 'description_en_required'.tr;
  //                   //   print('Validation error: description_en_required');
  //                   //   return;
  //                   // }
  //                   if (linkController.text.isEmpty) {
  //                     linkError.value = 'linkRequired'.tr;
  //                     print('Validation error: link_required');
  //                     return;
  //                   }
  //                   if (!Uri.parse(linkController.text).isAbsolute) {
  //                     linkError.value = 'invalidLink'.tr;
  //                     print('Validation error: link_invalid');
  //                     return;
  //                   }
  //                   if (banner == null && uploadedImage.value == null) {
  //                     imageError.value = 'imageRequired'.tr;
  //                     print('Validation error: image_required');
  //                     return;
  //                   }
  //                   if (!locations.contains(selectedLocation.value)) {
  //                     locationError.value = 'placeRequired'.tr;
  //                     print('Validation error: location_required');
  //                     return;
  //                   }
  //
  //                   print('All validations passed, proceeding with ${banner == null ? 'addBanner' : 'updateBanner'}');
  //
  //                   bool success;
  //                   if (banner == null) {
  //                     success = await bannerController.addBanner(
  //                       image: uploadedImage.value!,
  //                       descriptionAr: descriptionArController.text,
  //                       descriptionEn: descriptionArController.text,
  //                       link: linkController.text,
  //                       location: selectedLocation.value,
  //                       couponCode: couponCodeController.text.isEmpty ? null : couponCodeController.text,
  //                       status: status.value, // Pass status
  //                     );
  //                   } else {
  //                     success = await bannerController.updateBanner(
  //                       bannerId: banner.id,
  //                       image: uploadedImage.value,
  //                       descriptionAr: descriptionArController.text,
  //                       descriptionEn: descriptionArController.text,
  //                       link: linkController.text,
  //                       location: selectedLocation.value,
  //                       couponCode: couponCodeController.text.isEmpty ? null : couponCodeController.text,
  //                       status: status.value, // Pass status
  //                     );
  //                   }
  //
  //                   print('Banner operation success: $success');
  //                   if (success) {
  //                     print('Closing bottom sheet and showing success dialog');
  //                     Navigator.pop(context);
  //                     _showSuccessDialog(
  //                       context,
  //                       title: banner == null ? 'bannerAddSuccess'.tr : 'bannerEditSuccess'.tr,
  //                       buttonText: 'browseBanners'.tr,
  //                       onButtonPressed: () {
  //                         print('Refreshing banner list');
  //                         bannerController.fetchBanners(page: 1);
  //                         // Remove Navigator.pop(context)
  //                       },
  //                     );
  //                   } else {
  //                     print('Operation failed, checking validation errors');
  //                     if (bannerController.validationErrors.isNotEmpty) {
  //                       final errors = bannerController.validationErrors;
  //                       if (errors.containsKey('description_ar')) {
  //                         descriptionArError.value = errors['description_ar']!.join(', ');
  //                         print('API error: description_ar - ${descriptionArError.value}');
  //                       }
  //                       if (errors.containsKey('description_en')) {
  //                         descriptionEnError.value = errors['description_en']!.join(', ');
  //                         print('API error: description_en - ${descriptionEnError.value}');
  //                       }
  //                       if (errors.containsKey('link')) {
  //                         linkError.value = errors['link']!.join(', ');
  //                         print('API error: link - ${linkError.value}');
  //                       }
  //                       if (errors.containsKey('coupon_code')) {
  //                         couponCodeError.value = errors['coupon_code']!.join(', ');
  //                         print('API error: coupon_code - ${couponCodeError.value}');
  //                       }
  //                       if (errors.containsKey('image')) {
  //                         imageError.value = errors['image']!.join(', ');
  //                         print('API error: image - ${imageError.value}');
  //                       }
  //                       if (errors.containsKey('location')) {
  //                         locationError.value = errors['location']!.join(', ');
  //                         print('API error: location - ${locationError.value}');
  //                       }
  //                       if (errors.containsKey('status')) {
  //                         statusError.value = errors['status']!.join(', ');
  //                         print('API error: status - ${statusError.value}');
  //                       }
  //                     } else {
  //                       descriptionArError.value = bannerController.errorMessage.value;
  //                       print('API error: general - ${descriptionArError.value}');
  //                     }
  //                   }
  //                 },
  //               ),
  //               SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
  //             ],
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }
  // static void showAddOfferSheet(BuildContext context, {Offer? offer}) {
  //   final ThemeController themeController = Get.put(ThemeController());
  //   bool isDark = themeController.themeMode.value == ThemeMode.dark;
  //   final OfferController offerController = Get.put(OfferController());
  //   final ProfileController profileController = Get.put(ProfileController());
  //   final CategoryController categoryController = Get.put(CategoryController());
  //
  //   // Fetch categories if not already loaded
  //   if (categoryController.categories.isEmpty) {
  //     categoryController.fetchCategories();
  //   }
  //
  //   final titleArController = TextEditingController(text: offer?.titleAr ?? '');
  //   // final titleEnController = TextEditingController(text: offer?.titleEn ?? '');
  //   final descriptionArController = TextEditingController(text: offer?.descriptionAr ?? '');
  //   // final descriptionEnController = TextEditingController(text: offer?.descriptionEn ?? '');
  //   final termsController = TextEditingController(text: offer?.terms ?? '');
  //   final couponCodeController = TextEditingController(text: offer?.couponCode ?? '');
  //   final linkController = TextEditingController(text: offer?.link ?? '');
  //   final selectedCategoryId = Rxn<int>(offer?.categoryId);
  //   final uploadedImage = Rxn<File>();
  //   final titleArError = ''.obs;
  //   // final titleEnError = ''.obs;
  //   final descriptionArError = ''.obs;
  //   // final descriptionEnError = ''.obs;
  //   final termsError = ''.obs;
  //   final couponCodeError = ''.obs;
  //   final linkError = ''.obs;
  //   final categoryError = ''.obs;
  //   final imageError = ''.obs;
  //   final statusError = ''.obs; // Add for status errors
  //   final status = (offer?.status ?? 1).obs; // Initialize with offer status
  //   // Static market data (to be replaced with API in the future)
  //   final staticMarket = MarketOfferOffer(
  //     id: offer?.market.id ?? 2,
  //     name: profileController.profile.value?.name ?? 'متجر مثالي',
  //     logo: profileController.profile.value?.logo ?? 'https://couponatnoon.net/images/store_1716831527.png',
  //   );
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: kBottomSheetHeight,
  //       padding: EdgeInsets.only(
  //         left: kDefaultPadding,
  //         right: kDefaultPadding,
  //         top: kDefaultPadding,
  //         bottom: MediaQuery.of(context).viewInsets.bottom + 10,
  //       ),
  //       decoration: BoxDecoration(
  //         color: isDark ? Colors.black : Colors.white,
  //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Obx(() {
  //         final previewOffer = Offer(
  //           id: offer?.id ?? 0,
  //           marketId: staticMarket.id,
  //           market: staticMarket,
  //           categoryId: selectedCategoryId.value ?? 1,
  //           descriptionAr: descriptionArController.text.isEmpty ? 'وصف العرض' : descriptionArController.text,
  //           descriptionEn: descriptionArController.text.isEmpty ? 'Offer Description' : descriptionArController.text,
  //           titleAr: titleArController.text.isEmpty ? 'عنوان العرض' : titleArController.text,
  //           titleEn: titleArController.text.isEmpty ? null : titleArController.text,
  //           terms: termsController.text.isEmpty ? null : termsController.text,
  //           couponCode: couponCodeController.text.isEmpty ? null : couponCodeController.text,
  //           image: uploadedImage.value != null
  //               ? uploadedImage.value!.path
  //               : (offer?.image ?? 'https://via.placeholder.com/150'),
  //           link: linkController.text.isEmpty ? 'https://example.com' : linkController.text,
  //           createdAt: offer?.createdAt ?? '05-11-2025',
  //           updatedAt: offer?.updatedAt ?? '05-11-2025',
  //           isFavorite: offer?.isFavorite ?? false,
  //           status: status.value,
  //           viewCount: status.value,
  //         );
  //
  //         return SingleChildScrollView(
  //           physics: ClampingScrollPhysics(),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildSheetHeader(context, offer == null ? 'addOffer'.tr : 'editProfile'.tr),
  //               const SizedBox(height: 20),
  //               Text(
  //                 'preview'.tr,
  //                 style: GoogleFonts.tajawal(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: isDark ? Colors.white : Colors.black,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   SizedBox(
  //                     width: MediaQuery.of(context).size.width * 0.5,
  //                     height: MediaQuery.of(context).size.width * 0.5 * 1.2,
  //                     child: OfferCardGrid(
  //                       offer: previewOffer,
  //                       onTap: () {},
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               // Text(
  //               //   'offer_image'.tr,
  //               //   style: GoogleFonts.tajawal(
  //               //     fontSize: 18,
  //               //     fontWeight: FontWeight.bold,
  //               //     color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //               //   ),
  //               // ),
  //               // const SizedBox(height: 10),
  //               // Container(
  //               //   height: 150,
  //               //   width: double.infinity,
  //               //   decoration: BoxDecoration(
  //               //     color: isDark ? Colors.grey[700] : const Color(0xffF6F6F6),
  //               //     borderRadius: BorderRadius.circular(10),
  //               //     border: Border.all(color: isDark ? Colors.grey : Colors.grey),
  //               //   ),
  //               //   child: Center(
  //               //     child: Column(
  //               //       mainAxisAlignment: MainAxisAlignment.center,
  //               //       children: [
  //               //         IconButton(
  //               //           icon: const Icon(Icons.cloud_upload_sharp, size: 30),
  //               //           color: AppColors.black,
  //               //           onPressed: () async {
  //               //             final picker = ImagePicker();
  //               //             final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //               //             if (pickedFile != null) {
  //               //               uploadedImage.value = File(pickedFile.path);
  //               //               imageError.value = '';
  //               //             }
  //               //           },
  //               //         ),
  //               //         Text(
  //               //           'choose_image'.tr,
  //               //           style: GoogleFonts.tajawal(
  //               //             fontSize: 18,
  //               //             fontWeight: FontWeight.normal,
  //               //             color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //               //           ),
  //               //         ),
  //               //         Text(
  //               //           offer == null ? 'image_required'.tr : 'image_optional'.tr,
  //               //           style: GoogleFonts.tajawal(
  //               //             fontSize: 12,
  //               //             fontWeight: FontWeight.normal,
  //               //             color: isDark ? Colors.white : const Color(0xffC2C73A),
  //               //           ),
  //               //         ),
  //               //       ],
  //               //     ),
  //               //   ),
  //               // ),
  //               // if (uploadedImage.value != null)
  //               //   Padding(
  //               //     padding: const EdgeInsets.only(top: 10),
  //               //     child: Stack(
  //               //       children: [
  //               //         Container(
  //               //           width: 80,
  //               //           height: 80,
  //               //           decoration: BoxDecoration(
  //               //             borderRadius: BorderRadius.circular(10),
  //               //             image: DecorationImage(
  //               //               image: FileImage(uploadedImage.value!),
  //               //               fit: BoxFit.cover,
  //               //             ),
  //               //           ),
  //               //         ),
  //               //         Positioned(
  //               //           top: 0,
  //               //           right: 0,
  //               //           child: IconButton(
  //               //             icon: const Icon(Icons.remove_circle, color: Colors.red),
  //               //             onPressed: () => uploadedImage.value = null,
  //               //           ),
  //               //         ),
  //               //       ],
  //               //     ),
  //               //   ),
  //               // if (imageError.value.isNotEmpty)
  //               //   Padding(
  //               //     padding: const EdgeInsets.only(top: 8.0),
  //               //     child: Text(
  //               //       imageError.value,
  //               //       style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
  //               //     ),
  //               //   ),
  //               // const SizedBox(height: 20),
  //
  //
  //               Text(
  //                 'offerImage'.tr,
  //                 style: GoogleFonts.tajawal(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Container(
  //                 height: 150,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color: isDark ? Colors.grey[700] : const Color(0xffF6F6F6),
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(color: isDark ? Colors.grey : Colors.grey),
  //                 ),
  //                 child: Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       IconButton(
  //                         icon: const Icon(Icons.cloud_upload_sharp, size: 30),
  //                         color: AppColors.black,
  //                         onPressed: () async {
  //                           final picker = ImagePicker();
  //                           final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //                           if (pickedFile != null) {
  //                             uploadedImage.value = File(pickedFile.path);
  //                             imageError.value = '';
  //                           }
  //                         },
  //                       ),
  //                       Text(
  //                         'selectImage'.tr,
  //                         style: GoogleFonts.tajawal(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.normal,
  //                           color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //                         ),
  //                       ),
  //                       Text(
  //                         offer == null ? 'atLeastImage'.tr : 'atLeastImage'.tr,
  //                         style: GoogleFonts.tajawal(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.normal,
  //                           color: isDark ? Colors.white : const Color(0xffC2C73A),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               if (uploadedImage.value != null)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 10),
  //                   child: Stack(
  //                     children: [
  //                       Container(
  //                         width: 80,
  //                         height: 80,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10),
  //                           image: DecorationImage(
  //                             image: FileImage(uploadedImage.value!),
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ),
  //                       Positioned(
  //                         top: 0,
  //                         right: 0,
  //                         child: IconButton(
  //                           icon: const Icon(Icons.remove_circle, color: Colors.red),
  //                           onPressed: () => uploadedImage.value = null,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               if (imageError.value.isNotEmpty)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0),
  //                   child: Text(
  //                     imageError.value,
  //                     style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
  //                   ),
  //                 ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'titleOffer'.tr,
  //                 hintText: '',
  //                 controller: titleArController,
  //                 errorText: titleArError.value.isNotEmpty ? titleArError.value : null,
  //                 onChanged: (value) => titleArError.value = '',
  //               ),
  //               // const SizedBox(height: 20),
  //               // CustomTextField(
  //               //   label: 'title_en'.tr,
  //               //   hintText: 'Offer title in English (optional)',
  //               //   controller: titleEnController,
  //               //   errorText: titleEnError.value.isNotEmpty ? titleEnError.value : null,
  //               //   onChanged: (value) => titleEnError.value = '',
  //               // ),
  //               const SizedBox(height: 20),
  //
  //               CustomSingleDropdown(
  //                 categories: categoryController.categories,
  //                 selectedCategoryId: selectedCategoryId,
  //                 isDark: isDark,
  //                 errorText: categoryError.value.isNotEmpty ? categoryError.value : null,
  //               ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'descriptionApp'.tr,
  //                 hintText: '',
  //                 controller: descriptionArController,
  //                 errorText: descriptionArError.value.isNotEmpty ? descriptionArError.value : null,
  //                 onChanged: (value) => descriptionArError.value = '',
  //               ),
  //               // const SizedBox(height: 20),
  //               // CustomTextField(
  //               //   label: 'description_en'.tr,
  //               //   hintText: 'Offer description in English',
  //               //   controller: descriptionEnController,
  //               //   errorText: descriptionEnError.value.isNotEmpty ? descriptionEnError.value : null,
  //               //   onChanged: (value) => descriptionEnError.value = '',
  //               // ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'termsApp'.tr,
  //                 hintText: '',
  //                 controller: termsController,
  //                 errorText: termsError.value.isNotEmpty ? termsError.value : null,
  //                 onChanged: (value) => termsError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //
  //               CustomTextField(
  //                 label: 'offerCode'.tr,
  //                 hintText: '',
  //                 controller: couponCodeController,
  //                 errorText: couponCodeError.value.isNotEmpty ? couponCodeError.value : null,
  //                 onChanged: (value) => couponCodeError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'offerLink'.tr,
  //                 hintText: '',
  //                 controller: linkController,
  //                 keyboardType: TextInputType.url,
  //                 errorText: linkError.value.isNotEmpty ? linkError.value : null,
  //                 onChanged: (value) => linkError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               CustomStatusDropdown(
  //                 status: status,
  //                 isDark: isDark,
  //               ),
  //               const SizedBox(height: 20),
  //
  //               const SizedBox(height: 30),
  //               CustomButton(
  //                 text: offerController.isLoading.value
  //                     ? 'progress'.tr
  //                     : offer == null
  //                     ? 'add'.tr
  //                     : 'editApp'.tr,
  //                 textSize: 22,
  //                 textFontWeight: FontWeight.bold,
  //                 onPressed: offerController.isLoading.value
  //                     ? null
  //                     : () async {
  //                   titleArError.value = '';
  //                   titleArError.value = '';
  //                   descriptionArError.value = '';
  //                   descriptionArError.value = '';
  //                   termsError.value = '';
  //                   couponCodeError.value = '';
  //                   linkError.value = '';
  //                   categoryError.value = '';
  //                   imageError.value = '';
  //                   statusError.value = '';
  //                   if (titleArController.text.isEmpty) {
  //                     titleArError.value = 'titleRequired'.tr;
  //                     return;
  //                   }
  //                   if (descriptionArController.text.isEmpty) {
  //                     descriptionArError.value = 'descRequired'.tr;
  //                     return;
  //                   }
  //                   // if (descriptionArController.text.isEmpty) {
  //                   //   descriptionArController.value = 'description_ar_required'.tr;
  //                   //   return;
  //                   // }
  //                   if (linkController.text.isEmpty) {
  //                     linkError.value = 'linkRequired'.tr;
  //                     return;
  //                   }
  //                   if (!Uri.parse(linkController.text).isAbsolute) {
  //                     linkError.value = 'invalidLink'.tr;
  //                     return;
  //                   }
  //                   if (selectedCategoryId.value == null) {
  //                     categoryError.value = 'categoryRequired'.tr;
  //                     return;
  //                   }
  //                   if (offer == null && uploadedImage.value == null) {
  //                     imageError.value = 'imageRequired'.tr;
  //                     return;
  //                   }
  //
  //                   bool success;
  //                   if (offer == null) {
  //                     // Add new offer
  //                     success = await offerController.addOffer(
  //                       image: uploadedImage.value!,
  //                       descriptionAr: descriptionArController.text,
  //                       descriptionEn: descriptionArController.text,
  //                       link: linkController.text,
  //                       categoryId: selectedCategoryId.value!,
  //                       titleAr: titleArController.text,
  //                       titleEn: titleArController.text.isEmpty ? null : titleArController.text,
  //                       terms: termsController.text.isEmpty ? null : termsController.text,
  //                       couponCode: couponCodeController.text.isEmpty ? null : couponCodeController.text,
  //                       status: status.value, // Pass status
  //                     );
  //                   } else {
  //                     // Update existing offer
  //                     success = await offerController.updateOffer(
  //                       offerId: offer.id,
  //                       image: uploadedImage.value,
  //                       descriptionAr: descriptionArController.text,
  //                       descriptionEn: descriptionArController.text,
  //                       link: linkController.text,
  //                       categoryId: selectedCategoryId.value!,
  //                       titleAr: titleArController.text,
  //                       titleEn: titleArController.text.isEmpty ? null : titleArController.text,
  //                       terms: termsController.text.isEmpty ? null : termsController.text,
  //                       couponCode: couponCodeController.text.isEmpty ? null : couponCodeController.text,
  //                       status: status.value, // Pass status
  //                     );
  //                   }
  //
  //                   if (success) {
  //                     Navigator.pop(context); // Close the bottom sheet
  //                     _showSuccessDialog(
  //                       context,
  //                       title: offer == null ? 'offerAddSuccess'.tr : 'offerEditSuccess'.tr,
  //                       buttonText: 'browseOffer'.tr,
  //                       onButtonPressed: () {
  //                         offerController.fetchOffers(page: 1);
  //                         // Remove Navigator.pop(context)
  //                       },
  //                     );
  //                   }else {
  //                     if (offerController.validationErrors.isNotEmpty) {
  //                       final errors = offerController.validationErrors;
  //                       if (errors.containsKey('title_ar')) {
  //                         titleArError.value = errors['title_ar']!.join(', ');
  //                       }
  //                       // if (errors.containsKey('title_en')) {
  //                       //   titleEnError.value = errors['title_en']!.join(', ');
  //                       // }
  //                       if (errors.containsKey('description_ar')) {
  //                         descriptionArError.value = errors['description_ar']!.join(', ');
  //                       }
  //                       // if (errors.containsKey('description_en')) {
  //                       //   descriptionEnError.value = errors['description_en']!.join(', ');
  //                       // }
  //                       if (errors.containsKey('terms')) {
  //                         termsError.value = errors['terms']!.join(', ');
  //                       }
  //                       if (errors.containsKey('coupon_code')) {
  //                         couponCodeError.value = errors['coupon_code']!.join(', ');
  //                       }
  //                       if (errors.containsKey('link')) {
  //                         linkError.value = errors['link']!.join(', ');
  //                       }
  //                       if (errors.containsKey('category_id')) {
  //                         categoryError.value = errors['category_id']!.join(', ');
  //                       }
  //                       if (errors.containsKey('image')) {
  //                         imageError.value = errors['image']!.join(', ');
  //                       }
  //                       if (errors.containsKey('status')) {
  //                         statusError.value = errors['status']!.join(', ');
  //                       }
  //                     } else {
  //                       titleArError.value = offerController.errorMessage.value;
  //                     }
  //                   }
  //                 },
  //               ),
  //               SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
  //             ],
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }
  // static void showAddProductSheet(BuildContext context) {
  //   final ThemeController themeController = Get.put(ThemeController());
  //   bool isDark = themeController.themeMode.value == ThemeMode.dark;
  //   final productController = Get.put(ProductController());
  //   final categoryController = Get.put(CategoryController());
  //
  //   final nameController = TextEditingController();
  //   final descriptionController = TextEditingController();
  //   final priceController = TextEditingController();
  //   final priceOfferController = TextEditingController();
  //   final linkController = TextEditingController();
  //
  //   final nameError = ''.obs;
  //   final descriptionError = ''.obs;
  //   final priceError = ''.obs;
  //   final priceOfferError = ''.obs;
  //   final linkError = ''.obs;
  //   final categoryError = ''.obs;
  //   final imagesError = ''.obs;
  //   final statusError = ''.obs; // Added for status errors
  //   final selectedCategoryId = Rxn<int>();
  //   final uploadedImages = <File>[].obs;
  //   final status = 1.obs; // Changed to RxInt, default 1 (active)
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: kBottomSheetHeight,
  //       padding: EdgeInsets.only(
  //         left: kDefaultPadding,
  //         right: kDefaultPadding,
  //         top: kDefaultPadding,
  //         bottom: MediaQuery.of(context).viewInsets.bottom + 10,
  //       ),
  //       decoration: BoxDecoration(
  //         color: isDark ? Colors.black : Colors.white,
  //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Obx(() {
  //         final previewProduct = ProductAdd(
  //           id: 'preview',
  //           market: Market(
  //               name: nameController.text.isEmpty
  //                   ? 'اسم المنتج'
  //                   : nameController.text,
  //               logo: ''),
  //           price: priceController.text.isEmpty ? '0' : priceController.text,
  //           priceOffer:
  //           priceOfferController.text.isNotEmpty ? priceOfferController.text : '',
  //           descriptionAr: descriptionController.text.isEmpty
  //               ? 'وصف المنتج'
  //               : descriptionController.text,
  //           descriptionEn: descriptionController.text.isEmpty
  //               ? 'Product Description'
  //               : descriptionController.text,
  //           images: uploadedImages.isNotEmpty
  //               ? [ImageModel(image: uploadedImages.first.path)]
  //               : [],
  //         );
  //
  //         return SingleChildScrollView(
  //           physics: ClampingScrollPhysics(),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               _buildSheetHeader(context, 'addProduct'.tr),
  //               const SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'preview'.tr,
  //                     style: GoogleFonts.tajawal(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: isDark ? Colors.white : Colors.black,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //               SizedBox(
  //                 width: MediaQuery.of(context).size.width * 0.45,
  //                 child: ProductCardGrid(
  //                   product: previewProduct,
  //                   onTap: () {},
  //                   onFavoriteTap: () {},
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'productImages'.tr,
  //                     style: GoogleFonts.tajawal(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //               Container(
  //                 height: 150,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color: isDark ? Colors.grey[700] : const Color(0xffF6F6F6),
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(color: isDark ? Colors.grey : Colors.grey),
  //                 ),
  //                 child: Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       IconButton(
  //                         icon: const Icon(Icons.cloud_upload_sharp, size: 30),
  //                         color: AppColors.black,
  //                         onPressed: () async {
  //                           final picker = ImagePicker();
  //                           final pickedFile =
  //                           await picker.pickImage(source: ImageSource.gallery);
  //                           if (pickedFile != null) {
  //                             uploadedImages.add(File(pickedFile.path));
  //                           }
  //                         },
  //                       ),
  //                       Text(
  //                         'selectImages'.tr,
  //                         style: GoogleFonts.tajawal(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.normal,
  //                           color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //                         ),
  //                       ),
  //                       Text(
  //                         'atLeastImage'.tr,
  //                         style: GoogleFonts.tajawal(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.normal,
  //                           color: isDark ? Colors.white : const Color(0xffC2C73A),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 8,),
  //               if(uploadedImages.isNotEmpty)
  //                Padding(
  //                  padding:EdgeInsets.only(top: 10),
  //                  child: SizedBox(
  //                   height: 80,
  //                   child: Obx(() => ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     itemCount: uploadedImages.length,
  //                     itemBuilder: (context, index) {
  //                       return Padding(
  //                         padding: const EdgeInsets.only(right: 10),
  //                         child: Stack(
  //                           children: [
  //                             Container(
  //                               width: 80,
  //                               height: 100,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 image: DecorationImage(
  //                                   image: FileImage(uploadedImages[index]),
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                               ),
  //                             ),
  //                             Positioned(
  //                               top: -10,
  //                               right: -10,
  //                               child: IconButton(
  //                                 icon: const Icon(Icons.remove_circle,
  //                                     color: Colors.red),
  //                                 onPressed: () {
  //                                   uploadedImages.removeAt(index);
  //                                 },
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                   )),
  //                                  ),
  //                ),
  //               if (imagesError.value.isNotEmpty)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0),
  //                   child: Text(
  //                     imagesError.value,
  //                     style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
  //                   ),
  //                 ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'productName'.tr,
  //                 hintText: '',
  //                 controller: nameController,
  //                 errorText: nameError.value.isNotEmpty ? nameError.value : null,
  //                 onChanged: (value) => nameError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               CustomSingleDropdown(
  //                 categories: categoryController.categories,
  //                 selectedCategoryId: selectedCategoryId,
  //                 isDark: isDark,
  //                 errorText: categoryError.value.isNotEmpty ? categoryError.value : null,
  //               ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'descriptionApp'.tr,
  //                 hintText: '',
  //                 controller: descriptionController,
  //                 errorText:
  //                 descriptionError.value.isNotEmpty ? descriptionError.value : null,
  //                 onChanged: (value) => descriptionError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: CustomTextField(
  //                       label: 'productPrice'.tr,
  //                       hintText: '',
  //                       controller: priceController,
  //                       keyboardType: TextInputType.number,
  //                       errorText: priceError.value.isNotEmpty ? priceError.value : null,
  //                       onChanged: (value) => priceError.value = '',
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Expanded(
  //                     child: CustomTextField(
  //                       label: 'productOfferPrice'.tr,
  //                       hintText: '',
  //                       controller: priceOfferController,
  //                       keyboardType: TextInputType.number,
  //                       errorText:
  //                       priceOfferError.value.isNotEmpty ? priceOfferError.value : null,
  //                       onChanged: (value) => priceOfferError.value = '',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'productLink'.tr,
  //                 hintText: '',
  //                 controller: linkController,
  //                 keyboardType: TextInputType.url,
  //                 errorText: linkError.value.isNotEmpty ? linkError.value : null,
  //                 onChanged: (value) => linkError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               CustomStatusDropdown(
  //                 status: status,
  //                 isDark: isDark,
  //               ),
  //               const SizedBox(height: 30),
  //               CustomButton(
  //                 text: productController.isLoading.value ? 'progress'.tr : 'add'.tr,
  //                 textSize: 22,
  //                 textFontWeight: FontWeight.bold,
  //                 onPressed: productController.isLoading.value
  //                     ? null
  //                     : () async {
  //                   nameError.value = '';
  //                   descriptionError.value = '';
  //                   priceError.value = '';
  //                   priceOfferError.value = '';
  //                   linkError.value = '';
  //                   categoryError.value = '';
  //                   imagesError.value = '';
  //
  //                   if (nameController.text.isEmpty) {
  //                     nameError.value = 'nameRequired'.tr;
  //                     return;
  //                   }
  //                   if (descriptionController.text.isEmpty) {
  //                     descriptionError.value = 'descRequired'.tr;
  //                     return;
  //                   }
  //                   if (priceController.text.isEmpty) {
  //                     priceError.value = 'priceRequired'.tr;
  //                     return;
  //                   }
  //                   if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(priceController.text)) {
  //                     priceError.value = 'wrongPrice'.tr;
  //                     return;
  //                   }
  //                   if (priceOfferController.text.isNotEmpty &&
  //                       !RegExp(r'^\d+(\.\d+)?$')
  //                           .hasMatch(priceOfferController.text)) {
  //                     priceOfferError.value = 'wrongPrice'.tr;
  //                     return;
  //                   }
  //                   if (linkController.text.isEmpty) {
  //                     linkError.value = 'linkRequired'.tr;
  //                     return;
  //                   }
  //                   if (!Uri.parse(linkController.text).isAbsolute) {
  //                     linkError.value = 'invalidLink'.tr;
  //                     return;
  //                   }
  //                   if (uploadedImages.isEmpty) {
  //                     imagesError.value = 'imagesRequired'.tr;
  //                     return;
  //                   }
  //                   if (selectedCategoryId.value == null) {
  //                     categoryError.value = 'categoryRequired'.tr;
  //                     return;
  //                   }
  //
  //                   final success = await productController.addProduct(
  //                     nameAr: nameController.text,
  //                     nameEn: nameController.text,
  //                     categoryId: selectedCategoryId.value!,
  //                     descriptionAr: descriptionController.text,
  //                     descriptionEn: descriptionController.text,
  //                     price: priceController.text,
  //                     priceOffer: priceOfferController.text.isNotEmpty
  //                         ? priceOfferController.text
  //                         : null,
  //                     link: linkController.text,
  //                     images: uploadedImages,
  //                     status: status.value, // Pass status
  //                   );
  //
  //                   if (success) {
  //                     Navigator.pop(context);
  //                     _showSuccessDialog(
  //                       context,
  //                       title: 'productAddSuccess'.tr,
  //                       buttonText: 'browseProducts'.tr,
  //                       onButtonPressed: () {
  //                         productController.fetchProducts(page: 1);
  //                         // Get.offAllNamed(AppRoutes.navbar);
  //                         // Remove Navigator.pop(context)
  //                       },
  //                     );
  //                   } else {
  //                     if (productController.validationErrors.isNotEmpty) {
  //                       final errors = productController.validationErrors;
  //                       if (errors.containsKey('name_ar') ||
  //                           errors.containsKey('name_en')) {
  //                         nameError.value = (errors['name_ar'] ?? errors['name_en'])
  //                             ?.join(', ') ??
  //                             '';
  //                       }
  //                       if (errors.containsKey('description_ar') ||
  //                           errors.containsKey('description_en')) {
  //                         descriptionError.value =
  //                             (errors['description_ar'] ?? errors['description_en'])
  //                                 ?.join(', ') ??
  //                                 '';
  //                       }
  //                       if (errors.containsKey('price')) {
  //                         priceError.value = errors['price']!.join(', ');
  //                       }
  //                       if (errors.containsKey('price_offer')) {
  //                         priceOfferError.value =
  //                             errors['price_offer']!.join(', ');
  //                       }
  //                       if (errors.containsKey('link')) {
  //                         linkError.value = errors['link']!.join(', ');
  //                       }
  //                       if (errors.containsKey('category_id')) {
  //                         categoryError.value = errors['category_id']!.join(', ');
  //                       }
  //                       if (errors.containsKey('images')) {
  //                         imagesError.value = errors['images']!.join(', ');
  //                       }
  //                       if (errors.containsKey('status')) {
  //                         statusError.value = errors['status']!.join(', ');
  //                       }
  //                     } else {
  //                       nameError.value = productController.errorMessage.value;
  //                     }
  //                   }
  //                 },
  //               ),
  //               SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
  //             ],
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }
  // static void showEditProductSheet(BuildContext context, Product product) {
  //   final ThemeController themeController = Get.put(ThemeController());
  //   bool isDark = themeController.themeMode.value == ThemeMode.dark;
  //   final productController = Get.put(ProductController());
  //   final categoryController = Get.put(CategoryController());
  //
  //   final nameController = TextEditingController(text: product.nameAr);
  //   final descriptionController = TextEditingController(text: product.descriptionAr);
  //   final priceController = TextEditingController(text: product.price);
  //   final priceOfferController = TextEditingController(text: product.priceOffer ?? '');
  //   final linkController = TextEditingController(text: product.link);
  //
  //   final nameError = ''.obs;
  //   final descriptionError = ''.obs;
  //   final priceError = ''.obs;
  //   final priceOfferError = ''.obs;
  //   final linkError = ''.obs;
  //   final categoryError = ''.obs;
  //   final imagesError = ''.obs;
  //   final statusError = ''.obs; // Added for status errors
  //   final selectedCategoryId = Rxn<int>(product.categoryId);
  //   final uploadedImages = <File>[].obs;
  //
  //   final existingImages = product.images.obs;
  //   final status = product.status.obs; // Initialize with product.status
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: kBottomSheetHeight,
  //       padding: EdgeInsets.only(
  //         left: kDefaultPadding,
  //         right: kDefaultPadding,
  //         top: kDefaultPadding,
  //         bottom: MediaQuery.of(context).viewInsets.bottom + 10,
  //       ),
  //       decoration: BoxDecoration(
  //         color: isDark ? Colors.black : Colors.white,
  //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Obx(() {
  //         final previewImages = [
  //           ...existingImages.map((img) => ImageModel(image: img.image)),
  //           ...uploadedImages.map((file) => ImageModel(image: file.path)),
  //         ];
  //         final previewProduct = ProductAdd(
  //           id: product.id.toString(),
  //           market: Market(
  //             name: nameController.text.isEmpty ? 'اسم المنتج' : nameController.text,
  //             logo: '',
  //           ),
  //           price: priceController.text.isEmpty ? '0' : priceController.text,
  //           priceOffer: priceOfferController.text.isNotEmpty ? priceOfferController.text : '',
  //           descriptionAr: descriptionController.text.isEmpty
  //               ? 'وصف المنتج'
  //               : descriptionController.text,
  //           descriptionEn: descriptionController.text.isEmpty
  //               ? 'Product Description'
  //               : descriptionController.text,
  //           images: previewImages,
  //         );
  //
  //         return SingleChildScrollView(
  //           physics: ClampingScrollPhysics(),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               _buildSheetHeader(context, 'editProducts'.tr),
  //               const SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'preview'.tr,
  //                     style: GoogleFonts.tajawal(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: isDark ? Colors.white : Colors.black,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //               SizedBox(
  //                 width: MediaQuery.of(context).size.width * 0.45,
  //                 child: ProductCardGrid(
  //                   product: previewProduct,
  //                   onTap: () {},
  //                   onFavoriteTap: () {},
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'productImages'.tr,
  //                     style: GoogleFonts.tajawal(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //               Container(
  //                 height: 150,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color: isDark ? Colors.grey[700] : const Color(0xffF6F6F6),
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(color: isDark ? Colors.grey : Colors.grey),
  //                 ),
  //                 child: Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       IconButton(
  //                         icon: const Icon(Icons.cloud_upload_sharp, size: 30),
  //                         color: AppColors.black,
  //                         onPressed: () async {
  //                           final picker = ImagePicker();
  //                           final pickedFile =
  //                           await picker.pickImage(source: ImageSource.gallery);
  //                           if (pickedFile != null) {
  //                             uploadedImages.add(File(pickedFile.path));
  //                           }
  //                         },
  //                       ),
  //                       Text(
  //                         'selectImages'.tr,
  //                         style: GoogleFonts.tajawal(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.normal,
  //                           color: isDark ? Colors.white : const Color(0xff5D5C5C),
  //                         ),
  //                       ),
  //                       Text(
  //                         'atLeastImage'.tr,
  //                         style: GoogleFonts.tajawal(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.normal,
  //                           color: isDark ? Colors.white : const Color(0xffC2C73A),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 8),
  //                 child: SizedBox(
  //                   height: 80,
  //                   child: Obx(() => ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     itemCount: existingImages.length + uploadedImages.length,
  //                     itemBuilder: (context, index) {
  //                       if (index < existingImages.length) {
  //                         // Display existing images (URLs)
  //                         final image = existingImages[index];
  //                         return Padding(
  //                           padding: const EdgeInsets.only(right: 10),
  //                           child: Stack(
  //                             children: [
  //                               Container(
  //                                 width: 80,
  //                                 height: 100,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   image: DecorationImage(
  //                                     image: NetworkImage(image.image),
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Positioned(
  //                                 top: -10,
  //                                 right: -10,
  //                                 child: IconButton(
  //                                   icon: const Icon(Icons.remove_circle, color: Colors.red),
  //                                   onPressed: () {
  //                                     existingImages.removeAt(index);
  //                                   },
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                       } else {
  //                         // Display newly uploaded images
  //                         final file = uploadedImages[index - existingImages.length];
  //                         return Padding(
  //                           padding: const EdgeInsets.only(right: 10),
  //                           child: Stack(
  //                             children: [
  //                               Container(
  //                                 width: 80,
  //                                 height: 100,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   image: DecorationImage(
  //                                     image: FileImage(file),
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Positioned(
  //                                 top: -10,
  //                                 right: -10,
  //                                 child: IconButton(
  //                                   icon: const Icon(Icons.remove_circle, color: Colors.red),
  //                                   onPressed: () {
  //                                     uploadedImages.removeAt(index - existingImages.length);
  //                                   },
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                       }
  //                     },
  //                   )),
  //                 ),
  //               ),
  //               if (imagesError.value.isNotEmpty)
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0),
  //                   child: Text(
  //                     imagesError.value,
  //                     style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
  //                   ),
  //                 ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'productName'.tr,
  //                 hintText: '',
  //                 controller: nameController,
  //                 errorText: nameError.value.isNotEmpty ? nameError.value : null,
  //                 onChanged: (value) => nameError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               CustomSingleDropdown(
  //                 categories: categoryController.categories,
  //                 selectedCategoryId: selectedCategoryId,
  //                 isDark: isDark,
  //                 errorText: categoryError.value.isNotEmpty ? categoryError.value : null,
  //               ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'descriptionApp'.tr,
  //                 hintText: '',
  //                 controller: descriptionController,
  //                 errorText:
  //                 descriptionError.value.isNotEmpty ? descriptionError.value : null,
  //                 onChanged: (value) => descriptionError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: CustomTextField(
  //                       label: 'productPrice'.tr,
  //                       hintText: '',
  //                       controller: priceController,
  //                       keyboardType: TextInputType.number,
  //                       errorText: priceError.value.isNotEmpty ? priceError.value : null,
  //                       onChanged: (value) => priceError.value = '',
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Expanded(
  //                     child: CustomTextField(
  //                       label: 'productOfferPrice'.tr,
  //                       hintText: '',
  //                       controller: priceOfferController,
  //                       keyboardType: TextInputType.number,
  //                       errorText:
  //                       priceOfferError.value.isNotEmpty ? priceOfferError.value : null,
  //                       onChanged: (value) => priceOfferError.value = '',
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'productLink'.tr,
  //                 hintText: '',
  //                 controller: linkController,
  //                 keyboardType: TextInputType.url,
  //                 errorText: linkError.value.isNotEmpty ? linkError.value : null,
  //                 onChanged: (value) => linkError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               CustomStatusDropdown(
  //                 status: status,
  //                 isDark: isDark,
  //               ),
  //               const SizedBox(height: 30),
  //               CustomButton(
  //                 text: productController.isLoading.value ? 'editProgress'.tr : 'editApp'.tr,
  //                 textSize: 22,
  //                 textFontWeight: FontWeight.bold,
  //                 onPressed: productController.isLoading.value
  //                     ? null
  //                     : () async {
  //                   nameError.value = '';
  //                   descriptionError.value = '';
  //                   priceError.value = '';
  //                   priceOfferError.value = '';
  //                   linkError.value = '';
  //                   categoryError.value = '';
  //                   imagesError.value = '';
  //                   statusError.value = '';
  //                   if (nameController.text.isEmpty) {
  //                     nameError.value = 'nameRequired'.tr;
  //                     return;
  //                   }
  //                   if (descriptionController.text.isEmpty) {
  //                     descriptionError.value = 'descRequired'.tr;
  //                     return;
  //                   }
  //                   if (priceController.text.isEmpty) {
  //                     priceError.value = 'priceRequired'.tr;
  //                     return;
  //                   }
  //                   if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(priceController.text)) {
  //                     priceError.value = 'wrongPrice'.tr;
  //                     return;
  //                   }
  //                   if (priceOfferController.text.isNotEmpty &&
  //                       !RegExp(r'^\d+(\.\d+)?$')
  //                           .hasMatch(priceOfferController.text)) {
  //                     priceOfferError.value = 'wrongPrice'.tr;
  //                     return;
  //                   }
  //                   if (linkController.text.isEmpty) {
  //                     linkError.value = 'linkRequired'.tr;
  //                     return;
  //                   }
  //                   if (!Uri.parse(linkController.text).isAbsolute) {
  //                     linkError.value = 'invalidLink'.tr;
  //                     return;
  //                   }
  //                   if (uploadedImages.isEmpty && product.images.isEmpty) {
  //                     imagesError.value = 'imagesRequired'.tr;
  //                     return;
  //                   }
  //                   if (selectedCategoryId.value == null) {
  //                     categoryError.value = 'categoryRequired'.tr;
  //                     return;
  //                   }
  //
  //                   final success = await productController.updateProduct(
  //                     productId: product.id,
  //                     nameAr: nameController.text,
  //                     nameEn: nameController.text,
  //                     categoryId: selectedCategoryId.value!,
  //                     descriptionAr: descriptionController.text,
  //                     descriptionEn: descriptionController.text,
  //                     price: priceController.text,
  //                     priceOffer: priceOfferController.text.isNotEmpty
  //                         ? priceOfferController.text
  //                         : null,
  //                     link: linkController.text,
  //                     images: uploadedImages.isNotEmpty ? uploadedImages : null,
  //                     status: status.value, // Pass status
  //                   );
  //
  //                   if (success) {
  //                     Navigator.pop(context);
  //                     _showSuccessDialog(
  //                       context,
  //                       title: 'editSuccess'.tr,
  //                       buttonText: 'browseProducts'.tr,
  //                       onButtonPressed: () {
  //                         productController.fetchProducts(page: 1);
  //                         // Remove Navigator.pop(context)
  //                       },
  //                     );
  //                   } else {
  //                     if (productController.validationErrors.isNotEmpty) {
  //                       final errors = productController.validationErrors;
  //                       if (errors.containsKey('name_ar') ||
  //                           errors.containsKey('name_en')) {
  //                         nameError.value = (errors['name_ar'] ?? errors['name_en'])
  //                             ?.join(', ') ??
  //                             '';
  //                       }
  //                       if (errors.containsKey('description_ar') ||
  //                           errors.containsKey('description_en')) {
  //                         descriptionError.value =
  //                             (errors['description_ar'] ?? errors['description_en'])
  //                                 ?.join(', ') ??
  //                                 '';
  //                       }
  //                       if (errors.containsKey('price')) {
  //                         priceError.value = errors['price']!.join(', ');
  //                       }
  //                       if (errors.containsKey('price_offer')) {
  //                         priceOfferError.value =
  //                             errors['price_offer']!.join(', ');
  //                       }
  //                       if (errors.containsKey('link')) {
  //                         linkError.value = errors['link']!.join(', ');
  //                       }
  //                       if (errors.containsKey('category_id')) {
  //                         categoryError.value = errors['category_id']!.join(', ');
  //                       }
  //                       if (errors.containsKey('images')) {
  //                         imagesError.value = errors['images']!.join(', ');
  //                       }
  //                       if (errors.containsKey('status')) {
  //                         statusError.value = errors['status']!.join(', ');
  //                       }
  //                     } else {
  //                       nameError.value = productController.errorMessage.value;
  //                     }
  //                   }
  //                 },
  //               ),
  //               SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
  //             ],
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }
// static void showAddCouponSheet(BuildContext context, {Coupon? coupon}) {
  //   final ThemeController themeController = Get.put(ThemeController());
  //   bool isDark = themeController.themeMode.value == ThemeMode.dark;
  //   final CouponController couponController = Get.put(CouponController());
  //   final CategoryController categoryController = Get.put(CategoryController());
  //   final ProfileController profileController = Get.put(ProfileController());
  //
  //   final couponCodeController = TextEditingController(text: coupon?.couponCode ?? '');
  //   final descriptionArController = TextEditingController(text: coupon?.descriptionAr ?? '');
  //   final descriptionEnController = TextEditingController(text: coupon?.descriptionEn ?? '');
  //   final linkController = TextEditingController(text: coupon?.link ?? '');
  //   final termsController = TextEditingController(text: coupon?.terms ?? '');
  //   final discountController = TextEditingController(text: coupon?.discount ?? '');
  //   final selectedCategoryId = Rxn<int>(coupon?.categoryId);
  //   final couponCodeError = ''.obs;
  //   final descriptionArError = ''.obs;
  //   final descriptionEnError = ''.obs;
  //   final linkError = ''.obs;
  //   final termsError = ''.obs;
  //   final discountError = ''.obs;
  //   final categoryError = ''.obs;
  //   final statusError = ''.obs; // Add for status errors
  //   final status = (coupon?.status ?? 1).obs; // Initialize with coupon status
  //   // Static market data (to be replaced with API in the future)
  //   var staticMarket = MarketCoupon(
  //     id: coupon?.market.id ?? 2, // Use existing market ID or default
  //     name: profileController.profile.value?.name ?? 'متجر مثالي',
  //     logo: profileController.profile.value?.logo ?? 'https://couponatnoon.net/images/store_1716831527.png',
  //   );
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => Container(
  //       height: kBottomSheetHeight,
  //       padding: EdgeInsets.only(
  //         left: kDefaultPadding,
  //         right: kDefaultPadding,
  //         top: kDefaultPadding,
  //         bottom: MediaQuery.of(context).viewInsets.bottom + 10,
  //       ),
  //       decoration: BoxDecoration(
  //         color: isDark ? Colors.black : Colors.white,
  //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Obx(() {
  //         final previewCoupon = Coupon(
  //           id: coupon?.id ?? 0,
  //           couponCode: couponCodeController.text.isEmpty ? 'XXXX-XXXX' : couponCodeController.text,
  //           descriptionAr: descriptionArController.text.isEmpty ? 'وصف المنتج' : descriptionArController.text,
  //           descriptionEn: descriptionArController.text.isEmpty ? 'Product Description' : descriptionArController.text,
  //           terms: termsController.text.isEmpty ? null : termsController.text,
  //           discount: discountController.text.isEmpty ? '0' : discountController.text,
  //           link: linkController.text.isEmpty ? 'https://example.com' : linkController.text,
  //           createdAt: coupon?.createdAt ?? '05-11-2025',
  //           updatedAt: coupon?.updatedAt ?? '05-11-2025',
  //           categoryId: selectedCategoryId.value ?? 1,
  //           market: staticMarket,
  //           status: status.value, // Set status
  //           viewCoupon: status.value, // Set status
  //         );
  //
  //         return SingleChildScrollView(
  //           physics: ClampingScrollPhysics(),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildSheetHeader(context, coupon == null ? 'addCoupon'.tr : 'editCoupon'.tr),
  //               const SizedBox(height: 20),
  //               Text(
  //                 'preview'.tr,
  //                 style: GoogleFonts.tajawal(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: isDark ? Colors.white : Colors.black,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   SizedBox(
  //                     width: MediaQuery.of(context).size.width * 0.45,
  //                     height: MediaQuery.of(context).size.width * 0.45 * 1.33,
  //                     child: CouponCardGrid(
  //                       coupon: previewCoupon,
  //                       onTap: () {},
  //                       onCopy: () {},
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'couponDiscount'.tr,
  //                 hintText: '',
  //                 controller: discountController,
  //                 keyboardType: TextInputType.number,
  //                 errorText: discountError.value.isNotEmpty ? discountError.value : null,
  //                 onChanged: (value) => discountError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //
  //               CustomTextField(
  //                 label: 'descriptionApp'.tr,
  //                 hintText: '',
  //                 controller: descriptionArController,
  //                 errorText: descriptionArError.value.isNotEmpty ? descriptionArError.value : null,
  //                 onChanged: (value) => descriptionArError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               CustomSingleDropdown(
  //                 categories: categoryController.categories,
  //                 selectedCategoryId: selectedCategoryId,
  //                 isDark: isDark,
  //                 errorText: categoryError.value.isNotEmpty ? categoryError.value : null,
  //               ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'codeApp'.tr,
  //                 hintText: '',
  //                 controller: couponCodeController,
  //                 errorText: couponCodeError.value.isNotEmpty ? couponCodeError.value : null,
  //                 onChanged: (value) => couponCodeError.value = '',
  //               ),
  //               // const SizedBox(height: 20),
  //               // CustomTextField(
  //               //   label: 'description_ar'.tr,
  //               //   hintText: 'وصف الكوبون بالعربية',
  //               //   controller: descriptionArController,
  //               //   errorText: descriptionArError.value.isNotEmpty ? descriptionArError.value : null,
  //               //   onChanged: (value) => descriptionArError.value = '',
  //               // ),
  //               // const SizedBox(height: 20),
  //               // CustomTextField(
  //               //   label: 'description_en'.tr,
  //               //   hintText: 'Coupon description in English',
  //               //   controller: descriptionEnController,
  //               //   errorText: descriptionEnError.value.isNotEmpty ? descriptionEnError.value : null,
  //               //   onChanged: (value) => descriptionEnError.value = '',
  //               // ),
  //               const SizedBox(height: 20),
  //               CustomTextField(
  //                 label: 'couponLink'.tr,
  //                 hintText: '',
  //                 controller: linkController,
  //                 keyboardType: TextInputType.url,
  //                 errorText: linkError.value.isNotEmpty ? linkError.value : null,
  //                 onChanged: (value) => linkError.value = '',
  //               ),
  //               const SizedBox(height: 20),
  //               // CustomTextField(
  //               //   label: 'terms'.tr,
  //               //   hintText: 'شروط وأحكام الكوبون (اختياري)',
  //               //   controller: termsController,
  //               //   errorText: termsError.value.isNotEmpty ? termsError.value : null,
  //               //   onChanged: (value) => termsError.value = '',
  //               // ),
  //               // const SizedBox(height: 20),
  //               //
  //               // const SizedBox(height: 20),
  //
  //               const SizedBox(height: 20),
  //               CustomStatusDropdown(
  //                 status: status,
  //                 isDark: isDark,
  //               ),
  //               const SizedBox(height: 30),
  //               CustomButton(
  //                 text: couponController.isLoading.value
  //                     ? 'progress'.tr
  //                     : coupon == null
  //                     ? 'add'.tr
  //                     : 'editApp'.tr,
  //                 textSize: 22,
  //                 textFontWeight: FontWeight.bold,
  //                 onPressed: couponController.isLoading.value
  //                     ? null
  //                     : () async {
  //                   print('Add/Update Coupon button clicked at ${DateTime.now()}');
  //
  //                   couponCodeError.value = '';
  //                   descriptionArError.value = '';
  //                   descriptionEnError.value = '';
  //                   linkError.value = '';
  //                   termsError.value = '';
  //                   discountError.value = '';
  //                   categoryError.value = '';
  //                   statusError.value = '';
  //                   print('Input values:');
  //                   print('  couponCode: ${couponCodeController.text}');
  //                   print('  descriptionAr: ${descriptionArController.text}');
  //                   print('  descriptionEn: ${descriptionEnController.text}');
  //                   print('  link: ${linkController.text}');
  //                   print('  terms: ${termsController.text}');
  //                   print('  discount: ${discountController.text}');
  //                   print('  categoryId: ${selectedCategoryId.value}');
  //
  //                   if (couponCodeController.text.isEmpty) {
  //                     couponCodeError.value = 'codeRequired'.tr;
  //                     print('Validation error: coupon_code_required');
  //                     return;
  //                   }
  //                   if (descriptionArController.text.isEmpty) {
  //                     descriptionArError.value = 'descRequired'.tr;
  //                     print('Validation error: description_ar_required');
  //                     return;
  //                   }
  //                   // if (descriptionEnController.text.isEmpty) {
  //                   //   descriptionEnError.value = 'description_en_required'.tr;
  //                   //   print('Validation error: description_en_required');
  //                   //   return;
  //                   // }
  //                   if (linkController.text.isEmpty) {
  //                     linkError.value = 'linkRequired'.tr;
  //                     print('Validation error: link_required');
  //                     return;
  //                   }
  //                   if (!Uri.parse(linkController.text).isAbsolute) {
  //                     linkError.value = 'invalidLink'.tr;
  //                     print('Validation error: link_invalid');
  //                     return;
  //                   }
  //                   if (discountController.text.isEmpty) {
  //                     discountError.value = 'discountRequired'.tr;
  //                     print('Validation error: discount_required');
  //                     return;
  //                   }
  //                   if (!RegExp(r'^\d+$').hasMatch(discountController.text)) {
  //                     discountError.value = 'wrongDiscount'.tr;
  //                     print('Validation error: discount_invalid');
  //                     return;
  //                   }
  //                   int discountValue = int.parse(discountController.text);
  //                   if (discountValue < 1 || discountValue > 100) {
  //                     discountError.value = 'wrongDiscountMessage'.tr;
  //                     print('Validation error: discount_range_invalid');
  //                     return;
  //                   }
  //                   if (selectedCategoryId.value == null) {
  //                     categoryError.value = 'categoryRequired'.tr;
  //                     print('Validation error: category_required');
  //                     return;
  //                   }
  //
  //                   print('All validations passed, proceeding with ${coupon == null ? 'addCoupon' : 'updateCoupon'}');
  //
  //                   bool success;
  //                   if (coupon == null) {
  //                     success = await couponController.addCoupon(
  //                       couponCode: couponCodeController.text,
  //                       descriptionAr: descriptionArController.text,
  //                       descriptionEn: descriptionArController.text,
  //                       link: linkController.text,
  //                       terms: termsController.text.isEmpty ? null : termsController.text,
  //                       categoryId: selectedCategoryId.value!,
  //                       discount: discountController.text,
  //                       status: status.value, // Pass status
  //                     );
  //                   } else {
  //                     success = await couponController.updateCoupon(
  //                       couponId: coupon.id,
  //                       couponCode: couponCodeController.text,
  //                       descriptionAr: descriptionArController.text,
  //                       descriptionEn: descriptionArController.text,
  //                       link: linkController.text,
  //                       terms: termsController.text.isEmpty ? null : termsController.text,
  //                       categoryId: selectedCategoryId.value!,
  //                       discount: discountController.text,
  //                       status: status.value, // Pass status
  //                     );
  //                   }
  //
  //                   print('Coupon operation success: $success');
  //                   // In showAddCouponSheet, inside the CustomButton's onPressed callback
  //                   if (success) {
  //                     print('Closing bottom sheet and showing success dialog');
  //                     Navigator.pop(context); // Close the bottom sheet
  //                     _showSuccessDialog(
  //                       context,
  //                       title: coupon == null ? 'couponAddSuccess'.tr : 'couponEditSuccess'.tr,
  //                       buttonText: 'browseCoupon'.tr,
  //                       onButtonPressed: () {
  //                         print('Refreshing coupon list');
  //                         couponController.fetchCoupons(page: 1);
  //                         // Remove Navigator.pop(context) as it's handled in _showSuccessDialog
  //                       },
  //                     );
  //                   } else {
  //                     print('Operation failed, checking validation errors');
  //                     if (couponController.validationErrors.isNotEmpty) {
  //                       final errors = couponController.validationErrors;
  //                       if (errors.containsKey('coupon_code')) {
  //                         couponCodeError.value = errors['coupon_code']!.join(', ');
  //                         print('API error: coupon_code - ${couponCodeError.value}');
  //                       }
  //                       if (errors.containsKey('description_ar')) {
  //                         descriptionArError.value = errors['description_ar']!.join(', ');
  //                         print('API error: description_ar - ${descriptionArError.value}');
  //                       }
  //                       if (errors.containsKey('description_en')) {
  //                         descriptionEnError.value = errors['description_en']!.join(', ');
  //                         print('API error: description_en - ${descriptionEnError.value}');
  //                       }
  //                       if (errors.containsKey('link')) {
  //                         linkError.value = errors['link']!.join(', ');
  //                         print('API error: link - ${linkError.value}');
  //                       }
  //                       if (errors.containsKey('terms')) {
  //                         termsError.value = errors['terms']!.join(', ');
  //                         print('API error: terms - ${termsError.value}');
  //                       }
  //                       if (errors.containsKey('discount')) {
  //                         discountError.value = errors['discount']!.join(', ');
  //                         print('API error: discount - ${discountError.value}');
  //                       }
  //                       if (errors.containsKey('category_id')) {
  //                         categoryError.value = errors['category_id']!.join(', ');
  //                         print('API error: category_id - ${categoryError.value}');
  //                       }
  //                       if (errors.containsKey('status')) {
  //                         statusError.value = errors['status']!.join(', ');
  //                         print('API error: status - ${statusError.value}');
  //                       }
  //                     } else {
  //                       couponCodeError.value = couponController.errorMessage.value;
  //                       print('API error: general - ${couponCodeError.value}');
  //                     }
  //                   }
  //                 },
  //               ),
  //               SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
  //             ],
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }
  static Future<void> showAddProductSheet(BuildContext context) async {
    final ThemeController themeController = Get.put(ThemeController());
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final ProductController productController = Get.put(ProductController());
    final CategoryController categoryController = Get.put(CategoryController());
    final PackageUsageController packageUsageController =
        Get.put(PackageUsageController());
    final InstallmentWayController installmentController =
        Get.put(InstallmentWayController());

    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController priceOfferController = TextEditingController();
    final TextEditingController linkController = TextEditingController();

    final nameError = ''.obs;
    final descriptionError = ''.obs;
    final priceError = ''.obs;
    final priceOfferError = ''.obs;
    final linkError = ''.obs;
    final categoryError = ''.obs;
    final imagesError = ''.obs;
    final statusError = ''.obs;
    final installmentError = ''.obs;
    final selectedInstallmentIds = <int>[].obs;
    final selectedCategoryId = Rxn<int>();
    final uploadedImages = <File>[].obs;
    final status = 1.obs;
    final isFetchingUsage = true.obs;
    final usageError = ''.obs;
    packageUsageController.fetchPackageUsage().then((success) {
      isFetchingUsage(false);
      if (!success) {
        usageError.value = packageUsageController.errorMessage.value;
      }
    });
    installmentController.fetchInstallmentWays();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: kBottomSheetHeight,
        padding: EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final previewProduct = ProductAdd(
            id: 'preview',
            market: Market(
                name: nameController.text.isEmpty
                    ? 'productName'.tr
                    : nameController.text,
                logo: ''),
            price: priceController.text.isEmpty ? '0' : priceController.text,
            priceOffer: priceOfferController.text.isNotEmpty
                ? priceOfferController.text
                : '',
            descriptionAr: descriptionController.text.isEmpty
                ? 'product_des'.tr
                : descriptionController.text,
            descriptionEn: descriptionController.text.isEmpty
                ? 'product_des'.tr
                : descriptionController.text,
            images: uploadedImages.isNotEmpty
                ? [ImageModel(image: uploadedImages.first.path)]
                : [],
          );

          final addProductsUsage = packageUsageController.packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'add_products');

          print("tag ==>${addProductsUsage?.tag}");

          String addProductsStatus = "";
          if (addProductsUsage == null || addProductsUsage.isNone) {
            addProductsStatus = 'none';
          } else if (addProductsUsage.remaining == null) {
            addProductsStatus = 'unlimited';
          } else if (addProductsUsage.remaining! > 0) {
            addProductsStatus = 'available';
          } else {
            addProductsStatus = 'limit_reached';
          }
          print(
              'add_products status: $addProductsStatus, remaining: ${addProductsUsage?.remaining}, isNone: ${addProductsUsage?.isNone}');
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSheetHeader(context, 'addProduct'.tr),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'preview'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: ProductCardGrid(
                    product: previewProduct,
                    onTap: () {},
                    onFavoriteTap: () {},
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'productImages'.tr,
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xff5D5C5C),
                            ),
                          ),
                          TextSpan(
                            text: ' *',
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : const Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: isDark ? Colors.grey : Colors.grey),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.cloud_upload_sharp, size: 30),
                          color: AppColors.black,
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              //compress image
                              final dir = await getTemporaryDirectory();
                              final targetPath = path.join(dir.path,
                                  "${DateTime.now().millisecondsSinceEpoch}.jpg");
                              var result =
                                  await FlutterImageCompress.compressAndGetFile(
                                pickedFile.path,
                                targetPath,
                                quality: 60, // 60–80 is a good range
                              );

                              uploadedImages
                                  .add(File(result?.path ?? pickedFile.path));
                            }
                          },
                        ),
                        Text(
                          'selectImages'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color:
                                isDark ? Colors.white : const Color(0xff5D5C5C),
                          ),
                        ),
                        Text(
                          'atLeastImage'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color:
                                isDark ? Colors.white : const Color(0xffC2C73A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                if (uploadedImages.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: 80,
                      child: Obx(() => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: uploadedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image:
                                              FileImage(uploadedImages[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () {
                                          uploadedImages.removeAt(index);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
                    ),
                  ),
                if (imagesError.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      imagesError.value,
                      style:
                          GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'productName'.tr,
                  hintText: '',
                  controller: nameController,
                  isRequired: true,
                  maxLength: 100,
                  errorText:
                      nameError.value.isNotEmpty ? nameError.value : null,
                  onChanged: (value) {
                    productController.addProductModalSheetCardTitle.value =
                        value;
                    print(
                        productController.addProductModalSheetCardTitle.value);
                    nameError.value = '';
                  },
                ),
                const SizedBox(height: 20),
                CustomSingleDropdown(
                  categories: categoryController.categories,
                  selectedCategoryId: selectedCategoryId,
                  isDark: isDark,
                  label: 'selectCategory'.tr,
                  isRequired: true,
                  errorText: categoryError.value.isNotEmpty
                      ? categoryError.value
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'descriptionApp'.tr,
                  hintText: '',
                  controller: descriptionController,
                  isRequired: true,
                  maxLength: 250,
                  errorText: descriptionError.value.isNotEmpty
                      ? descriptionError.value
                      : null,
                  onChanged: (value) => descriptionError.value = '',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        maxLength: 9,
                        label: 'productPrice'.tr,
                        hintText: '',
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        isDigits: true,
                        errorText: priceError.value.isNotEmpty
                            ? priceError.value
                            : null,
                        onChanged: (value) {
                          priceController.text  // Remove leading zeros
                           = value.replaceFirst(RegExp(r'^0+'), '');
                          priceError.value = '';
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        labelHeadLineStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Color(0xff5D5C5C),
                        ),
                        label: 'productOfferPrice'.tr,
                        hintText: '',
                        controller: priceOfferController,
                        isDigits: true,
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        errorText: priceOfferError.value.isNotEmpty
                            ? priceOfferError.value
                            : null,
                        onChanged: (value) {
                          priceOfferController.text  =  value.replaceFirst(RegExp(r'^0+'), '');
                          priceOfferError.value = '';
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'productLink'.tr,
                  hintText: '',
                  controller: linkController,
                  keyboardType: TextInputType.url,
                  isRequired: true,
                  errorText:
                      linkError.value.isNotEmpty ? linkError.value : null,
                  onChanged: (value) => linkError.value = '',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'choose_installment_ways'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xff5D5C5C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Obx(() {
                      if (installmentController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (installmentController
                          .errorMessage.value.isNotEmpty) {
                        return Text(
                          installmentController.errorMessage.value,
                          style: GoogleFonts.tajawal(
                              color: Colors.red, fontSize: 12),
                        );
                      } else if (installmentController
                          .installmentWays.isEmpty) {
                        return Text(
                          'noInstallmentWays'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                installmentController.installmentWays.length,
                            itemBuilder: (context, index) {
                              final way =
                                  installmentController.installmentWays[index];
                              final isSelected =
                                  selectedInstallmentIds.contains(way.id);
                              print(
                                  'Rendering way ${way.id}, isSelected: $isSelected');
                              return GestureDetector(
                                onTap: () {
                                  print('Tapped way ${way.id}');
                                  final newIds =
                                      List<int>.from(selectedInstallmentIds);
                                  if (isSelected) {
                                    newIds.remove(way.id);
                                  } else {
                                    newIds.add(way.id);
                                  }
                                  selectedInstallmentIds.assignAll(newIds);
                                  print(
                                      'selectedInstallmentIds: $selectedInstallmentIds');
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 120,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.grey,
                                        width: 2.0,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(way.image),
                                        fit: BoxFit.scaleDown,
                                        scale: 0.65,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    });
                  },
                ),
                if (installmentError.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      installmentError.value,
                      style:
                          GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 10),
                CustomStatusDropdown(
                  status: status,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                if (packageUsageController.isLoading.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Shimmer.fromColors(
                      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
                      child: Container(
                        width:139.w,
                        height: 17.h,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    ),
                  )
                else if (addProductsStatus == 'unlimited')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'unlimited'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  )
                else if (addProductsStatus == 'available')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${'attempts_remaining_label'.tr}${'${addProductsUsage?.remaining.toString()}'}',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  )
                else if (addProductsStatus == 'none')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'feature_not_in_your_package'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                CustomButton(
                  margin: EdgeInsets.only(bottom: 60.h),
                  text: productController.isLoading.value
                      ? 'progress'.tr
                      : 'add'.tr,
                  textSize: 22,
                  textFontWeight: FontWeight.bold,
                  onPressed: productController.isLoading.value
                      ? null
                      : () async {
                          nameError.value = '';
                          descriptionError.value = '';
                          priceError.value = '';
                          priceOfferError.value = '';
                          linkError.value = '';
                          categoryError.value = '';
                          imagesError.value = '';
                          installmentError.value = '';
                          statusError.value = '';

                          print('add_products status: $addProductsStatus');
                          if (addProductsStatus == 'none') {
                            _showLimitReachedDialog(
                              context,
                              title: 'feature_not_available'.tr,
                              message: 'add_products_not_in_package'.tr,
                              buttonText: 'upgrade_package'.tr,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Get.to(() => isIOs
                                    ? IosSubscriptionsScreen()
                                    : AndroidSubscriptionsScreen());
                              },
                            );
                            return;
                          } else if (addProductsStatus == 'limit_reached') {
                            _showLimitReachedDialog(
                              context,
                              title: 'limit_reached'.tr,
                              message: 'add_products_limit_reached'.tr,
                              buttonText: 'upgrade_package'.tr,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Get.to(() => isIOs
                                    ? IosSubscriptionsScreen()
                                    : AndroidSubscriptionsScreen());
                              },
                            );
                            return;
                          }

                          if (uploadedImages.isEmpty) {
                            imagesError.value = 'image_cannot_empty'.tr;
                            return;
                          }
                          if (nameController.text.isEmpty) {
                            nameError.value = 'nameRequired'.tr;
                            return;
                          }
                          if (descriptionController.text.isEmpty) {
                            descriptionError.value = 'descRequired'.tr;
                            return;
                          }
                          if (priceController.text.isEmpty) {
                            priceError.value = 'priceRequired'.tr;
                            return;
                          }
                          if (double.tryParse(priceController.text) == null ||
                              double.tryParse(priceController.text) == 0) {
                            priceError.value =
                                'السعر يجب ان يكن اكبر من صفر'.tr;
                            return;
                          }
                          if (double.tryParse(priceController.text) == null ||
                              double.tryParse(priceController.text)! >
                                  9999999) {
                            priceError.value =
                                'السعر يجب ان يكن اقل من 9,999,999'.tr;
                            return;
                          }
                          if (!RegExp(r'^\d+(\.\d+)?$')
                              .hasMatch(priceController.text)) {
                            priceError.value = 'wrongPrice'.tr;
                            return;
                          }
                          if (priceOfferController.text.isNotEmpty &&
                              !RegExp(r'^\d+(\.\d+)?$')
                                  .hasMatch(priceOfferController.text)) {
                            priceOfferError.value = 'wrongPrice'.tr;
                            return;
                          }
                          if (priceOfferController.text.isNotEmpty &&
                              double.tryParse(priceOfferController.text)! >
                                  double.tryParse(priceController.text)!) {
                            priceOfferError.value =
                                'discount_price_less_than_product'.tr;
                            return;
                          }

                          if (linkController.text.isEmpty) {
                            linkError.value = 'linkRequired'.tr;
                            return;
                          }
                          final urlPattern = RegExp(
                              r'^(https?:\/\/)?([\w-]+\.)*[\w-]+\.[a-zA-Z]{2,}(\/.*)?$',
                              caseSensitive: false);
                          if (!urlPattern.hasMatch(linkController.text.trim())) {
                            linkError.value = 'invalidLink'.tr;
                            return;
                          }
                          // Normalize the URL (optional)
                          String normalizedLink = linkController.text;
                          if (!normalizedLink.startsWith('http://') &&
                              !normalizedLink.startsWith('https://')) {
                            normalizedLink = 'https://$normalizedLink';
                          }
                          if (uploadedImages.isEmpty) {
                            imagesError.value = 'imagesRequired'.tr;
                            return;
                          }
                          if (selectedCategoryId.value == null) {
                            categoryError.value = 'categoryRequired'.tr;
                            return;
                          }

                          final success = await productController.addProduct(
                            nameAr: nameController.text,
                            nameEn: nameController.text,
                            categoryId: selectedCategoryId.value!,
                            descriptionAr: descriptionController.text,
                            descriptionEn: descriptionController.text,
                            price: priceController.text,
                            priceOffer: priceOfferController.text.isNotEmpty
                                ? priceOfferController.text
                                : null,
                            link: normalizedLink,
                            images: uploadedImages,
                            installmentIds: selectedInstallmentIds.toList(),
                            status: status.value,
                          );

                          if (success) {
                            Navigator.pop(context);
                            packageUsageController.fetchPackageUsage();

                            _showSuccessDialog(
                              context,
                              title: 'productAddSuccess'.tr,
                              buttonText: 'browseProducts'.tr,
                              onButtonPressed: () {
                                print('Refreshing product list');
                                productController.fetchProducts(page: 1);
                              },
                            );
                          } else {
                            if (productController.validationErrors.isNotEmpty) {
                              final errors = productController.validationErrors;
                              if (errors.containsKey('name_ar') ||
                                  errors.containsKey('name_en')) {
                                nameError.value =
                                    (errors['name_ar'] ?? errors['name_en'])
                                            ?.join(', ') ??
                                        '';
                              }
                              if (errors.containsKey('description_ar') ||
                                  errors.containsKey('description_en')) {
                                descriptionError.value =
                                    (errors['description_ar'] ??
                                                errors['description_en'])
                                            ?.join(', ') ??
                                        '';
                              }
                              if (errors.containsKey('price')) {
                                priceError.value = errors['price']!.join(', ');
                              }
                              if (errors.containsKey('price_offer')) {
                                priceOfferError.value =
                                    errors['price_offer']!.join(', ');
                              }
                              if (errors.containsKey('link')) {
                                linkError.value = errors['link']!.join(', ');
                              }
                              if (errors.containsKey('category_id')) {
                                categoryError.value =
                                    errors['category_id']!.join(', ');
                              }
                              if (errors.containsKey('images')) {
                                imagesError.value =
                                    errors['images']!.join(', ');
                              }
                              if (errors.containsKey('status')) {
                                statusError.value =
                                    errors['status']!.join(', ');
                              }
                              if (errors.containsKey('installment_ids')) {
                                installmentError.value =
                                    errors['installment_ids']!.join(', ');
                              }
                            } else {
                              nameError.value =
                                  productController.errorMessage.value;
                            }
                          }
                        },
                ),
                SizedBox(
                    height:
                        MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
              ],
            ),
          );
        }),
      ),
    ).then((value) {
      productController.addProductModalSheetCardTitle.value ="";
    },);
  }

  static void showEditProductSheet(BuildContext context, Product product) {
    final ThemeController themeController = Get.put(ThemeController());
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final ProductController productController = Get.put(ProductController());
    final CategoryController categoryController = Get.put(CategoryController());
    final PackageUsageController packageUsageController =
        Get.put(PackageUsageController());
    final InstallmentWayController installmentController =
        Get.put(InstallmentWayController());
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final TextEditingController nameController =
        TextEditingController(text: product.nameAr);
    final TextEditingController descriptionController =
        TextEditingController(text: product.descriptionAr);
    final TextEditingController priceController =
        TextEditingController(text: product.price);
    final TextEditingController priceOfferController =
        TextEditingController(text: product.priceOffer ?? '');
    final TextEditingController linkController =
        TextEditingController(text: product.link);

    final nameError = ''.obs;
    final descriptionError = ''.obs;
    final priceError = ''.obs;
    final priceOfferError = ''.obs;
    final linkError = ''.obs;
    final categoryError = ''.obs;
    final imagesError = ''.obs;
    final statusError = ''.obs;
    final installmentError = ''.obs;
    final selectedInstallmentIds =
        product.installmentWays.map((way) => way.id).toList().obs;
    final selectedCategoryId = Rxn<int>(product.categoryId);
    final uploadedImages = <File>[].obs;
    final existingImages = product.images.obs;
    final status = product.status.obs;
    final isFetchingUsage = true.obs;
    final usageError = ''.obs;

    packageUsageController.fetchPackageUsage().then((success) {
      isFetchingUsage(false);
      if (!success) {
        usageError.value = packageUsageController.errorMessage.value;
      }
    });
    installmentController.fetchInstallmentWays();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: kBottomSheetHeight,
        padding: EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final previewImages = [
            ...existingImages.map((img) => ImageModel(image: img.image)),
            ...uploadedImages.map((file) => ImageModel(image: file.path)),
          ];
          final previewProduct = ProductAdd(
            id: product.id.toString(),
            market: Market(
              name: nameController.text.isEmpty
                  ? 'productName'.tr
                  : nameController.text,
              logo: '',
            ),
            price: priceController.text.isEmpty ? '0' : priceController.text,
            priceOffer: priceOfferController.text.isNotEmpty
                ? priceOfferController.text
                : '',
            descriptionAr: descriptionController.text.isEmpty
                ? 'product_des'.tr
                : descriptionController.text,
            descriptionEn: descriptionController.text.isEmpty
                ? 'Product Description'
                : descriptionController.text,
            images: previewImages,
          );
          final editProductsUsage = packageUsageController.packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'edit_products');

          String? editProductsStatus;
          if (editProductsUsage == null || editProductsUsage.isNone) {
            editProductsStatus = 'none';
          } else if (editProductsUsage.remaining == null) {
            editProductsStatus = 'unlimited';
          } else if (editProductsUsage.remaining! > 0) {
            editProductsStatus = 'available';
          } else {
            editProductsStatus = 'limit_reached';
          }
          print(
              'edit_products status: $editProductsStatus, remaining: ${editProductsUsage?.remaining}, isNone: ${editProductsUsage?.isNone}');
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSheetHeader(context, 'editProducts'.tr),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'preview'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: ProductCardGrid(
                    product: previewProduct,
                    onTap: () {},
                    onFavoriteTap: () {},
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'productImages'.tr,
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xff5D5C5C),
                            ),
                          ),
                          TextSpan(
                            text: ' *',
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : const Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: isDark ? Colors.grey : Colors.grey),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.cloud_upload_sharp, size: 30),
                          color: AppColors.black,
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              //compress image
                              final dir = await getTemporaryDirectory();
                              final targetPath = path.join(dir.path,
                                  "${DateTime.now().millisecondsSinceEpoch}.jpg");
                              var result =
                                  await FlutterImageCompress.compressAndGetFile(
                                pickedFile.path,
                                targetPath,
                                quality: 60, // 60–80 is a good range
                              );
                              uploadedImages.add(File(result!.path));
                            }
                          },
                        ),
                        Text(
                          'selectImages'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color:
                                isDark ? Colors.white : const Color(0xff5D5C5C),
                          ),
                        ),
                        Text(
                          'atLeastImage'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color:
                                isDark ? Colors.white : const Color(0xffC2C73A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: SizedBox(
                    height: isSmallScreen ? 60 : 80,
                    child: Obx(() => productController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                existingImages.length + uploadedImages.length,
                            itemBuilder: (context, index) {
                              if (index < existingImages.length) {
                                // Display existing images (URLs)
                                final image = existingImages[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: screenSize.width * 0.02),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: isSmallScreen ? 60 : 80,
                                        height: isSmallScreen ? 60 : 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(image.image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -10,
                                        child: IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.red, size: 20),
                                          onPressed: image.id == null
                                              ? null
                                              : () {
                                                  // Show confirmation dialog before deleting
                                                  Get.dialog(
                                                    AlertDialog(
                                                      backgroundColor: isDark
                                                          ? Colors.grey[800]
                                                          : Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                      title: Text(
                                                        'confirm_delete_image'
                                                            .tr,
                                                        style:
                                                            GoogleFonts.tajawal(
                                                          fontSize:
                                                              isSmallScreen
                                                                  ? 18
                                                                  : 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      content: Text(
                                                        'confirm_delete_image_message'
                                                            .tr,
                                                        style:
                                                            GoogleFonts.tajawal(
                                                          fontSize:
                                                              isSmallScreen
                                                                  ? 14
                                                                  : 16,
                                                          color: isDark
                                                              ? Colors.grey[300]
                                                              : Colors
                                                                  .grey[600],
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          child: Text(
                                                            'cancel'.tr,
                                                            style: GoogleFonts
                                                                .tajawal(
                                                              fontSize:
                                                                  isSmallScreen
                                                                      ? 14
                                                                      : 16,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                AppColors
                                                                    .primary,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            Get.back(); // Close dialog
                                                            final success =
                                                                await productController
                                                                    .deleteProductImage(
                                                              productId:
                                                                  product.id,
                                                              imageId: image.id,
                                                            );
                                                            if (success) {
                                                              existingImages
                                                                  .removeAt(
                                                                      index); // Remove from local list
                                                              SnackBarConstantVersion1
                                                                  .showSuccessSnackbar(
                                                                'Success'.tr,
                                                                productController
                                                                    .successMessage
                                                                    .value,
                                                              );
                                                            } else {
                                                              SnackBarConstantVersion1
                                                                  .showErrorSnackbar(
                                                                'error'.tr,
                                                                productController
                                                                    .errorMessage
                                                                    .value,
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            'confirm'.tr,
                                                            style: GoogleFonts
                                                                .tajawal(
                                                              fontSize:
                                                                  isSmallScreen
                                                                      ? 14
                                                                      : 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    barrierDismissible: true,
                                                  );
                                                },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                // Display newly uploaded images
                                final file = uploadedImages[
                                    index - existingImages.length];
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: screenSize.width * 0.02),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: isSmallScreen ? 60 : 80,
                                        height: isSmallScreen ? 60 : 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -10,
                                        child: IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.red, size: 20),
                                          onPressed: () {
                                            uploadedImages.removeAt(
                                                index - existingImages.length);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          )),
                  ),
                ),
                if (imagesError.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      imagesError.value,
                      style:
                          GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'productName'.tr,
                  hintText: '',
                  controller: nameController,
                  maxLength: 100,
                  isRequired: true,
                  errorText:
                      nameError.value.isNotEmpty ? nameError.value : null,
                  onChanged: (value) => nameError.value = '',
                ),
                const SizedBox(height: 20),
                CustomSingleDropdown(
                  categories: categoryController.categories,
                  selectedCategoryId: selectedCategoryId,
                  isDark: isDark,
                  label: 'selectCategory'.tr,
                  isRequired: true,
                  errorText: categoryError.value.isNotEmpty
                      ? categoryError.value
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'descriptionApp'.tr,
                  hintText: '',
                  controller: descriptionController,
                  isRequired: true,
                  maxLength: 250,
                  errorText: descriptionError.value.isNotEmpty
                      ? descriptionError.value
                      : null,
                  onChanged: (value) => descriptionError.value = '',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'productPrice'.tr,
                        hintText: '',
                        controller: priceController,
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        errorText: priceError.value.isNotEmpty
                            ? priceError.value
                            : null,
                        onChanged: (value) {
                          priceController.text  // Remove leading zeros
                          = value.replaceFirst(RegExp(r'^0+'), '');
                          priceError.value = '';
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'productOfferPrice'.tr,
                        hintText: '',
                        controller: priceOfferController,
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        errorText: priceOfferError.value.isNotEmpty
                            ? priceOfferError.value
                            : null,
                        onChanged: (value) {
                          priceOfferController.text  // Remove leading zeros
                          = value.replaceFirst(RegExp(r'^0+'), '');
                          priceOfferError.value = '';
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'productLink'.tr,
                  hintText: '',
                  controller: linkController,
                  keyboardType: TextInputType.url,
                  isRequired: true,
                  errorText:
                      linkError.value.isNotEmpty ? linkError.value : null,
                  onChanged: (value) => linkError.value = '',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'installmentWays'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xff5D5C5C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Obx(() {
                      if (installmentController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (installmentController
                          .errorMessage.value.isNotEmpty) {
                        return Text(
                          installmentController.errorMessage.value,
                          style: GoogleFonts.tajawal(
                              color: Colors.red, fontSize: 12),
                        );
                      } else if (installmentController
                          .installmentWays.isEmpty) {
                        return Text(
                          'noInstallmentWays'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                installmentController.installmentWays.length,
                            itemBuilder: (context, index) {
                              final way =
                                  installmentController.installmentWays[index];
                              final isSelected =
                                  selectedInstallmentIds.contains(way.id);
                              print(
                                  'Rendering way ${way.id}, isSelected: $isSelected');
                              return GestureDetector(
                                onTap: () {
                                  print('Tapped way ${way.id}');
                                  final newIds =
                                      List<int>.from(selectedInstallmentIds);
                                  if (isSelected) {
                                    newIds.remove(way.id);
                                  } else {
                                    newIds.add(way.id);
                                  }
                                  selectedInstallmentIds.assignAll(newIds);
                                  print(
                                      'selectedInstallmentIds: $selectedInstallmentIds');
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 115,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.grey,
                                        width: 2.0,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(way.image),
                                        fit: BoxFit.scaleDown,
                                        scale: 0.65,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    });
                  },
                ),
                if (installmentError.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      installmentError.value,
                      style:
                          GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),
                CustomStatusDropdown(
                  status: status,
                  isDark: isDark,
                ),
                const SizedBox(height: 30),
                if (packageUsageController.isLoading.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Shimmer.fromColors(
                      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
                      child: Container(
                        width:139.w,
                        height: 17.h,
                        decoration: BoxDecoration(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    ),
                  )
                else if (editProductsStatus == 'unlimited')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'unlimited'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  )
                else if (editProductsStatus == 'available')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${'attempts_remaining_label'.tr}${'${editProductsUsage?.remaining.toString()}'}',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  )
                else if (editProductsStatus == 'none')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'feature_not_in_your_package'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                CustomButton(
                  margin: EdgeInsets.only(bottom: 60.h),
                  text: productController.isLoading.value
                      ? 'editProgress'.tr
                      : 'editApp'.tr,
                  textSize: 22,
                  textFontWeight: FontWeight.bold,
                  onPressed: productController.isLoading.value
                      ? null
                      : () async {
                          nameError.value = '';
                          descriptionError.value = '';
                          priceError.value = '';
                          priceOfferError.value = '';
                          linkError.value = '';
                          categoryError.value = '';
                          imagesError.value = '';
                          statusError.value = '';
                          installmentError.value = '';

                          print('edit_products status: $editProductsStatus');
                          if (editProductsStatus == 'none') {
                            _showLimitReachedDialog(
                              context,
                              title: 'feature_not_available'.tr,
                              message: 'edit_products_not_in_package'.tr,
                              buttonText: 'upgrade_package'.tr,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Get.to(() => isIOs
                                    ? IosSubscriptionsScreen()
                                    : AndroidSubscriptionsScreen());
                              },
                            );
                            return;
                          } else if (editProductsStatus == 'limit_reached') {
                            _showLimitReachedDialog(
                              context,
                              title: 'limit_reached'.tr,
                              message: 'edit_products_limit_reached'.tr,
                              buttonText: 'upgrade_package'.tr,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Get.to(() => isIOs
                                    ? IosSubscriptionsScreen()
                                    : AndroidSubscriptionsScreen());
                              },
                            );
                            return;
                          }

                          if (nameController.text.isEmpty) {
                            nameError.value = 'nameRequired'.tr;
                            return;
                          }
                          if (descriptionController.text.isEmpty) {
                            descriptionError.value = 'descRequired'.tr;
                            return;
                          }
                          if (priceController.text.isEmpty) {
                            priceError.value = 'priceRequired'.tr;
                            return;
                          }
                          if (!RegExp(r'^\d+(\.\d+)?$')
                              .hasMatch(priceController.text)) {
                            priceError.value = 'wrongPrice'.tr;
                            return;
                          }
                          if (double.tryParse(priceController.text) == null ||
                              double.tryParse(priceController.text) == 0) {
                            priceError.value =
                                'السعر يجب ان يكن اكبر من صفر'.tr;
                            return;
                          }
                          if (double.tryParse(priceController.text) == null ||
                              double.tryParse(priceController.text)! >
                                  9999999) {
                            priceError.value =
                                'السعر يجب ان يكن اقل من 9,999,999'.tr;
                            return;
                          }
                          if (priceOfferController.text.isNotEmpty &&
                              !RegExp(r'^\d+(\.\d+)?$')
                                  .hasMatch(priceOfferController.text)) {
                            priceOfferError.value = 'wrongPrice'.tr;
                            return;
                          }
                          if (priceOfferController.text.isNotEmpty &&
                              double.tryParse(priceOfferController.text)! >
                                  double.tryParse(priceController.text)!) {
                            priceOfferError.value =
                                'discount_price_less_than_product'.tr;
                            return;
                          }
                          if (linkController.text.isEmpty) {
                            linkError.value = 'linkRequired'.tr;
                            return;
                          }
                          // Updated URL validation
                          final urlPattern = RegExp(
                              r'^(https?:\/\/)?([\w-]+\.)*[\w-]+\.[a-zA-Z]{2,}(\/.*)?$',
                              caseSensitive: false);
                          if (!urlPattern.hasMatch(linkController.text.trim())) {
                            linkError.value = 'invalidLink'.tr;
                            return;
                          }
                          // Normalize the URL (optional)
                          String normalizedLink = linkController.text;
                          if (!normalizedLink.startsWith('http://') &&
                              !normalizedLink.startsWith('https://')) {
                            normalizedLink = 'https://$normalizedLink';
                          }
                          if (uploadedImages.isEmpty &&
                              existingImages.isEmpty) {
                            imagesError.value = 'imagesRequired'.tr;
                            return;
                          }
                          if (selectedCategoryId.value == null) {
                            categoryError.value = 'categoryRequired'.tr;
                            return;
                          }

                          final success = await productController.updateProduct(
                            productId: product.id,
                            nameAr: nameController.text.trim(),
                            nameEn: nameController.text.trim(),
                            categoryId: selectedCategoryId.value!,
                            descriptionAr: descriptionController.text.trim(),
                            descriptionEn: descriptionController.text.trim(),
                            price: priceController.text.trim(),
                            priceOffer: priceOfferController.text.isNotEmpty
                                ? priceOfferController.text.trim()
                                : null,
                            link: normalizedLink.trim(),
                            images: uploadedImages.isNotEmpty
                                ? uploadedImages
                                : null,
                            installmentIds: selectedInstallmentIds,
                            status: status.value,
                          );

                          if (success) {
                            Navigator.pop(context);
                            packageUsageController.fetchPackageUsage();

                            _showSuccessDialog(
                              context,
                              title: 'editSuccess'.tr,
                              buttonText: 'browseProducts'.tr,
                              onButtonPressed: () {
                                print('Refreshing product list');
                                productController.fetchProducts(page: 1);
                              },
                            );
                          } else if (productController
                              .validationErrors.isNotEmpty) {
                            final errors = productController.validationErrors;
                            if (errors.containsKey('name_ar') ||
                                errors.containsKey('name_en')) {
                              nameError.value =
                                  (errors['name_ar'] ?? errors['name_en'])!
                                      .join(', ');
                            }
                            if (errors.containsKey('description_ar') ||
                                errors.containsKey('description_en')) {
                              descriptionError.value =
                                  (errors['description_ar'] ??
                                          errors['description_en'])!
                                      .join(', ');
                            }
                            if (errors.containsKey('price')) {
                              priceError.value = errors['price']!.join(', ');
                            }
                            if (errors.containsKey('price_offer')) {
                              priceOfferError.value =
                                  errors['price_offer']!.join(', ');
                            }
                            if (errors.containsKey('link')) {
                              linkError.value = errors['link']!.join(', ');
                            }
                            if (errors.containsKey('category_id')) {
                              categoryError.value =
                                  errors['category_id']!.join(', ');
                            }
                            if (errors.containsKey('images')) {
                              imagesError.value = errors['images']!.join(', ');
                            }
                            if (errors.containsKey('status')) {
                              statusError.value = errors['status']!.join(', ');
                            }
                            if (errors.containsKey('installment_ids')) {
                              installmentError.value =
                                  errors['installment_ids']!.join(', ');
                            }
                          } else {
                            nameError.value =
                                productController.errorMessage.value;
                          }
                        },
                ),
                SizedBox(
                    height:
                        MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
              ],
            ),
          );
        }),
      ),
    );
  }

  static void showAddCouponSheet(BuildContext context, {Coupon? coupon}) {
    final ThemeController themeController = Get.put(ThemeController());
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final CouponController couponController = Get.put(CouponController());
    final CategoryController categoryController = Get.put(CategoryController());
    final ProfileController profileController = Get.put(ProfileController());
    final PackageUsageController packageUsageController =
        Get.put(PackageUsageController());

    final TextEditingController couponCodeController =
        TextEditingController(text: coupon?.couponCode ?? '');
    final TextEditingController descriptionArController =
        TextEditingController(text: coupon?.descriptionAr ?? '');
    final TextEditingController descriptionEnController =
        TextEditingController(text: coupon?.descriptionEn ?? '');
    final TextEditingController linkController =
        TextEditingController(text: coupon?.link ?? '');
    final TextEditingController termsController =
        TextEditingController(text: coupon?.terms ?? '');
    final TextEditingController discountController =
        TextEditingController(text: coupon?.discount ?? '');

    final couponCodeError = ''.obs;
    final descriptionArError = ''.obs;
    final descriptionEnError = ''.obs;
    final linkError = ''.obs;
    final termsError = ''.obs;
    final discountError = ''.obs;
    final categoryError = ''.obs;
    final statusError = ''.obs;
    final selectedCategoryId = Rxn<int>(coupon?.categoryId);
    final status = (coupon?.status ?? 1).obs;
    final isFetchingUsage = true.obs;
    final usageError = ''.obs;

    var staticMarket = MarketCoupon(
      id: coupon?.market.id ?? 2,
      name: profileController.profile.value?.name ?? 'متجر مثالي',
      logo: profileController.profile.value?.logo ??
          'https://couponatnoon.net/images/store_1716831527.png',
    );

    packageUsageController.fetchPackageUsage().then((success) {
      isFetchingUsage(false);
      if (!success) {
        usageError.value = packageUsageController.errorMessage.value;
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: kBottomSheetHeight,
        padding: EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final previewCoupon = Coupon(
            id: coupon?.id ?? 0,
            couponCode: couponCodeController.text.isEmpty
                ? 'XXXX-XXXX'
                : couponCodeController.text,
            descriptionAr: descriptionArController.text.isEmpty
                ? 'وصف الكوبون'
                : descriptionArController.text,
            descriptionEn: descriptionArController.text.isEmpty
                ? 'Coupon Description'
                : descriptionArController.text,
            terms: termsController.text.isEmpty ? null : termsController.text,
            discount:
                discountController.text.isEmpty ? '0' : discountController.text,
            link: linkController.text.isEmpty
                ? 'https://example.com'
                : linkController.text,
            createdAt: coupon?.createdAt ?? '05-11-2025',
            updatedAt: coupon?.updatedAt ?? '05-11-2025',
            categoryId: selectedCategoryId.value ?? 1,
            market: staticMarket,
            status: status.value,
            viewCoupon: status.value,
          );

          final packageUsages = packageUsageController.packageUsages;
          final addCouponUsage = packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'add_coupon');
          final editCouponUsage = packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'edit_coupon');

          String? couponStatus;
          PackageUsage? relevantUsage;
          String actionTag;

          if (coupon == null) {
            actionTag = 'add_coupon';
            relevantUsage = addCouponUsage;
          } else {
            actionTag = 'edit_coupon';
            relevantUsage = editCouponUsage;
          }

          if (relevantUsage == null || relevantUsage.isNone) {
            couponStatus = 'none';
          }
          else if (relevantUsage.remaining == null) {
            couponStatus = 'unlimited';
          } else if (relevantUsage.remaining! > 0) {
            couponStatus = 'available';
          } else {
            couponStatus = 'limit_reached';
          }
          print(
              '$actionTag status: $couponStatus, remaining: ${relevantUsage?.remaining}, isNone: ${relevantUsage?.isNone}');
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(
                    context, coupon == null ? 'addCoupon'.tr : 'editCoupon'.tr),
                const SizedBox(height: 20),
                Text(
                  'preview'.tr,
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.width * 0.45 * 1.33,
                      child: CouponCardGrid(
                        coupon: previewCoupon,
                        onTap: () {},
                        onCopy: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'couponDiscount'.tr,
                  hintText: '',
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  isRequired: true,
                  errorText: discountError.value.isNotEmpty
                      ? discountError.value
                      : null,
                  onChanged: (value) {
                    discountController.text  // Remove leading zeros
                    = value.replaceFirst(RegExp(r'^0+'), '');
                    couponController.discountAmountCopounCart.value = value;
                    discountError.value = '';
                    if(int.parse(value)>100){
                      discountError.value = 'يجب الا يزيد الخصم عن ١٠٠٪';

                    }

                  },
                  isDigits: true,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'descriptionApp'.tr,
                  hintText: '',
                  controller: descriptionArController,
                  isRequired: true,
                  maxLength: 250,
                  errorText: descriptionArError.value.isNotEmpty
                      ? descriptionArError.value
                      : null,
                  onChanged: (value) => descriptionArError.value = '',
                ),
                const SizedBox(height: 20),
                CustomSingleDropdown(
                  categories: categoryController.categories,
                  selectedCategoryId: selectedCategoryId,
                  isDark: isDark,
                  label: 'selectCategory'.tr,
                  isRequired: true,
                  errorText: categoryError.value.isNotEmpty
                      ? categoryError.value
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'codeApp'.tr,
                  hintText: '',
                  controller: couponCodeController,
                  isRequired: true,
                  maxLength: 100,
                  errorText: couponCodeError.value.isNotEmpty
                      ? couponCodeError.value
                      : null,
                  onChanged: (value) => couponCodeError.value = '',
                ),
                // const SizedBox(height: 20),
                // CustomTextField(
                //   label: 'description_ar'.tr,
                //   hintText: 'وصف الكوبون بالعربية',
                //   controller: descriptionArController,
                //   errorText: descriptionArError.value.isNotEmpty ? descriptionArError.value : null,
                //   onChanged: (value) => descriptionArError.value = '',
                // ),
                // const SizedBox(height: 20),
                // CustomTextField(
                //   label: 'description_en'.tr,
                //   hintText: 'Coupon description in English',
                //   controller: descriptionEnController,
                //   errorText: descriptionEnError.value.isNotEmpty ? descriptionEnError.value : null,
                //   onChanged: (value) => descriptionEnError.value = '',
                // ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'couponLink'.tr,
                  hintText: '',
                  controller: linkController,
                  keyboardType: TextInputType.url,
                  isRequired: true,
                  errorText:
                      linkError.value.isNotEmpty ? linkError.value : null,
                  onChanged: (value) => linkError.value = '',
                ),
                const SizedBox(height: 20),
                // CustomTextField(
                //   label: 'terms'.tr,
                //   hintText: 'شروط وأحكام الكوبون (اختياري)',
                //   controller: termsController,
                //   errorText: termsError.value.isNotEmpty ? termsError.value : null,
                //   onChanged: (value) => termsError.value = '',
                // ),
                // const SizedBox(height: 20),
                //
                // const SizedBox(height: 20),

                const SizedBox(height: 20),
                CustomStatusDropdown(
                  status: status,
                  isDark: isDark,
                ),
                const SizedBox(height: 20),

                if (packageUsageController.isLoading.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Shimmer.fromColors(
                      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
                      child: Container(
                        width:139.w,
                        height: 17.h,
                        decoration: BoxDecoration(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    ),
                  )
                else if (couponStatus == 'unlimited')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'unlimited'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  )
                else if (couponStatus == 'available')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(

                      '${'attempts_remaining_label'.tr}${'${relevantUsage?.remaining.toString()}'}',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  )
                else if (couponStatus == 'none')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'هذه الميزة غير متاحة فى باقتك',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                CustomButton(
                  margin: EdgeInsets.only(bottom: 60.h),
                  text: couponController.isLoading.value
                      ? 'progress'.tr
                      : coupon == null
                          ? 'add'.tr
                          : 'editApp'.tr,
                  textSize: 22,
                  textFontWeight: FontWeight.bold,
                  onPressed: couponController.isLoading.value
                      ? null
                      : () async {
                          print(
                              'Add/Update Coupon button clicked at ${DateTime.now()}');
                          couponCodeError.value = '';
                          descriptionArError.value = '';
                          descriptionEnError.value = '';
                          linkError.value = '';
                          termsError.value = '';
                          discountError.value = '';
                          categoryError.value = '';
                          statusError.value = '';

                          print('$actionTag status: $couponStatus');
                          if (couponStatus == 'none') {
                            _showLimitReachedDialog(
                              context,
                              title: 'feature_not_available'.tr,
                              message: 'this_feature_not_in_package'.tr,
                              buttonText: 'upgrade_package'.tr,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Get.to(() => isIOs
                                    ? IosSubscriptionsScreen()
                                    : AndroidSubscriptionsScreen());
                              },
                            );
                            return;
                          } else if (couponStatus == 'limit_reached') {
                            _showLimitReachedDialog(
                              context,
                              title: 'limit_reached'.tr,
                              message: 'have_limit_reached'.tr,
                              buttonText: 'upgrade_package'.tr,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Get.to(() => isIOs
                                    ? IosSubscriptionsScreen()
                                    : AndroidSubscriptionsScreen());
                              },
                            );
                            return;
                          }
                          // discount validation
                          if (discountController.text.isEmpty) {
                            discountError.value = 'discountRequired'.tr;
                            print('Validation error: discount_required');
                            return;
                          }
                          if (!RegExp(r'^\d+$')
                              .hasMatch(discountController.text)) {
                            discountError.value = 'wrongDiscount'.tr;
                            print('Validation error: discount_invalid');
                            return;
                          }
                          int discountValue =
                              int.parse(discountController.text);
                          if (discountValue < 1 || discountValue > 100) {
                            discountError.value = 'wrongDiscountMessage'.tr;
                            print('Validation error: discount_range_invalid');
                            return;
                          }
                          //======================

                          // description validation
                          if (descriptionArController.text.isEmpty) {
                            descriptionArError.value = 'descRequired'.tr;
                            print('Validation error: description_ar_required');
                            return;
                          }
                          //============

                          // categoryId validation
                          if (selectedCategoryId.value == null) {
                            categoryError.value = 'categoryRequired'.tr;
                            print('Validation error: category_required');
                            return;
                          }
                          //=================
                          // couponCode validation
                          if (couponCodeController.text.isEmpty) {
                            couponCodeError.value = 'codeRequired'.tr;
                            print('Validation error: coupon_code_required');
                            return;
                          }

                          if (linkController.text.isEmpty) {
                            linkError.value = 'linkRequired'.tr;
                            print('Validation error: link_required');
                            return;
                          }
                          if (linkController.text.isEmpty) {
                            linkError.value = 'linkRequired'.tr;
                            print('Validation error: link_required');
                            return;
                          }
                          // Updated URL validation
                          final urlPattern = RegExp(
                              r'^(https?:\/\/)?([\w-]+\.)*[\w-]+\.[a-zA-Z]{2,}(\/.*)?$',
                              caseSensitive: false);
                          if (!urlPattern.hasMatch(linkController.text.trim())) {
                            linkError.value = 'invalidLink'.tr;
                            print('Validation error: link_invalid');
                            return;
                          }
                          // Normalize the URL (optional)
                          String normalizedLink = linkController.text;
                          if (!normalizedLink.startsWith('http://') &&
                              !normalizedLink.startsWith('https://')) {
                            normalizedLink = 'https://$normalizedLink';
                          }

                          print(
                              'All validations passed, proceeding with ${coupon == null ? 'addCoupon' : 'updateCoupon'}');

                          bool success;
                          if (coupon == null) {
                            success = await couponController.addCoupon(
                              couponCode: couponCodeController.text.trim(),
                              descriptionAr: descriptionArController.text.trim(),
                              descriptionEn: descriptionArController.text.trim(),
                              link: normalizedLink.trim(),
                              terms: termsController.text.isEmpty
                                  ? null
                                  : termsController.text.trim(),
                              categoryId: selectedCategoryId.value!,
                              discount: discountController.text.trim(),
                              status: status.value,
                            );
                          } else {
                            success = await couponController.updateCoupon(
                              couponId: coupon.id,
                              couponCode: couponCodeController.text.trim(),
                              descriptionAr: descriptionArController.text.trim(),
                              descriptionEn: descriptionArController.text.trim(),
                              link: normalizedLink.trim(),
                              terms: termsController.text.isEmpty
                                  ? null
                                  : termsController.text.trim(),
                              categoryId: selectedCategoryId.value!,
                              discount: discountController.text.trim(),
                              status: status.value,
                            );
                          }

                          print('Coupon operation success: $success');
                          if (success) {
                            Navigator.pop(context);
                            packageUsageController.fetchPackageUsage();

                            _showSuccessDialog(
                              context,
                              title: coupon == null
                                  ? 'couponAddSuccess'.tr
                                  : 'couponEditSuccess'.tr,
                              buttonText: 'browseCoupon'.tr,
                              onButtonPressed: () {
                                print('Refreshing coupon list');
                                couponController.fetchCoupons(page: 1);
                              },
                            );
                          } else {
                            print(
                                'Operation failed, checking validation errors');
                            if (couponController.validationErrors.isNotEmpty) {
                              final errors = couponController.validationErrors;
                              if (errors.containsKey('coupon_code')) {
                                couponCodeError.value =
                                    errors['coupon_code']!.join(', ');
                                print(
                                    'API error: coupon_code - ${couponCodeError.value}');
                              }
                              if (errors.containsKey('description_ar')) {
                                descriptionArError.value =
                                    errors['description_ar']!.join(', ');
                                print(
                                    'API error: description_ar - ${descriptionArError.value}');
                              }
                              if (errors.containsKey('description_en')) {
                                descriptionEnError.value =
                                    errors['description_en']!.join(', ');
                                print(
                                    'API error: description_en - ${descriptionEnError.value}');
                              }
                              if (errors.containsKey('link')) {
                                linkError.value = errors['link']!.join(', ');
                                print('API error: link - ${linkError.value}');
                              }
                              if (errors.containsKey('terms')) {
                                termsError.value = errors['terms']!.join(', ');
                                print('API error: terms - ${termsError.value}');
                              }
                              if (errors.containsKey('discount')) {
                                discountError.value =
                                    errors['discount']!.join(', ');
                                print(
                                    'API error: discount - ${discountError.value}');
                              }
                              if (errors.containsKey('category_id')) {
                                categoryError.value =
                                    errors['category_id']!.join(', ');
                                print(
                                    'API error: category_id - ${categoryError.value}');
                              }
                              if (errors.containsKey('status')) {
                                statusError.value =
                                    errors['status']!.join(', ');
                                print(
                                    'API error: status - ${statusError.value}');
                              }
                            } else {
                              couponCodeError.value =
                                  couponController.errorMessage.value;
                              print(
                                  'API error: general - ${couponCodeError.value}');
                            }
                          }
                        },
                ),
                SizedBox(
                    height:
                        MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
              ],
            ),
          );
        }),
      ),
    ).then((value) {
      couponController.discountAmountCopounCart.value = "";
    },);
  }

  static void showAddOfferSheet(BuildContext context, {Offer? offer}) {
    final ThemeController themeController = Get.put(ThemeController());
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final OfferController offerController = Get.put(OfferController());
    final ProfileController profileController = Get.put(ProfileController());
    final CategoryController categoryController = Get.put(CategoryController());
    final PackageUsageController packageUsageController =
        Get.put(PackageUsageController());
    final isArabic = Get.locale?.languageCode == 'ar';

    // Fetch categories if not already loaded
    if (categoryController.categories.isEmpty) {
      categoryController.fetchCategories();
    }

    // Initialize controllers and observables
    final titleController = TextEditingController(
        text: offer != null ? offer.titleAr?.replaceAll('خصم ', '') ?? '' : '');
    final descriptionArController =
        TextEditingController(text: offer?.descriptionAr ?? '');
    final termsController = TextEditingController(text: offer?.terms ?? '');
    final offerCodeController =
        TextEditingController(text: offer?.couponCode ?? '');
    final linkController = TextEditingController(text: offer?.link ?? '');
    final selectedCategoryId = Rxn<int>(offer?.categoryId);

    // final uploadedImage = Rxn<File>();
    final offerTitleError = ''.obs;
    final percentageError = ''.obs;
    final descriptionArError = ''.obs;
    final termsError = ''.obs;
    final couponCodeError = ''.obs;
    final linkError = ''.obs;
    final categoryError = ''.obs;
    final imageError = ''.obs;
    final statusError = ''.obs;
    final status = (offer?.status ?? 1).obs;
    final isFetchingUsage = true.obs;
    final usageError = ''.obs;

    // Static market data
    final staticMarket = MarketOfferOffer(
      id: offer?.market.id ?? 2,
      name: profileController.profile.value?.name ?? 'متجر مثالي',
      logo: profileController.profile.value?.logo ??
          'https://couponatnoon.net/images/store_1716831527.png',
    );

    packageUsageController.fetchPackageUsage().then((success) {
      isFetchingUsage(false);
      if (!success) {
        usageError.value = packageUsageController.errorMessage.value;
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: kBottomSheetHeight,
        padding: EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final previewOffer = Offer(
            type: offer?.type ?? 'percentage',
            id: offer?.id ?? 0,
            marketId: staticMarket.id,
            market: staticMarket,
            categoryId: selectedCategoryId.value ?? 1,
            descriptionAr: descriptionArController.text,
            descriptionEn: descriptionArController.text,
            titleAr: titleController.text,
            titleEn: titleController.text,
            terms: termsController.text.isEmpty ? null : termsController.text,
            couponCode: offerCodeController.text.isEmpty
                ? null
                : offerCodeController.text,
            // image: uploadedImage.value != null
            //     ? uploadedImage.value!.path
            //     : (offer?.image ?? 'https://via.placeholder.com/150'),
            link: linkController.text.isEmpty
                ? 'https://example.com'
                : linkController.text,
            createdAt: offer?.createdAt ?? '05-11-2025',
            updatedAt: offer?.updatedAt ?? '05-11-2025',
            isFavorite: offer?.isFavorite ?? false,
            status: status.value,
            viewCount: status.value,
          );

          final packageUsages = packageUsageController.packageUsages;
          final addOffersUsage = packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'add_offers');
          final editOffersUsage = packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'edit_offers');

          String? offerStatus;
          {
            if (offer == null) {
              if (addOffersUsage == null || addOffersUsage.isNone) {
                offerStatus = 'none';
              }
              else if (addOffersUsage.remaining == null) {
                offerStatus = 'unlimited';
              } else if (addOffersUsage.remaining! > 0) {
                offerStatus = 'available';
              } else {
                offerStatus = 'limit_reached';
              }
              print(
                  'add_offers status: $offerStatus, remaining: ${addOffersUsage?.remaining}, isNone: ${addOffersUsage?.isNone}');
            } else {
              if (editOffersUsage == null || editOffersUsage.isNone) {
                offerStatus = 'none';
              } else if (editOffersUsage.remaining == null) {
                offerStatus = 'unlimited';
              } else if (editOffersUsage.remaining! > 0) {
                offerStatus = 'available';
              } else {
                offerStatus = 'limit_reached';
              }
            }
            print(
                'edit_offers status: $offerStatus, remaining: ${editOffersUsage?.remaining}, isNone: ${editOffersUsage?.isNone}');
          }

          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Form(
              key: globalValidationKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHeader(context,
                      offer == null ? 'addOffer'.tr : 'editProfile'.tr),
                  const SizedBox(height: 20),
                  Text(
                    'preview'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5 * 1.2,
                        child: OfferCardGrid(
                          offer: previewOffer,
                          onTap: () {
                            print('1234');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    errorText: percentageError.value,
                    controller: titleController,
                    hintText: 'enter_offer_hint'.tr,
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    isRequired: true,
                    // errorText: percentageError.value.isNotEmpty
                    //     ? percentageError.value
                    //     : null,
                    onChanged: (value) {
                      offerController.showOfferTitleInOfferCardGrid.value =
                          value;
                      percentageError.value = '';

                      if (value.isEmpty) {
                        percentageError.value = 'ادخل عنوان العرض';
                      }
                    },
                    label: 'titleOffer'.tr,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomText(
                        text: 'classification'.tr,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomSingleDropdown(
                    categories: categoryController.categories,
                    selectedCategoryId: selectedCategoryId,
                    isDark: isDark,
                    label: 'selectCategory'.tr,
                    isRequired: true,
                    errorText: categoryError.value.isNotEmpty
                        ? categoryError.value
                        : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    isRequired: true,
                    label: 'descriptionApp'.tr,
                    hintText: '',
                    controller: descriptionArController,
                    maxLength: 250,
                    maxLines: 3,
                    errorText: descriptionArError.value,
                    onChanged: (value) {
                      offerController
                          .showOfferDescriptionInOfferCardGrid.value = value;

                      if (value.isEmpty) {
                        descriptionArError.value = 'ادخل الوصف';
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    maxLines: 3,
                    label: 'termsApp'.tr,
                    hintText: '',
                    maxLength: 250,
                    controller: termsController,
                    errorText:
                        termsError.value.isNotEmpty ? termsError.value : null,
                    onChanged: (value) => termsError.value = '',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'offerCode'.tr,
                    hintText: '',
                    controller: offerCodeController,
                    maxLength: 100,
                    errorText: couponCodeError.value.isNotEmpty
                        ? couponCodeError.value
                        : null,
                    onChanged: (value) => couponCodeError.value = '',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    isRequired: true,
                    label: 'offerLink'.tr,
                    hintText: '',
                    controller: linkController,
                    keyboardType: TextInputType.url,
                    errorText:
                        linkError.value.isNotEmpty ? linkError.value : null,
                    onChanged: (value) => linkError.value = '',
                  ),
                  const SizedBox(height: 20),
                  CustomStatusDropdown(
                    status: status,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  if (packageUsageController.isLoading.value)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Shimmer.fromColors(
                        baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
                        child: Container(
                          width:139.w,
                          height: 17.h,
                          decoration: BoxDecoration(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                    )
                  else if (offerStatus == 'unlimited')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        offer == null ? 'unlimited'.tr : 'unlimited'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    )
                  else if (offerStatus == 'available')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        offer == null
                            ? '${'attempts_remaining_label'.tr}${addOffersUsage?.remaining.toString()}'
                            : '${'attempts_remaining_label'.tr}${editOffersUsage?.remaining.toString()}',
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    )
                  else if (offerStatus == 'none')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'هذه الميزة غير متاحة فى باقتك',
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  CustomButton(
                    margin: EdgeInsets.only(bottom: 25.h),
                    text: offerController.isLoading.value
                        ? 'progress'.tr
                        : offer == null
                            ? 'add'.tr
                            : 'editApp'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: offerController.isLoading.value
                        ? null
                        : () async {
                            if (globalValidationKey.currentState!.validate()) {
                              percentageError.value = '';
                              descriptionArError.value = '';
                              termsError.value = '';
                              couponCodeError.value = '';
                              linkError.value = '';
                              categoryError.value = '';
                              // imageError.value = '';
                              statusError.value = '';

                              print('Offer action status: $offerStatus');

                              if (offerStatus == 'none') {
                                _showLimitReachedDialog(
                                  context,
                                  title: 'feature_not_available'.tr,
                                  message: offer == null
                                      ? 'add_offers_not_in_package'.tr
                                      : 'edit_offers_not_in_package'.tr,
                                  buttonText: 'upgrade_package'.tr,
                                  onButtonPressed: () {
                                    Navigator.pop(context);
                                    Get.to(() => isIOs
                                        ? IosSubscriptionsScreen()
                                        : AndroidSubscriptionsScreen());
                                  },
                                );
                                return;
                              } else if (offerStatus == 'limit_reached') {
                                _showLimitReachedDialog(
                                  context,
                                  title: 'limit_reached'.tr,
                                  message: offer == null
                                      ? 'add_offers_limit_reached'.tr
                                      : 'edit_offers_limit_reached'.tr,
                                  buttonText: 'upgrade_package'.tr,
                                  onButtonPressed: () {
                                    Navigator.pop(context);
                                    Get.to(() => isIOs
                                        ? IosSubscriptionsScreen()
                                        : AndroidSubscriptionsScreen());
                                  },
                                );
                                return;
                              }

                              if (titleController.text.isEmpty) {
                                percentageError.value = 'titleRequired'.tr;
                                return;
                              }
                              if (selectedCategoryId.value == null) {
                                categoryError.value = 'categoryRequired'.tr;
                                return;
                              }

                              ///COMMENTED 4/8/2025

                              // final percentage =
                              //     int.tryParse(percentageController.text);
                              // if (percentage == null ||
                              //     percentage > 100 ||
                              //     percentage < 0) {
                              //   percentageError.value =
                              //       'النسبة يجب أن تكون بين 0 و 100';
                              //   return;
                              // }
                              if (descriptionArController.text.isEmpty) {
                                descriptionArError.value = 'descRequired'.tr;
                                return;
                              }

                              if (linkController.text.isEmpty) {
                                linkError.value = 'linkRequired'.tr;
                                return;
                              }
                              // Updated URL validation
                              final urlPattern = RegExp(
                                  r'^(https?:\/\/)?([\w-]+\.)*[\w-]+\.[a-zA-Z]{2,}(\/.*)?$',
                                  caseSensitive: false);
                              if (!urlPattern.hasMatch(linkController.text.trim())) {
                                linkError.value = 'invalidLink'.tr;
                                return;
                              }

                              print('creatig offer ..loading');
                              print(' offer value: ${offer?.type}');
                              // Normalize the URL (optional)
                              String normalizedLink = linkController.text;
                              if (!normalizedLink.startsWith('http://') &&
                                  !normalizedLink.startsWith('https://')) {
                                normalizedLink = 'https://$normalizedLink';
                              }

                              // if (offer == null && uploadedImage.value == null) {
                              //   imageError.value = 'imageRequired'.tr;
                              //   return;
                              // }

                              bool success;
                              final titleAr = titleController.text;
                              final titleEn = titleController.text;

                              if (offer == null) {
                                // Add new offer
                                success = await offerController.addOffer(
                                  discountType: 'text',
                                  discountTypeInfo:
                                      offerController.DiscountTypeInfo ?? '',
                                  // image: uploadedImage.value!,
                                  descriptionAr: descriptionArController.text.trim(),
                                  descriptionEn: descriptionArController.text.trim(),
                                  link: normalizedLink.trim(),
                                  categoryId: selectedCategoryId.value!,
                                  titleAr: titleAr.trim(),
                                  titleEn: titleEn.trim(),
                                  terms: termsController.text.isEmpty
                                      ? null
                                      : termsController.text.trim(),
                                  couponCode: offerCodeController.text.isEmpty
                                      ? null
                                      : offerCodeController.text.trim(),
                                  status: status.value,
                                );
                              } else {
                                // Update existing offer
                                success = await offerController.updateOffer(
                                  discountType: 'text',
                                  discountTypeInfo:
                                      offerController.DiscountTypeInfo ?? '',
                                  offerId: offer.id,
                                  // image: uploadedImage.value,
                                  descriptionAr: descriptionArController.text.trim(),
                                  descriptionEn: descriptionArController.text.trim(),
                                  link: normalizedLink.trim(),
                                  categoryId: selectedCategoryId.value!,
                                  titleAr: titleAr.trim(),
                                  titleEn: titleEn.trim(),
                                  terms: termsController.text.isEmpty
                                      ? null
                                      : termsController.text.trim(),
                                  couponCode: offerCodeController.text.isEmpty
                                      ? null
                                      : offerCodeController.text.trim(),
                                  status: status.value,
                                );
                              }

                              //=============================================================
                              if (success) {
                                Navigator.pop(context);
                                packageUsageController.fetchPackageUsage();
                                _showSuccessDialog(
                                  context,
                                  title: offer == null
                                      ? 'offerAddSuccess'.tr
                                      : 'offerEditSuccess'.tr,
                                  buttonText: 'browseOffer'.tr,
                                  onButtonPressed: () {
                                    print('Refreshing offer list');
                                    offerController.fetchOffers(page: 1);
                                  },
                                );
                              } else if (offerController
                                  .validationErrors.isNotEmpty) {
                                final errors = offerController.validationErrors;
                                if (errors.containsKey('title_ar')) {
                                  percentageError.value =
                                      errors['title_ar']!.join(', ');
                                }
                                if (errors.containsKey('description_ar')) {
                                  descriptionArError.value =
                                      errors['description_ar']!.join(', ');
                                }
                                if (errors.containsKey('terms')) {
                                  termsError.value =
                                      errors['terms']!.join(', ');
                                }
                                if (errors.containsKey('coupon_code')) {
                                  couponCodeError.value =
                                      errors['coupon_code']!.join(', ');
                                }
                                if (errors.containsKey('link')) {
                                  linkError.value = errors['link']!.join(', ');
                                }
                                if (errors.containsKey('category_id')) {
                                  categoryError.value =
                                      errors['category_id']!.join(', ');
                                }
                                // if (errors.containsKey('image')) {
                                //   imageError.value = errors['image']!.join(', ');
                                // }
                                if (errors.containsKey('status')) {
                                  statusError.value =
                                      errors['status']!.join(', ');
                                }
                              } else {
                                percentageError.value =
                                    offerController.errorMessage.value;
                              }
                            }
                          },
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  static void showAddBannerSheet(BuildContext context, {BannerMarket? banner}) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final BannerController bannerController = Get.put(BannerController());
    final ProfileController profileController = Get.put(ProfileController());
    final PackageUsageController packageUsageController =
        Get.put(PackageUsageController());
    final descriptionArController =
        TextEditingController(text: banner?.descriptionAr ?? '');
    final descriptionEnController =
        TextEditingController(text: banner?.descriptionEn ?? '');
    final linkController = TextEditingController(text: banner?.link ?? '');
    final couponCodeController =
        TextEditingController(text: banner?.couponCode ?? '');
    final uploadedImage = Rxn<File>();
    final selectedLocation = (banner?.location ?? 'top').obs;
    final locations = ['top', 'bottom'];
    final descriptionArError = ''.obs;
    final descriptionText = ''.obs;
    final descriptionEnError = ''.obs;
    final linkError = ''.obs;
    final statusError = ''.obs; // Add for status errors
    final status = (banner?.status ?? 1).obs; // Initialize with banner status
    final couponCodeError = ''.obs;
    final imageError = ''.obs;
    final locationError = ''.obs;
    final isFetchingUsage = true.obs;
    final usageError = ''.obs;
    var staticMarket = MarketBanner(
      id: banner?.market.id ?? 2,
      name: profileController.profile.value?.name ?? 'متجر مثالي',
      logo: profileController.profile.value?.logo ?? '',
    );
    packageUsageController.fetchPackageUsage().then((success) {
      isFetchingUsage(false);
      if (!success) {
        usageError.value = packageUsageController.errorMessage.value;
      }
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: kBottomSheetHeight,
        padding: EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          final previewBanner = BannerMarket(
            id: banner?.id ?? 0,
            marketId: staticMarket.id,
            market: staticMarket,
            image: uploadedImage.value != null
                ? uploadedImage.value!.path
                : (banner?.image ?? ''),
            descriptionAr: descriptionArController.text.isEmpty
                ? 'وصف البانر'
                : descriptionText.value,
            descriptionEn: descriptionEnController.text.isEmpty
                ? 'Banner Description'
                : descriptionEnController.text,
            link: linkController.text.isEmpty
                ? 'https://example.com'
                : linkController.text,
            location: selectedLocation.value,
            couponCode: couponCodeController.text.isEmpty
                ? null
                : couponCodeController.text,
            status: status.value,
            // Use status.value
            createdAt: banner?.createdAt ?? '05-11-2025',
            updatedAt: banner?.updatedAt ?? '05-11-2025',
          );

          final packageUsages = packageUsageController.packageUsages;
          final storeBannerTopUsage = packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'store_banner_top');
          final editTopBannerUsage = packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'edit_top_banner');
          final storeBannerBottomUsage = packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'store_banner_bottom');
          final editBottomBannerUsage = packageUsages
              .firstWhereOrNull((usage) => usage.tag == 'edit_bottom_banner');

          String? bannerStatus;
          PackageUsage? relevantUsage;
          if (banner == null) {
            // Adding new banner
            relevantUsage = selectedLocation.value == 'top'
                ? storeBannerTopUsage
                : storeBannerBottomUsage;
            if (relevantUsage == null || relevantUsage.isNone) {
              bannerStatus = 'none';
            }
            else if (relevantUsage.remaining == null) {
              bannerStatus = 'unlimited';
            } else if (relevantUsage.remaining! > 0) {
              bannerStatus = 'available';
            } else {
              bannerStatus = 'limit_reached';
            }
            print(
                '${selectedLocation.value == 'top' ? 'store_banner_top' : 'store_banner_bottom'} status: $bannerStatus, remaining: ${relevantUsage?.remaining}, isNone: ${relevantUsage?.isNone}');
          } else {
            // Editing existing banner
            relevantUsage = selectedLocation.value == 'top'
                ? editTopBannerUsage
                : editBottomBannerUsage;
            if (relevantUsage == null || relevantUsage.isNone) {
              bannerStatus = 'none';
            } else if (relevantUsage.remaining == null) {
              bannerStatus = 'unlimited';
            } else if (relevantUsage.remaining! > 0) {
              bannerStatus = 'available';
            } else {
              bannerStatus = 'limit_reached';
            }
            print(
                '${selectedLocation.value == 'top' ? 'edit_top_banner' : 'edit_bottom_banner'} status: $bannerStatus, remaining: ${relevantUsage?.remaining}, isNone: ${relevantUsage?.isNone}');
          }
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(
                    context, banner == null ? 'addBanner'.tr : 'editBanner'.tr),
                const SizedBox(height: 20),
                Text(
                  'preview'.tr,
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.27,
                  child: PromoBanner(
                    banner: previewBanner,
                    isClick: false,
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'bannerImage'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' *',
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: isDark ? Colors.grey : Colors.grey),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.cloud_upload_sharp, size: 40),
                          color: AppColors.primary,
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              //compress image
                              final dir = await getTemporaryDirectory();
                              final targetPath = path.join(dir.path,
                                  "${DateTime.now().millisecondsSinceEpoch}.jpg");
                              var result =
                                  await FlutterImageCompress.compressAndGetFile(
                                pickedFile.path,
                                targetPath,
                                quality: 60, // 60–80 is a good range
                              );
                              uploadedImage.value = File(result!.path);
                              imageError.value = '';
                            }
                          },
                        ),
                        Text(
                          'selectImage'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color:
                                isDark ? Colors.white : const Color(0xff5D5C5C),
                          ),
                        ),
                        Text(
                          banner == null
                              ? 'atLeastImage'.tr
                              : 'atLeastImage'.tr,
                          style: GoogleFonts.tajawal(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color:
                                isDark ? Colors.white : const Color(0xffC2C73A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (uploadedImage.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(uploadedImage.value!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () => uploadedImage.value = null,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (imageError.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      imageError.value,
                      style:
                          GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'descriptionApp'.tr,
                  hintText: '',
                  controller: descriptionArController,
                  maxLength: 250,
                  isRequired: true,
                  errorText: descriptionArError.value.isNotEmpty
                      ? descriptionArError.value
                      : null,
                  onChanged: (value) {
                    descriptionArError.value = '';
                    descriptionText.value = value;
                  },
                ),
                // const SizedBox(height: 20),
                // CustomTextField(
                //   label: 'description_en'.tr,
                //   hintText: 'Banner Description',
                //   controller: descriptionEnController,
                //   errorText: descriptionEnError.value.isNotEmpty ? descriptionEnError.value : null,
                //   onChanged: (value) => descriptionEnError.value = '',
                // ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'bannerLink'.tr,
                  hintText: '',
                  controller: linkController,
                  keyboardType: TextInputType.url,
                  isRequired: true,
                  errorText:
                      linkError.value.isNotEmpty ? linkError.value : null,
                  onChanged: (value) => linkError.value = '',
                ),
                // const SizedBox(height: 20),
                // CustomTextField(
                //   label: 'coupon_code'.tr,
                //   hintText: 'XXXX-XXXX (optional)',
                //   controller: couponCodeController,
                //   errorText: couponCodeError.value.isNotEmpty ? couponCodeError.value : null,
                //   onChanged: (value) => couponCodeError.value = '',
                // ),
                const SizedBox(height: 20),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'مكان العرض'.tr,
                //       style: GoogleFonts.tajawal(
                //         fontSize: 16,
                //         color: isDark ? Colors.white70 : Colors.grey,
                //       ),
                //     ),
                //     const SizedBox(height: 8),
                //     Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 12),
                //       decoration: BoxDecoration(
                //         color: isDark ? Colors.grey[800] : Colors.white,
                //         border: Border.all(color: isDark ? Colors.grey : Colors.grey),
                //         borderRadius: BorderRadius.circular(50),
                //       ),
                //       child: DropdownButtonHideUnderline(
                //         child: DropdownButton<String>(
                //           value: selectedLocation.value,
                //           isExpanded: true,
                //           items: locations.map((String location) {
                //             return DropdownMenuItem<String>(
                //               value: location,
                //               child: Text(
                //                 location.tr,
                //                 style: GoogleFonts.tajawal(
                //                   fontSize: 16,
                //                   color: isDark ? Colors.white : Colors.black,
                //                 ),
                //               ),
                //             );
                //           }).toList(),
                //           onChanged: (String? newValue) {
                //             if (newValue != null) {
                //               selectedLocation.value = newValue;
                //               locationError.value = '';
                //             }
                //           },
                //           style: GoogleFonts.tajawal(
                //             color: isDark ? Colors.white : Colors.black,
                //           ),
                //           dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                //           icon: Icon(
                //             Icons.arrow_drop_down,
                //             color: isDark ? Colors.grey : Colors.black54,
                //           ),
                //         ),
                //       ),
                //     ),
                //     if (locationError.value.isNotEmpty)
                //       Padding(
                //         padding: const EdgeInsets.only(top: 8.0),
                //         child: Text(
                //           locationError.value,
                //           style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                //         ),
                //       ),
                //   ],
                // ),
                CustomLocationDropdown(
                  locations: locations,
                  selectedLocation: selectedLocation,
                  isDark: isDark,
                  errorText: locationError.value.isNotEmpty
                      ? locationError.value
                      : null,
                ),
                const SizedBox(height: 10),
                CustomStatusDropdown(
                  status: status,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                if (packageUsageController.isLoading.value)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Shimmer.fromColors(
                      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      highlightColor: isDark ? Colors.grey[500]! : Colors.grey[100]!,
                      child: Container(
                        width:139.w,
                        height: 17.h,
                        decoration: BoxDecoration(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                    ),
                  )
                else if (bannerStatus == 'unlimited')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      banner == null
                          ? selectedLocation.value == 'top'
                          ? 'store_banner_top_unlimited'.tr
                          : 'store_banner_bottom_unlimited'.tr
                          : selectedLocation.value == 'top'
                          ? 'edit_top_banner_unlimited'.tr
                          : 'edit_bottom_banner_unlimited'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  )
                else if (bannerStatus == 'available')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(

                        banner == null
                            ? selectedLocation.value == 'top'
                            ? '${'attempts_remaining_label'.tr}${'${relevantUsage?.remaining.toString()}'}'
                            : '${'attempts_remaining_label'.tr}${'${relevantUsage?.remaining.toString()}'}'
                            : selectedLocation.value == 'top'
                            ? '${'attempts_remaining_label'.tr}${'${relevantUsage?.remaining.toString()}'}'
                            : '${'attempts_remaining_label'.tr}${'${relevantUsage?.remaining.toString()}'}',
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    )
                  else if (bannerStatus == 'none')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          'هذه الميزة غير متاحة فى باقتك',
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                CustomButton(
                  margin: EdgeInsets.only(bottom: 60.h),
                  text: bannerController.isLoading.value
                      ? 'progress'.tr
                      : banner == null
                          ? 'add'.tr
                          : 'editApp'.tr,
                  textSize: 22,
                  textFontWeight: FontWeight.bold,
                  onPressed: bannerController.isLoading.value
                      ? null
                      : () async {
                          descriptionArError.value = '';
                          // descriptionEnError.value = '';
                          linkError.value = '';
                          // couponCodeError.value = '';
                          imageError.value = '';
                          locationError.value = '';
                          statusError.value = '';

                          if (bannerStatus == 'none') {
                            _showLimitReachedDialog(
                              context,
                              title: 'feature_not_available'.tr,
                              message: banner == null
                                  ? selectedLocation.value == 'top'
                                      ? 'store_banner_top_not_in_package'.tr
                                      : 'store_banner_bottom_not_in_package'.tr
                                  : selectedLocation.value == 'top'
                                      ? 'edit_top_banner_not_in_package'.tr
                                      : 'edit_bottom_banner_not_in_package'.tr,
                              buttonText: 'upgrade_package'.tr,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Get.to(() => isIOs
                                    ? IosSubscriptionsScreen()
                                    : AndroidSubscriptionsScreen());
                              },
                            );
                            return;
                          } else if (bannerStatus == 'limit_reached') {
                            _showLimitReachedDialog(
                              context,
                              title: 'limit_reached'.tr,
                              message: banner == null
                                  ? selectedLocation.value == 'top'
                                      ? 'store_banner_top_limit_reached'.tr
                                      : 'store_banner_bottom_limit_reached'.tr
                                  : selectedLocation.value == 'top'
                                      ? 'edit_top_banner_limit_reached'.tr
                                      : 'edit_bottom_banner_limit_reached'.tr,
                              buttonText: 'upgrade_package'.tr,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Get.to(() => isIOs
                                    ? IosSubscriptionsScreen()
                                    : AndroidSubscriptionsScreen());
                              },
                            );
                            return;
                          }
                          if (banner == null && uploadedImage.value == null) {
                            imageError.value = 'imageRequired'.tr;
                            print('Validation error: image_required');
                            return;
                          }
                          if (descriptionArController.text.isEmpty) {
                            descriptionArError.value = 'descRequired'.tr;
                            print('Validation error: description_ar_required');
                            return;
                          }
                          // if (descriptionEnController.text.isEmpty) {
                          //   descriptionEnError.value = 'description_en_required'.tr;
                          //   print('Validation error: description_en_required');
                          //   return;
                          // }
                          if (linkController.text.isEmpty) {
                            linkError.value = 'linkRequired'.tr;
                            return;
                          }
                          // Updated URL validation
                          final urlPattern = RegExp(
                              r'^(https?:\/\/)?([\w-]+\.)*[\w-]+\.[a-zA-Z]{2,}(\/.*)?$',
                              caseSensitive: false);
                          if (!urlPattern.hasMatch(linkController.text.trim())) {
                            linkError.value = 'invalidLink'.tr;
                            return;
                          }
                          // Normalize the URL (optional)
                          String normalizedLink = linkController.text;
                          if (!normalizedLink.startsWith('http://') &&
                              !normalizedLink.startsWith('https://')) {
                            normalizedLink = 'https://$normalizedLink';
                          }

                          if (!locations.contains(selectedLocation.value)) {
                            locationError.value = 'placeRequired'.tr;
                            print('Validation error: location_required');
                            return;
                          }

                          print(
                              'All validations passed, proceeding with ${banner == null ? 'addBanner' : 'updateBanner'}');

                          bool success;
                          if (banner == null) {
                            success = await bannerController.addBanner(
                              image: uploadedImage.value!,
                              descriptionAr: descriptionArController.text.trim(),
                              descriptionEn: descriptionArController.text.trim(),
                              link: normalizedLink.trim(),
                              location: selectedLocation.value,
                              couponCode: null,
                              // couponCodeController.text.isEmpty ? null : couponCodeController.text,
                              status: status.value,
                            );
                          } else {
                            success = await bannerController.updateBanner(
                              bannerId: banner.id,
                              image: uploadedImage.value,
                              descriptionAr: descriptionArController.text,
                              descriptionEn: descriptionArController.text,
                              link: normalizedLink.trim(),
                              location: selectedLocation.value,
                              couponCode: null,
                              // couponCodeController.text.isEmpty ? null : couponCodeController.text,
                              status: status.value,
                            );
                          }

                          print('Banner operation success: $success');
                          if (success) {
                            print(
                                'Closing bottom sheet and showing success dialog');
                            Navigator.pop(context);

                            _showSuccessDialog(
                              context,
                              title: banner == null
                                  ? 'bannerAddSuccess'.tr
                                  : 'bannerEditSuccess'.tr,
                              buttonText: 'browseBanners'.tr,
                              onButtonPressed: () {
                                print('Refreshing banner list');
                                bannerController.fetchBanners(page: 1);
                              },
                            );
                            packageUsageController.fetchPackageUsage();

                          } else {
                            print(
                                'Operation failed, checking validation errors');
                            if (bannerController.validationErrors.isNotEmpty) {
                              final errors = bannerController.validationErrors;
                              if (errors.containsKey('description_ar')) {
                                descriptionArError.value =
                                    errors['description_ar']!.join(', ');
                                print(
                                    'API error: description_ar - ${descriptionArError.value}');
                              }
                              // if (errors.containsKey('description_en')) {
                              //   descriptionEnError.value = errors['description_en']!.join(', ');
                              //   print('API error: description_en - ${descriptionEnError.value}');
                              // }
                              if (errors.containsKey('link')) {
                                linkError.value = errors['link']!.join(', ');
                                print('API error: link - ${linkError.value}');
                              }
                              // if (errors.containsKey('coupon_code')) {
                              //   couponCodeError.value = errors['coupon_code']!.join(', ');
                              //   print('API error: coupon_code - ${couponCodeError.value}');
                              // }
                              if (errors.containsKey('image')) {
                                imageError.value = errors['image']!.join(', ');
                                print('API error: image - ${imageError.value}');
                              }
                              if (errors.containsKey('location')) {
                                locationError.value =
                                    errors['location']!.join(', ');
                                print(
                                    'API error: location - ${locationError.value}');
                              }
                              if (errors.containsKey('status')) {
                                statusError.value =
                                    errors['status']!.join(', ');
                                print(
                                    'API error: status - ${statusError.value}');
                              }
                            } else {
                              descriptionArError.value =
                                  bannerController.errorMessage.value;
                              print(
                                  'API error: general - ${descriptionArError.value}');
                            }
                          }
                        },
                ),
                SizedBox(
                    height:
                        MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
              ],
            ),
          );
        }),
      ),
    ).then((value) {
      bannerController.fetchBanners();
    },);
  }

  static Widget _buildSheetHeader(BuildContext context, String headerText) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40), // Spacer to balance the close icon

        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              headerText, // Use dynamic text here
              style: GoogleFonts.tajawal(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xff5D5C5C),
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.close,
            color: isDark ? Colors.grey[400] : Colors.grey,
          ),
        ),
      ],
    );
  }

  static void _showSuccessDialog(
    BuildContext context, {
    required String title,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Use dialogContext for the dialog
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/check 1.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: GoogleFonts.tajawal(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: buttonText,
                  textSize: 22,
                  textFontWeight: FontWeight.bold,
                  onPressed: () {
                    onButtonPressed();
                    Navigator.pop(dialogContext); // Pop using dialogContext
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showLimitReachedDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
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
              Text(
                title,
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: GoogleFonts.tajawal(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  if (onButtonPressed != null) {
                    onButtonPressed();
                  }
                },
                text: buttonText,
                textSize: 16,
                textFontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiscountTypeWidget extends StatefulWidget {
  const DiscountTypeWidget({super.key});

  @override
  State<DiscountTypeWidget> createState() => _DiscountTypeWidgetState();
}

class _DiscountTypeWidgetState extends State<DiscountTypeWidget> {
  OfferController offerController = Get.put(OfferController());
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var selectedValue = offerController.selectedValueDiscountType.value;
        return Column(
          children: [
            Row(
              children: [
                CustomText(
                  text: 'discount_type'.tr,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                icon: Icon(Icons.expand_more),
                style: TextStyle(color: Colors.black),
                dropdownColor: Colors.white,
                items: [
                  DropdownMenuItem(
                    value: 'percentage',
                    child: CustomText(
                      text: 'خصم بنسبة',
                      color: selectedValue == 'percentage'
                          ? AppColors.blue
                          : AppColors.grey2,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'amount',
                    child: CustomText(
                        text: 'خصم مبلغ',
                        color: selectedValue == 'amount'
                            ? AppColors.blue
                            : AppColors.grey2),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      offerController.selectedValueDiscountType.value = value;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            AdCustomTextField(
              focusNode: focusNode,
              hint: '',
              hitOverTextField:
                  offerController.selectedValueDiscountType.value.tr,
              controller: controller,
              keyboardType: offerController.selectedValueDiscountType.value ==
                      'percentage'
                  ? TextInputType.number
                  : TextInputType.text,
              onChanged: (value) {
                offerController.DiscountTypeInfo = value;
              },
              validator: (p0) {
                // Safely get the trimmed value
                final trimmed = p0?.trim() ?? '';

                // Access discount type (use GetX safely)
                final type = offerController.selectedValueDiscountType.value;

                // Conditional validation
                if (type == 'percentage') {
                  return Validation.mustBeNumber(trimmed, 'percentage'.tr);
                } else {
                  return Validation.notEmpty(trimmed, 'amount'.tr);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
