import 'dart:async';
import 'package:dieaya_user/UI/pages/HomeScreen/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Utils/app_colors.dart';
import '../../Controllers/AuthController/login_controller.dart';
import '../../Controllers/AuthController/register_controller.dart';
import '../../Controllers/AuthController/verify_controller.dart';
import '../../Utils/app_text_field.dart';
import '../../controllers/AuthController/send_otp_controller.dart';
import '../../controllers/AuthController/update_pass_controller.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import 'buttons.dart';
import '../pages/dashboard/navbar.dart';

import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class CustomSheets {
  static const double kDefaultPadding = 16.0;
  static const double kInputHeight = 60.0;

  static double get kBottomSheetHeight =>
      MediaQuery.of(Get.context!).size.height * 0.85;
  final ThemeController themeController =
      Get.put(ThemeController()); // Access ThemeController
  static void showLoginSheet(BuildContext context) {
    // final theme = Theme.of(context);
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final loginController = Get.put(LoginController(), tag: 'login');
    final phoneError = ''.obs;
    final passwordError = ''.obs;
    final obscurePassword = true.obs;

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
        child: Obx(() => SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'login'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      // color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'phone_number'.tr,
                          hintText: '50xxxxxxx'.tr,
                          isDigits: true,
                          maxLength: 9,
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          errorText: phoneError.value.isNotEmpty
                              ? phoneError.value
                              : null,
                          onChanged: (value) => phoneError.value = '',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [CustomTextSolveIssue('')],
                            ),
                          ),
                          _buildCountryCodePicker(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'password'.tr,
                    hintText: '********',
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscurePassword.value,
                    errorText: passwordError.value.isNotEmpty
                        ? passwordError.value
                        : null,
                    onChanged: (value) => passwordError.value = '',
                    suffixIcon: obscurePassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixIconTap: () => obscurePassword.toggle(),
                  ),
                  const SizedBox(height: 10),
                  _buildLoginActions(context),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: loginController.isLoading.value
                        ? 'loginLoading'.tr
                        : 'loginButton'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: loginController.isLoading.value
                        ? null
                        : () => _handleLogin(
                              context,
                              loginController,
                              phoneController,
                              passwordController,
                              phoneError,
                              passwordError,
                            ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            )),
      ),
    );
  }

  static void showOTPLoginSheet(BuildContext context,
      {required String phoneNumber}) {
    final theme = Theme.of(context);
    final OtpVerifyController otpController =
        Get.put(OtpVerifyController(), tag: 'otp_login_verify');
    final sendOtpController = Get.put(SendOtpController(), tag: 'send_otp_verify_login');

    final codeController = TextEditingController();
    final otpError = ''.obs;
    final timerSeconds = 60.obs;
    Timer? timer;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        t.cancel();
      }
    });

    void disposeTimer() {
      timer?.cancel();
    }

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
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() => SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'confirmLogin'.tr,
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextSolveIssue(
                        'enterOTP'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          color: theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      _buildOTPResend(
                        context,
                        phoneNumber: phoneNumber,
                        timerSeconds: timerSeconds,
                        // theme: theme,
                        onResend: () {
                          timerSeconds.value = 60;
                          timer = Timer.periodic(const Duration(seconds: 1),
                              (Timer t) {
                            if (timerSeconds.value > 0) {
                              timerSeconds.value--;
                            } else {
                              t.cancel();
                            }
                          });
                        },
                        sendOtpController: sendOtpController
                      ),
                    ],
                  ),
                  // CustomTextSolveIssue(
                  //   phoneNumber,
                  //   style: GoogleFonts.tajawal(
                  //     fontSize: 14,
                  //     color: theme.textTheme.bodyMedium?.color,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 4,
                      controller: codeController,
                      autofillHints: const [AutofillHints.oneTimeCode],
                      keyboardType: TextInputType.number,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        textStyle: GoogleFonts.tajawal(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        textStyle: GoogleFonts.tajawal(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.colorScheme.primary),
                        ),
                      ),
                      onChanged: (value) => otpError.value = '',
                    ),
                  ),
                  if (otpError.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomTextSolveIssue(
                        otpError.value,
                        style: GoogleFonts.tajawal(
                          color: theme.colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextSolveIssue(
                          '${'otpMessage'.tr}\n$phoneNumber',
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: otpController.isLoading.value
                        ? 'acceptOTP'.tr
                        : 'count'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: otpController.isLoading.value
                        ? null
                        : () => _handleOTPLogin(
                              context,
                              otpController,
                              codeController,
                              phoneNumber,
                              otpError,
                            ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            )),
      ),
    ).then((value) {
      disposeTimer();
      Get.delete<OtpVerifyController>(tag: 'otp_login_verify');
      Get.delete<SendOtpController>(tag: 'send_otp_verify_login');
      print("ojijij");


    },);
  }

  static void showRegisterSheet(BuildContext context) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final registerController = Get.put(RegisterController(), tag: 'register');
    final usernameController = TextEditingController();
    final emailController =
        TextEditingController(text: ''); // Initialize with empty string

    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final nameError = ''.obs;
    final emailError = ''.obs;
    final phoneError = ''.obs;
    final passwordError = ''.obs;
    final confirmPasswordError = ''.obs;
    final obscurePassword = true.obs;
    final obscureConfirmPassword = true.obs;

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
        child: Obx(() => SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'register'.tr,
                    style: GoogleFonts.tajawal(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'username'.tr,
                    hintText: 'اسم',
                    controller: usernameController,
                    isRequired: true,
                    maxLength: 50,
                    errorText:
                        nameError.value.isNotEmpty ? nameError.value : null,
                    onChanged: (value) => nameError.value = '',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'phone_number'.tr,
                          hintText: '50xxxxxxx',
                          isDigits: true,
                          maxLength: 9,
                          isRequired: true,
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          errorText: phoneError.value.isNotEmpty
                              ? phoneError.value
                              : null,
                          onChanged: (value) => phoneError.value = '',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [CustomTextSolveIssue('')],
                            ),
                          ),
                          _buildCountryCodePicker(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: '${'email'.tr} (${'اختيارى'.tr})',
                    // Mark as optional
                    hintText: 'example@gmail.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    errorText:
                        emailError.value.isNotEmpty ? emailError.value : null,
                    onChanged: (value) => emailError.value = '',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'password'.tr,
                    hintText: '*********',
                    controller: passwordController,
                    isRequired: true,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscurePassword.value,
                    errorText: passwordError.value.isNotEmpty
                        ? passwordError.value
                        : null,
                    onChanged: (value) => passwordError.value = '',
                    suffixIcon: obscurePassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixIconTap: () => obscurePassword.toggle(),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'acceptPass'.tr,
                    hintText: '*******',
                    controller: confirmPasswordController,
                    isRequired: true,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscureConfirmPassword.value,
                    errorText: confirmPasswordError.value.isNotEmpty
                        ? confirmPasswordError.value
                        : null,
                    onChanged: (value) => confirmPasswordError.value = '',
                    suffixIcon: obscureConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixIconTap: () => obscureConfirmPassword.toggle(),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showLoginSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CustomTextSolveIssue(
                              'haveAcc'.tr,
                              style: GoogleFonts.tajawal(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            CustomTextSolveIssue(
                              'login'.tr,
                              style: GoogleFonts.tajawal(
                                  fontSize: 14, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: registerController.isLoading.value
                        ? 'createLoading'.tr
                        : 'create'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: registerController.isLoading.value
                        ? null
                        : () => _handleRegister(
                              context,
                              registerController,
                              usernameController,
                              emailController,
                              phoneController,
                              passwordController,
                              confirmPasswordController,
                              nameError,
                              emailError,
                              phoneError,
                              passwordError,
                              confirmPasswordError,
                            ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            )),
      ),
    );
  }

  static void showOTPSheet(BuildContext context,
      {required String phoneNumber}) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final otpController = Get.put(OtpVerifyController(), tag: 'otp_verify');

    final sendOtpController = Get.put(SendOtpController(), tag: 'send_otp_verify')..sendOtp(phoneNumber);

    final codeController = TextEditingController();
    final otpError = ''.obs;
    final timerSeconds = 60.obs;
    Timer? timer;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        t.cancel();
      }
    });

    void disposeTimer() {
      timer?.cancel();
    }

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() => SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'confirmHead'.tr,
                    style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Color(0xff5D5C5C)),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextSolveIssue(
                        'enterOTP'.tr,
                        style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.grey,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      _buildOTPResend(context,
                          phoneNumber: phoneNumber,
                          timerSeconds: timerSeconds, onResend: () {
                        timerSeconds.value = 60;
                        timer = Timer.periodic(const Duration(seconds: 1),
                            (Timer t) {
                          if (timerSeconds.value > 0) {
                            timerSeconds.value--;
                          } else {
                            t.cancel();
                          }
                        });
                      }
                      ,sendOtpController:sendOtpController ),
                    ],
                  ),
                  // CustomTextSolveIssue(
                  //   phoneNumber,
                  //   style: GoogleFonts.tajawal(fontSize: 14, color: AppColors.grey, fontWeight: FontWeight.w600),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 4,
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        textStyle: GoogleFonts.tajawal(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          color: const Color(0xff9C9C9C).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        textStyle: GoogleFonts.tajawal(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey
                              : AppColors.lightGreyBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary),
                        ),
                      ),
                      onChanged: (value) => otpError.value = '',
                    ),
                  ),
                  if (otpError.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomTextSolveIssue(
                        otpError.value,
                        style: GoogleFonts.tajawal(
                            color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      disposeTimer();
                      Navigator.pop(context);
                      showRegisterSheet(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextSolveIssue(
                          '${'otpMessage'.tr}\n $phoneNumber',
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: otpController.isLoading.value
                        ? 'acceptOTP'.tr
                        : 'count'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: otpController.isLoading.value|| otpController.isBlock.value
                        ? null
                        : () {
                          _handleOTP(context, otpController,
                            codeController, phoneNumber, otpError);
                        },
                    isBlock:  otpController.isBlock.value,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            )),
      ),
    ).then(
        (value) {
          disposeTimer();
          Get.delete<OtpVerifyController>(tag: 'otp_verify');
          Get.delete<SendOtpController>(tag: 'send_otp_verify');

          print("otpController.dispose");
        },
        );
  }

  static void showOTPSheetForgetPass(BuildContext context,
      {required String phoneNumber}) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final otpController =
        Get.put(VerifyOtpController(), tag: 'otp_verify_forget_pass');
    final sendOtpController = Get.put(SendOtpController(), tag: 'send_otp_verify_forget_pass');

    final codeController = TextEditingController();
    final otpError = ''.obs;
    final timerSeconds = 60.obs;
    Timer? timer;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        t.cancel();
      }
    });

    void disposeTimer() {
      timer?.cancel();
    }

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() => SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'confirmHead'.tr,
                    style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Color(0xff5D5C5C)),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextSolveIssue(
                        'enterOTP'.tr,
                        style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.grey,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      _buildOTPResend(context,
                          phoneNumber: phoneNumber,
                          timerSeconds: timerSeconds, onResend: () {
                        timerSeconds.value = 60;
                        timer = Timer.periodic(const Duration(seconds: 1),
                            (Timer t) {
                          if (timerSeconds.value > 0) {
                            timerSeconds.value--;
                          } else {
                            t.cancel();
                          }
                        });
                      },
                      sendOtpController: sendOtpController),
                    ],
                  ),
                  // CustomTextSolveIssue(
                  //   phoneNumber,
                  //   style: GoogleFonts.tajawal(fontSize: 14, color: AppColors.grey, fontWeight: FontWeight.w600),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 4,
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        textStyle: GoogleFonts.tajawal(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          color: const Color(0xff9C9C9C).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        textStyle: GoogleFonts.tajawal(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey
                              : AppColors.lightGreyBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary),
                        ),
                      ),
                      onChanged: (value) => otpError.value = '',
                    ),
                  ),
                  // if (otpError.value.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: CustomTextSolveIssue(
                  //       otpError.value,
                  //       style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                  //     ),
                  //   ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextSolveIssue(
                        '${'otpMessage'.tr}\n $phoneNumber',
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          color: isDark ? Colors.white : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: otpController.isLoading.value
                        ? 'acceptOTP'.tr
                        : 'count'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: otpController.isLoading.value
                        ? null
                        : () async {
                            if (codeController.text.isEmpty) {
                              otpError.value = 'otpRequired'.tr;
                              return;
                            }
                            await otpController.verifyOtp(
                                phoneNumber, codeController.text);
                            if (otpController.successMessage.isNotEmpty) {
                              disposeTimer();
                              Navigator.pop(context);
                              showResetPasswordSheet(context);
                            } else {
                              otpError.value = otpController.errorMessage.value;
                            }
                          },
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            )),
      ),
    ).then(
        (value) {
          disposeTimer();
          Get.delete<OtpVerifyController>(tag: 'otp_verify_forget_pass');
          Get.delete<SendOtpController>(tag: 'send_otp_verify_forget_pass');
        },
        );
  }

  static void showForgotPasswordSheet(BuildContext context) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final sendOtpController = Get.put(SendOtpController());
    final phoneController = TextEditingController();
    final phoneError = ''.obs;

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() => SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'forgotPass'.tr,
                    style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Color(0xff5D5C5C)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          isDigits: true,
                          maxLength: 9,
                          label: 'enterNumber'.tr,
                          hintText: '50xxxxxxx',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          errorText: phoneError.value.isNotEmpty
                              ? phoneError.value
                              : null,
                          onChanged: (value) => phoneError.value = '',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [CustomTextSolveIssue('')],
                            ),
                          ),
                          _buildCountryCodePicker(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextSolveIssue(
                        'willSend'.tr,
                        style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     CustomTextSolveIssue(
                  //       phoneController.text.isNotEmpty
                  //           ? '966${phoneController.text}'
                  //           : '966XXXXXXXX',
                  //       style: GoogleFonts.tajawal(
                  //           fontSize: 14,
                  //           color: isDark ? Colors.white : AppColors.grey,
                  //           fontWeight: FontWeight.w600),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ],
                  // ),
                  // if (sendOtpController.errorMessage.value.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: CustomTextSolveIssue(
                  //       sendOtpController.errorMessage.value,
                  //       style: GoogleFonts.tajawal(
                  //           color: Colors.red, fontSize: 12),
                  //     ),
                  //   ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: sendOtpController.isLoading.value
                        ? 'sendLoading'.tr
                        : 'count'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: sendOtpController.isLoading.value
                        ? null
                        : () async {
                            if (phoneController.text.isEmpty) {
                              phoneError.value = 'phoneRequire'.tr;
                              return;
                            }
                            final success = await sendOtpController
                                .sendOtp('966${phoneController.text}');
                            if (success) {
                              Navigator.pop(context);
                              showOTPSheetForgetPass(context,
                                  phoneNumber: '966${phoneController.text}');
                            } else {
                              phoneError.value =
                                  sendOtpController.errorMessage.value;
                            }
                          },
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            )),
      ),
    );
  }

  static void showResetPasswordSheet(BuildContext context) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final updatePasswordController = Get.put(UpdatePasswordController());
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final newPasswordError = ''.obs;
    final confirmPasswordError = ''.obs;
    final obscureNewPassword = true.obs;
    final obscureConfirmPassword = true.obs;

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() => SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'addPass'.tr,
                    style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Color(0xff5D5C5C)),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'enterNewPass'.tr,
                    hintText: '**********',
                    controller: newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscureNewPassword.value,
                    errorText: newPasswordError.value.isNotEmpty
                        ? newPasswordError.value
                        : null,
                    onChanged: (value) => newPasswordError.value = '',
                    suffixIcon: obscureNewPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixIconTap: () => obscureNewPassword.toggle(),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'acceptPass'.tr,
                    hintText: '********',
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscureConfirmPassword.value,
                    errorText: confirmPasswordError.value.isNotEmpty
                        ? confirmPasswordError.value
                        : null,
                    onChanged: (value) => confirmPasswordError.value = '',
                    suffixIcon: obscureConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixIconTap: () => obscureConfirmPassword.toggle(),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: updatePasswordController.isLoading.value
                        ? 'addEditLoading'.tr
                        : 'addEdit'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: updatePasswordController.isLoading.value
                        ? null
                        : () async {
                            newPasswordError.value = '';
                            confirmPasswordError.value = '';

                            if (newPasswordController.text.isEmpty) {
                              newPasswordError.value = 'newPassRequire'.tr;
                              return;
                            }
                            if (confirmPasswordController.text.isEmpty) {
                              confirmPasswordError.value =
                                  'newPassRequireAcc'.tr;
                              return;
                            }
                            if (newPasswordController.text !=
                                confirmPasswordController.text) {
                              confirmPasswordError.value = 'passNotMatch'.tr;
                              return;
                            }
                            final success = await updatePasswordController
                                .updatePassword(newPasswordController.text);
                            if (success) {
                              Navigator.pop(context);
                              // Get.snackbar('نجاح', 'تم تعيين كلمة المرور بنجاح');
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(30),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/check 1.png',
                                            height: 100,
                                          ),
                                          const SizedBox(height: 20),
                                          CustomTextSolveIssue(
                                            'passChanged'.tr,
                                            style: GoogleFonts.tajawal(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),
                                          CustomButton(
                                            text: 'login'.tr,
                                            textSize: 22,
                                            textFontWeight: FontWeight.bold,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showLoginSheet(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              newPasswordError.value =
                                  updatePasswordController.errorMessage.value;
                            }
                          },
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? 20
                          : 0),
                ],
              ),
            )),
      ),
    );
  }

  static Widget _buildSheetHeader(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.grey),
          ),
        ],
      );

  static Widget _buildCountryCodePicker() {
    final selectedCountryCode = '+966'.obs;
    final countryData = {
      '+966': {'flag': 'assets/images/Saudi Arabia.png', 'name': ''},
    };

    return Container(
      height: kInputHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xff9C9C9C).withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCountryCode.value,
              icon: const SizedBox.shrink(),
              items: countryData.entries.map((entry) {
                final code = entry.key;
                final flag = entry.value['flag']!;
                final name = entry.value['name']!;
                return DropdownMenuItem<String>(
                  value: code,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextSolveIssue(
                        code,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        flag,
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.flag_circle,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomTextSolveIssue(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  selectedCountryCode.value = newValue;
                }
              },
              selectedItemBuilder: (context) =>
                  countryData.entries.map((entry) {
                final code = entry.key;
                final flag = entry.value['flag']!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextSolveIssue(
                          code,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          flag,
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.flag_circle,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black54,
                    ),
                  ],
                );
              }).toList(),
            ),
          )),
    );
  }

  static Widget _buildLoginActions(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showForgotPasswordSheet(context);
                  },
                  child: CustomTextSolveIssue(
                    'forgotPass'.tr,
                    style: GoogleFonts.tajawal(
                        fontSize: 14, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showRegisterSheet(context);
                  },
                  child: Row(
                    children: [
                      CustomTextSolveIssue(
                        'makeAcc'.tr,
                        style: GoogleFonts.tajawal(
                            fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      CustomTextSolveIssue(
                        'makeAccNew'.tr,
                        style: GoogleFonts.tajawal(
                            fontSize: 14, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  static Widget _buildOTPResend(
    BuildContext context, {
    required String phoneNumber,
    required RxInt timerSeconds,
    required SendOtpController sendOtpController,
    required VoidCallback onResend,
  }) {
    return Obx(() =>
    sendOtpController.isLoading.value
        ? Shimmer.fromColors(
            key: const ValueKey('resend-shimmer'),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 85,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        : sendOtpController.errorMessage.isEmpty?
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (timerSeconds.value > 0 ||
              sendOtpController.isLoading.value)
              ? null
              : () async {
            final success =
            await sendOtpController.sendOtp(phoneNumber);
            if (success) {
              // Get.snackbar('نجاح', sendOtpController.successMessage.value);
              onResend();
            } else {
              Get.find<OtpVerifyController>(tag: 'otp_verify')
                  .errorMessage
                  .value = sendOtpController.errorMessage.value;
            }
          },
          child: CustomTextSolveIssue(
            sendOtpController.isLoading.value
                ? 'resendOtpLoading'.tr
                : 'resendOtp'.tr,
            style: GoogleFonts.tajawal(
              fontSize: 14,
              color: (timerSeconds.value > 0 ||
                  sendOtpController.isLoading.value)
                  ? Colors.grey
                  : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 5),
        CustomTextSolveIssue(
          '(0:${timerSeconds.value.toString().padLeft(2, '0')})',
          style: GoogleFonts.tajawal(
            fontSize: 14,
            color: (timerSeconds.value > 0 ||
                sendOtpController.isLoading.value)
                ? Colors.grey
                : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ):
    CustomTextSolveIssue(
      '${sendOtpController.errorMessage.value}',
      style: GoogleFonts.tajawal(
        fontSize: 14,
        color: AppColors.red,
        fontWeight: FontWeight.w600,
      ),
    ),
    );

  }

  static void _showSuccessDialog(
    BuildContext context, {
    required String title,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: theme.dialogBackgroundColor,
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
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextSolveIssue(
                  title,
                  style: GoogleFonts.tajawal(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: buttonText,
                  textSize: 22,
                  textFontWeight: FontWeight.bold,
                  onPressed: onButtonPressed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _handleLogin(
    BuildContext context,
    LoginController controller,
    TextEditingController phone,
    TextEditingController password,
    RxString phoneError,
    RxString passwordError,
  ) async {
    final theme = Theme.of(context);
    phoneError.value = '';
    passwordError.value = '';

    if (phone.text.isEmpty) {
      phoneError.value = 'phoneRequire'.tr;
      return;
    }
    if (!RegExp(r'^\d{9}$').hasMatch(phone.text)) {
      phoneError.value = 'phoneNumbersValidation'.tr;
      return;
    }
    if (password.text.isEmpty) {
      passwordError.value = 'passRequire'.tr;
      return;
    }

    final success = await controller.login('966${phone.text}', password.text);
    if (success) {
      Navigator.pop(context);
      if (kIsWeb) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Navbar()),
        );
      }
    } else if (controller.requiresVerification.value) {
      Navigator.pop(context);
      showOTPLoginSheet(context, phoneNumber: '966${phone.text}');
    } else {
      if (controller.errorMessage.value.contains('phone') ||
          controller.errorMessage.value
              .contains('The selected phone is invalid')) {
        phoneError.value = 'phoneValid'.tr;
      } else if (controller.errorMessage.value.contains('password') ||
          controller.errorMessage.value.contains('Password') ||
          controller.errorMessage.value.contains('كلمة المرور') ||
          controller.errorMessage.value.contains('Invalid credentials')) {
        passwordError.value =
            controller.errorMessage.value.contains('كلمة المرور')
                ? controller.errorMessage.value
                : 'phonePassError'.tr;
      } else {
        Get.snackbar(
          'خطأ',
          controller.errorMessage.value,
          backgroundColor: theme.colorScheme.error,
          colorText: theme.colorScheme.onError,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  static void _handleOTPLogin(
    BuildContext context,
    OtpVerifyController controller,
    TextEditingController otp,
    String phoneNumber,
    RxString otpError,
  ) async {
    final theme = Theme.of(context);
    otpError.value = '';

    if (otp.text.isEmpty) {
      otpError.value = 'otpRequire'.tr;
      return;
    }

    await controller.verifyOtp(phone: phoneNumber, otp: otp.text);
    if (controller.successMessage.isNotEmpty) {
      Navigator.pop(context);
      _showSuccessDialog(
        context,
        title: 'success'.tr,
        buttonText: 'shopNow'.tr,
        onButtonPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Navbar()),
          );
        },
      );
    } else {
      otpError.value = controller.errorMessage.value;
      // Get.snackbar(
      //   'خطأ',
      //   controller.errorMessage.value,
      //   backgroundColor: theme.colorScheme.error,
      //   colorText: theme.colorScheme.onError,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  static void _handleRegister(
    BuildContext context,
    RegisterController controller,
    TextEditingController username,
    TextEditingController email,
    TextEditingController phone,
    TextEditingController password,
    TextEditingController confirmPassword,
    RxString nameError,
    RxString emailError,
    RxString phoneError,
    RxString passwordError,
    RxString confirmPasswordError,
  ) async {
    nameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    // Client-side validation
    if (username.text.isEmpty) {
      nameError.value = 'nameRequire'.tr;
      return;
    }
    // if (email.text.isEmpty) {
    //   emailError.value = 'emailRequire'.tr;
    //   return;
    // }
    // Only validate email format if email is provided
    if (email.text.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(email.text.trim())) {
      emailError.value = 'emailValidation'.tr;
      return;
    }
    if (phone.text.isEmpty) {
      phoneError.value = 'phoneRequire'.tr;
      return;
    }
    if (!RegExp(r'^\d{9}$').hasMatch(phone.text)) {
      phoneError.value = 'phoneNumbersValidation'.tr;
      return;
    }
    if (password.text.isEmpty) {
      passwordError.value = 'passRequire'.tr;
      return;
    }
    if (confirmPassword.text.isEmpty) {
      confirmPasswordError.value = 'newPassRequireAcc'.tr;
      return;
    }
    if (password.text != confirmPassword.text) {
      confirmPasswordError.value = 'passNotMatch'.tr;
      return;
    }

    // Call register API
    await controller.register(
      name: username.text.trim(),
      email: email.text.isEmpty ? '' : email.text.trim(),
      phone: '966${phone.text}',
      password: password.text,
      passwordConfirmation: confirmPassword.text,
    );

    if (controller.successMessage.isNotEmpty ||
        controller.requiresVerification.value) {
      // Success or unverified account: Navigate to OTP sheet
      Navigator.pop(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showOTPSheet(context, phoneNumber: '966${phone.text}');
      });
    } else {
      // Parse API errors
      final errors = controller.errorMessage.value.split('; ');
      for (var error in errors) {
        if (error.toLowerCase().startsWith('phone:')) {
          phoneError.value = error.replaceFirst('phone: ', '').trim();
        } else if (error.toLowerCase().startsWith('email:')) {
          emailError.value = error.replaceFirst('email: ', '').trim();
        } else if (error.toLowerCase().startsWith('name:')) {
          nameError.value = error.replaceFirst('name: ', '').trim();
        } else if (error.toLowerCase().startsWith('password:')) {
          passwordError.value = error.replaceFirst('password: ', '').trim();
        } else {
          // Fallback: Show generic error in name field
          nameError.value = error;
        }
      }
      // If no field-specific errors, show generic message
      if (errors.isEmpty && controller.errorMessage.value.isNotEmpty) {
        nameError.value = controller.errorMessage.value;
      }
    }
  }

  static void _handleOTP(
    BuildContext context,
    OtpVerifyController controller,
    TextEditingController otp,
    String phoneNumber,
    RxString otpError,
  ) async {
    otpError.value = '';

    if (otp.text.isEmpty) {
      otpError.value = 'otpRequired'.tr;
      return;
    }

    await controller.verifyOtp(phone: phoneNumber, otp: otp.text);
    if (controller.successMessage.isNotEmpty) {
      // Get.snackbar('نجاح', controller.successMessage.value);
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/check 1.png',
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'registerSuccess'.tr,
                    style: GoogleFonts.tajawal(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'shopNow'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Navbar()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      otpError.value = controller.errorMessage.value;
    }
  }
}
