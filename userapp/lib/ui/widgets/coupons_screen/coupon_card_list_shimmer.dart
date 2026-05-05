import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CouponListCardShimmer extends StatelessWidget {
  const CouponListCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9;
    final cardHeight = screenHeight * 0.190;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(cardWidth * 0.04),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: EdgeInsets.all(cardWidth * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Logo + Name + Discount %
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Logo placeholder
                        CircleAvatar(
                          radius: cardWidth * 0.07,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        // Market name placeholder
                        Container(
                          width: cardWidth * 0.35,
                          height: 14,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: cardWidth * 0.08,
                        height: 12,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Container(
                        width: cardWidth * 0.12,
                        height: 24,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Container(
                        width: cardWidth * 0.04,
                        height: 12,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ],
              ),
              // Bottom Row: Coupon code + Copy icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: cardWidth * 0.3,
                    height: 14,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(width: cardWidth * 0.03),
                  Container(
                    width: cardWidth * 0.05,
                    height: cardWidth * 0.05,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
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
