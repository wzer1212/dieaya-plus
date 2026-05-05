import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class SnackBarConstantVersion1 {
  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      titleText: Text(
        title,
        style: GoogleFonts.notoKufiArabic(
          color: Colors.white,
          fontWeight: FontWeight.bold, // Optional: adjust fontWeight
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.notoKufiArabic(
          color: Colors.white,
        ),
      ),
    );
  }

  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      icon: const Icon(Icons.error, color: Colors.white),
      titleText: Text(
        title,
        style: GoogleFonts.notoKufiArabic(
          color: Colors.white,
          fontWeight: FontWeight.bold, // Optional: adjust fontWeight
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.notoKufiArabic(
          color: Colors.white,
        ),
      ),
    );
  }

  static void showWarningSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.warning,
      colorText: Colors.black,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      icon: const Icon(Icons.warning, color: Colors.black),
      titleText: Text(
        title,
        style: GoogleFonts.notoKufiArabic(
          color: Colors.black,
          fontWeight: FontWeight.bold, // Optional: adjust fontWeight
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.notoKufiArabic(
          color: Colors.black,
        ),
      ),
    );
  }

  static void showInfoSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      icon: const Icon(Icons.info, color: Colors.white),
      titleText: Text(
        title,
        style: GoogleFonts.notoKufiArabic(
          color: Colors.white,
          fontWeight: FontWeight.bold, // Optional: adjust fontWeight
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.notoKufiArabic(
          color: Colors.white,
        ),
      ),
    );
  }
}