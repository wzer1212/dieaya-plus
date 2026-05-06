import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/ui/widgets/stores_card.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../../Utils/app_colors.dart';
import '../../Utils/app_sharedprefs_contants.dart';
import '../../controllers/FavController/fav_controller.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import '../../models/product_model.dart';
import 'custom_sheets.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';


//
// class ProductCardGrid extends StatelessWidget {
//   final Product product;
//   final VoidCallback? onTap;
//   final VoidCallback? onFavoriteTap;
//   final double? priceFontSize;
//   final double? priceCanceledFontSize;
//   final double? storeFontSize;
//   final double? descriptionFontSize;
//
//   const ProductCardGrid({
//     super.key,
//     required this.product,
//     this.onTap,
//     this.onFavoriteTap, this.priceFontSize, this.storeFontSize, this.descriptionFontSize, this.priceCanceledFontSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
//     bool isDark = themeController.themeMode.value == ThemeMode.dark;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final cardWidth = screenWidth * 0.45;
//
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isDark? [AppColors.primary, Colors.black]:[AppColors.primary, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: const BorderRadius.only(
//             topRight: Radius.circular(15),
//             topLeft: Radius.circular(15),
//           ),
//         ),
//         padding: const EdgeInsets.all(1.5),
//         child: Container(
//           decoration:  BoxDecoration(
//             color: isDark? Colors.black :Colors.white,
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(15),
//               topLeft: Radius.circular(15),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 30),
//                     child: Center(
//                       child: Container(
//                         width: !kIsWeb?200.h:double.infinity,
//                         height: ! kIsWeb?200.h:160.h,
//                         // color: Colors.red,
//                         child: Image.network(
//                           product.images.isNotEmpty ? product.images[0].image : '',
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) => const Center(
//                             child: Icon(
//                               Icons.broken_image,
//                               color: Colors.grey,
//                               size: 40,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     child: FavoriteButton(
//                       productId: product.id,
//                       onFavoriteTap: onFavoriteTap,
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Stack(
//                   children: [
//                     Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CustomTextSolveIssue(
//                               // product.market.nameAr,
//                               Get.locale?.languageCode == 'ar'
//                                   ? product.market.nameAr
//                                   : product.market.nameAr,
//                               style: GoogleFonts.tajawal(
//                                 fontSize:storeFontSize?? cardWidth * 0.06,
//                                 fontWeight: FontWeight.bold,
//                                 color: isDark? Colors.white: Color(0xff666565),
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             if (product.priceOffer.isNotEmpty &&
//                                 product.priceOffer != product.price)
//                               Container(
//                                 child: Row(
//                                   children: [
//                                     CustomTextSolveIssue(
//                                       '${product.price}',
//                                       style: GoogleFonts.tajawal(
//                                         fontSize: priceCanceledFontSize??cardWidth * 0.08,
//                                         color: Colors.grey,
//                                         decoration: TextDecoration.lineThrough,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     CustomTextSolveIssue(
//                                       '${product.priceOffer}',
//                                       style: GoogleFonts.tajawal(
//                                         fontSize:priceFontSize?? cardWidth * 0.13,
//                                         fontWeight: FontWeight.bold,
//                                         color: AppColors.primary,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Image.asset(
//                                       'assets/images/saCurancy.png',
//                                       height: cardWidth * 0.06,
//                                       color: isDark? Colors.white:Colors.grey,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             else
//                               Container(
//                                 child: Row(
//                                   children: [
//                                     CustomTextSolveIssue(
//                                       '${product.price}',
//                                       style: GoogleFonts.tajawal(
//                                         fontSize:priceFontSize?? cardWidth * 0.13,
//                                         fontWeight: FontWeight.bold,
//                                         color: AppColors.primary,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Image.asset(
//                                       'assets/images/saCurancy.png',
//                                       height: cardWidth * 0.06,
//                                       color: isDark? Colors.white : Colors.grey,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: CustomTextSolveIssue(
//                                 // product.descriptionAr,
//                                 Get.locale?.languageCode == 'ar'
//                                     ? product.nameAr
//                                     : product.nameEn,
//                                 textAlign: TextAlign.start,
//                                 style: GoogleFonts.tajawal(
//                                   fontSize: descriptionFontSize??cardWidth * 0.075,
//                                   color: isDark? Colors.white :Color(0xff666565),
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//




// class FavoriteButton extends StatelessWidget {
//   final int productId;
//   final VoidCallback? onFavoriteTap;
//
//   const FavoriteButton({
//     super.key,
//     required this.productId,
//     this.onFavoriteTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<FavoriteController>();
//
//     return Obx(() {
//       final isFavorite = controller.isFavorite(productId: productId);
//       final isLoading = controller.isLoading.value;
//
//       return GestureDetector(
//         onTap: isLoading
//             ? null // Disable tap during loading
//             : () async {
//           bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
//           if (isLoggedIn) {
//             await controller.toggleFavorite(productId: productId);
//             onFavoriteTap?.call();
//           } else {
//             CustomSheets.showLoginSheet(context);
//             debugPrint('Favorite Action - Showing Login Bottom Sheet');
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: isLoading
//               ? const SizedBox(
//             width: 30,
//             height: 30,
//             child: CircularProgressIndicator(strokeWidth: 2),
//           )
//               : SvgPicture.asset(
//             isFavorite ? 'assets/svg/fullheart2.svg' : 'assets/svg/Heart 2.svg',
//             width: 30,
//             height: 30,
//             colorFilter: isFavorite
//                 ? const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)
//                 : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
//           ),
//         ),
//       );
//     });
//   }
// }
//

