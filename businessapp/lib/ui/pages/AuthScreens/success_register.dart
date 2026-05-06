import 'package:dieaya_market/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessRegister extends StatelessWidget {
  const SuccessRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/dwq.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                    text: 'continue_button'.tr,
                    textFontWeight: FontWeight.bold,
                    textSize: 22,
                    onPressed: () {
                      Get.offAllNamed('/navbar');
                    })),
          )
        ],
      ),
    );
  }
}
