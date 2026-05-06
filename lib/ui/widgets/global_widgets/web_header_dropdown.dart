import 'package:dieaya_user/controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/animated_web_header_button.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/web_header_dropdown.dart';
import 'package:dieaya_user/utils/app_colors.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowDropDown extends StatefulWidget {
  final List<Widget> items;

  @override
  State<ShowDropDown> createState() => _ShowDropDownState();

  ShowDropDown({required this.items});
}

class _ShowDropDownState extends State<ShowDropDown> {
  LayerLink link = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isOpened = false;

  createDropdown() {
    // discard any open dropdown solve an issue
    if (isOpened) return;
    final overLay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 200.w,
        child: CompositedTransformFollower(
          link: link,
          offset: const Offset(0, 35),
          child: MouseRegion(
            onExit: (event) => closeDropdown(),
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12.r),
              color: context.isDarkMode?null:AppColors.white,
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 9.w),
                separatorBuilder: (context, index) => Divider(),
                itemCount: widget.items.length,
                itemBuilder: (context, index) => widget.items[index],
              ),
            ),
          ),
        ),
      ),
    );
    overLay.insert(_overlayEntry!);
    setState(() {
      isOpened = true;
    });
  }

  closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isOpened = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: MouseRegion(
        onEnter: (event) => createDropdown(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 170),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
              color: isOpened ? Colors.white.withValues(alpha: 0.2) : null,
              borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            children: [
              CustomTextSolveIssue(
                'shop'.tr,
                style: GoogleFonts.tajawal(
                  fontSize: 12.w,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
