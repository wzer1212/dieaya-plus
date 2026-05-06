import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'dart:convert';

class AppTranslations extends Translations {
  static Map<String, Map<String, String>> _translations = {};

  @override
  Map<String, Map<String, String>> get keys => _translations;

  // Static method to load translations from JSON files
  static Future<void> loadTranslations() async {
    try {
      // Load English translations
      String enJson = await rootBundle.loadString('assets/locales/en.json');
      Map<String, dynamic> enMap = jsonDecode(enJson);
      _translations['en'] = enMap.map((key, value) => MapEntry(key, value.toString()));

      // Load Arabic translations
      String arJson = await rootBundle.loadString('assets/locales/ar.json');
      Map<String, dynamic> arMap = jsonDecode(arJson);
      _translations['ar'] = arMap.map((key, value) => MapEntry(key, value.toString()));

      // Update GetX translations
      Get.addTranslations(_translations);
    } catch (e) {
      print('Error loading translations: $e');
      // Optionally, set fallback translations
      _translations = {
        'en': {'error': 'Translation loading failed'},
        'ar': {'error': 'فشل تحميل الترجمة'},
      };
    }
  }
}