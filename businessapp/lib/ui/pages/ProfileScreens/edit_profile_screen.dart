import 'package:dieaya_market/ui/pages/AuthScreens/auth_main.dart';
import 'package:dieaya_market/ui/pages/NotificationsScreen/notifications_screen.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Routes/app_routes.dart';
import '../../../Utils/app_colors.dart';
import '../../../controllers/CategoryController/category_controller.dart';
import '../../../controllers/ProfileController/profile_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../utils/app_text_field.dart';
import '../../widgets/buttons.dart';

import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

import 'dart:io';

import '../AuthScreens/register_screen.dart';
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
  late TextEditingController _confirmPasswordController;
  late TextEditingController _descriptionController;
  late TextEditingController _storeLinkController;
  final ProfileController profileController = Get.put(ProfileController());
  final CategoryController categoryController = Get.put(CategoryController());
  final usernameError = ''.obs;
  final emailError = ''.obs;
  final phoneError = ''.obs;
  final passwordError = ''.obs;
  final descriptionError = ''.obs;
  final categoriesError = ''.obs;
  final storeLinkError = ''.obs;
  final logoError = ''.obs;
  final confirmPasswordError = ''.obs;
  final ThemeController themeController = Get.put(ThemeController());
  final selectedCategories = <int>[].obs;
  final storeLogo = Rxn<XFile>();
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  late bool _whatsappNotification;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _descriptionController = TextEditingController();
    _storeLinkController = TextEditingController();
    _whatsappNotification =
        profileController.profile.value?.whatsappNotification ??
            false; // Initialize here

    SharedPrefsConstants.isLoggedIn().then((isLoggedIn) {
      if (!isLoggedIn) {
        Get.offNamed(AppRoutes.auth);
      } else if (profileController.profile.value != null) {
        _populateFields();
      } else {
        profileController.fetchProfile().then((success) {
          if (success && profileController.profile.value != null) {
            _populateFields();
          }
        });
      }
    });
  }

  void _populateFields() {
    final profile = profileController.profile.value;
    if (profile == null) {
      Get.snackbar('error'.tr, 'no_profile_data'.tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    _usernameController.text = profile.name ?? '';
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone != null
        ? (profile.phone!.startsWith('966')
            ? profile.phone!.substring(3)
            : profile.phone!)
        : '';
    _passwordController.text = '';
    _confirmPasswordController.text = '';
    _descriptionController.text = profile.description ?? '';
    _storeLinkController.text = profile.link ?? '';
    selectedCategories.value = profile.categories
            ?.map((category) => category.id!)
            .where((id) => id != null && id != 1)
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _descriptionController.dispose();
    _storeLinkController.dispose();
    usernameError.close();
    emailError.close();
    phoneError.close();
    passwordError.close();
    confirmPasswordError.close();
    descriptionError.close();
    storeLinkError.close();
    logoError.close();
    selectedCategories.close();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    print('Starting _saveProfile...');
    print('Current Profile: ${profileController.profile.value}');
    if (profileController.profile.value == null) {
      Get.snackbar('error'.tr, 'no_profile_data'.tr,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    /// validation
    if (_phoneController.text.length < 9) {
      phoneError.value = 'the phone must be 9 digits';
      return;
    }

    usernameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    descriptionError.value = '';
    storeLinkError.value = '';
    logoError.value = '';

    bool hasError = false;
    final currentProfile = profileController.profile.value!;

    if (_usernameController.text.trim().isEmpty) {
      usernameError.value = 'userNameRequired'.tr;
      hasError = true;
    }
    if (_emailController.text.trim().isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_emailController.text.trim())) {
      emailError.value = 'emailRequired'.tr;
      hasError = true;
    }
    if (_descriptionController.text.trim().isEmpty) {
      descriptionError.value = 'appDesc'.tr;
      hasError = true;
    }
    if (_storeLinkController.text.trim().isEmpty) {
      storeLinkError.value = 'marketLink'.tr;
      hasError = true;
    }
    if (_passwordController.text.isNotEmpty &&
        _confirmPasswordController.text != _passwordController.text) {
      confirmPasswordError.value = "password_mismatch".tr;
      hasError = true;
    }

    Map<String, dynamic> fieldsToUpdate = {};
    if (_usernameController.text != (currentProfile.name ?? '')) {
      fieldsToUpdate['name'] = _usernameController.text;
    }

    if (_phoneController.text != (currentProfile.phone ?? '') ||
        _phoneController.text.isNotEmpty) {
      fieldsToUpdate['phone'] = '966${_phoneController.text}';
    }

    if (_whatsappNotification != currentProfile.whatsappNotification) {
      fieldsToUpdate['whatsapp_notification'] = _whatsappNotification ? 1 : 0;
    }
    if (_emailController.text != (currentProfile.email ?? '')) {
      fieldsToUpdate['email'] = _emailController.text.trim();
    }
    if (_passwordController.text.isNotEmpty) {
      fieldsToUpdate['password'] = _passwordController.text;
    }
    if (_descriptionController.text != (currentProfile.description ?? '')) {
      fieldsToUpdate['description'] = _descriptionController.text;
    }
    if (_storeLinkController.text != (currentProfile.link ?? '')) {
      fieldsToUpdate['link'] = _storeLinkController.text;
    }
    if (storeLogo.value != null) {
      fieldsToUpdate['logo'] = storeLogo.value;
    }
    final currentCategoryIds = currentProfile.categories
            ?.map((category) => category.id)
            .where((id) => id != null && id != 1)
            .toList() ??
        [];
    if (!const IterableEquality()
        .equals(selectedCategories, currentCategoryIds)) {
      fieldsToUpdate['categories'] = selectedCategories;
    }

    if (fieldsToUpdate.isEmpty) {
      Get.snackbar('no_changes'.tr, 'no_fields_modified'.tr,
          backgroundColor: Colors.grey, colorText: Colors.white);
      return;
    }

    if (hasError) return;

    print('Fields to update: $fieldsToUpdate');

    // if ('966${_phoneController.text}' != (currentProfile.phone ?? '')) {
    //   var x = await showDialog<bool>(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(20),
    //         ),
    //         child: Container(
    //           padding: const EdgeInsetsDirectional.all(30),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Image.asset(
    //                 'assets/images/check 1.png',
    //                 height: 100,
    //               ),
    //               const SizedBox(height: 20),
    //               Text(
    //                 'force_sign_out_message'.tr,
    //                 style: GoogleFonts.tajawal(
    //                     fontSize: 22, fontWeight: FontWeight.bold),
    //                 textAlign: TextAlign.center,
    //               ),
    //               const SizedBox(height: 20),
    //               CustomButton(
    //
    //                 text: 'ok'.tr,
    //                 textSize: 22,
    //                 textFontWeight: FontWeight.bold,
    //                 onPressed: () async {
    //                   bool success = await profileController.updateProfile(
    //                     name: fieldsToUpdate['name'],
    //                     email: fieldsToUpdate['email'],
    //                     phone: fieldsToUpdate['phone'],
    //                     password: fieldsToUpdate['password'],
    //                     description: fieldsToUpdate['description'],
    //                     link: fieldsToUpdate['link'],
    //                     logo: fieldsToUpdate['logo'],
    //                     categories: fieldsToUpdate['categories'],
    //                     whatsappNotification:
    //                         fieldsToUpdate['whatsapp_notification'],
    //                   );
    //
    //                   print('Update success: $success');
    //                   if (success) {
    //                     showDialog(
    //                       context: context,
    //                       barrierDismissible: false,
    //                       builder: (BuildContext context) {
    //                         return Dialog(
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(20),
    //                           ),
    //                           child: Container(
    //                             padding: const EdgeInsetsDirectional.all(30),
    //                             child: Column(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Image.asset(
    //                                   'assets/images/check 1.png',
    //                                   height: 100,
    //                                 ),
    //                                 const SizedBox(height: 20),
    //                                 Text(
    //                                   'updated_successfully'.tr,
    //                                   style: GoogleFonts.tajawal(
    //                                       fontSize: 22,
    //                                       fontWeight: FontWeight.bold),
    //                                   textAlign: TextAlign.center,
    //                                 ),
    //                                 const SizedBox(height: 20),
    //                                 CustomButton(
    //                                   text: 'done'.tr,
    //                                   textSize: 22,
    //                                   textFontWeight: FontWeight.bold,
    //                                   onPressed: () async {
    //                                     if ('966${_phoneController.text}' !=
    //                                         (currentProfile.phone ?? '')) {
    //                                       final success =
    //                                           await profileController.logout();
    //                                       if (success) {
    //                                         await _resetAppState();
    //                                         Get.offAll(() => AuthMain());
    //                                       } else {
    //                                         Get.snackbar(
    //                                           'error'.tr,
    //                                           profileController.errorMessage
    //                                                   .value.isNotEmpty
    //                                               ? profileController
    //                                                   .errorMessage.value
    //                                               : 'logout failed'.tr,
    //                                           backgroundColor: Colors.red,
    //                                           colorText: Colors.white,
    //                                           snackPosition:
    //                                               SnackPosition.BOTTOM,
    //                                         );
    //                                       }
    //                                     } else {
    //                                       Navigator.pop(context);
    //                                       Get.back();
    //                                       profileController.fetchProfile();
    //                                     }
    //                                   },
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     );
    //                     if (fieldsToUpdate.containsKey('password')) {
    //                       _passwordController.clear();
    //                     }
    //                     storeLogo.value = null;
    //                   } else {
    //                     print(
    //                         'Validation errors: ${profileController.validationErrors}');
    //                     print(
    //                         'Error message: ${profileController.errorMessage.value}');
    //                     if (profileController.validationErrors.isNotEmpty) {
    //                       if (profileController.validationErrors
    //                           .containsKey('name')) {
    //                         usernameError.value =
    //                             profileController.validationErrors['name']!;
    //                       }
    //                       if (profileController.validationErrors
    //                           .containsKey('email')) {
    //                         emailError.value =
    //                             profileController.validationErrors['email']!;
    //                       }
    //                       if (profileController.validationErrors
    //                           .containsKey('password')) {
    //                         passwordError.value =
    //                             profileController.validationErrors['password']!;
    //                       }
    //                       if (profileController.validationErrors
    //                           .containsKey('description')) {
    //                         descriptionError.value = profileController
    //                             .validationErrors['description']!;
    //                       }
    //                       if (profileController.validationErrors
    //                           .containsKey('link')) {
    //                         storeLinkError.value =
    //                             profileController.validationErrors['link']!;
    //                       }
    //                       if (profileController.validationErrors
    //                           .containsKey('logo')) {
    //                         logoError.value =
    //                             profileController.validationErrors['logo']!;
    //                       }
    //                       if (profileController.validationErrors
    //                           .containsKey('phone')) {
    //                         phoneError.value =
    //                             profileController.validationErrors['phone']!;
    //                       }
    //                     } else {
    //                       Get.snackbar(
    //                           'error'.tr, profileController.errorMessage.value,
    //                           backgroundColor: Colors.red,
    //                           colorText: Colors.white);
    //                     }
    //                   }
    //                 },
    //               ),
    //               SizedBox(height: 5,),
    //               CustomButton(
    //                 color: AppColors.white,
    //                 textColor: AppColors.black,
    //                 text: 'cancel'.tr,
    //                 textSize: 22,
    //                 textFontWeight: FontWeight.bold,
    //                 onPressed: () async {
    //                   Navigator.pop(context);
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    //   print(x);
    // }

    // else {
      bool success = await profileController.updateProfile(
        name: fieldsToUpdate['name'],
        email: fieldsToUpdate['email'],
        phone: fieldsToUpdate['phone'],
        password: fieldsToUpdate['password'],
        description: fieldsToUpdate['description'],
        link: fieldsToUpdate['link'],
        logo: fieldsToUpdate['logo'],
        categories: fieldsToUpdate['categories'],
        whatsappNotification: fieldsToUpdate['whatsapp_notification'],
      );

      print('Update success: $success');
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

                    Text(
                      'updated_successfully'.tr,
                      style: GoogleFonts.tajawal(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'done'.tr,
                      textSize: 22,
                      textFontWeight: FontWeight.bold,
                      onPressed: () async {
                        // if ('966${_phoneController.text}' !=
                        //     (currentProfile.phone ?? '')) {
                        //   final success = await profileController.logout();
                        //   if (success) {
                        //     await _resetAppState();
                        //     Get.offAll(() => AuthMain());
                        //   } else {
                        //     Get.snackbar(
                        //       'error'.tr,
                        //       profileController.errorMessage.value.isNotEmpty
                        //           ? profileController.errorMessage.value
                        //           : 'logout failed'.tr,
                        //       backgroundColor: Colors.red,
                        //       colorText: Colors.white,
                        //       snackPosition: SnackPosition.BOTTOM,
                        //     );
                        //   }
                        // }
                        // else {
                          Navigator.pop(context);
                          Get.back();
                          profileController.fetchProfile();
                        // }
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
        storeLogo.value = null;
      }
      else {
        print('Validation errors: ${profileController.validationErrors}');
        print('Error message: ${profileController.errorMessage.value}');
        if (profileController.validationErrors.isNotEmpty) {
          if (profileController.validationErrors.containsKey('name')) {
            usernameError.value = profileController.validationErrors['name']!;
          }
          if (profileController.validationErrors.containsKey('email')) {
            emailError.value = profileController.validationErrors['email']!;
          }
          if (profileController.validationErrors.containsKey('password')) {
            passwordError.value =
                profileController.validationErrors['password']!;
          }
          if (profileController.validationErrors.containsKey('description')) {
            descriptionError.value =
                profileController.validationErrors['description']!;
          }
          if (profileController.validationErrors.containsKey('link')) {
            storeLinkError.value = profileController.validationErrors['link']!;
          }
          if (profileController.validationErrors.containsKey('logo')) {
            logoError.value = profileController.validationErrors['logo']!;
          }
          if (profileController.validationErrors.containsKey('phone')) {
            phoneError.value = profileController.validationErrors['phone']!;
          }
        } else {
          Get.snackbar('error'.tr, profileController.errorMessage.value,
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    // }
  }

  Future<void> _resetAppState() async {
    // Get.deleteAll();
    SharedPrefsConstants.removeToken();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
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
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'account_settings'.tr,
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 10),
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
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: isArabic
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.center,
                children: [
                  _buildStoreLogoPicker(
                      isDark: isDark,
                      errorText:
                          logoError.value.isNotEmpty ? logoError.value : null),
                  const SizedBox(height: 6),
                  Obx(() => CustomTextField(
                        label: 'enter_store_name'.tr,
                        hintText: 'store_name'.tr,
                        controller: _usernameController,
                        errorText: usernameError.value.isNotEmpty
                            ? usernameError.value
                            : null,
                        onChanged: (value) => usernameError.value = '',
                      )),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: isArabic
                        ? [
                            Expanded(
                              child: Obx(() => CustomTextField(
                                    textDirection: TextDirection.ltr,
                                    // readOnly: true,
                                    label: 'phone_number'.tr,
                                    hintText: 'phone_hint'.tr,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 9,
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
                                    children: [Text('')],
                                  ),
                                ),
                                _buildCountryCodePicker(),
                              ],
                            ),
                          ]
                        : [
                            Expanded(
                              child: Obx(() => CustomTextField(
                                    // readOnly: true,
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
                            _buildCountryCodePicker(),
                          ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() => CustomTextField(
                        label: 'email'.tr,
                        hintText: 'email'.tr,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: emailError.value.isNotEmpty
                            ? emailError.value
                            : null,
                        onChanged: (value) => emailError.value = '',
                      )),
                  const SizedBox(height: 20),
                  Obx(() => CustomTextField(
                        label: 'password'.tr,
                        hintText: 'enter_new_password'.tr,
                        controller: _passwordController,
                        obscureText: obscurePassword.value,
                        errorText: passwordError.value.isNotEmpty
                            ? passwordError.value
                            : null,
                        onChanged: (value) => passwordError.value = '',
                        suffixIcon: obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixIconTap: () => obscurePassword.toggle(),
                      )),
                  const SizedBox(height: 20),
                  Obx(() => CustomTextField(
                        label: 'confirm_password'.tr,
                        hintText: 'confirm_password'.tr,
                        controller: _confirmPasswordController,
                        obscureText: obscureConfirmPassword.value,
                        errorText: confirmPasswordError.value.isNotEmpty
                            ? confirmPasswordError.value
                            : null,
                        onChanged: (value) => passwordError.value = '',
                        suffixIcon: obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onSuffixIconTap: () => obscureConfirmPassword.toggle(),
                      )),
                  const SizedBox(height: 20),
                  Obx(() => CustomTextField(
                        label: 'description'.tr,
                        hintText: 'store_description'.tr,
                        controller: _descriptionController,
                        maxLines: 3,
                        errorText: descriptionError.value.isNotEmpty
                            ? descriptionError.value
                            : null,
                        onChanged: (value) => descriptionError.value = '',
                      )),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: Text(
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
                  const SizedBox(height: 20),
                  Obx(() => Column(
                        crossAxisAlignment: isArabic
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            'categories'.tr,
                            style: GoogleFonts.tajawal(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 8),
                          categoryController.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : CustomDropdown(
                                  categories: categoryController.categories,
                                  selectedCategories: selectedCategories,
                                  isDark: isDark,
                                  errorText: categoriesError.value.isNotEmpty
                                      ? categoriesError.value
                                      : null,
                                ),
                        ],
                      )),
                  const SizedBox(height: 20),
                  Obx(() => CustomTextField(
                        label: 'marketLinkApp'.tr,
                        hintText: 'https://example.com',
                        controller: _storeLinkController,
                        keyboardType: TextInputType.url,
                        errorText: storeLinkError.value.isNotEmpty
                            ? storeLinkError.value
                            : null,
                        onChanged: (value) => storeLinkError.value = '',
                      )),
                  const SizedBox(height: 40),
                  Obx(() => CustomButton(
                        text: profileController.isLoading.value
                            ? 'saving'.tr
                            : 'save'.tr,
                        textSize: 22,
                        onPressed: profileController.isLoading.value
                            ? null
                            : _saveProfile,
                      )),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryCodePicker() {
    final selectedCountryCode = '966'.obs;
    final countryData = {
      '966': {'flag': 'assets/images/Saudi Arabia.png', 'name': ''},
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
                            Text(
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
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.flag_circle,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              code,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]
                        : [
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
                  children: isArabic
                      ? [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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

  Widget _buildStoreLogoPicker({required bool isDark, String? errorText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null) ...[
          Text(
            errorText,
            style: GoogleFonts.tajawal(fontSize: 12, color: Colors.red),
          ),
          const SizedBox(height: 4),
        ],
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picker = ImagePicker();
            final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              storeLogo.value = pickedFile;
              logoError.value = '';
            }
          },
          child: Obx(() => Stack(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color:
                          isDark ? Colors.grey[800] : const Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: storeLogo.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              File(storeLogo.value!.path),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          )
                        : profileController.profile.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  profileController.profile.value?.logo ?? '',
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Icon(Icons.image,
                                        size: 60,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.white),
                                  ),
                                ),
                              )
                            : Center(
                                child: Icon(Icons.image,
                                    size: 60,
                                    color:
                                        isDark ? Colors.white : Colors.white),
                              ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
