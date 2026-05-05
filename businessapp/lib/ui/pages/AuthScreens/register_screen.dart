import 'dart:io';
import 'dart:typed_data';
import 'package:dieaya_market/Routes/app_routes.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/android_subscription.dart';
import 'package:dieaya_market/ui/pages/SubscreptionScreens/ios_subscriptions_screen.dart';
import 'package:dieaya_market/ui/widgets/coupon_card.dart';
import 'package:dieaya_market/ui/widgets/custom_verify_sheets.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import 'package:dieaya_market/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dieaya_market/utils/app_colors.dart';
import '../../../controllers/CategoryController/category_controller.dart';
import '../../../controllers/RegisterController/register_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../utils/app_text_field.dart';
import '../../widgets/buttons.dart';
import 'package:dieaya_market/models/product_model.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: value
          ? SvgPicture.asset(
              'assets/svg/checkbox_on.svg',
              width: 24,
              height: 24,
            )
          : SvgPicture.asset(
              'assets/svg/checkbox_off.svg',
              width: 24,
              height: 24,
            ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<Category> categories;
  final RxList<int> selectedCategories;
  final bool isDark;
  final String? errorText;

  const CustomDropdown({
    Key? key,
    required this.categories,
    required this.selectedCategories,
    required this.isDark,
    this.errorText,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
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
          // Close dropdown when tapping outside
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
                        return Obx(() => ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              leading: CustomCheckbox(
                                value: widget.selectedCategories
                                    .contains(category.id),
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    if (value) {
                                      if (!widget.selectedCategories
                                          .contains(category.id)) {
                                        widget.selectedCategories
                                            .add(category.id);
                                      }
                                    } else {
                                      widget.selectedCategories
                                          .remove(category.id);
                                    }
                                  }
                                },
                              ),
                              title: Text(
                                Get.locale?.languageCode == 'ar'
                                    ? category.nameAr
                                    : category.nameEn,
                                style: GoogleFonts.tajawal(
                                  fontSize: 16,
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              onTap: () {
                                final isSelected = widget.selectedCategories
                                    .contains(category.id);
                                if (isSelected) {
                                  widget.selectedCategories.remove(category.id);
                                } else {
                                  widget.selectedCategories.add(category.id);
                                }
                              },
                            ));
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
                    Obx(() => widget.selectedCategories.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 50.0),
                            child: Text(
                              'select_categories'.tr,
                              style: GoogleFonts.tajawal(
                                fontSize: 16,
                                color: widget.isDark
                                    ? Colors.grey[400]
                                    : Colors.grey,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 30, top: 10, bottom: 10),
                            child: Wrap(
                              spacing: 4,
                              children:
                                  widget.selectedCategories.map((categoryId) {
                                final category = widget.categories.firstWhere(
                                  (cat) => cat.id == categoryId,
                                  orElse: () => Category(
                                      id: 0, nameAr: '', nameEn: '', image: ''),
                                );
                                return category.id != 0
                                    ? Text(
                                        '${category.nameAr},',
                                        style: GoogleFonts.tajawal(
                                          color: widget.isDark
                                              ? Colors.white
                                              : AppColors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    // backgroundColor:
                                    // AppColors.primary.withOpacity(0.3),
                                    // onDeleted: () {
                                    //   widget.selectedCategories
                                    //       .remove(categoryId);
                                    // },
                                    //   deleteIcon:
                                    //   const Icon(Icons.close, size: 16),
                                    //   deleteIconColor: widget.isDark
                                    //       ? Colors.white
                                    //       : AppColors.primary,
                                    // )
                                    : const SizedBox.shrink();
                              }).toList(),
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

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final categoryController = Get.put(CategoryController());
    final registerController = Get.put(RegisterController());

    final usernameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController(text: '');
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final descriptionController = TextEditingController();
    final storeLinkController = TextEditingController();

    final nameError = ''.obs;
    final phoneError = ''.obs;
    final emailError = ''.obs;
    final passwordError = ''.obs;
    final confirmPasswordError = ''.obs;
    final descriptionError = ''.obs;
    final storeLinkError = ''.obs;
    final logoError = ''.obs;
    final categoryError = ''.obs;

    final obscurePassword = true.obs;
    final obscureConfirmPassword = true.obs;

    final storeLogo = Rxn<XFile>();

    final selectedCountryCode = '966'.obs;

    final isDark = themeController.themeMode.value == ThemeMode.dark;

    return AdaptiveLayOut(
      mobile: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Stack(
            children: [
              Stack(
                children: [
                  Image.asset('assets/images/tester.png'),
                  Padding(
                    padding: const EdgeInsets.only(top: 170),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'create_account'.tr,
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
                        CustomTextField(
                          label: 'enter_store_name'.tr,
                          hintText: 'store_name'.tr,
                          controller: usernameController,
                          isRequired: true,
                          errorText: nameError.value.isNotEmpty
                              ? nameError.value
                              : null,
                          onChanged: (value) => nameError.value = '',
                        ),
                        const SizedBox(height: 20),
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
                                isRequired: true,
                                isDigits: true,
                                errorText: phoneError.value.isNotEmpty
                                    ? phoneError.value
                                    : null,
                                // onChanged: (value) {
                                //   phoneError.value = '';
                                //   // Client-side validation on input change
                                //   if (value.isNotEmpty && !RegExp(r'^\d{9,10}$').hasMatch(value)) {
                                //     phoneError.value = 'يجب أن يكون رقم الجوال على الاقل 9  أرقام';
                                //   }
                                // },
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
                          label: 'enter_email'.tr,
                          hintText: 'example@gmail.com',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          isRequired: true,
                          errorText: emailError.value.isNotEmpty
                              ? emailError.value
                              : null,
                          onChanged: (value) => emailError.value = '',
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'enter_password'.tr,
                          hintText: '*********',
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscurePassword.value,
                          isRequired: true,
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
                          label: 'confirm_password'.tr,
                          hintText: '*********',
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureConfirmPassword.value,
                          isRequired: true,
                          errorText: confirmPasswordError.value.isNotEmpty
                              ? confirmPasswordError.value
                              : null,
                          onChanged: (value) => confirmPasswordError.value = '',
                          suffixIcon: obscureConfirmPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onSuffixIconTap: () =>
                              obscureConfirmPassword.toggle(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildStoreLogoPicker(
                              storeLogo,
                              isDark: isDark,
                              errorText: logoError.value.isNotEmpty
                                  ? logoError.value
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'choose_image'.tr,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text(
                                  'upload_professional_image'.tr,
                                  style: GoogleFonts.tajawal(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'description'.tr,
                          hintText: 'store_description'.tr,
                          controller: descriptionController,
                          maxLines: 3,
                          isRequired: true,
                          errorText: descriptionError.value.isNotEmpty
                              ? descriptionError.value
                              : null,
                          onChanged: (value) => descriptionError.value = '',
                        ),
                        const SizedBox(height: 20),
                        Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'categories'.tr,
                                        style: GoogleFonts.tajawal(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? Colors.white : Colors.black,
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
                                categoryController.isLoading.value
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : CustomDropdown(
                                        categories:
                                            categoryController.categories,
                                        selectedCategories: registerController
                                            .selectedCategories,
                                        isDark: isDark,
                                        errorText:
                                            categoryError.value.isNotEmpty
                                                ? categoryError.value
                                                : null,
                                      ),
                              ],
                            )),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'store_link'.tr,
                          hintText: 'https://example.com',
                          controller: storeLinkController,
                          keyboardType: TextInputType.url,
                          isRequired: true,
                          errorText: storeLinkError.value.isNotEmpty
                              ? storeLinkError.value
                              : null,
                          onChanged: (value) => storeLinkError.value = '',
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.login),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'already_have_account'.tr,
                                    style: GoogleFonts.tajawal(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'login_now'.tr,
                                    style: GoogleFonts.tajawal(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          text: categoryController.isLoading.value ||
                                  registerController.isLoading.value
                              ? 'creating_account'.tr
                              : 'create_account_and_login'.tr,
                          textSize: 18,
                          textFontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          textColor: Colors.white,
                          onPressed: categoryController.isLoading.value ||
                                  registerController.isLoading.value
                              ? null
                              : () async {
                                  final response = await _handleRegister(
                                    context,
                                    registerController,
                                    usernameController,
                                    emailController,
                                    phoneController,
                                    passwordController,
                                    confirmPasswordController,
                                    descriptionController,
                                    _handlehHttpsNotFound(storeLinkController),
                                    storeLogo,
                                    nameError,
                                    emailError,
                                    phoneError,
                                    passwordError,
                                    confirmPasswordError,
                                    descriptionError,
                                    storeLinkError,
                                    logoError,
                                    categoryError,
                                    selectedCountryCode,
                                  );
                                  if (response != null) {
                                    final token =
                                        response['data']['token'] as String?;
                                    if (token != null && token.isNotEmpty) {
                                      await SharedPrefsConstants.saveToken(
                                          token);

                                      // var isIOs = Platform.isIOS;
                                      var ph = "966"+phoneController.text;
                                      Get.to( ()=>VerifyPhoneWidget(phoneNumber:ph ,isFromRegister: true,));

                                      // Get.to(() => isIOs
                                      //     ? SubscriptionsScreen()
                                      //     : AndroidSubscriptionsScreen());
                                      // Get.offAllNamed(AppRoutes.sub);
                                    }
                                  }
                                },
                        ),
                        SizedBox(height: 50.h),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
      desktop: Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
        body: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Card(
                elevation: 8,
                color: isDark ? Colors.grey[850] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Header Section with Image
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: AppColors.primary),
                      child: Center(
                        child: Text(
                          'create_account'.tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Form Section
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Store Name
                              CustomTextField(
                                label: 'enter_store_name'.tr,
                                hintText: 'store_name'.tr,
                                controller: usernameController,
                                isRequired: true,
                                errorText: nameError.value.isNotEmpty
                                    ? nameError.value
                                    : null,
                                onChanged: (value) => nameError.value = '',
                              ),
                              const SizedBox(height: 24),

                              // Phone and Email Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Phone Field
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            textDirection: TextDirection.ltr,
                                            label: 'enter_phone_number'.tr,
                                            hintText: '511234567',
                                            controller: phoneController,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 10,
                                            isRequired: true,
                                            errorText:
                                                phoneError.value.isNotEmpty
                                                    ? phoneError.value
                                                    : null,
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
                                              selectedCountryCode:
                                                  selectedCountryCode,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Email Field
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'enter_email'.tr,
                                      hintText: 'example@gmail.com',
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      isRequired: true,
                                      errorText: emailError.value.isNotEmpty
                                          ? emailError.value
                                          : null,
                                      onChanged: (value) =>
                                          emailError.value = '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Password Fields Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'enter_password'.tr,
                                      hintText: '*********',
                                      controller: passwordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: obscurePassword.value,
                                      isRequired: true,
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
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'confirm_password'.tr,
                                      hintText: '*********',
                                      controller: confirmPasswordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: obscureConfirmPassword.value,
                                      isRequired: true,
                                      errorText:
                                          confirmPasswordError.value.isNotEmpty
                                              ? confirmPasswordError.value
                                              : null,
                                      onChanged: (value) =>
                                          confirmPasswordError.value = '',
                                      suffixIcon: obscureConfirmPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      onSuffixIconTap: () =>
                                          obscureConfirmPassword.toggle(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Store Logo Section
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]?.withOpacity(0.5)
                                      : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: logoError.value.isNotEmpty
                                        ? Colors.red
                                        : isDark
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'store_logo'.tr,
                                                style: GoogleFonts.tajawal(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
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
                                        if (logoError.value.isNotEmpty) ...[
                                          Text(
                                            logoError.value,
                                            style: GoogleFonts.tajawal(
                                                fontSize: 12,
                                                color: Colors.red),
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            final picker = ImagePicker();

                                            final pickedFile =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            if (pickedFile == null) return;

                                            if (kIsWeb) {
                                              // 🌐 WEB LOGIC
                                              // No file paths, no temp directory

                                              Uint8List bytes = await pickedFile
                                                  .readAsBytes();

                                              // Store bytes or XFile directly
                                              storeLogo.value = XFile.fromData(
                                                bytes,
                                                name: pickedFile.name,
                                                mimeType: pickedFile.mimeType,
                                              );
                                            } else {
                                              // 📱 MOBILE LOGIC
                                              final dir =
                                                  await getTemporaryDirectory();
                                              final targetPath = path.join(
                                                dir.path,
                                                "${DateTime.now().millisecondsSinceEpoch}.jpg",
                                              );

                                              final result =
                                                  await FlutterImageCompress
                                                      .compressAndGetFile(
                                                pickedFile.path,
                                                targetPath,
                                                quality: 60,
                                              );

                                              storeLogo.value = result != null
                                                  ? XFile(result.path)
                                                  : pickedFile;
                                            }
                                          },
                                          child: Obx(() => Stack(
                                                children: [
                                                  Container(
                                                    height: 120,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      color: isDark
                                                          ? Colors.grey[800]
                                                          : const Color(
                                                              0xffD9D9D9),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                    ),
                                                    child: storeLogo.value ==
                                                            null
                                                        ? Center(
                                                            child: Icon(
                                                              Icons.image,
                                                              size: 60,
                                                              color: isDark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          )
                                                        : FutureBuilder(
                                                      future: storeLogo.value!.readAsBytes(),
                                                      builder: (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return const CircularProgressIndicator();
                                                        }
                                                        return Image.memory(
                                                          snapshot.data as Uint8List,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    )
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            AppColors.primary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'choose_image'.tr,
                                            style: GoogleFonts.tajawal(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'upload_professional_image'.tr,
                                            style: GoogleFonts.tajawal(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Description
                              CustomTextField(
                                label: 'description'.tr,
                                hintText: 'store_description'.tr,
                                controller: descriptionController,
                                maxLines: 3,
                                isRequired: true,
                                errorText: descriptionError.value.isNotEmpty
                                    ? descriptionError.value
                                    : null,
                                onChanged: (value) =>
                                    descriptionError.value = '',
                              ),
                              const SizedBox(height: 24),

                              // Categories and Store Link Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Obx(() => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'categories'.tr,
                                                    style: GoogleFonts.tajawal(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
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
                                            categoryController.isLoading.value
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : CustomDropdown(
                                                    categories:
                                                        categoryController
                                                            .categories,
                                                    selectedCategories:
                                                        registerController
                                                            .selectedCategories,
                                                    isDark: isDark,
                                                    errorText: categoryError
                                                            .value.isNotEmpty
                                                        ? categoryError.value
                                                        : null,
                                                  ),
                                          ],
                                        )),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'store_link'.tr,
                                      hintText: 'https://example.com',
                                      controller: storeLinkController,
                                      keyboardType: TextInputType.url,
                                      isRequired: true,
                                      errorText: storeLinkError.value.isNotEmpty
                                          ? storeLinkError.value
                                          : null,
                                      onChanged: (value) =>
                                          storeLinkError.value = '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Already have account
                              Center(
                                child: GestureDetector(
                                  onTap: () => Get.toNamed(AppRoutes.login),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'already_have_account'.tr,
                                        style: GoogleFonts.tajawal(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'login_now'.tr,
                                        style: GoogleFonts.tajawal(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text: categoryController.isLoading.value ||
                                          registerController.isLoading.value
                                      ? 'creating_account'.tr
                                      : 'create_account_and_login'.tr,
                                  textSize: 18,
                                  textFontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  textColor: Colors.white,
                                  onPressed:
                                      categoryController.isLoading.value ||
                                              registerController.isLoading.value
                                          ? null
                                          : () async {
                                              final response =
                                                  await _handleRegister(
                                                context,
                                                registerController,
                                                usernameController,
                                                emailController,
                                                phoneController,
                                                passwordController,
                                                confirmPasswordController,
                                                descriptionController,
                                                _handlehHttpsNotFound(
                                                    storeLinkController),
                                                storeLogo,
                                                nameError,
                                                emailError,
                                                phoneError,
                                                passwordError,
                                                confirmPasswordError,
                                                descriptionError,
                                                storeLinkError,
                                                logoError,
                                                categoryError,
                                                selectedCountryCode,
                                              );
                                              if (response != null) {
                                                final token = response['data']
                                                    ['token'] as String?;
                                                if (token != null &&
                                                    token.isNotEmpty) {
                                                  await SharedPrefsConstants
                                                      .saveToken(token);
                                             if(kIsWeb){
                                               Get.to(() =>  IosSubscriptionsScreen());
                                             }
                                             else{
                                               var isIOs = Platform.isIOS;
                                               Get.to(() => isIOs
                                                   ? IosSubscriptionsScreen()
                                                   : AndroidSubscriptionsScreen());
                                             }
                                                }
                                              }
                                            },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // tablet: Scaffold(
      //   backgroundColor: isDark ? Colors.black : Colors.white,
      //   body: SingleChildScrollView(
      //     physics: ClampingScrollPhysics(),
      //     child: Stack(
      //       children: [
      //         Stack(
      //           children: [
      //             Image.asset('assets/images/tester.png'),
      //             Padding(
      //               padding: const EdgeInsets.only(top: 100),
      //               child: Align(
      //                 alignment: Alignment.topCenter,
      //                 child: Text(
      //                   'create_account'.tr,
      //                   textAlign: TextAlign.center,
      //                   style: GoogleFonts.tajawal(
      //                     fontSize: 18.w,
      //                     fontWeight: FontWeight.bold,
      //                     color: isDark ? Colors.white : Colors.white,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(top: 300, left: 15, right: 15),
      //           child: Obx(() => Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   SizedBox(
      //                     height: 290.h,
      //                   ),
      //                   CustomTextField(
      //                     label: 'enter_store_name'.tr,
      //                     hintText: 'store_name'.tr,
      //                     controller: usernameController,
      //                     errorText: nameError.value.isNotEmpty
      //                         ? nameError.value
      //                         : null,
      //                     onChanged: (value) => nameError.value = '',
      //                   ),
      //                   const SizedBox(height: 20),
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Expanded(
      //                         child: CustomTextField(
      //                           textDirection: TextDirection.ltr,
      //                           label: 'enter_phone_number'.tr,
      //                           hintText: '511234567',
      //                           controller: phoneController,
      //                           keyboardType: TextInputType.phone,
      //                           maxLength: 10,
      //                           errorText: phoneError.value.isNotEmpty
      //                               ? phoneError.value
      //                               : null,
      //                           // onChanged: (value) {
      //                           //   phoneError.value = '';
      //                           //   // Client-side validation on input change
      //                           //   if (value.isNotEmpty && !RegExp(r'^\d{9,10}$').hasMatch(value)) {
      //                           //     phoneError.value = 'يجب أن يكون رقم الجوال على الاقل 9  أرقام';
      //                           //   }
      //                           // },
      //                         ),
      //                       ),
      //                       const SizedBox(width: 10),
      //                       Column(
      //                         children: [
      //                           const Padding(
      //                             padding: EdgeInsets.all(8.0),
      //                             child: Row(
      //                               children: [Text('')],
      //                             ),
      //                           ),
      //                           _buildCountryCodePicker(
      //                             isDark: isDark,
      //                             selectedCountryCode: selectedCountryCode,
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                   const SizedBox(height: 20),
      //                   CustomTextField(
      //                     label: 'enter_email'.tr,
      //                     hintText: 'jjj@gmail.com',
      //                     controller: emailController,
      //                     keyboardType: TextInputType.emailAddress,
      //                     errorText: emailError.value.isNotEmpty
      //                         ? emailError.value
      //                         : null,
      //                     onChanged: (value) => emailError.value = '',
      //                   ),
      //                   const SizedBox(height: 20),
      //                   CustomTextField(
      //                     label: 'enter_password'.tr,
      //                     hintText: '*********',
      //                     controller: passwordController,
      //                     keyboardType: TextInputType.visiblePassword,
      //                     obscureText: obscurePassword.value,
      //                     errorText: passwordError.value.isNotEmpty
      //                         ? passwordError.value
      //                         : null,
      //                     onChanged: (value) => passwordError.value = '',
      //                     suffixIcon: obscurePassword.value
      //                         ? Icons.visibility_off
      //                         : Icons.visibility,
      //                     onSuffixIconTap: () => obscurePassword.toggle(),
      //                   ),
      //                   const SizedBox(height: 20),
      //                   CustomTextField(
      //                     label: 'confirm_password'.tr,
      //                     hintText: '*********',
      //                     controller: confirmPasswordController,
      //                     keyboardType: TextInputType.visiblePassword,
      //                     obscureText: obscureConfirmPassword.value,
      //                     errorText: confirmPasswordError.value.isNotEmpty
      //                         ? confirmPasswordError.value
      //                         : null,
      //                     onChanged: (value) => confirmPasswordError.value = '',
      //                     suffixIcon: obscureConfirmPassword.value
      //                         ? Icons.visibility_off
      //                         : Icons.visibility,
      //                     onSuffixIconTap: () =>
      //                         obscureConfirmPassword.toggle(),
      //                   ),
      //                   const SizedBox(height: 20),
      //                   Row(
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       _buildStoreLogoPicker(
      //                         storeLogo,
      //                         isDark: isDark,
      //                         errorText: logoError.value.isNotEmpty
      //                             ? logoError.value
      //                             : null,
      //                       ),
      //                       const SizedBox(width: 10),
      //                       Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Text(
      //                             'choose_image'.tr,
      //                             style: GoogleFonts.tajawal(
      //                               fontSize: 18,
      //                               fontWeight: FontWeight.w500,
      //                               color: isDark ? Colors.white : Colors.black,
      //                             ),
      //                           ),
      //                           Text(
      //                             'upload_professional_image'.tr,
      //                             style: GoogleFonts.tajawal(
      //                                 fontSize: 14, color: Colors.grey),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                   const SizedBox(height: 20),
      //                   CustomTextField(
      //                     label: 'description'.tr,
      //                     hintText: 'store_description'.tr,
      //                     controller: descriptionController,
      //                     maxLines: 3,
      //                     errorText: descriptionError.value.isNotEmpty
      //                         ? descriptionError.value
      //                         : null,
      //                     onChanged: (value) => descriptionError.value = '',
      //                   ),
      //                   const SizedBox(height: 20),
      //                   Obx(() => Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Text(
      //                             'categories'.tr,
      //                             style: GoogleFonts.tajawal(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500,
      //                               color: isDark ? Colors.white : Colors.black,
      //                             ),
      //                           ),
      //                           const SizedBox(height: 8),
      //                           categoryController.isLoading.value
      //                               ? const Center(
      //                                   child: CircularProgressIndicator())
      //                               : CustomDropdown(
      //                                   categories:
      //                                       categoryController.categories,
      //                                   selectedCategories: registerController
      //                                       .selectedCategories,
      //                                   isDark: isDark,
      //                                   errorText:
      //                                       categoryError.value.isNotEmpty
      //                                           ? categoryError.value
      //                                           : null,
      //                                 ),
      //                         ],
      //                       )),
      //                   const SizedBox(height: 20),
      //                   CustomTextField(
      //                     label: 'store_link'.tr,
      //                     hintText: 'https://example.com',
      //                     controller: storeLinkController,
      //                     keyboardType: TextInputType.url,
      //                     errorText: storeLinkError.value.isNotEmpty
      //                         ? storeLinkError.value
      //                         : null,
      //                     onChanged: (value) => storeLinkError.value = '',
      //                   ),
      //                   const SizedBox(height: 30),
      //                   Align(
      //                     alignment: Alignment.centerRight,
      //                     child: GestureDetector(
      //                       onTap: () => Get.toNamed(AppRoutes.login),
      //                       child: Padding(
      //                         padding: const EdgeInsets.all(8.0),
      //                         child: Row(
      //                           mainAxisSize: MainAxisSize.min,
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           children: [
      //                             Text(
      //                               'already_have_account'.tr,
      //                               style: GoogleFonts.tajawal(
      //                                 fontSize: 14,
      //                                 color: isDark
      //                                     ? Colors.grey[400]
      //                                     : Colors.grey,
      //                               ),
      //                             ),
      //                             const SizedBox(width: 4),
      //                             Text(
      //                               'login_now'.tr,
      //                               style: GoogleFonts.tajawal(
      //                                 fontSize: 14,
      //                                 color: AppColors.primary,
      //                                 fontWeight: FontWeight.bold,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                   const SizedBox(height: 30),
      //                   CustomButton(
      //                     text: categoryController.isLoading.value ||
      //                             registerController.isLoading.value
      //                         ? 'creating_account'.tr
      //                         : 'create_account_and_login'.tr,
      //                     textSize: 18,
      //                     textFontWeight: FontWeight.bold,
      //                     color: AppColors.primary,
      //                     textColor: Colors.white,
      //                     onPressed: categoryController.isLoading.value ||
      //                             registerController.isLoading.value
      //                         ? null
      //                         : () async {
      //                             final response = await _handleRegister(
      //                               context,
      //                               registerController,
      //                               usernameController,
      //                               emailController,
      //                               phoneController,
      //                               passwordController,
      //                               confirmPasswordController,
      //                               descriptionController,
      //                               _handlehHttpsNotFound(storeLinkController),
      //                               storeLogo,
      //                               nameError,
      //                               emailError,
      //                               phoneError,
      //                               passwordError,
      //                               confirmPasswordError,
      //                               descriptionError,
      //                               storeLinkError,
      //                               logoError,
      //                               categoryError,
      //                               selectedCountryCode,
      //                             );
      //                             if (response != null) {
      //                               final token =
      //                                   response['data']['token'] as String?;
      //                               if (token != null && token.isNotEmpty) {
      //                                 await SharedPrefsConstants.saveToken(
      //                                     token);
      //
      //                                 if(kIsWeb){
      //                                   Get.to(() => SubscriptionsScreen());
      //                                 }else{
      //                                   var isIOs = Platform.isIOS;
      //
      //                                   Get.to(() => isIOs
      //                                       ? SubscriptionsScreen()
      //                                       : AndroidSubscriptionsScreen());
      //                                 }
      //
      //                                 // Get.offAllNamed(AppRoutes.sub);
      //                               }
      //                             }
      //                           },
      //                   ),
      //                   SizedBox(height: 50.h),
      //                 ],
      //               )),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  TextEditingController _handlehHttpsNotFound(
      TextEditingController controller) {
    if (controller.text.contains('https://')) {
      return controller;
    }
    TextEditingController newController = TextEditingController();
    newController.text = 'https://' + controller.text;
    return newController;
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
      child: Obx(() => DropdownButtonHideUnderline(
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
                        errorBuilder: (context, error, stackTrace) => Icon(
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
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.flag_circle,
                          color: isDark ? Colors.grey[600] : Colors.grey,
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

  Widget _buildStoreLogoPicker(
    Rx<XFile?> storeLogo, {
    required bool isDark,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'store_logo'.tr,
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
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
              // Compress image
              final dir = await getTemporaryDirectory();
              final targetPath = path.join(
                  dir.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");
              var result = await FlutterImageCompress.compressAndGetFile(
                pickedFile.path,
                targetPath,
                quality: 60, // 60–80 is a good range
              );
              storeLogo.value =
                  result != null ? XFile(result.path) : pickedFile;
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
                    child: storeLogo.value == null
                        ? Center(
                            child: Icon(
                              Icons.image,
                              size: 60,
                              color: isDark ? Colors.white : Colors.white,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              File(storeLogo.value!.path),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
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
                        Icons.add,
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

  Future<Map<String, dynamic>?> _handleRegister(
    BuildContext context,
    RegisterController registerController,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    TextEditingController descriptionController,
    TextEditingController storeLinkController,
    Rx<XFile?> storeLogo,
    RxString nameError,
    RxString emailError,
    RxString phoneError,
    RxString passwordError,
    RxString confirmPasswordError,
    RxString descriptionError,
    RxString storeLinkError,
    RxString logoError,
    RxString categoryError,
    RxString selectedCountryCode,
  ) async {
    bool hasError = false;

    // Reset all errors
    nameError.value = '';
    phoneError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    descriptionError.value = '';
    storeLinkError.value = '';
    logoError.value = '';
    categoryError.value = '';

    // Client-side validation
    if (usernameController.text.trim().isEmpty) {
      nameError.value = 'enter_store_name_required'.tr;
      hasError = true;
    }
    if (!(usernameController.text.length>2)) {
      nameError.value = 'enter_store_name_required'.tr;
      hasError = true;
    }
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'phone_required'.tr;
      hasError = true;
    } else if (!RegExp(r'^\d{9,10}$').hasMatch( phoneController.text.trim())) {
      phoneError.value = 'phone_length_error_min'.tr;
      hasError = true;
    }
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'valid_email_required'.tr;
      hasError = true;
    }
    if (emailController.text.trim().isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(emailController.text.trim())) {
      emailError.value = 'valid_email_required'.tr;
      hasError = true;
    }
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'password_required'.tr;
      hasError = true;
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      confirmPasswordError.value = 'confirm_password_required'.tr;
      hasError = true;
    }
    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'password_mismatch'.tr;
      hasError = true;
    }
    if (descriptionController.text.trim().isEmpty) {
      descriptionError.value = 'store_description_required'.tr;
      hasError = true;
    }
    // store link validation
    final RegExp linkRegx =
        RegExp(r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$');
    if (storeLinkController.text.trim().isEmpty) {
      storeLinkError.value = 'store_link_required'.tr;
      hasError = true;
    } else if (!linkRegx.hasMatch(storeLinkController.text.trim())) {
      storeLinkError.value = 'invalid_store_link'.tr;
      hasError = true;
    }
    if (storeLogo.value == null) {
      logoError.value = 'store_logo_required'.tr;
      hasError = true;
    }
    if (registerController.selectedCategories.isEmpty) {
      categoryError.value = 'category_required'.tr;
      hasError = true;
    }

    if (hasError) {
      return null;
    }

    final phoneWithCountryCode =
        '${selectedCountryCode.value}${phoneController.text.trim()}';
    final response = await registerController.register(
      name: usernameController.text.trim(),
      phone: phoneWithCountryCode,
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      passwordConfirmation: confirmPasswordController.text.trim(),
      description: descriptionController.text.trim(),
      link: storeLinkController.text.trim(),
      logo: storeLogo.value,
      categories: registerController.selectedCategories,
    );

    // Handle API errors
    if (registerController.validationErrors.isNotEmpty) {
      final errorTranslations = {
        'email': {
          'Email already exists': 'email_exists'.tr,
        },
        'password': {
          'Password must be at least 8 characters': 'password_min_length'.tr,
        },
        'phone': {
          'Phone number already exists': 'phone_exists'.tr,
        },
        'link': {
          'The link field must be a valid URL.': 'invalid_url'.tr,
        },
      };

      registerController.validationErrors.forEach((key, errorList) {
        final errorText = errorList.isNotEmpty
            ? (errorTranslations[key]?[errorList[0]] ?? errorList[0])
            : '';
        switch (key) {
          case 'name':
            nameError.value = errorText;
            break;
          case 'phone':
            phoneError.value = errorText;
            break;
          case 'email':
            emailError.value = errorText;
            break;
          case 'password':
            passwordError.value = errorText;
            break;
          case 'password_confirmation':
            confirmPasswordError.value = errorText;
            break;
          case 'description':
            descriptionError.value = errorText;
            break;
          case 'link':
            storeLinkError.value = errorText;
            break;
          case 'logo':
            logoError.value = errorText;
            break;
          case 'categories':
            categoryError.value = errorText;
            break;
          default:
            print('Unexpected error key: $key, errors: $errorList');
            nameError.value = errorText;
        }
      });
    }

    return response;
  }
}
