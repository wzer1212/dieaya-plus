import 'package:dieaya_market/Routes/app_routes.dart';
import 'package:dieaya_market/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dieaya_market/utils/app_colors.dart';

import '../../../controllers/LoginController/login_controller.dart';
import '../../../controllers/ProfileController/profile_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../utils/app_text_field.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_verify_sheets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Move state variables outside build method to prevent recreation on rebuild
  final phoneError = ''.obs;
  final passwordError = ''.obs;
  final obscurePassword = true.obs;
  final selectedCountryCode = '966'.obs;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final loginController = Get.put(LoginController(), tag: 'login');

    final isDark = themeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      // body: SingleChildScrollView(
      //   physics: ClampingScrollPhysics(),
      //   child: Stack(
      //     children: [
      //       Stack(
      //         children: [
      //           Image.asset('assets/images/tester.png'),
      //           Padding(
      //             padding: EdgeInsets.only(top: 195.h),
      //             child: Align(
      //               alignment: Alignment.topCenter,
      //               child: Text(
      //                 'login'.tr,
      //                 textAlign: TextAlign.center,
      //                 style: GoogleFonts.tajawal(
      //                   fontSize: 26,
      //                   fontWeight: FontWeight.bold,
      //                   color: isDark ? Colors.white : Colors.white,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 300, left: 15, right: 15),
      //         child: Obx(() => Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Row(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Expanded(
      //                   child: CustomTextField(
      //                     textDirection: TextDirection.ltr,
      //                     label: 'enter_phone_number'.tr,
      //                     hintText: '50xxxxxxx',
      //                     controller: phoneController,
      //                     keyboardType: TextInputType.phone,
      //                     maxLength: 9,
      //                     // Added maxLength
      //                     errorText: phoneError.value.isNotEmpty
      //                         ? phoneError.value
      //                         : null,
      //                     onChanged: (value) => phoneError.value = '',
      //                   ),
      //                 ),
      //                 const SizedBox(width: 10),
      //                 Column(
      //                   children: [
      //                     const Padding(
      //                       padding: EdgeInsets.all(8.0),
      //                       child: Row(
      //                         children: [Text('')],
      //                       ),
      //                     ),
      //                     _buildCountryCodePicker(
      //                       isDark: isDark,
      //                       selectedCountryCode: selectedCountryCode,
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(height: 20),
      //             CustomTextField(
      //               label: 'enter_password'.tr,
      //               hintText: '*********',
      //               controller: passwordController,
      //               keyboardType: TextInputType.visiblePassword,
      //               obscureText: obscurePassword.value,
      //               errorText: passwordError.value.isNotEmpty
      //                   ? passwordError.value
      //                   : null,
      //               onChanged: (value) => passwordError.value = '',
      //               suffixIcon: obscurePassword.value
      //                   ? Icons.visibility_off
      //                   : Icons.visibility,
      //               onSuffixIconTap: () {
      //                 obscurePassword.value = !obscurePassword.value;
      //               },
      //             ),
      //             const SizedBox(height: 10),
      //             Align(
      //               alignment: Alignment.centerRight,
      //               child: GestureDetector(
      //                 onTap: () =>
      //                     CustomSheetsVerify.showForgotPasswordSheet(
      //                         context),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Text(
      //                     'forgot_password'.tr,
      //                     style: GoogleFonts.tajawal(
      //                       fontSize: 14,
      //                       color: const Color(0xFF2196F3),
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(height: 10),
      //             Align(
      //               alignment: Alignment.center,
      //               child: GestureDetector(
      //                 onTap: () => Get.toNamed(AppRoutes.register),
      //                 child: Padding(
      //                   padding: EdgeInsets.only(left: 8, right: 8),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         'have_no_account'.tr,
      //                         style: GoogleFonts.tajawal(
      //                             fontSize: 14,
      //                             color: isDark
      //                                 ? Colors.grey[400]
      //                                 : Colors.grey),
      //                       ),
      //                       const SizedBox(width: 4),
      //                       Text(
      //                         'register_now'.tr,
      //                         style: GoogleFonts.tajawal(
      //                             fontSize: 14,
      //                             color: AppColors.primary,
      //                             fontWeight: FontWeight.bold),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(height: 30),
      //             CustomButton(
      //               text: loginController.isLoading.value
      //                   ? 'logging_in'.tr
      //                   : 'login_button'.tr,
      //               textSize: 18,
      //               textFontWeight: FontWeight.bold,
      //               textColor: Colors.white,
      //               onPressed: loginController.isLoading.value
      //                   ? null
      //                   : () async {
      //                 final success = await _handleLogin(
      //                   context,
      //                   loginController,
      //                   phoneController,
      //                   passwordController,
      //                   phoneError,
      //                   passwordError,
      //                   selectedCountryCode,
      //                 );
      //                 // Navigation handled in _handleLogin
      //               },
      //             ),
      //             const SizedBox(height: 20),
      //           ],
      //         )),
      //       ),
      //     ],
      //   ),
      // ),
      body: AdaptiveLayOut(
          mobile: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/images/tester.png'),
                    Padding(
                      padding: EdgeInsets.only(top: 195.h),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'login'.tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 300, left: 15, right: 15),
                  child: Obx(() =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                textDirection: TextDirection.ltr,
                                label: 'enter_phone_number'.tr,
                                hintText: '50xxxxxxx',
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 9,
                                isDigits: true,
                                // Added maxLength
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
                                _buildCountryCodePicker(
                                  isDark: isDark,
                                  selectedCountryCode: selectedCountryCode,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'enter_password'.tr,
                          hintText: '*********',
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscurePassword.value,
                          onTap: () {
                            print(phoneController.text);
                          },
                          errorText: passwordError.value.isNotEmpty
                              ? passwordError.value
                              : null,
                          onChanged: (value) => passwordError.value = '',
                          suffixIcon: obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onSuffixIconTap: () {
                            print('suffix tapped');
                            obscurePassword.value = !obscurePassword.value;
                            // obscurePassword.toggle();
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                           onTap: () =>
                                CustomSheetsVerify.showForgotPasswordSheet(
                                    context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'forgot_password'.tr,
                                style: GoogleFonts.tajawal(
                                  fontSize: 14,
                                  color: const Color(0xFF2196F3),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.register),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'have_no_account'.tr,
                                    style: GoogleFonts.tajawal(
                                        fontSize: 14,
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'register_now'.tr,
                                    style: GoogleFonts.tajawal(
                                        fontSize: 14,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          text: loginController.isLoading.value
                              ? 'logging_in'.tr
                              : 'login_button'.tr,
                          textSize: 18,
                          textFontWeight: FontWeight.bold,
                          textColor: Colors.white,
                          onPressed: loginController.isLoading.value
                              ? null
                              : () async {
                                  final success = await _handleLogin(
                                    context,
                                    loginController,
                                    phoneController,
                                    passwordController,
                                    phoneError,
                                    passwordError,
                                    selectedCountryCode,
                                  );
                                  // Navigation handled in _handleLogin
                                },
                        ),
                        const SizedBox(height: 20),
                      ],
                    )),
              ),
            ],
          ),
        ),
        desktop: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [Colors.black, Colors.grey[900]!]
                  : [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 1200,
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Row(
                  children: [
                    // Left side - Image/Branding
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/tester.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

    // Right side - Login Form
    Expanded(
    flex: 5,
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 60, vertical: 40),
    child: Center(
    child: Container(
    constraints: BoxConstraints(maxWidth: 480),
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(
    color: isDark ? Colors.grey[850] : Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
    BoxShadow(
    color: isDark
    ? Colors.black.withOpacity(0.3)
        : Colors.grey.withOpacity(0.1),
    blurRadius: 20,
    offset: const Offset(0, 10),
    ),
    ],
    ),
    child: Obx(() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment:
    CrossAxisAlignment.stretch,
    children: [
    // Title
    Text(
    'login'.tr,
    textAlign: TextAlign.center,
    style: GoogleFonts.tajawal(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: isDark
    ? Colors.white
        : Colors.black,
    ),
    ),
    const SizedBox(height: 40),

    // Phone Number Field
    Row(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: [
    Expanded(
    child: CustomTextField(
    textDirection: TextDirection.ltr,
    label: 'enter_phone_number'.tr,
    hintText: '50xxxxxxx',
    controller: phoneController,
    keyboardType: TextInputType.phone,
    maxLength: 9,
    errorText:
    phoneError.value.isNotEmpty
    ? phoneError.value
        : null,
    onChanged: (value) =>
    phoneError.value = '',
    ),
    ),
    const SizedBox(width: 12),
    Column(
    children: [
    const Padding(
    padding: EdgeInsets.all(8.0),
    child: Row(
    children: [Text('')],
    ),
    ),
    _buildCountryCodePicker(
    isDark: isDark,
    selectedCountryCode:
    selectedCountryCode,
    ),
    ],
    ),
    ],
    ),
    const SizedBox(height: 24),

    // Password Field
    CustomTextField(
    label: 'enter_password'.tr,
    hintText: '*********',
    controller: passwordController,
    keyboardType:
    TextInputType.visiblePassword,
    obscureText: obscurePassword.value,
    errorText: passwordError.value.isNotEmpty
    ? passwordError.value
        : null,
    onChanged: (value) =>
    passwordError.value = '',
    suffixIcon: obscurePassword.value
    ? Icons.visibility_off
        : Icons.visibility,
    onSuffixIconTap: () =>
    obscurePassword.toggle(),
    ),
    const SizedBox(height: 16),

    // Forgot Password
    Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
    onTap: () => CustomSheetsVerify
        .showForgotPasswordSheet(context),
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
    'forgot_password'.tr,
    style: GoogleFonts.tajawal(
    fontSize: 15,
    color: const Color(0xFF2196F3),
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    ),
    const SizedBox(height: 32),

    // Login Button
    CustomButton(
    text: loginController.isLoading.value
    ? 'logging_in'.tr
        : 'login_button'.tr,
    textSize: 18,
    textFontWeight: FontWeight.bold,
    textColor: Colors.white,
    onPressed: loginController.isLoading.value
    ? null
        : () async {
    final success =
    await _handleLogin(
    context,
    loginController,
    phoneController,
    passwordController,
    phoneError,
    passwordError,
    selectedCountryCode,
    );
    // Navigation handled in _handleLogin
    },
    ),
    const SizedBox(height: 24),

    // Register Link
    Center(
    child: GestureDetector(
    onTap: () =>
    Get.toNamed(AppRoutes.register),
    child: Padding(
    padding:
    EdgeInsets.symmetric(vertical: 8),
    child: Row(
    mainAxisAlignment:
    MainAxisAlignment.center,
    children: [
    Text(
    'have_no_account'.tr,
    style: GoogleFonts.tajawal(
    fontSize: 15,
    color: isDark
    ? Colors.grey[400]
        : Colors.grey[700]),
    ),
    const SizedBox(width: 6),
    Text(
    'register_now'.tr,
    style: GoogleFonts.tajawal(
    fontSize: 15,
    color: AppColors.primary,
    fontWeight:
    FontWeight.bold),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    )),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ),
    tablet: SingleChildScrollView(
    physics: ClampingScrollPhysics(),
    child: Stack(
    children: [
    Stack(
    children: [
    Image.asset('assets/images/tester.png'),
    Padding(
    padding: EdgeInsets.only(top: 300.h),
    child: Align(
    alignment: Alignment.topCenter,
    child: Text(
    'login'.tr,
    textAlign: TextAlign.center,
    style: GoogleFonts.tajawal(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: isDark ? Colors.white : Colors.white,
    ),
    ),
    ),
    ),
    ],
    ),
    Padding(
    padding: const EdgeInsets.only(top: 300, left: 15, right: 15),
    child: Obx(() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    SizedBox(
    height: 300.h,
    ),
    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: CustomTextField(
    textDirection: TextDirection.ltr,
    label: 'enter_phone_number'.tr,
    hintText: '151864113',
    controller: phoneController,
    keyboardType: TextInputType.phone,
    maxLength: 10,
    onTap: () {},
    // Added maxLength
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
    _buildCountryCodePicker(
    isDark: isDark,
    selectedCountryCode: selectedCountryCode,
    ),
    ],
    ),
    ],
    ),
    const SizedBox(height: 20),
    CustomTextField(
    label: 'enter_password'.tr,
    hintText: '*********',
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
    Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
    onTap: () =>
    CustomSheetsVerify.showForgotPasswordSheet(
    context),
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
    'forgot_password'.tr,
    style: GoogleFonts.tajawal(
    fontSize: 14,
    color: const Color(0xFF2196F3),
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    ),
    const SizedBox(height: 10),
    Align(
    alignment: Alignment.center,
    child: GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.register),
    child: Padding(
    padding: EdgeInsets.only(left: 8, right: 8),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Text(
    'have_no_account'.tr,
    style: GoogleFonts.tajawal(
    fontSize: 14,
    color: isDark
    ? Colors.grey[400]
        : Colors.grey),
    ),
    const SizedBox(width: 4),
    Text(
    'register_now'.tr,
    style: GoogleFonts.tajawal(
    fontSize: 14,
    color: AppColors.primary,
    fontWeight: FontWeight.bold),
    ),
    ],
    ),
    ),
    ),
    ),
    const SizedBox(height: 30),
    CustomButton(
    text: loginController.isLoading.value
    ? 'logging_in'.tr
        : 'login_button'.tr,
    textSize: 18,
    textFontWeight: FontWeight.bold,
    textColor: Colors.white,
    onPressed: loginController.isLoading.value
    ? null
        : () async {
    final success = await _handleLogin(
    context,
    loginController,
    phoneController,
    passwordController,
    phoneError,
    passwordError,
    selectedCountryCode,
    );
    // Navigation handled in _handleLogin
    },
    ),
    const SizedBox(height: 20),
    ],
    )),
    ),
    ],
    )
    ,
    )
    ,
    )
    ,
    );
  }

  Widget _buildCountryCodePicker({
    required bool isDark,
    required RxString selectedCountryCode,
  }) {
    final countryData = {
      '966': {'flag': 'assets/images/Saudi Arabia.png', 'name': ''},
    };

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[800]
            : const Color(0xff9C9C9C).withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Obx(() =>
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCountryCode.value,
              icon: Icon(Icons.arrow_drop_down,
                  color: isDark ? Colors.grey[400] : Colors.grey),
              items: countryData.entries.map((entry) {
                final code = entry.key;
                final flag = entry.value['flag']!;
                return DropdownMenuItem<String>(
                  value: code,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        code,
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        flag,
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(
                              Icons.flag_circle,
                              color: isDark ? Colors.grey[600] : Colors.grey,
                              size: 24,
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
                    return Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            code,
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                            flag,
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                                  Icons.flag_circle,
                                  color: isDark ? Colors.grey[600] : Colors
                                      .grey,
                                  size: 24,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              dropdownColor: isDark ? Colors.grey[850] : Colors.white,
            ),
          )),
    );
  }

  Future<bool> _handleLogin(BuildContext context,
      LoginController loginController,
      TextEditingController phoneController,
      TextEditingController passwordController,
      RxString phoneError,
      RxString passwordError,
      RxString selectedCountryCode,) async {
    bool hasError = false;

    if (phoneController.text
        .trim()
        .isEmpty) {
      phoneError.value = 'phone_required'.tr;
      hasError = true;
    } else if (!RegExp(r'^\d{9,10}$').hasMatch(phoneController.text.trim())) {
      phoneError.value = 'phone_length_error'.tr;
      hasError = true;
    }
    if (passwordController.text
        .trim()
        .isEmpty) {
      passwordError.value = 'password_required'.tr;
      hasError = true;
    }

    if (!hasError) {
      final phoneWithCountryCode =
          '${selectedCountryCode.value}${phoneController.text.trim()}';
      final success = await loginController.login(
          phoneWithCountryCode, passwordController.text.trim());
      print('Login success: $success');
      if (!success && loginController.errorMessage.value.isNotEmpty) {
        passwordError.value = loginController.errorMessage.value;
        return false;
      }
      if (success) {
        // Initialize ProfileController and fetch profile
        final ProfileController profileController =
        Get.put(ProfileController());
        final profileFetched = await profileController.fetchProfile();
        print('Profile fetched: $profileFetched');

        if (profileFetched && profileController.profile.value != null) {
          final packageId = profileController.profile.value!.packageId;
          print('Package ID: $packageId');
          Get.offAllNamed(AppRoutes.navbar);
          // if (packageId == null) {
          //   Get.offAllNamed(AppRoutes.sub);
          // } else {
          //   Get.offAllNamed(AppRoutes.navbar);
          // }
        } else {
          print('Profile fetch failed or profile is null');
          Get.offAllNamed(AppRoutes.auth);
        }
        return true;
      }
      return false;
    }
    return false;
  }
}
