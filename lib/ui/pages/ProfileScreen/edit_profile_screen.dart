import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/UI/pages/NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../Controllers/AuthController/profile_controller.dart';
import '../../../Routes/app_routes.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/app_sharedprefs_contants.dart';
import '../../../Utils/app_text_field.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import 'package:flutter_svg/svg.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  final ProfileController profileController = Get.find<ProfileController>();
  final usernameError = ''.obs;
  final emailError = ''.obs;
  final phoneError = ''.obs;
  final passwordError = ''.obs;
  final ThemeController themeController = Get.find<ThemeController>();
  late bool _whatsappNotification;
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _whatsappNotification = profileController.profile.value?.whatsappNotification ?? false; // Initialize here

    SharedPrefsConstants.isLoggedIn().then((isLoggedIn) {
      if (!isLoggedIn) {
        Get.offNamed(AppRoutes.login);
      } else if (profileController.profile.value != null) {
        final profile = profileController.profile.value!;
        _usernameController.text = profile.name;
        _emailController.text = profile.email;
        _phoneController.text = profile.phone.startsWith('966')
            ? profile.phone.substring(3)
            : profile.phone;
      } else {
        profileController.fetchProfile().then((success) {
          if (success && profileController.profile.value != null) {
            final profile = profileController.profile.value!;
            _usernameController.text = profile.name;
            _emailController.text = profile.email;
            _phoneController.text = profile.phone.startsWith('966')
                ? profile.phone.substring(3)
                : profile.phone;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    usernameError.close();
    emailError.close();
    phoneError.close();
    passwordError.close();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (profileController.profile.value == null) {
      Get.snackbar('error'.tr, 'no_profile_data'.tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    usernameError.value = '';
    emailError.value = '';
    passwordError.value = '';

    final currentProfile = profileController.profile.value!;
    Map<String, dynamic> fieldsToUpdate = {};

    if (_whatsappNotification != currentProfile.whatsappNotification) {
      fieldsToUpdate['whatsapp_notification'] = _whatsappNotification ? 1 : 0;
    }
    if (_usernameController.text.trim() != currentProfile.name) {
      fieldsToUpdate['name'] = _usernameController.text.trim();
    }
    if (_emailController.text.trim() != currentProfile.email) {
      fieldsToUpdate['email'] = _emailController.text.trim();
    }
    if (_passwordController.text.isNotEmpty) {
      fieldsToUpdate['password'] = _passwordController.text;
    }

    if (fieldsToUpdate.isEmpty) {
      Get.snackbar('no_changes'.tr, 'no_fields_modified'.tr,
          backgroundColor: Colors.grey, colorText: Colors.white);
      return;
    }

    bool success = await profileController.updateProfile(
      name: fieldsToUpdate['name'],
      email: fieldsToUpdate['email'],
      password: fieldsToUpdate['password'],
      whatsappNotification: fieldsToUpdate['whatsapp_notification'],
    );

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsetsDirectional.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/check 1.png',
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  CustomTextSolveIssue(
                    'updated_successfully'.tr,
                    style: GoogleFonts.tajawal(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'done'.tr,
                    textSize: 22,
                    textFontWeight: FontWeight.bold,
                    onPressed: () {
                      Navigator.pop(context);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
      if (fieldsToUpdate.containsKey('password')) {
        _passwordController.clear();
      }
    } else {
      if (profileController.validationErrors.isNotEmpty) {
        if (profileController.validationErrors.containsKey('name')) {
          usernameError.value = profileController.validationErrors['name']!;
        }
        if (profileController.validationErrors.containsKey('email')) {
          emailError.value = profileController.validationErrors['email']!;
        }
        if (profileController.validationErrors.containsKey('password')) {
          passwordError.value = profileController.validationErrors['password']!;
        }
      } else {
        Get.snackbar('error'.tr, profileController.errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }
final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final isArabic = Get.locale?.languageCode == 'ar';

    return AdaptiveLayOut(mobile: Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 0,
      //   automaticallyImplyLeading: true,
      //   backgroundColor: AppColors.primary,
      // ),
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.black : Colors.white,
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
                  stops: const [0.0, 0.0, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        'assets/svg/backbutton.svg',
                        width: 40,
                        height: 40,
                        color: Colors.white,
                      ),
                    ),
                    CustomTextSolveIssue(
                      'account_settings'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Stack(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/svg/notify.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  Colors.black54,
                                  BlendMode.srcIn,
                                ),
                              ),
                              onPressed: () {
                                Get.to(NotificationsScreen());
                              },
                            ),
                            Positioned(
                              right: 11,
                              top: 14,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 8,
                                  minHeight: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment:
                isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Obx(() => CustomTextField(
                    label: 'username'.tr,
                    hintText: 'username'.tr,
                    controller: _usernameController,
                    maxLength: 50,
                    errorText:
                    usernameError.value.isNotEmpty ? usernameError.value : null,
                    onChanged: (value) => usernameError.value = '',
                  )),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: isArabic
                        ? [
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(() => CustomTextField(
                          readOnly: true,
                          label: 'phone_number'.tr,
                          hintText: 'phone_hint'.tr,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          errorText: phoneError.value.isNotEmpty
                              ? phoneError.value
                              : null,
                          onChanged: (value) => phoneError.value = '',
                        )),
                      ),
                    ]
                        : [
                      Expanded(
                        child: Obx(() => CustomTextField(
                          readOnly: true,
                          label: 'phone_number'.tr,
                          hintText: 'phone_hint'.tr,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          errorText: phoneError.value.isNotEmpty
                              ? phoneError.value
                              : null,
                          onChanged: (value) => phoneError.value = '',
                        )),
                      ),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 32),
                  Obx(() => CustomTextField(
                    label: 'email'.tr,
                    hintText: 'email'.tr,
                    controller: _emailController,
                    maxLength: 50,
                    keyboardType: TextInputType.emailAddress,
                    errorText: emailError.value.isNotEmpty ? emailError.value : null,
                    onChanged: (value) => emailError.value = '',
                  )),
                  const SizedBox(height: 32),
                  Obx(() => CustomTextField(
                    label: 'password'.tr,
                    hintText: 'enter_new_password'.tr,
                    controller: _passwordController,
                    obscureText: true,
                    errorText:
                    passwordError.value.isNotEmpty ? passwordError.value : null,
                    onChanged: (value) => passwordError.value = '',
                  )),
                  const SizedBox(height: 32),

                  SwitchListTile(
                    title: CustomTextSolveIssue(
                      'whatsapp_notification'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    value: _whatsappNotification,
                    onChanged: (bool value) {
                      setState(() {
                        _whatsappNotification = value;
                      });
                    },
                    activeColor: AppColors.primary, // Customize color if needed
                  ),
                  const SizedBox(height: 32),
                  Obx(() => CustomButton(
                    text: profileController.isLoading.value
                        ? 'saving'.tr
                        : 'save'.tr,
                    textSize: 22,
                    onPressed: profileController.isLoading.value ? null : _saveProfile,
                  )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    ), desktop: Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Column(
        children: [
          GlobalWebHeader(scrollController: _scrollController),
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextSolveIssue(
                        'account_settings'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 14.w,
                          fontWeight: FontWeight.bold,
                          color: isDark?Colors.white:AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 175.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment:
                      isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Obx(() => CustomTextField(
                          textStyle:  GoogleFonts.tajawal(
                            fontSize: 10.w,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),

                          label: 'username'.tr,
                          hintText: 'username'.tr,
                          controller: _usernameController,
                          errorText:
                          usernameError.value.isNotEmpty ? usernameError.value : null,
                          onChanged: (value) => usernameError.value = '',
                          hintStyle: GoogleFonts.tajawal(
                            fontSize: 8.w,
                            color: greyTextColor.withOpacity(0.7),
                          ),
                        )),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: isArabic
                              ? [
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
                            const SizedBox(width: 8),
                            Expanded(
                              child: Obx(() => CustomTextField(
                                textStyle:  GoogleFonts.tajawal(
                                  fontSize: 10.w,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                hintStyle: GoogleFonts.tajawal(
                                  fontSize: 8.w,
                                  color: greyTextColor.withOpacity(0.7),
                                ),

                                readOnly: true,
                                label: 'phone_number'.tr,
                                hintText: 'phone_hint'.tr,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                errorText: phoneError.value.isNotEmpty
                                    ? phoneError.value
                                    : null,
                                onChanged: (value) => phoneError.value = '',
                              )),
                            ),
                          ]
                              : [
                            Expanded(
                              child: Obx(() => CustomTextField(
                                textStyle:  GoogleFonts.tajawal(
                                  fontSize: 10.w,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                hintStyle: GoogleFonts.tajawal(
                                  fontSize: 8.w,
                                  color: greyTextColor.withOpacity(0.7),
                                ),

                                readOnly: true,
                                label: 'phone_number'.tr,
                                hintText: 'phone_hint'.tr,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                errorText: phoneError.value.isNotEmpty
                                    ? phoneError.value
                                    : null,
                                onChanged: (value) => phoneError.value = '',
                              )),
                            ),
                            const SizedBox(width: 8),
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
                        const SizedBox(height: 32),
                        Obx(() => CustomTextField(
                          textStyle:  GoogleFonts.tajawal(
                            fontSize: 10.w,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          hintStyle: GoogleFonts.tajawal(
                            fontSize: 8.w,
                            color: greyTextColor.withOpacity(0.7),
                          ),

                          label: 'email'.tr,
                          hintText: 'email'.tr,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          errorText: emailError.value.isNotEmpty ? emailError.value : null,
                          onChanged: (value) => emailError.value = '',
                        )),
                        const SizedBox(height: 32),
                        Obx(() => CustomTextField(
                          textStyle:  GoogleFonts.tajawal(
                            fontSize: 10.w,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          hintStyle: GoogleFonts.tajawal(
                            fontSize: 8.w,
                            color: greyTextColor.withOpacity(0.7),
                          ),

                          label: 'password'.tr,
                          hintText: 'enter_new_password'.tr,
                          controller: _passwordController,
                          obscureText: true,
                          errorText:
                          passwordError.value.isNotEmpty ? passwordError.value : null,
                          onChanged: (value) => passwordError.value = '',
                        )),
                        const SizedBox(height: 32),

                        SwitchListTile(
                          title: CustomTextSolveIssue(
                            'whatsapp_notification'.tr,
                            style: GoogleFonts.tajawal(
                              fontSize: 10.w,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          value: _whatsappNotification,
                          onChanged: (bool value) {
                            setState(() {
                              _whatsappNotification = value;
                            });
                          },
                          activeColor: AppColors.primary, // Customize color if needed
                        ),
                        const SizedBox(height: 32),
                        Obx(() => CustomButton(
                          text: profileController.isLoading.value
                              ? 'saving'.tr
                              : 'save'.tr,
                          textSize: 22,
                          onPressed: profileController.isLoading.value ? null : _saveProfile,
                        )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),FooterWidget()
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildCountryCodePicker() {
    final selectedCountryCode = '+966'.obs;
    final countryData = {
      '+966': {'flag': 'assets/images/Saudi Arabia.png', 'name': ''},
    };
    final isArabic = Get.locale?.languageCode == 'ar';

    return Container(
      height: 60,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
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
                children: isArabic
                    ? [
                  CustomTextSolveIssue(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    flag,
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.flag_circle,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomTextSolveIssue(
                    code,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]
                    : [
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
                    errorBuilder: (context, error, stackTrace) => const Icon(
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
          selectedItemBuilder: (context) => countryData.entries.map((entry) {
            final code = entry.key;
            final flag = entry.value['flag']!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: isArabic
                  ? [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      flag,
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.flag_circle,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomTextSolveIssue(
                      code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black54,
                ),
              ]
                  : [
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
                      errorBuilder: (context, error, stackTrace) => const Icon(
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
}
