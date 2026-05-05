import 'package:dieaya_market/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatefulWidget {
  const CustomText(
      {super.key,
      required this.text,
      this.color,
      this.fontWeight,
      this.maxLines,
      this.textAlign,
      this.height,
      this.overFlowText,
      this.fontSize});

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? height;
  final TextOverflow? overFlowText;
  final double? fontSize;

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text,
        maxLines: widget.maxLines,
        textAlign: widget.textAlign,
        overflow: widget.overFlowText,
        style:  GoogleFonts.tajawal(
            fontWeight: widget.fontWeight,
            color: widget.color,
            fontSize: widget.fontSize ?? 15.sp,
            height: widget.height,
           ));
  }
}
