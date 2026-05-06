import 'package:dieaya_market/ui/widgets/global_widgets/custom_text.dart';
import 'package:dieaya_market/utils/app_colors.dart';
import 'package:dieaya_market/utils/constants/icon_constants.dart';
import 'package:dieaya_market/utils/custom_svg.dart';
import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdCustomTextField extends StatefulWidget {
  AdCustomTextField({
    required this.focusNode,
    required this.hint,
    required this.controller,
    this.onChanged,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.maxLine,
    this.readOnly,
    this.obscureText = false,
    this.width,
    this.height,
    this.backGroundColor,
    this.radiusCircular,
    this.showShadow,
    this.minLines,
    this.searchIcon,
    this.onTap,
    this.isDisabled,
    this.validator,
    this.onPressedPassword,
    this.obscureTextHideIcon,
    Key? key,
    this.prefixIcon,
    required this.hitOverTextField,
    this.desibleBorder = false,
    this.borderColor,
  }) : super(key: key);
  final Color? borderColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLine;
  final int? minLines;
  final int? maxLength;
  final String? hint;
  final String hitOverTextField;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode focusNode;
  final bool? isDisabled;
  final bool? readOnly;
  final bool? obscureText;
  final bool? obscureTextHideIcon;
  final double? width;
  final double? height;
  final Color? backGroundColor;
  final double? radiusCircular;
  final bool? showShadow;
  final bool? searchIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final VoidCallback? onPressedPassword;
  final Widget? prefixIcon;
  final bool? desibleBorder;

  @override
  State<AdCustomTextField> createState() => _AdCustomTextFieldState();
}

class _AdCustomTextFieldState extends State<AdCustomTextField> {
  bool obscureText = false;

  @override
  void initState() {
    obscureText = widget.obscureText ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              text: widget.hitOverTextField,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black,

            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: widget.height,
          child: TextFormField(

            autovalidateMode: AutovalidateMode.onUserInteraction,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            textInputAction: TextInputAction.done,
            focusNode: widget.focusNode,
            controller: widget.controller,
            validator: widget.validator,
            onChanged: (v) =>
                widget.onChanged == null ? null : widget.onChanged!(v),
            onSaved: (v) {
              widget.focusNode.unfocus();
            },
            onTap: widget.onTap,
            onEditingComplete: () {
              widget.focusNode.nextFocus();
            },
            onFieldSubmitted: (value) {
              widget.focusNode.unfocus();
            },
            style: TextStyle(color: AppColors.black, fontSize: 16.sp,fontWeight: FontWeight.w600),
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            maxLines: widget.maxLine ?? 1,
            readOnly: widget.readOnly ?? false,
            obscureText: obscureText,
            decoration: InputDecoration(

              suffixIcon: (widget.obscureTextHideIcon ?? false)
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: (obscureText)
                          ? Icon(
                              Icons.visibility,
                              color: AppColors.grey2,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: AppColors.grey2,
                            ),
                    )
                  : widget.searchIcon == true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                    color: AppColors.black,
                                    shape: BoxShape.circle),
                                child: CustomSvgImage(
                                    image: IconConstants.search,
                                    height: 20.h,
                                    width: 20.w)),
                          ],
                        )
                      : null,
              prefixIcon: widget.prefixIcon,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintText: widget.hint ?? "",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 17.h),
              errorBorder: widget.desibleBorder == true
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.radiusCircular ?? 30.r),
                      borderSide: BorderSide(color: Colors.red),
                    ),
              hintStyle:
                  TextStyle(fontSize: 14.sp, color: AppColors.grey),
              enabledBorder: widget.desibleBorder == true
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.radiusCircular ?? 30.r),
                      borderSide: BorderSide(
                          color: widget.borderColor ?? AppColors.lightGrey, width: 1),
                    ),
              focusedBorder: widget.desibleBorder == true
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.radiusCircular ?? 30.r),
                      borderSide: BorderSide(
                          color: widget.borderColor ?? AppColors.lightGrey, width: 1),
                    ),
              border: widget.desibleBorder == true
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.radiusCircular ?? 30.r),
                      borderSide: BorderSide(
                          color: widget.borderColor ?? AppColors.lightGrey, width: 1),
                    ),
              filled: true,
              fillColor: widget.backGroundColor ?? Colors.grey[200],
              labelStyle:
                  TextStyle(fontSize: 10.sp, color: AppColors.grey2,fontWeight: FontWeight.w500),
              isDense: true,
              counterText: "",
            ),
          ),
        ),
      ],
    );
  }
}
