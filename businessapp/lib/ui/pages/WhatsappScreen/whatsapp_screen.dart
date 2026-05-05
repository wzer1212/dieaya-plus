import 'package:dieaya_market/Routes/app_routes.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/app_text_field.dart';
import '../../../controllers/PackgesController/use_packge_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import '../../../controllers/WhatsappController/whatsapp_controller.dart';
import '../../../utils/app_snackbars.dart';
import '../../widgets/buttons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';




class AddWhatsAppCampaignScreen extends StatelessWidget {
  const AddWhatsAppCampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers
    final WhatsAppCampaignController controller = Get.put(WhatsAppCampaignController(), tag: 'WhatsAppCampaignController');
    final ThemeController themeController = Get.put(ThemeController());
    final PackageUsageController packageUsageController = Get.put(PackageUsageController());
    final descriptionController = TextEditingController();
    final startDateController = TextEditingController();
    final marketLinkController = TextEditingController();
    final noteController = TextEditingController();
    final bool isDark = themeController.themeMode.value == ThemeMode.dark;

    // Reactive variables
    final descriptionError = ''.obs;
    final startDateError = ''.obs;
    final marketLinkError = ''.obs;
    final noteError = ''.obs;
    final advertiseImageError = ''.obs;
    final numbersFileError = ''.obs;
    final advertiseImage = Rxn<File>(); // For image file
    final numbersFile = Rxn<File>(); // For Excel file
    final isFetchingUsage = true.obs;
    final usageError = ''.obs;
    final selectedDateTime = Rxn<DateTime>();
    packageUsageController.fetchPackageUsage().then((success) {
      isFetchingUsage(false);
      if (!success) {
        usageError.value = packageUsageController.errorMessage.value;
      }
    });

    // File picker functions
    Future<void> pickImage() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result != null && result.files.single.path != null) {
          advertiseImage.value = File(result.files.single.path!);

        } else {
          advertiseImageError.value = 'no_image_selected'.tr;
        }
      } catch (e) {
        advertiseImageError.value = 'error_selecting_image'.tr;
        print('Error picking image: $e');
      }
    }

    Future<void> pickExcelFile() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx', 'xls'],
          allowMultiple: false,
        );
        if (result != null && result.files.single.path != null) {
          numbersFile.value = File(result.files.single.path!);
        } else {
          numbersFileError.value = 'no_file_selected'.tr;
        }
      } catch (e) {
        numbersFileError.value = 'error_selecting_file'.tr;
        print('Error picking Excel file: $e');
      }
    }

    // Date and time picker function
    Future<void> pickDateTime() async {
      // Show date picker
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(), // Restrict to today or later
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        // Show time picker after date is selected
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          // Combine date and time
          final DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          selectedDateTime.value = combinedDateTime;
          // Format the date and time for display and API
          startDateController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedDateTime);
          startDateError.value = '';
        }
      }
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Obx(() {
        final addWhatsAppCampaignUsage = packageUsageController.packageUsages
            .firstWhereOrNull((usage) => usage.tag == 'add_whatsapp_campaign');

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [AppColors.primary, AppColors.primary, Colors.black]
                      : [AppColors.primary, AppColors.primary, Colors.white],
                  stops: [0.0, 0.0, 5.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'add_whatsapp_campaign'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.notifications);
                        },
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
                                Get.toNamed(AppRoutes.notifications);
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
            if (isFetchingUsage.value)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (usageError.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      usageError.value,
                      style: GoogleFonts.tajawal(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'retry'.tr,
                      textSize: 18,
                      textFontWeight: FontWeight.bold,
                      onPressed: () {
                        isFetchingUsage(true);
                        usageError.value = '';
                        packageUsageController.fetchPackageUsage().then((success) {
                          isFetchingUsage(false);
                          if (!success) {
                            usageError.value = packageUsageController.errorMessage.value;
                          }
                        });
                      },
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                          label: 'description'.tr,
                          hintText: 'وصف الإعلان'.tr,
                          controller: descriptionController,
                          maxLines: 4,
                          errorText: descriptionError.value.isNotEmpty ? descriptionError.value : null,
                          onChanged: (value) => descriptionError.value = '',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'صورة الإعلان'.tr,
                              style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: isDark ? Colors.grey : Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: advertiseImage.value == null
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('الصورة هنا'.tr, style: GoogleFonts.tajawal()),
                                      Text(
                                        textAlign: TextAlign.center,
                                        'الامتدادات المسموحة: .jpg, .png, .jpeg | الحد الأقصى للحجم: 5MB'.tr,
                                        style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                      : Text(
                                    advertiseImage.value!.path.split('/').last,
                                    style: GoogleFonts.tajawal(),
                                  ),
                                ),
                              ),
                            ),
                            if (advertiseImageError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  advertiseImageError.value,
                                  style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ملف الأرقام*'.tr,
                              style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: pickExcelFile,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: isDark ? Colors.grey : Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: numbersFile.value == null
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('الملف هنا'.tr, style: GoogleFonts.tajawal()),
                                      Text(
                                        textAlign: TextAlign.center,
                                        'الامتدادات المسموحة: .xlsx, .csv | يجب أن يحتوي العمود الأول على أرقام الجوالات بصيغة دولية'.tr,
                                        style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                      : Text(
                                    numbersFile.value!.path.split('/').last,
                                    style: GoogleFonts.tajawal(),
                                  ),
                                ),
                              ),
                            ),
                            if (numbersFileError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  numbersFileError.value,
                                  style: GoogleFonts.tajawal(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                          label: 'التوقيت للبداية'.tr,
                          hintText: 'اختر تاريخ ووقت البدء'.tr,
                          controller: startDateController,
                          readOnly: true, // Make the field read-only

                          onTap: pickDateTime, // Trigger date picker on tap
                          errorText: startDateError.value.isNotEmpty ? startDateError.value : null,
                          suffixIcon: Icons.calendar_today,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                          label: 'رابط المتجر أو المنتج*'.tr,
                          hintText: 'https://'.tr,
                          controller: marketLinkController,
                          errorText: marketLinkError.value.isNotEmpty ? marketLinkError.value : null,
                          onChanged: (value) => marketLinkError.value = '',
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Remaining count UI
                      if (addWhatsAppCampaignUsage != null && addWhatsAppCampaignUsage.remaining != 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            addWhatsAppCampaignUsage.remaining == null
                                ? 'غير محدود'.tr
                                : '${'عدد المحاولات'.tr}: ${addWhatsAppCampaignUsage.remaining}',
                            style: GoogleFonts.tajawal(
                              fontSize: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          margin: EdgeInsets.only(bottom: 60.h),

                          text: controller.isLoading.value ? 'creating'.tr : 'create'.tr,
                          textSize: 22,
                          textFontWeight: FontWeight.bold,
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                            print('Create button pressed');
                            descriptionError.value = '';
                            advertiseImageError.value = '';
                            numbersFileError.value = '';
                            startDateError.value = '';
                            noteError.value = '';
                            marketLinkError.value = '';

                            // Basic client-side validation
                            if (descriptionController.text.isEmpty) {
                              descriptionError.value = 'description_required'.tr;
                              return;
                            }
                            //handle to no image selected
                            if (advertiseImage.value == null) {
                              advertiseImageError.value = 'image_cannot_empty'.tr;
                              return;
                            }
                            //handle to no file selected
                            if (numbersFile.value == null) {
                              numbersFileError.value = 'file_cannot_empty'.tr;
                              return;
                            }

                            if (startDateController.text.isEmpty) {
                              startDateError.value = 'start_date_required'.tr;
                              return;
                            }
                            if (marketLinkController.text.isEmpty) {
                              marketLinkError.value = 'market_link_required'.tr;
                              return;
                            }
                            if (
                            !isValidUrl(marketLinkController.text)) {
                              marketLinkError.value = 'market_link_not_valid'.tr;
                              return;
                            }

                            try {
                              // Package usage check
                              print('add_whatsapp_campaign remaining: ${addWhatsAppCampaignUsage?.remaining}');
                              if (addWhatsAppCampaignUsage == null) {
                                _showFeatureNotIncludedDialog(
                                  context,
                                  title: 'feature_not_available'.tr,
                                  message: 'whatsapp_campaign_not_in_package'.tr,
                                  buttonText: 'ok'.tr,
                                );
                                return;
                              }
                              if (addWhatsAppCampaignUsage.remaining == 0) {
                                _showLimitReachedDialog(
                                  context,
                                  title: 'limit_reached'.tr,
                                  message: 'add_whatsapp_campaign_limit_reached'.tr,
                                  buttonText: 'ok'.tr,
                                );
                                return;
                              }

                              // Proceed with campaign creation
                              final success = await controller.addWhatsAppCampaign(
                                description: descriptionController.text,
                                advertise_image: advertiseImage.value,
                                numbers_file: numbersFile.value,
                                start_date: startDateController.text,
                                note: noteController.text.isNotEmpty ? noteController.text : null,
                                market_link: marketLinkController.text,
                              );
                              print('addWhatsAppCampaign result: $success');

                              if (success) {
                                print('Refetching package usage');
                                await packageUsageController.fetchPackageUsage();
                                print('Showing success snackbar');
                                SnackBarConstantVersion1.showSuccessSnackbar('success'.tr, 'campaign_created'.tr);
                                print('Navigating back');
                                await Future.delayed(const Duration(seconds: 1));
                                Get.back();
                              } else {
                                print('Handling error: ${controller.validationErrors}, ${controller.errorMessage.value}');
                                if (controller.validationErrors.isNotEmpty) {
                                  if (controller.validationErrors.containsKey('description')) {
                                    descriptionError.value = controller.validationErrors['description']!;
                                  }
                                  if (controller.validationErrors.containsKey('advertise_image')) {
                                    advertiseImageError.value = controller.validationErrors['advertise_image']!;
                                  }
                                  if (controller.validationErrors.containsKey('numbers_file')) {
                                    numbersFileError.value = controller.validationErrors['numbers_file']!;
                                  }
                                  if (controller.validationErrors.containsKey('start_date')) {
                                    startDateError.value = controller.validationErrors['start_date']!;
                                  }
                                  if (controller.validationErrors.containsKey('note')) {
                                    noteError.value = controller.validationErrors['note']!;
                                  }
                                  if (controller.validationErrors.containsKey('market_link')) {
                                    marketLinkError.value = controller.validationErrors['market_link']!;
                                  }
                                } else {
                                  print('Showing error snackbar: ${controller.errorMessage.value}');
                                  SnackBarConstantVersion1.showErrorSnackbar('error'.tr, controller.errorMessage.value);
                                }
                              }
                            } catch (e) {
                              print('Exception in onPressed: $e');
                              SnackBarConstantVersion1.showErrorSnackbar('error'.tr, 'unexpected_error'.tr);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
  bool isValidUrl(String url) {
    final urlRegExp = RegExp(
      r'^(www\.)[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$',
      caseSensitive: false,
    );

    return urlRegExp.hasMatch(url.trim());
  }
  static void _showLimitReachedDialog(
      BuildContext context, {
        required String title,
        required String message,
        required String buttonText,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold),
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
                text: buttonText,
                textSize: 18,
                textFontWeight: FontWeight.bold,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showFeatureNotIncludedDialog(
      BuildContext context, {
        required String title,
        required String message,
        required String buttonText,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 60),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold),
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
                text: buttonText,
                textSize: 18,
                textFontWeight: FontWeight.bold,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


