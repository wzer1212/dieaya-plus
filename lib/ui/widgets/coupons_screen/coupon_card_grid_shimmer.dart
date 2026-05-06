import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CouponCardGridShimmer extends StatelessWidget {
  const CouponCardGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45; // same ratio as your card
    final cardHeight = cardWidth * 1.33;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(cardWidth * 0.08),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: EdgeInsets.only(right: cardWidth * 0.08, top: cardWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Top Row (logo + store name)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: cardWidth * 0.1,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Container(
                    width: cardWidth * 0.25,
                    height: 14,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),

              // Discount Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: cardWidth * 0.25,
                    height: 14,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: cardHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: cardWidth * 0.25,
                        height: 30,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(width: 6),
                      Container(
                        width: cardWidth * 0.06,
                        height: 14,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ],
              ),

              // Bottom (copy icon + coupon code)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: cardWidth * 0.10,
                    height: cardWidth * 0.10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: cardWidth * 0.05),
                  Container(
                    width: cardWidth * 0.25,
                    height: 16,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
