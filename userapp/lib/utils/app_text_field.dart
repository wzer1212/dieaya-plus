import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

const Color primaryColor = Color(0xFF00A9E0); // Bright blue from image
const Color lightBlueBackground = Color(0xFFE0F7FF); // Lighter blue for inputs
const Color greyTextColor = Colors.grey;
const double defaultPadding = 16.0;
const double inputHeight = 60.0;

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final VoidCallback? onPrefixIconTap;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final Color? borderColor;
  final double borderWidth;
  final bool showLabel;
  final bool enabled;
  final bool? isDigits;
  final bool readOnly; // New readOnly parameter
  final bool isRequired; // New required field indicator
  final EdgeInsets containerPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final int maxLines;
  final int? maxLength;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.onPrefixIconTap,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.borderColor,
    this.borderWidth = 1.0,
    this.showLabel = true,
    this.enabled = true,
    this.readOnly = false, // Default to false
    this.isRequired = false, // Default to false
    this.containerPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    this.textStyle,
    this.hintStyle,
    this.maxLines = 1,
    this.errorText,
    this.onChanged,
    this.maxLength, this.isDigits=false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showLabel) // Conditionally show the label
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CustomTextSolveIssue(
                  label,
                  style: textStyle ??
                      GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Color(0xff5D5C5C),
                      ),
                ),
                if (isRequired) // Show red asterisk for required fields
                  CustomTextSolveIssue(
                    ' *',
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                const Icon(Icons.mode_edit_outlined, color: Colors.grey),
              ],
            ),
          ),
        Container(
          height: maxLines == 1 ? inputHeight : null,
          // Use inputHeight for single-line, auto for multi-line
          padding: containerPadding,
          decoration: BoxDecoration(
            color: enabled
                ? Color(0xff9C9C9C).withOpacity(0.15)
                : Color(0xff9C9C9C).withOpacity(0.15),
            borderRadius: BorderRadius.circular(inputHeight / 2),
            border: Border.all(
              color: borderColor ?? Colors.grey.shade300,
              width: borderWidth,
            ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              if (prefixIcon != null)
                IconButton(
                  icon: Icon(
                    prefixIcon,
                    color: isDark ? Colors.white : Colors.black54,
                  ),
                  onPressed: onPrefixIconTap,
                ),
              Expanded(
                child: TextField(
                  inputFormatters: isDigits!
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  // textAlign: textAlign,
                  // textDirection: textDirection,
                  enabled: enabled,
                  readOnly: readOnly,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  // onTap: onTap,
                  // Pass onTap to TextField
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: hintStyle ??
                        GoogleFonts.tajawal(
                          fontSize: 16,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                    border: InputBorder.none,
                    suffixIcon: suffixIcon != null
                        ? IconButton(
                      icon: Icon(
                        suffixIcon,
                        color: isDark ? Colors.white : Colors.black54,
                      ),
                      onPressed: onSuffixIconTap,
                    )
                        : null,
                  ),
                  style: textStyle ??
                      GoogleFonts.tajawal(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                  onChanged: onChanged,
                  buildCounter: (context,
                      {required currentLength,
                        required isFocused,
                        maxLength}) =>
                  maxLength != null ? null : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) // Show error text if provided
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 5.0),
            child: CustomTextSolveIssue(
              errorText!,
              style: GoogleFonts.tajawal(
                fontSize: 12,
                color: Colors.red,
              ),
              textAlign: TextAlign.right,
            ),
          ),
      ],
    );
  }
}
