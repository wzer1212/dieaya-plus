

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GridCardShimmer extends StatelessWidget {
  const GridCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            const SizedBox(height: 8),
            // Title placeholder
            Container(
              height: 16,
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            // Subtitle placeholder
            Container(
              height: 14,
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
