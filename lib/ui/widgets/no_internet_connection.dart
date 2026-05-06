import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        ClipPath(
          clipper: CustomClip(),
          child: Container(
            decoration:  const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            width: double.maxFinite,
            height: 200,
            child: const Center(
              child: Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
        Positioned(
          top: 180,
          left: 0,
          right: 0,
          child: Column(
            children: [
              CustomTextSolveIssue(
                'أوبس!',
                style: GoogleFonts.tajawal(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextSolveIssue(
                'لم يتم العثور على اتصال بالإنترنت.',
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              CustomTextSolveIssue(
                'تحقق من اتصالك وحاول مرة أخرى.',
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2); // Left side height
    path.lineTo(size.width, size.height); // Right side height
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}