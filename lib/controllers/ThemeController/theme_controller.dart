import 'package:dieaya_user/utils/caching_sevice/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    loadTheme();
    super.onInit();
  }

  void setThemeMode(ThemeMode mode) async {
    try {
      themeMode.value = mode;
      Get.changeThemeMode(mode);
      await saveTheme(mode);
    } catch (e) {
      print('❌ [ThemeController] Error setting theme: $e');
    }
  }

  Future<void> saveTheme(ThemeMode mode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("themeMode", mode.toString());
      print('✅ [ThemeController] Theme saved: ${mode.toString()}');
    } catch (e) {
      print('❌ [ThemeController] Error saving theme: $e');
    }
  }

  Future<void> loadTheme() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? themeString = prefs.getString("themeMode");

      if (themeString != null) {
        if (themeString == ThemeMode.dark.toString()) {
          themeMode.value = ThemeMode.dark;
        } else if (themeString == ThemeMode.light.toString()) {
          themeMode.value = ThemeMode.light;
        } else {
          themeMode.value = ThemeMode.system;
        }
      } else {
        themeMode.value = ThemeMode.light;
      }

      Get.changeThemeMode(themeMode.value);
      print('✅ [ThemeController] Theme loaded: ${themeMode.value}');
    } catch (e) {
      print('❌ [ThemeController] Error loading theme: $e');
      themeMode.value = ThemeMode.light;
    } finally {
      isLoading.value = false;
    }
  }
}
