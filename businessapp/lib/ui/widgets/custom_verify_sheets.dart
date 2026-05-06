import 'dart:async';
import 'dart:io';
import 'package:dieaya_market/ui/pages/HomePage/home_screen.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/ios_subscriptions_screen.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../Utils/app_colors.dart';
import '../../Routes/app_routes.dart';
import '../../Utils/app_text_field.dart';
import '../../controllers/LoginController/send_otp_controller.dart';
import '../../controllers/LoginController/update_pass_controller.dart';
import '../../controllers/LoginController/verify_controller.dart';
import '../../controllers/ProfileController/profile_controller.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import '../../utils/caching_sevice/app_sharedprefs_contants.dart';
import '../pages/SubscreptionScreens/android_subscription.dart';
import 'buttons.dart';
import 'navbar.dart';

class CustomSheetsVerify {
  static const double kDefaultPadding = 16.0;
  static const double kInputHeight = 60.0;

  static double get kBottomSheetHeight =>
      MediaQuery.of(Get.context!).size.height * 0.85;
  final ThemeController themeController =
      Get.put(ThemeController()); // Access ThemeController

  static void showOTPSheetForgetPass(BuildContext context,
      {required String phoneNumber}) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final otpController =
        Get.put(VerifyOtpController(), tag: 'otp_verify_forget_pass');
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
                  Text(
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
                      Text(
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
                      }),
                    ],
                  ),
                  // Text(
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
                      child: Text(
                        otpError.value,
                        style: GoogleFonts.tajawal(
                            color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          '${'otpMessage'.tr}\n $phoneNumber',
                          maxLines: 3,
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.grey,
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
    ).whenComplete(disposeTimer);
  }

  static void showOTPSheetVerify(BuildContext context,
      {required String phoneNumber}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VerifyPhoneWidget(
        phoneNumber: phoneNumber,
        onOTPCanceled: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  static void showForgotPasswordSheet(BuildContext context) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final sendOtpController = Get.put(SendOtpController());
    final phoneController = TextEditingController();
    final phoneError = ''.obs;
    final phoneText = ''.obs;

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
                  Text(
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
                          label: 'enterNumber'.tr,
                          hintText: '1951464161',
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
                              children: [Text('')],
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
                      Text(
                        'willSend'.tr,
                        style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        phoneController.text.isNotEmpty
                            ? '966${phoneController.text}'
                            : '966XXXXXXXX',
                        style: GoogleFonts.tajawal(
                            fontSize: 14,
                            color: isDark ? Colors.white : AppColors.grey,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  // if (sendOtpController.errorMessage.value.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Text(
                  //       sendOtpController.errorMessage.value,
                  //       style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
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
                  Text(
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
                                          Text(
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
    final selectedCountryCode = '966'.obs;
    final countryData = {
      '966': {'flag': 'assets/images/Saudi Arabia.png', 'name': ''},
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
                      Text(
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
                      Text(
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
                        Text(
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

  static Widget _buildOTPResend(
    BuildContext context, {
    required String phoneNumber,
    required RxInt timerSeconds,
    required VoidCallback onResend,
  }) {
    final sendOtpController = Get.put(SendOtpController());
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap:
                  (timerSeconds.value > 0 || sendOtpController.isLoading.value)
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
              child: Text(
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
            Text(
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
        ));
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
                Text(
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
}

class VerifyPhoneWidget extends StatefulWidget {
  VerifyPhoneWidget(
      {super.key,
      required this.phoneNumber,
      this.onOTPCanceled,
      this.isFromRegister = false});

  final String phoneNumber;
  final bool? isFromRegister;
  final Function()? onOTPCanceled;

  @override
  State<VerifyPhoneWidget> createState() => _VerifyPhoneWidgetState();
}

class _VerifyPhoneWidgetState extends State<VerifyPhoneWidget> {
  final ThemeController themeController = Get.put(ThemeController());

  // Ensure you are using the correct tag for the controller if you have multiple instances
  final otpController =
      Get.put(VerifyOtpController(), tag: 'otp_verify_account');
  final sendOtpController = Get.put(SendOtpController());

  // Changed tag for clarity
  final ProfileController profileController = Get.put(ProfileController());
  final OtpVerifyController otpVerifyController =
      Get.put(OtpVerifyController());

  // Get the ProfileController instance
  final codeController = TextEditingController();

  final otpError = ''.obs;

  final timerSeconds = 60.obs;

  Timer? timer;
  var attemptsCount = 5.obs;

  @override
  void initState() {
    sendOtpController.sendOtp(widget.phoneNumber).then(
      (value) {
        print("the sendOtp(widget.phoneNumber) fun res is ===>$value");
      },
    );
    print("=================================");
    print("==                             ==");
    print("==                             ==");
    print("==    ${widget.phoneNumber}    ==");
    print("==                             ==");
    print("=================================");
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        t.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  static Widget _buildOTPResend(
    BuildContext context, {
    required String phoneNumber,
    required RxInt timerSeconds,
    required VoidCallback onResend,
  }) {
    final sendOtpController = Get.put(SendOtpController());
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap:
                  (timerSeconds.value > 0 || sendOtpController.isLoading.value)
                      ? null
                      : () async {
                          print("+===============+");
                          final success =
                              await sendOtpController.sendOtp(phoneNumber);
                          if (success) {
                            // Get.snackbar('نجاح', sendOtpController.successMessage.value);
                            onResend();
                          } else {
                            print(sendOtpController.errorMessage.value);
                            Get.put(OtpVerifyController(), tag: 'otp_verify')
                                .errorMessage
                                .value = sendOtpController.errorMessage.value;
                          }
                        },
              child: Text(
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
            Text(
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
        ));
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
                Text(
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

  static double get kBottomSheetHeight =>
      MediaQuery.of(Get.context!).size.height * 0.85;
  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    const double kDefaultPadding = 16.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: kBottomSheetHeight,
        padding: EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() =>
            sendOtpController.isLoading.value?
                Center(child: CircularProgressIndicator(),):
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // _buildSheetHeader(context),
                  SizedBox(
                    height: 70.h,
                  ),
                  Container(
                    width: 500.w,
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 80.h,
                        ),
                        GestureDetector(
                          onTap: widget.onOTPCanceled ??
                              () async {
                                if (widget.isFromRegister!) {
                                  Get.offAllNamed(AppRoutes.navbar);
                                } else {
                                  await SharedPrefsConstants.removeToken();
                                  Get.offAllNamed(AppRoutes.auth);
                                }
                              },
                          child: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  Text(
                    'confirmHead'.tr,
                    style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xff5D5C5C)),
                  ),
                  const SizedBox(height: 15),
                 if(sendOtpController.errorMessage.value.isEmpty) Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'enterOTP'.tr,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.tajawal(
                              fontSize: 16,
                              color: isDark ? Colors.white : AppColors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _buildOTPResend(context,
                          phoneNumber: widget.phoneNumber,
                          timerSeconds: timerSeconds, onResend: () {
                        print("+===============+");
                        timerSeconds.value = 60;
                        timer = Timer.periodic(const Duration(seconds: 1),
                            (Timer t) {
                          if (timerSeconds.value > 0) {
                            timerSeconds.value--;
                          } else {
                            t.cancel();
                          }
                        });
                      }),
                    ],
                  )
                  else
                    Text(sendOtpController.errorMessage.value,style: TextStyle(color: AppColors.red),),
                  SizedBox(
                    height: 10,
                  ),
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
                      child: Text(
                        otpError.value,
                        style: GoogleFonts.tajawal(
                            color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          '${'otpMessage'.tr}\n ${widget.phoneNumber}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.grey,
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
                    onPressed: otpController.isLoading.value || sendOtpController.errorMessage.value.isNotEmpty
                        ? null
                        : () async {
                            if (codeController.text.isEmpty) {
                              otpError.value = 'otpRequired'.tr;
                              return;
                            }

                            await otpController.verifyOtp(
                                widget.phoneNumber, codeController.text);
                            if (attemptsCount > 0) {
                              attemptsCount--;
                            }
                            if (otpController.successMessage.isNotEmpty) {
                              // Refresh the profile data to reflect the verified status
                              // This call will be safe because it doesn't use the 'context' of the popped sheet.
                              await profileController.fetchProfile();

                              // Display the success dialog using Get.context!
                              _showSuccessDialog(
                                Get.context!, // <--- FIX: Use Get.context! here
                                title: 'activation_complete'.tr,
                                buttonText: 'browse_your_store'.tr,
                                onButtonPressed: () {
                                  // The button in the success dialog will also use Get.context!
                                  // to pop itself, ensuring it doesn't depend on the old context.
                                  Get.back(); // Dismiss the success dialog
                                  Get.offAllNamed(
                                      AppRoutes.navbar); // Navigate to home
                                },
                              );
                            } else {
                              otpError.value = otpController.errorMessage.value;
                            }
                          },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
