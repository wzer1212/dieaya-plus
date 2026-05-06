
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _storage = GetStorage();
  final locale = const Locale('ar').obs; // Default to Arabic

  LanguageController() {
    String? savedLanguage = _storage.read('language');
    if (savedLanguage != null) {
      locale.value = Locale(savedLanguage);
    }
  }

  void changeLanguage(String languageCode) {
    if (!['ar', 'en'].contains(languageCode)) {
      Get.snackbar('error'.tr, 'unsupported_language'.tr);
      return;
    }
    locale.value = Locale(languageCode);
    _storage.write('language', languageCode);
    Get.updateLocale(Locale(languageCode));
    // Remove Get.forceAppUpdate() as it's not always reliable
  }
}