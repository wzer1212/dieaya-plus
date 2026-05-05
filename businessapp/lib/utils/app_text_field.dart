import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/ThemeController/theme_controller.dart';
import 'app_colors.dart';

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
  final bool readOnly;
  final EdgeInsets containerPadding;
  final TextStyle? textStyle;
  final TextStyle? labelHeadLineStyle;
  final TextStyle? hintStyle;
  final int maxLines;
  final int? maxLength;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap; // New onTap parameter
  final bool showEditIcon;
  final TextDirection? textDirection;
  final bool? isDigits;
  final bool isRequired;

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
    this.readOnly = false,
    this.containerPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    this.textStyle,
    this.hintStyle,
    this.maxLines = 1,
    this.maxLength,
    this.errorText,
    this.onChanged,
    this.onTap, // Add to constructor
    this.showEditIcon = false,
    this.textDirection = TextDirection.rtl,
    this.isDigits = false,
    this.labelHeadLineStyle,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    final TextAlign textAlign =
        textDirection == TextDirection.ltr ? TextAlign.left : TextAlign.right;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: label,
                        style: labelHeadLineStyle ??
                            GoogleFonts.tajawal(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Color(0xff5D5C5C),
                            ),
                      ),
                      if (isRequired)
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
                if (showEditIcon)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.mode_edit_outlined,
                        color: AppColors.primary),
                  ),
              ],
            ),
          ),
        Container(
          height: maxLines == 1 ? 50 : null,
          // Adjusted inputHeight to a fixed value
          padding: containerPadding,
          decoration: BoxDecoration(
            color: enabled
                ? Color(0xff9C9C9C).withOpacity(0.15)
                : Color(0xff9C9C9C).withOpacity(0.15),
            borderRadius: BorderRadius.circular(25), // Adjusted for consistency
            border: Border.all(
              color: borderColor ?? Colors.grey.shade300,
              width: borderWidth,
            ),
          ),
          child: Row(
            textDirection: textDirection,
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
                  textAlign: textAlign,
                  textDirection: textDirection,
                  enabled: enabled,
                  readOnly: readOnly,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  onTap: onTap,
                  enableInteractiveSelection: true,
                  onSubmitted: (value) {

                  },
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
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 5.0),
            child: Text(
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
