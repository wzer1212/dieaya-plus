import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Reduced vertical padding
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.tajawal(
                // Consistent font
                fontSize: 20, // Slightly larger header font
                // fontWeight: FontWeight.w500,
                color: Color(0xff666565),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionText != null && onActionPressed != null)
            InkWell(
              onTap: onActionPressed,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0), // Add padding for touch target
                child: Row(
                  children: [

                    Text(
                      actionText!,
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                        AppColors.grey, // Use primary color for action text
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,size: 16,color: Colors.grey,),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
