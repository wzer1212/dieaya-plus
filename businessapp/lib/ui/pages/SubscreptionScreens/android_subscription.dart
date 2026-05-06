import 'dart:async';
import 'dart:developer';

import 'package:dieaya_market/ui/pages/SubscreptionScreens/components/subscription_details.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/components/subscription_line_widget.dart';
import 'package:dieaya_market/ui/widgets/buttons.dart';
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

class AndroidSubscriptionsScreen extends StatefulWidget {
  const AndroidSubscriptionsScreen({super.key});

  @override
  _AndroidSubscriptionsScreenState createState() =>
      _AndroidSubscriptionsScreenState();
}

class _AndroidSubscriptionsScreenState
    extends State<AndroidSubscriptionsScreen> {
  final String _apiKey =
      'EEiYv_IMa8SCWhPMNhREjGEEHS3plguugab_KuhpXZbdPrrCXe0OdUfPHqsYtMRHAbRcpOoezsqjVibd7Y7Fo7P4auUbzV1filhrjb0yg4gfonB8s9d7eTbYXtR8AmJ1ap5kSGO3XISfeZCK1L3JCXMIQ_Z7VffN8DyfxkpqFQGyhw8aS9c_2fBpyiH7DP2FgxvTXXC4jZAgRn3oiaZsuCvNR1EIhtx0sOZ9Bb48aG-NzUNTTt-bBbzg0gLA6DAwdZJpT8mWosbJv439ttASc3APDUu8264E9JiwEjjmjwHKNQh0SvLB2kIxZAxP1EtuRzyAYmKRha2h7nwWsYGIOYxSPaZSpd_CViYkGpdXO_YVdOkNOngsnp6gAkVyM1L04blyMmss9xZHSjRwBEr3IEsgTrBQJA-Ytes08oPm3ngRXrFabmllnQK7KcybcR4ZDJtb36Vy5tBicbiFRk27QwK10YDDjdJOJn5FJn1rt2UkZJrvciRRejPwnAI_irfapJffy4LOlkT1b56qyFxK4RDYB2WM12qBrA5kXzQBFSRdVQC3rNwxfK-qcRn6tmiSKs0Pdllo8Qfm27vvmM7KeTHURLZG6kcJGauzZEnwbZYmXY1036h782gkmDmk79Fk0tQqZ_FUgvyiEUQbRH6_jmIiKXNWz3AUGpSHlqatxUv7HvjbGuRh9UBIY8fPBR7uNUFd7AOzN8uw47UBq2Ggk51TkLs';


  final ProfileController profileController =
  Get.find<ProfileController>();
  late MFApplePayButton mfApplePayButton;
  bool _isApplePayLoading = false;
  bool _isProcessing = false;
  final PackageController packageController = Get.find<PackageController>();

  @override
  void initState() {
    packageController.fetchPackages();

    super.initState();
    // Step 1: Initialize SDK (usually once)
    MFSDK.init(_apiKey, MFCountry.SAUDIARABIA, MFEnvironment.LIVE);

    MFSDK.setUpActionBar(
      toolBarTitle: 'pay_dieaya'.tr,
      toolBarTitleColor: '#FFFFFF', // White
      toolBarBackgroundColor: '#00B4FF', // Color(0xFF00B4FF)
      isShowToolBar: true,
    );
    if (Platform.isIOS) {
      try {
        mfApplePayButton = MFApplePayButton(
          applePayStyle: MFApplePayStyle(),
        );
      } catch (e) {
        debugPrint('Apple Pay button init failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final BuyPackageController buyPackageController =
        Get.find<BuyPackageController>();
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
                  alignment: Alignment.topCenter,
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

                    //back button
                    Positioned(
                      top: 50,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_rounded,
                                  color: Colors.white),
                              onPressed: _isProcessing ? null : () => Get.back(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      //subscription details
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
        if (_isProcessing)
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
                    return  '${"allow".tr}$quantity $name';
                  }).toList() ??
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
      // margin: const EdgeInsets.symmetric(vertical: 10),
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
                const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        package.price ?? '0',
                                        style: GoogleFonts.tajawal(
                                          fontSize: isFree ? 30 : 40,
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
                            SizedBox(height: 30,)
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'package_allows_you'.tr,
                                        style: GoogleFonts.tajawal(
                                          fontSize: 16.sp,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 10.w,
                                            color: Color(0xff5D5C5C),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              feature,
                                              style: GoogleFonts.tajawal(
                                                fontSize: 16.sp,
                                                color: const Color(0xffAEAEAE),
                                              ),
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
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
                                  _isApplePayLoading
                              ? 'loading'.tr
                              : buttonText,
                          textSize: 14,
                          textFontWeight: FontWeight.bold,
                          onPressed: _isProcessing ||
                                  buyPackageController.isLoading.value ||
                                  _isApplePayLoading
                              ? null
                              : () async {
                            if (profileController
                                .profile.value?.verified ==
                                1)  {
                                    if (isFree) {
                                      _handleFreePackage(context, package,
                                          buyPackageController);
                                    } else {
                                      _showPaymentSelectionDialog(
                                        context,
                                        package,
                                        buyPackageController,
                                        isDark,
                                      );
                                    }
                                  }
                            else{
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
                        isFree ?  '$duration $durationUnit' : '$duration $durationUnit',
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

    setState(() => _isProcessing = true);
    try {
      final env = Platform.isAndroid ? 'android' : 'ios';

      final success =
          await buyPackageController.buyPackage(package.id!, env: env);
      setState(() => _isProcessing = false);
      SnackBarConstant.showEnhancedSnackbar(
        context,
        success ? 'success'.tr : 'error'.tr,
        success
            ? buyPackageController.successMessage.value
            : buyPackageController.errorMessage.value,
        success: success,
      );
      if (success) {
        final ProfileController profileController =
            Get.put(ProfileController());
        await profileController.fetchProfile();
        Get.offAll(() => SuccessRegister());
      }
    } catch (error) {
      setState(() => _isProcessing = false);
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
  Future<void> _handlePaidPackage(
    BuildContext context,
    Package package,
    BuyPackageController buyPackageController, {
    required bool isApplePay,
  }) async {
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
    setState(() {
      _isProcessing = true;
      if (isApplePay) {
        _isApplePayLoading = true;
      } else {
        buyPackageController.isLoading.value = true;
      }
    });

    try {
      if (isApplePay) {
        // Initiate Payment
      } else {
        // ============ CARD / OTHER METHODS FLOW ============
        // 1) Initiate available methods
        final initRes = await MFSDK.initiatePayment(
          MFInitiatePaymentRequest(
            invoiceAmount: invoiceAmount,
            currencyIso: MFCurrencyISO
                .SAUDIARABIA_SAR, // <--- SAR: MFCurrencyISO.SAUDI_ARABIA_SAR
          ),
          MFLanguage.ENGLISH,
        );
        final methods = initRes.paymentMethods ?? <MFPaymentMethod>[];
        if (methods.isEmpty)
          throw MFError(message: 'no_payment_methods_available'.tr);

        debugPrint(
            'Methods: ${methods.map((m) => m.paymentMethodEn).toList()}');

        // 2) Pick a method (example: visa/master; falls back to first)
        final picked = methods.firstWhere(
          (m) => m.paymentMethodCode == 'vm',
          orElse: () => methods.first,
        );

        // 3) Execute payment
        final execReq = MFExecutePaymentRequest(
          invoiceValue: invoiceAmount,
          paymentMethodId: picked.paymentMethodId!,
        );

        await MFSDK
            .executePayment(
          execReq,
          MFLanguage.ENGLISH,
          (invoiceId) async {},
        )
            .then(
          (value) async {
            var invoiceId = value.invoiceId;
            debugPrint('✅ Card payment invoice: $invoiceId');
            await _processInvoice(
              context: context,
              invoiceId: invoiceId.toString(),
              packageId: package.id!,
              buyPackageController: buyPackageController,
            );
            print('========================');
            print('====     then      =====');
            print('====    $value     =====');
            print('========================');
          },
        ).catchError((error) {
          print('========================');
          print('====        error          =====');
          print('====    ${(error as MFError).message}     =====');
          print('========================');
        });
      }
    } on MFError catch (e) {
      debugPrint('❌ MFError [${e.code}] ${e.message}');
      _showErrorSnack(
        context,
        _mapFriendlyError(e) ?? 'payment_failed'.tr,
      );
    } catch (e, st) {
      debugPrint('❌ Exception: $e\n$st');
      _showErrorSnack(
        context,
        'payment_failed'.trParams({'error': e.toString()}),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _isApplePayLoading = false;
          buyPackageController.isLoading.value = false;
        });
      }
    }
  }

  /// Calls your backend / controller with the invoice and shows UI feedback.
  Future<void> _processInvoice({
    required BuildContext context,
    required String invoiceId,
    required int packageId,
    required BuyPackageController buyPackageController,
  }) async {
    try {
      final env = Platform.isAndroid ? 'android' : 'ios';
      final ok = await buyPackageController.buyPackage(
        packageId,
        invoiceId: invoiceId.toString(),
        env: env,
      );

      // Clear overlay spinner immediately
      if (mounted) setState(() => _isProcessing = false);

      SnackBarConstant.showEnhancedSnackbar(
        context,
        ok ? 'success'.tr : 'error'.tr,
        ok
            ? buyPackageController.successMessage.value
            : buyPackageController.errorMessage.value,
        success: ok,
      );

      if (ok) {
        print('===============================>> is ok');
        final profileController = Get.put(ProfileController());
        await profileController.fetchProfile();
        Get.offAll(() => SuccessRegister());
      }
    } catch (e) {
      if (mounted) setState(() => _isProcessing = false);
      debugPrint('Post-invoice error: $e');
      _showErrorSnack(context, e.toString());
    }
  }

  /// Maps common MF errors to friendly messages; returns null if no special case.
  String? _mapFriendlyError(MFError e) {
    final msg = (e.message ?? '').toLowerCase();

    if (msg.contains('invalid card number')) {
      return 'invalid_card_number'.trParams({'hint': 'use_test_card'.tr});
    }
    if (msg.contains('401') || e.code == 401) {
      return 'authentication_failed_check_token'.tr;
    }
    if (msg.contains('session')) {
      return 'apple_pay_session_failed'.tr;
    }
    if (msg.contains('displaycurrencyiso')) {
      return 'You should set displayCurrencyIso'; // MF code 113 earlier
    }
    return null;
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

// ========================================================
  void _showPaymentSelectionDialog(BuildContext context, Package package,
      BuyPackageController buyPackageController, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'select_payment_method'.tr,
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                foregroundColor: isDark ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.credit_card),
              label: Text(
                'pay_with_card'.tr,
                style: GoogleFonts.tajawal(fontSize: 16),
              ),
              onPressed: _isProcessing
                  ? null
                  : () {
                      Get.back();
                      _showConfirmationDialog(
                        context,
                        package,
                        buyPackageController,
                        isDark,
                        isApplePay: false,
                      );
                    },
            ),

          ],
        ),
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: !_isProcessing,
    );
  }

  void _showConfirmationDialog(BuildContext context, Package package,
      BuyPackageController buyPackageController, bool isDark,
      {required bool isApplePay}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'confirm_purchase'.tr,
          style: GoogleFonts.tajawal(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'confirm_purchase_message'.trParams({
                'name': package.nameAr ?? 'Unnamed Package',
                'price':
                    package.price == "0" ? 'free'.tr : package.price ?? '0',
              }),
              style: GoogleFonts.tajawal(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _isProcessing
                ? null
                : () async {
                    Get.back();
                    await _handlePaidPackage(
                      context,
                      package,
                      buyPackageController,
                      isApplePay: isApplePay,
                    );
                  },
            child: Text(
              'confirm'.tr,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: !_isProcessing,
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


