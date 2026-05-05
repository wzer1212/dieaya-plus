import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final Color? color;

  const CustomSvgImage({
    required this.image,
    this.height,
    this.width,
    this.boxFit,
    Key? key, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(color: color,

      image,
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.none,

    );
  }
}
