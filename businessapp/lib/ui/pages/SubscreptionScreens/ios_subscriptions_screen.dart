import 'dart:async';
import 'dart:developer';

import 'package:dieaya_market/ui/pages/SubscreptionScreens/components/subscription_details.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/components/subscription_line_widget.dart';
import 'package:dieaya_market/ui/widgets/buttons.dart';
import 'package:dieaya_market/ui/widgets/custom_sheets.dart';
import 'package:dieaya_market/ui/widgets/custom_verify_sheets.dart';
import 'package:dieaya_market/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_market/utils/app_colors.dart';
import 'package:dieaya_market/utils/constants/image_constants.dart';
import 'package:dieaya_market/utils/custom_svg.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import '../../../controllers/PackgesController/buy_packge_controller.dart';
import '../../../controllers/PackgesController/packges_controller.dart';
import '../../../controllers/ProfileController/profile_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../models/packges_model.dart';
import '../../../utils/app_snackbars.dart';
import '../AuthScreens/success_register.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

import 'dart:io' show Platform;

import 'dart:convert';
import 'dart:io';

class IosSubscriptionsScreen extends StatefulWidget {
  const IosSubscriptionsScreen({super.key});

  @override
  _IosSubscriptionsScreenState createState() => _IosSubscriptionsScreenState();
}

class _IosSubscriptionsScreenState extends State<IosSubscriptionsScreen> {
  // final String _apiKey =
  //     'EEiYv_IMa8SCWhPMNhREjGEEHS3plguugab_KuhpXZbdPrrCXe0OdUfPHqsYtMRHAbRcpOoezsqjVibd7Y7Fo7P4auUbzV1filhrjb0yg4gfonB8s9d7eTbYXtR8AmJ1ap5kSGO3XISfeZCK1L3JCXMIQ_Z7VffN8DyfxkpqFQGyhw8aS9c_2fBpyiH7DP2FgxvTXXC4jZAgRn3oiaZsuCvNR1EIhtx0sOZ9Bb48aG-NzUNTTt-bBbzg0gLA6DAwdZJpT8mWosbJv439ttASc3APDUu8264E9JiwEjjmjwHKNQh0SvLB2kIxZAxP1EtuRzyAYmKRha2h7nwWsYGIOYxSPaZSpd_CViYkGpdXO_YVdOkNOngsnp6gAkVyM1L04blyMmss9xZHSjRwBEr3IEsgTrBQJA-Ytes08oPm3ngRXrFabmllnQK7KcybcR4ZDJtb36Vy5tBicbiFRk27QwK10YDDjdJOJn5FJn1rt2UkZJrvciRRejPwnAI_irfapJffy4LOlkT1b56qyFxK4RDYB2WM12qBrA5kXzQBFSRdVQC3rNwxfK-qcRn6tmiSKs0Pdllo8Qfm27vvmM7KeTHURLZG6kcJGauzZEnwbZYmXY1036h782gkmDmk79Fk0tQqZ_FUgvyiEUQbRH6_jmIiKXNWz3AUGpSHlqatxUv7HvjbGuRh9UBIY8fPBR7uNUFd7AOzN8uw47UBq2Ggk51TkLs';

  // late MFApplePayButton mfApplePayButton;
  // bool _isApplePayLoading = false;
  Rx<bool> _isProcessing = false.obs;
  final PackageController packageController = Get.put(PackageController());
  final ProfileController profileController =
      Get.find<ProfileController>(); // Use Get.find for existing controller

  final Set<String> _kProductIds = <String>{};
  int? paidPackageId;

  String? transactionId;

  /// ====================IAP
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  /// ====================================

  @override
  void initState() {
    super.initState();
    packageController.fetchPackages();
    // Initialize IAP
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) async {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onError: (Object error) async {
        debugPrint('Purchase stream error: $error');
      },
    );

    // Initialize StoreKit for iOS
    if (Platform.isIOS) {
      initStoreInfo();
    }
    // _loadProducts(_kProPackageId);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  final BuyPackageController buyPackageController =
      Get.find<BuyPackageController>();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    final isDark = themeController.themeMode.value == ThemeMode.dark;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                // badge of the top of screen
                Stack(
                  fit: StackFit.passthrough,
                  // alignment: Alignment.topCenter,
                  children: [
                    //fill free top space with color
                    Container(
                      height: 400.h,
                      width: 600.w,
                      color: AppColors.black,
                    ),

                    // base image
                    if (!isDark)
                      Image.asset(
                        'assets/images/backtest.png',
                        height: 400.h,
                        width: 600.w,
                        fit: BoxFit.fill,
                      ),
                    if (isDark) ...[
                      Positioned(
                        left: -60,
                        top: MediaQuery.of(context).size.height * 0.03,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.height * 0.30,
                          child: SvgPicture.asset(
                            'assets/images/circle_full.svg',
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: MediaQuery.of(context).size.height * 0.16,
                        child: Container(
                          height: 100.h,
                          width: 100.h,
                          child: SvgPicture.asset(
                            'assets/images/circle_full.svg',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],

                    Positioned(
                      top: 190.h,
                      child: Container(
                        width: 450.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'packages_subscriptions'.tr,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //back button
                    Positioned(
                      top: 50,

                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded,
                                color: Colors.white),
                            onPressed:
                                _isProcessing.value ? null : () => Get.back(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      // subscription details
                      SubscriptionDetails(),

                      SizedBox(height: 55.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        child: Divider(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      Container(
                        key: const ValueKey('subscriptions_list_section'),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Obx(() => _buildSubscriptionsList(
                            isDark, packageController, buyPackageController)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isProcessing.value)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubscriptionsList(
      bool isDark,
      PackageController packageController,
      BuyPackageController buyPackageController) {
    if (packageController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (packageController.errorMessage.value.isNotEmpty) {
      return Center(
        child: Text(
          packageController.errorMessage.value,
          style: GoogleFonts.tajawal(fontSize: 16, color: Colors.red),
        ),
      );
    }
    if (packageController.packages.isEmpty) {
      return Center(
        child: Text(
          'no_packages'.tr,
          style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            CustomText(
              text: 'other_packages'.tr,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: packageController.packages.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final package = packageController.packages[index];
            final isFree = package.price == "0";
            final List<String> features = [
              ...(package.boquetItems?.map((item) {
                    final name = Get.locale?.languageCode == 'ar'
                        ? item.nameAr
                        : item.nameEn;
                    final quantity = item.quantity?.toString() ?? 'unlimited'.tr;
                    return '${"allow".tr}$quantity $name';
                  })
                  .toList() ??
                  <String>[]),
            ];
            final duration = isFree ? '30' : '30';
            final durationUnit = 'day'.tr;
            final buttonText = isFree ? 'get_now'.tr : 'buy_now'.tr;

            return _buildSubscriptionCard(
              context,
              package,
              duration,
              durationUnit,
              features,
              buttonText,
              isFree,
              isDark,
              buyPackageController,
            );
          },
        ),
      ],
    );
  }

//========================= IAP

  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [];

  Future<void> initStoreInfo() async {
    if (Platform.isIOS) {
      var iosPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(null);
    }
  }

  // step 0 in in app purchase (during runtime)
  Future<void> _loadProducts(String id) async {
    // return;
    try {
      _kProductIds.clear();
      _kProductIds.add(id);
      print('Checking if IAP store is available...');
      final bool available = await _iap.isAvailable();
      print('IAP store available: $available');

      if (!available) {
        print('❌ Store not available');
        return;
      }

      print('Querying product details for product IDs: $_kProductIds');
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(_kProductIds);

      if (response.error != null) {
        print('Product details: ${response.productDetails}');
        print('❌ Error fetching products: ${response.error?.details}');
        SnackBarConstant.showEnhancedSnackbar(
            context,
            response.error?.details ?? 'error'.tr,
            response.error?.message ?? 'there was an error please try again',
            success: false);
        return;
      }

      if (response.productDetails.isEmpty) {
        if (mounted) {
          _isProcessing.value = false;
          SnackBarConstant.showEnhancedSnackbar(
            context,
            'info'.tr,
            'product not found \n mis corresponding with apple',
            success: false,
          );
        }
        print('⚠️ No products found');
        return;
      }

      print('✅ Products found: ${response.productDetails.length}');
      for (var product in response.productDetails) {
        print('  - Product ID: ${product.id}');
        print('    Title: ${product.title}');
        print('    Price: ${product.price}');
        print('    Description: ${product.description}');
        _products.add(product);
      }

      // Store products to display in UI

      _buy(_products.first);

      print('========== _loadProducts() completed ==========');
    } catch (e) {
      buyPackageController.iosVerityIsLoading.value = false;
      buyPackageController.iosVerityIsLoading.value = false;
      _showErrorSnack(
        context,
        'payment_failed'.trParams({'error': e.toString()}),
      );
    } finally {}
  }

  //step 2
  void _buy(ProductDetails productDetails) async {
    try {
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      var x = await _iap.buyConsumable(purchaseParam: purchaseParam);

      print(
          '_iap.buyConsumable(purchaseParam: purchaseParam); ================ >$x');
      // buyPackageController.iosVerityIsLoading.value= false;
    } catch (e) {
      buyPackageController.iosVerityIsLoading.value = false;
      SnackBarConstant.showEnhancedSnackbar(
        context,
        'status is _buy func failed',
        'Purchase failed:  "Unknown error"}',
        success: false,
      );
      _showErrorSnack(
        context,
        'payment_failed'.trParams({'error': e.toString()}),
      );
    } finally {
      print('==================================');
      print('=====                        =====');
      print('=====                        =====');
      print('=====                        =====');
      print('=====                        =====');
      print('==================================');
      buyPackageController.isLoading.value = false;
      buyPackageController.iosVerityIsLoading.value = false;
    }
  }

  // step 3 called from listener
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    try {
      for (final purchase in purchases) {
        debugPrint('Purchase status: ${purchase.status}');
        debugPrint('Purchases length: ✅✅✅✅✅✅✅${purchases.length}');

        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          /// same purchase code

          print(
              '========================&&&&&&&&55%%    or     %%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_____+++__+))_)))_)$purchase');

          if (purchase is AppStorePurchaseDetails) {
            transactionId = purchase.skPaymentTransaction.transactionIdentifier;
            debugPrint('Purchase transactionId: ${transactionId}');
          }
          // Handle restore flow
          await _iap.completePurchase(purchase);
          print(
              'Enviroment ===== >${json.decode(purchase.verificationData.localVerificationData)['environment']}');
          String env = json.decode(
              purchase.verificationData.localVerificationData)['environment'];
          env = env.toLowerCase();
          var success = await buyPackageController.verifyInAppPurchase(
              purchase.purchaseID!, paidPackageId!, env);
          if (mounted && success) {
            SnackBarConstant.showEnhancedSnackbar(
              context,
              'success'.tr,
              'purchase_successfully'.tr,
              success: true,
            );
            final ProfileController profileController =
                Get.put<ProfileController>(ProfileController());
            await profileController.fetchProfile();
            Get.offAll(() => SuccessRegister());
            // final env = Platform.isIOS?'ios':'android';
            // var success = await buyPackageController.buyPackage(paidPackageId!,env:env );
            // if (success) {
            //
            // }
          } else {
            _showErrorSnack(
              context,
              'payment_failed'.trParams({'error': 'transaction not verified'}),
            );
            buyPackageController.iosVerityIsLoading.value = false;
            buyPackageController.iosVerityIsLoading.value = false;
            _isProcessing.value = false;
          }

          /// same purchase code
        } else if (purchase.status == PurchaseStatus.error) {
          debugPrint('❌ Purchase error: ${purchase.error}');
          if (mounted) {
            _isProcessing.value = false;
            SnackBarConstant.showEnhancedSnackbar(
              context,
              'error'.tr,
              'Purchase failed: ${purchase.error?.message ?? "Unknown error"}',
              success: false,
            );
          }
        } else if (purchase.status == PurchaseStatus.canceled) {
          debugPrint('Purchase canceled by user');
          if (mounted) {
            _isProcessing.value = false;
            SnackBarConstant.showEnhancedSnackbar(
              context,
              'info'.tr,
              'Purchase canceled',
              success: false,
            );
          }
        } else if (purchase.status == PurchaseStatus.restored) {
          print(
              '========================&&&&&&&&55%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@_____+++__+))_)))_)$purchase');

          if (purchase is AppStorePurchaseDetails) {
            transactionId = purchase.skPaymentTransaction.transactionIdentifier;
            debugPrint('Purchase transactionId: ${transactionId}');
          }
          debugPrint(
              'Purchase restored: ${purchase.verificationData.localVerificationData}');
          debugPrint('Purchase restored: ${purchase.purchaseID}');
          debugPrint('Purchase restored: ${purchase.productID}');
          // Handle restore flow
          await _iap.completePurchase(purchase);
          print(
              'Enviroment ===== >${json.decode(purchase.verificationData.localVerificationData)['environment']}');
          String env = json.decode(
              purchase.verificationData.localVerificationData)['environment'];
          env = env.toLowerCase();
          var success = await buyPackageController.verifyInAppPurchase(
              purchase.purchaseID!, paidPackageId!, env);
          if (mounted && success) {
            final env = Platform.isIOS ? 'ios' : 'android';
            var success =
                await buyPackageController.buyPackage(paidPackageId!, env: env);
            if (success) {
              SnackBarConstant.showEnhancedSnackbar(
                context,
                'success'.tr,
                'Purchase restored successfully',
                success: true,
              );
              final ProfileController profileController =
                  Get.put<ProfileController>(ProfileController());
              await profileController.fetchProfile();
              Get.offAll(() => SuccessRegister());
            }
          } else {
            _showErrorSnack(
              context,
              'payment_failed'.trParams({'error': 'transaction not verified'}),
            );
            buyPackageController.iosVerityIsLoading.value = false;
            buyPackageController.iosVerityIsLoading.value = false;
            _isProcessing.value = false;
          }
        } else if (purchase.status == PurchaseStatus.pending) {
          debugPrint('⏳ Purchase pending...');
          if (mounted) {
            SnackBarConstant.showEnhancedSnackbar(
              context,
              'processing'.tr,
              'Purchase is being processed...',
              success: true,
            );
          }
        }
      }
    } catch (e) {
      buyPackageController.iosVerityIsLoading.value = false;
      buyPackageController.isLoading.value = false;
      _showErrorSnack(
        context,
        'payment_failed'.trParams({'error': e.toString()}),
      );
    } finally {
      buyPackageController.iosVerityIsLoading.value = false;
      buyPackageController.isLoading.value = false;
    }
  }

//============================================

  Widget _buildSubscriptionCard(
      BuildContext context,
      Package package,
      String duration,
      String durationUnit,
      List<String> features,
      String buttonText,
      bool isFree,
      bool isDark,
      BuyPackageController buyPackageController) {
    return Container(
      height: 370,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'assets/images/back_sub.png',
              width: double.infinity,
              height: 370,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Container(
              // margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,

                // mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      package.nameAr.toString(),
                      style: GoogleFonts.tajawal(
                        fontSize: 20,
                        color: isDark ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 20, top: 70, bottom: 40),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isFree
                              ? Text(
                                  'free'.tr,
                                  style: GoogleFonts.tajawal(
                                    fontSize: isFree ? 30 : 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      (double.parse(package.price ?? '0'))
                                          .toStringAsFixed(2),
                                      style: GoogleFonts.tajawal(
                                        fontSize: isFree ? 30 : 30,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    CustomSvgImage(
                                      image: ImageConstants.moneySign,
                                      boxFit: BoxFit.none,
                                      height: 25.h,
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'package_allows_you'.tr,
                                        style: GoogleFonts.tajawal(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                          color: const Color(0xffAEAEAE),
                                        ),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                  ...features.map(
                                    (feature) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Icon(
                                              Icons.circle,
                                              size: 10.w,
                                              color: Color(0xff5D5C5C),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              feature,
                                              style: GoogleFonts.tajawal(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18.sp,
                                                color: const Color(0xffAEAEAE),
                                              ),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => CustomButton(
                          width: 150,
                          text: buyPackageController.isLoading.value ||
                                  buyPackageController.iosVerityIsLoading.value
                              ? 'loading'.tr
                              : buttonText,
                          textSize: 14,
                          textFontWeight: FontWeight.bold,
                          onPressed: buyPackageController.isLoading.value ||
                                  buyPackageController.iosVerityIsLoading.value
                              // _products.isEmpty
                              ? null
                              : () async {
                                  if (profileController
                                          .profile.value?.verified ==
                                      1) {
                                    if (isFree) {
                                      _handleFreePackage(context, package,
                                          buyPackageController);
                                    } else {
                                      // Use native IAP for paid packages on iOS
                                      if (Platform.isIOS) {
                                        paidPackageId = package.id!;
                                        print(paidPackageId);
                                        // _loadProducts(
                                        //   package.IAPPackageId ?? '',
                                        // );
                                        _handlePaidPackage(context, package,
                                            buyPackageController);
                                        ;

                                        // buyPackageController.buyPackage( package.id!,);
                                      } else {
                                        _showErrorSnack(context,
                                            'IAP not available or products not loaded');
                                      }
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF7FAFC),
                                              borderRadius: BorderRadius.circular(32.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.08),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => Navigator.pop(context),
                                                      child: Container(
                                                        width: 36.w,
                                                        height: 36.w,
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.04),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.close_rounded,
                                                          size: 22.sp,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8.h),

                                                Container(
                                                  width: 72.w,
                                                  height: 72.w,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary.withOpacity(0.12),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.verified_user_rounded,
                                                    color: AppColors.primary,
                                                    size: 34.sp,
                                                  ),
                                                ),

                                                SizedBox(height: 18.h),

                                                Text(
                                                  "phone_verification_title".tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black87,
                                                  ),
                                                ),

                                                SizedBox(height: 10.h),

                                                Text(
                                                  "phone_verification_message".tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    height: 1.7,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),

                                                SizedBox(height: 24.h),

                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 52.h,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      CustomSheetsVerify.showOTPSheetVerify(
                                                        context,
                                                        phoneNumber:
                                                        (profileController.profile.value?.phone)!,
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      backgroundColor: AppColors.primary,
                                                      foregroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(18.r),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "verify_now".tr,
                                                      style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w700,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(height: 10.h),

                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text(
                                                    "later".tr,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                        )),
                    Flexible(
                      child: Text(
                        isFree ?  '${package.days} $durationUnit' : '${package.days} $durationUnit',
                        style: GoogleFonts.tajawal(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff5D5C5C),
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
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

  void _handleFreePackage(BuildContext context, Package package,
      BuyPackageController buyPackageController) async {
    if (package.id == null) {
      SnackBarConstant.showEnhancedSnackbar(
        context,
        'error'.tr,
        'invalid_package_id'.tr,
        success: false,
      );
      return;
    }

    _isProcessing.value = false;

    try {
      final env = Platform.isIOS ? 'ios' : 'android';

      final success =
          await buyPackageController.buyPackage(package.id!, env: env);
      _isProcessing.value = false;
      ;
      SnackBarConstant.showEnhancedSnackbar(
        context,
        success ? 'success'.tr : 'error'.tr,
        success
            ? buyPackageController.successMessage.value
            : buyPackageController.errorMessage.value,
        success: success,
      );
      if (success) {
        // final ProfileController profileController =
        //     Get.put(ProfileController());
        // await profileController.fetchProfile();
        Get.offAll(() => SuccessRegister());
      }
    } catch (error) {
      _isProcessing.value = false;
      SnackBarConstant.showEnhancedSnackbar(
        context,
        'error'.tr,
        'free_package_failed'.trParams({'error': error.toString()}),
        success: false,
      );
      debugPrint('Free Package Error: $error');
    }
  }

//======================================================
  /// Call this for paid packages. Keeps UI states consistent and logs everything.
  /// Change the 3 "KWD/KUWAIT" marked lines if your merchant is Saudi.
  /// step zero of in app purchase
  Future<void> _handlePaidPackage(
    BuildContext context,
    Package package,
    BuyPackageController buyPackageController,
  ) async {
    buyPackageController.iosVerityIsLoading.value = true;
    buyPackageController.isLoading.value = true;

    // --- Validate package / amount ---
    if (package.id == null || package.price == null) {
      _showErrorSnack(context, 'invalid_package_data'.tr);
      return;
    }
    final invoiceAmount = double.tryParse(package.price!) ?? 0.0;
    if (invoiceAmount <= 0) {
      _showErrorSnack(context, 'invalid_invoice_amount'.tr);
      return;
    }

    // --- Toggle UI states ---

    _isProcessing.value = true;

    try {
      await _loadProducts(
        package.IAPPackageId ?? '',
      );
    } catch (e, st) {
      debugPrint('❌ Exception: $e\n$st');
      _showErrorSnack(
        context,
        'payment_failed'.trParams({'error': e.toString()}),
      );
    } finally {
      if (mounted) {
        _isProcessing.value = false;
        // buyPackageController.isLoading.value = false;
        // buyPackageController.iosVerityIsLoading.value = false;
        // buyPackageController.isLoading.value = false;
        // buyPackageController.iosVerityIsLoading.value = false;
      }
    }
  }

  /// Small helper to keep SnackBar calls consistent.
  void _showErrorSnack(BuildContext context, String message) {
    SnackBarConstant.showEnhancedSnackbar(
      context,
      'error'.tr,
      message,
      success: false,
    );
  }
}

class SnackBarConstant {
  static void showEnhancedSnackbar(
    BuildContext context,
    String title,
    String message, {
    bool success = true,
    SnackBarAction? action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? AppColors.green : AppColors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: success ? 3 : 5),
        action: action,
      ),
    );
  }
}

// Finish Without Payment

// class SubscriptionsScreen extends StatelessWidget {
//   const SubscriptionsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.find<ThemeController>();
//     final PackageController packageController = Get.put(PackageController());
//     final BuyPackageController buyPackageController =
//         Get.put(BuyPackageController());
//     final isDark = themeController.themeMode.value == ThemeMode.dark;
//
//     return Scaffold(
//       backgroundColor: isDark ? Colors.black : Colors.white,
//       body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//         child: Stack(
//           children: [
//             Stack(
//               children: [
//                 Image.asset('assets/images/tester.png'),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 160),
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: Text(
//                       'الباقات والاشتراكات',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.tajawal(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: isDark ? Colors.white : Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 60,
//                   right: 20,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back_ios_rounded,
//                         color: Colors.white),
//                     onPressed: () => Get.back(),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 220, left: 15, right: 15, bottom: 15),
//               child: Column(
//                 children: [
//                   Container(
//                     key: const ValueKey('subscriptions_list_section'),
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: Obx(() => _buildSubscriptionsList(
//                         isDark, packageController, buyPackageController)),
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
//   Widget _buildSubscriptionsList(
//       bool isDark,
//       PackageController packageController,
//       BuyPackageController buyPackageController) {
//     if (packageController.isLoading.value) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (packageController.errorMessage.value.isNotEmpty) {
//       return Center(
//         child: Text(
//           packageController.errorMessage.value,
//           style: GoogleFonts.tajawal(fontSize: 16, color: Colors.red),
//         ),
//       );
//     }
//     if (packageController.packages.isEmpty) {
//       return Center(
//         child: Text(
//           'no_packages'.tr,
//           style: GoogleFonts.tajawal(fontSize: 16, color: Colors.grey[600]),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       itemCount: packageController.packages.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         final package = packageController.packages[index];
//         final isFree = package.price == "0";
//         final List<String> features = [
//           'الباقة تتيح لك',
//           ...(package.boquetItems?.map((item) {
//                 final name = Get.locale?.languageCode == 'ar'
//                     ? item.nameAr
//                     : item.nameEn;
//                 final quantity = item.quantity?.toString() ?? 'غير محدود';
//                 return 'اضافة $quantity $name';
//               }).toList() ??
//               <String>[]),
//         ];
//         final duration = isFree ? 'شهريا' : '30';
//         final durationUnit = isFree ? '' : 'يوم';
//         final buttonText = isFree ? 'احصل الان' : 'اشتر الان';
//
//         return _buildSubscriptionCard(
//           context,
//           package,
//           duration,
//           durationUnit,
//           features,
//           buttonText,
//           isFree,
//           isDark,
//           buyPackageController,
//         );
//       },
//     );
//   }
//
//   // Widget _buildSubscriptionCard(
//   //     BuildContext context,
//   //     Package package,
//   //     String duration,
//   //     String durationUnit,
//   //     List<String> features,
//   //     String buttonText,
//   //     bool isFree,
//   //     bool isDark,
//   //     BuyPackageController buyPackageController,
//   //     ) {
//   //   return Container(
//   //     height: isFree ? 400 : 400,
//   //     width: double.infinity,
//   //     decoration: BoxDecoration(
//   //       color: Colors.transparent,
//   //       borderRadius: BorderRadius.circular(25),
//   //     ),
//   //     child: Stack(
//   //       children: [
//   //         ClipRRect(
//   //           borderRadius: BorderRadius.circular(25),
//   //           child: Image.asset(
//   //             'assets/images/back_sub.png',
//   //             width: double.infinity,
//   //             height: 400,
//   //             fit: BoxFit.cover,
//   //           ),
//   //         ),
//   //         Padding(
//   //           padding: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
//   //           child: Column(
//   //             children: [
//   //               Expanded(
//   //                 child: Row(
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   children: [
//   //                     Expanded(
//   //                       flex: 1,
//   //                       child: Column(
//   //                         crossAxisAlignment: CrossAxisAlignment.start,
//   //                         children: [
//   //                           Text(
//   //                             isFree ? 'free'.tr : package.price ?? '0',
//   //                             style: GoogleFonts.tajawal(
//   //                               fontSize: isFree ? 30 : 40,
//   //                               fontWeight: FontWeight.bold,
//   //                               color: AppColors.primary,
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                     const SizedBox(width: 20),
//   //                     Expanded(
//   //                       flex: 2,
//   //                       child: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//   //                         child: Column(
//   //                           crossAxisAlignment: CrossAxisAlignment.end,
//   //                           children: features
//   //                               .map(
//   //                                 (feature) => Padding(
//   //                               padding: const EdgeInsets.symmetric(vertical: 2.0),
//   //                               child: Row(
//   //                                 mainAxisAlignment: MainAxisAlignment.end,
//   //                                 children: [
//   //                                   Flexible(
//   //                                     child: Text(
//   //                                       feature,
//   //                                       style: GoogleFonts.tajawal(
//   //                                         fontSize: 14,
//   //                                         color: const Color(0xffAEAEAE),
//   //                                       ),
//   //                                       textAlign: TextAlign.end,
//   //                                       overflow: TextOverflow.ellipsis,
//   //                                       maxLines: 2,
//   //                                     ),
//   //                                   ),
//   //                                   const SizedBox(width: 8),
//   //                                   const Icon(
//   //                                     Icons.circle,
//   //                                     size: 8,
//   //                                     color: Color(0xffAEAEAE),
//   //                                   ),
//   //                                 ],
//   //                               ),
//   //                             ),
//   //                           )
//   //                               .toList(),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 20),
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                 children: [
//   //                   Obx(() => CustomButton(
//   //                     width: 150,
//   //                     text: buyPackageController.isLoading.value
//   //                         ? 'loading'.tr
//   //                         : buttonText,
//   //                     textSize: 14,
//   //                     textFontWeight: FontWeight.bold,
//   //                     onPressed: buyPackageController.isLoading.value
//   //                         ? null
//   //                         : () {
//   //                       _showConfirmationDialog(
//   //                         context,
//   //                         package,
//   //                         buyPackageController,
//   //                         isDark,
//   //                       );
//   //                     },
//   //                   )),
//   //                   Flexible(
//   //                     child: Text(
//   //                       isFree ? duration : '$duration $durationUnit',
//   //                       style: GoogleFonts.tajawal(
//   //                         fontSize: 24,
//   //                         fontWeight: FontWeight.bold,
//   //                         color: Color(0xff5D5C5C),
//   //                       ),
//   //                       textAlign: TextAlign.right,
//   //                       overflow: TextOverflow.ellipsis,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//
//   Widget _buildSubscriptionCard(
//       BuildContext context,
//       Package package,
//       String duration,
//       String durationUnit,
//       List<String> features,
//       String buttonText,
//       bool isFree,
//       bool isDark,
//       BuyPackageController buyPackageController,
//       ) {
//     return Container(
//       height: 400,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(25),
//             child: Image.asset(
//               'assets/images/back_sub.png',
//               width: double.infinity,
//               height: 400,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// Price Section
//                       Expanded(
//                         flex: 1,
//                         child: FittedBox(
//                           fit: BoxFit.scaleDown,
//                           child: Text(
//                             isFree ? 'free'.tr : (package.price ?? '0'),
//                             style: GoogleFonts.tajawal(
//                               fontSize: isFree ? 30 : 40,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(width: 20),
//
//                       /// Features Section
//                       Expanded(
//                         flex: 2,
//                         child: ListView.builder(
//                           itemCount: features.length,
//                           padding: EdgeInsets.zero,
//                           physics: const NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             final feature = features[index];
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 2.0),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Padding(
//                                     padding: EdgeInsets.only(top: 6.0),
//                                     child: Icon(
//                                       Icons.circle,
//                                       size: 8,
//                                       color: Color(0xffAEAEAE),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Expanded(
//                                     child: Text(
//                                       feature,
//                                       style: GoogleFonts.tajawal(
//                                         fontSize: 14,
//                                         color: const Color(0xffAEAEAE),
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 /// Button & Duration Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Obx(() => CustomButton(
//                       width: 150,
//                       text: buyPackageController.isLoading.value
//                           ? 'loading'.tr
//                           : buttonText,
//                       textSize: 14,
//                       textFontWeight: FontWeight.bold,
//                       onPressed: buyPackageController.isLoading.value
//                           ? null
//                           : () {
//                         _showConfirmationDialog(
//                           context,
//                           package,
//                           buyPackageController,
//                           isDark,
//                         );
//                       },
//                     )),
//                     const SizedBox(width: 10),
//                     Flexible(
//                       child: Text(
//                         isFree ? duration : '$duration $durationUnit',
//                         style: GoogleFonts.tajawal(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xff5D5C5C),
//                         ),
//                         textAlign: TextAlign.right,
//                         overflow: TextOverflow.ellipsis,
//                       ),
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
//   void _showConfirmationDialog(
//     BuildContext context,
//     Package package,
//     BuyPackageController buyPackageController,
//     bool isDark,
//   ) {
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: isDark ? Colors.grey[800] : Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text(
//           'confirm_purchase'.tr,
//           style: GoogleFonts.tajawal(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: isDark ? Colors.white : Colors.black,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'confirm_purchase_message'.trParams({
//                 'name': package.nameAr ?? 'Unnamed Package',
//                 'price':
//                     package.price == "0" ? 'free'.tr : package.price ?? '0',
//               }),
//               style: GoogleFonts.tajawal(
//                 fontSize: 16,
//                 color: isDark ? Colors.grey[300] : Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text(
//               'cancel'.tr,
//               style: GoogleFonts.tajawal(
//                 fontSize: 16,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//             ),
//             onPressed: () async {
//               Get.back(); // Close dialog
//               if (package.id != null) {
//                 final success =
//                     await buyPackageController.buyPackage(package.id!);
//                 SnackBarConstant.showSuccessSnackbar(
//                   success ? 'success'.tr : 'error'.tr,
//                   success
//                       ? buyPackageController.successMessage.value
//                       : buyPackageController.errorMessage.value,
//                 );
//                 if (success) {
//                   // Refresh profile data
//                   final ProfileController profileController =
//                   Get.put(ProfileController());
//                   await profileController.fetchProfile();
//                   // Route to SplashScreen
//                   Get.offAll(() => SuccessRegister());
//                 }
//               } else {
//                 SnackBarConstant.showErrorSnackbar(
//                   'error'.tr,
//                   'invalid_package_id'.tr,
//                 );
//               }
//             },
//             child: Text(
//               'confirm'.tr,
//               style: GoogleFonts.tajawal(
//                 fontSize: 16,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//       barrierDismissible: true,
//     );
//   }
// }
