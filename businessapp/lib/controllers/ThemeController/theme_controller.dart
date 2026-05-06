import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    loadTheme();
    super.onInit();
  }

  void setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    saveTheme(mode);
  }

  void saveTheme(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("themeMode", mode.toString());
  }

  void loadTheme() async {
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
      Get.changeThemeMode(themeMode.value);
    }
  }
}


