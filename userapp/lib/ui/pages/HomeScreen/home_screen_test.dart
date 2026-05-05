// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dieaya_user/Utils/app_texts.dart';
// import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
// import 'package:dieaya_user/ui/widgets/global_widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../Utils/app_colors.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // If using SVG icons
// import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Add dependency
//
// class Category {
//   final String id;
//   final String name;
//   final String imageUrl; // Or icon data
//   Category({required this.id, required this.name, required this.imageUrl});
// }
//
// class Product {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final String price;
//   final double rating;
//   final int reviewCount;
//   Product({required this.id, required this.name, required this.imageUrl, required this.price, required this.rating, required this.reviewCount});
//
// }
//
// final List<Category> dummyCircularCategories = List.generate(8, (index) =>
//     Category(id: '$index', name: 'قسم ${index + 1}', imageUrl: 'assets/images/Illustration.png')); // Placeholder images
//
// final List<Category> dummySquareCategories = List.generate(8, (index) =>
//     Category(id: 's$index', name: 'عرض ${index + 1}', imageUrl: 'assets/images/Illustration.png')); // Placeholder SVG icon path
//
// final List<Product> dummyProducts = List.generate(6, (index) =>
//     Product(id: 'p$index', name: 'منتج رائع ${index + 1}', imageUrl: 'assets/images/Illustration.png', price: '${(index + 1) * 150} EGP', rating: 4.0 + (index * 0.1), reviewCount: 20 + index * 5));
//
// final List<String> dummyCarouselImages = [
//   'https://picsum.photos/seed/banner1/600/300',
//   'https://picsum.photos/seed/banner2/600/300',
//   'https://picsum.photos/seed/banner3/600/300',
// ];
// final List<Map<String, dynamic>> banners = [
//   {
//     'imageUrl': 'assets/images/Rectangle 6.png',
//     'title': 'Special Offer!',
//     'subtitle': 'Get 20% off on all items',
//     'buttonText': 'Shop Now',
//     'onButtonPressed': () {
//       // Add your navigation or action here
//       print('Shop Now clicked for banner 1');
//     },
//   },
//   {
//     'imageUrl': 'assets/images/Rectangle 6.png',
//     'title': 'New Arrivals',
//     'subtitle': 'Check out the latest products',
//     'buttonText': 'Explore',
//     'onButtonPressed': () {
//       print('Explore clicked for banner 2');
//     },
//   },
//   {
//     'imageUrl': 'assets/images/Rectangle 6.png',
//     'title': 'Limited Time Deal',
//     'subtitle': 'Hurry up! Offer ends soon',
//     'buttonText': 'Grab Now',
//     'onButtonPressed': () {
//       print('Grab Now clicked for banner 3');
//     },
//   },
// ];
// // --- NEW: Dummy Store Data ---
// // Generate 12 stores for a 2x6 grid example
// final List<Store> dummyStores = List.generate(8, (index) =>
//     Store(id: 'store$index', name: 'نمشي${index + 1}', imageUrl: 'assets/images/Ellipse 14.png')); // Use appropriate placeholder
//
// // --- NEW: Store Class ---
// class Store {
//   final String id;
//   final String name;
//   final String imageUrl;
//   Store({required this.id, required this.name, required this.imageUrl});
// }
// // ... existing code ...
//
// // --- NEW: Coupon Class ---
// class Coupon {
//   final String id;
//   final String code;
//   final String imageUrl;
//   final String description;
//   final String expiryDate;
//
//   Coupon({
//     required this.id,
//     required this.code,
//     required this.imageUrl,
//     required this.description,
//     required this.expiryDate
//   });
// }
//
// // --- NEW: Dummy Coupon Data ---
// final List<Coupon> dummyCoupons = [
//   Coupon(
//       id: 'coupon1',
//       code: 'SAVE20',
//       imageUrl: 'assets/images/Rectangle 6.png',
//       description: 'خصم 20% على جميع المنتجات',
//       expiryDate: '2023-12-31'
//   ),
//   Coupon(
//       id: 'coupon2',
//       code: 'FREESHIP',
//       imageUrl: 'assets/images/Rectangle 6.png',
//       description: 'شحن مجاني على جميع الطلبات',
//       expiryDate: '2023-12-15'
//   ),
//   Coupon(
//       id: 'coupon3',
//       code: 'NEWUSER',
//       imageUrl: 'assets/images/Rectangle 6.png',
//       description: 'خصم 15% للمستخدمين الجدد',
//       expiryDate: '2023-12-31'
//   ),
//   Coupon(
//       id: 'coupon4',
//       code: 'SUMMER',
//       imageUrl: 'assets/images/Rectangle 6.png',
//       description: 'خصم صيفي 25%',
//       expiryDate: '2023-08-31'
//   ),
// ];
//
// // ... existing code ...
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final PageController _bannerPageController = PageController();
//
//   @override
//   void dispose() {
//     _bannerPageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset('assets/images/logo.png'),
//         ),
//       ),
//       body: ListView(
//         // Use ListView for vertical scrolling of sections
//         physics: ClampingScrollPhysics(),
//         padding: const EdgeInsets.only(bottom: 20), // Padding at the bottom
//         children: [
//           // 1. Top Promo Banner
//           PromoBannerCarousel(
//             banners: banners,
//             height: 180.0, // Adjust height as needed
//             borderRadius: 15.0,
//             // overlayColor: Colors.black38,
//           ),
//
//           // 2. Circular Categories Section
//           SizedBox(height: 20,),
//           _buildHorizontalCategoryList(
//             title: 'أقسام المنتجات',
//             categories: dummyCircularCategories,
//             itemBuilder: (context, category) => CircularCategoryItem(
//               label: category.name,
//               imageUrl: category.imageUrl,
//               onTap: () { /* Handle category tap */ },
//             ),
//           ),
//
//           SizedBox(height: 20,), // Spacing
//
//           // --- NEW: Best Stores Grid Section ---
//           _buildStoreGridSection(
//             title: 'أفضل المتاجر',
//             stores: dummyStores,
//             // Optional: Add a "See All" button if needed
//             // onSeeAllTap: () { print('See All Stores Tapped'); /* Handle See All */ },
//           ),
//
//           const SizedBox(height: 20),
//           StoreShowcaseCarousel(
//             stores: dummyStores.take(5).toList(), // Show first 5 stores
//             height: 160.0,
//             onButtonPressed: (store) {
//               print('Shopping button pressed for store: ${store.name}');
//               // Navigate to store page or handle shopping action
//             },
//           ),
//           // 4. Best Sellers Product Grid
//           _buildProductGridSection(
//             title: 'الأكثر مبيعاً',
//             products: dummyProducts,
//             onSeeAllTap: () { /* Handle See All tap */ },
//           ),
//
//           SizedBox(height: 20),
//           _buildCouponsSection(
//             title: 'كوبونات الخصم',
//             coupons: dummyCoupons,
//             onSeeAllTap: () {
//               print('See all coupons tapped');
//               // Navigate to all coupons page
//             },
//           ),
//
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildHorizontalCategoryList({
//     required String title,
//     required List<Category> categories,
//     required Widget Function(BuildContext, Category) itemBuilder,
//     double itemHeight = 100, // Adjust default height as needed
//     VoidCallback? onSeeAllTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // SectionHeader(
//         //   title: title,
//         //   actionText: onSeeAllTap != null ? 'مشاهدة الكل' : null,
//         //   onActionPressed: onSeeAllTap,
//         // ),
//         SizedBox(
//           height: itemHeight, // Control the height of the horizontal list area
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: categories.length,
//             // Add padding to the start and end of the list
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             itemBuilder: (context, index) {
//               return itemBuilder(context, categories[index]);
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _buildProductGridSection({
//     required String title,
//     required List<Product> products,
//     VoidCallback? onSeeAllTap,
//   }) {
//     return Column(
//       children: [
//         SectionHeader(
//           title: title,
//           actionText: onSeeAllTap != null ? 'مشاهدة الكل' : null,
//           onActionPressed: onSeeAllTap,
//         ),
//         GridView.builder(
//           // Essential properties when nesting GridView inside ListView
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, // Two columns
//             crossAxisSpacing: 12.0, // Horizontal spacing
//             mainAxisSpacing: 12.0, // Vertical spacing
//             childAspectRatio: 0.65, // Adjust aspect ratio (width / height) for card shape
//           ),
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];
//             return ProductCard(
//               imageUrl: product.imageUrl,
//               title: product.name,
//               price: product.price,
//               rating: product.rating,
//               reviewCount: product.reviewCount,
//               onTap: () { /* Navigate to Product Details */ },
//               onFavoriteTap: () { /* Handle favorite toggle */ },
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   // ... existing code ...
//
// // Add this method to the _HomeScreenState class
//   Widget _buildCouponsSection({
//     required String title,
//     required List<Coupon> coupons,
//     VoidCallback? onSeeAllTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SectionHeader(
//           title: title,
//           actionText: onSeeAllTap != null ? 'مشاهدة الكل' : null,
//           onActionPressed: onSeeAllTap,
//         ),
//         SizedBox(
//           height: 140, // Height of the coupon cards
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: coupons.length,
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             itemBuilder: (context, index) {
//               final coupon = coupons[index];
//               return CouponCard(
//                 coupon: coupon,
//                 onTap: () {
//                   print('Coupon tapped: ${coupon.code}');
//                   // Navigate to coupon details or apply coupon
//                 },
//                 onCopyCode: () {
//                   print('Copy code: ${coupon.code}');
//                   // Copy code to clipboard
//                   // You can use Clipboard.setData(ClipboardData(text: coupon.code))
//                   // and show a snackbar or toast
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: CustomTextSolveIssue('تم نسخ الكود: ${coupon.code}'),
//                       duration: const Duration(seconds: 2),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
// // ... existing code ...
//   // --- NEW: Helper Widget for Store Grid Section ---
//   Widget _buildStoreGridSection({
//     required String title,
//     required List<Store> stores,
//     VoidCallback? onSeeAllTap,
//   }) {
//     // You can limit the number of stores shown initially if needed
//     // final limitedStores = stores.take(6).toList(); // Example: Show only first 6
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomTextSolveIssue(title, style: Theme.of(context).textTheme.titleLarge),
//               if (onSeeAllTap != null)
//                 TextButton(onPressed: onSeeAllTap, child: CustomTextSolveIssue('عرض الكل')),
//             ],
//           ),
//         ),
//         GridView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           // itemCount: limitedStores.length, // Use limited list if needed
//           itemCount: stores.length, // Show all stores for now
//           shrinkWrap: true, // CRITICAL inside ListView
//           physics: const NeverScrollableScrollPhysics(), // CRITICAL inside ListView
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 6,        // 2 columns
//             // crossAxisSpacing: 10.0,   // Horizontal space between items
//             // mainAxisSpacing: 10.0,    // Vertical space between items
//             childAspectRatio: 0.7,    // Adjust aspect ratio (width / height). 1.0 = square. > 1.0 wider, < 1.0 taller
//           ),
//           itemBuilder: (context, index) {
//             // final store = limitedStores[index]; // Use if limiting
//             final store = stores[index];
//             return StoreGridItem( // Use the new widget
//               store: store,
//               onTap: () {
//                 print('Tapped on store: ${store.name}');
//                 // Handle store tap navigation/action
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
//
// }
//
//
// // --- NEW: Widget for a single Store Item in the Grid ---
// class StoreGridItem extends StatelessWidget {
//   final Store store;
//   final VoidCallback? onTap;
//
//   const StoreGridItem({Key? key, required this.store, this.onTap}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: 50,
//             height: 50,
//             decoration:BoxDecoration(
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Image.asset(
//               store.imageUrl,
//               fit: BoxFit.cover,
//               width: 50,
//               height: 50,
//               // Cover the area
//               // Add error builder for robustness
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: Colors.grey[200],
//                   child: const Center(child: Icon(Icons.store, color: Colors.grey)),
//                 );
//               },
//             ),
//           ),
//         ),
//         CustomTextSolveIssue(
//           store.name,
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
//           maxLines: 1, // Prevent text wrapping issues
//           overflow: TextOverflow.ellipsis, // Handle long names
//         ),
//       ],
//     );
//   }
// }
// class PromoBannerCarousel extends StatelessWidget {
//   // Define a list of banner data
//   final List<Map<String, dynamic>> banners;
//   final double height;
//   final double borderRadius;
//   final Color overlayColor;
//
//   const PromoBannerCarousel({
//     super.key,
//     required this.banners,
//     this.height = 160.0,
//     this.borderRadius = 15.0,
//     this.overlayColor = Colors.black38,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: CarouselSlider(
//         options: CarouselOptions(
//           height: height,
//           autoPlay: true, // Enable auto-play
//           autoPlayInterval: const Duration(seconds: 3), // Time between slides
//           autoPlayAnimationDuration: const Duration(milliseconds: 800),
//           viewportFraction: 0.9, // Slightly smaller than 1 to show a bit of the next item
//           enlargeCenterPage: false, // Enlarge the center item
//           enableInfiniteScroll: true, // Loop the carousel
//         ),
//         items: banners.map((banner) {
//           return PromoBanner(
//             imageUrl: banner['imageUrl'],
//             title: banner['title'],
//             subtitle: banner['subtitle'],
//             buttonText: banner['buttonText'],
//             height: height,
//             borderRadius: borderRadius,
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
// class PromoBanner extends StatelessWidget {
//   final String imageUrl;
//   final String? title;
//   final String? subtitle;
//   final String? buttonText;
//   final VoidCallback? onButtonPressed;
//   final double height;
//   final double borderRadius;
//   final Color overlayColor;
//
//   const PromoBanner({
//     super.key,
//     required this.imageUrl,
//     this.title,
//     this.subtitle,
//     this.buttonText,
//     this.onButtonPressed,
//     this.height = 160.0,
//     this.borderRadius = 15.0,
//     this.overlayColor = Colors.black38,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(borderRadius),
//           child: Container(
//             height: height,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(imageUrl),
//                 fit: BoxFit.cover,
//                 // colorFilter: ColorFilter.mode(overlayColor, BlendMode.darken),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: Directionality.of(context) == TextDirection.rtl
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (title != null)
//                         CustomTextSolveIssue(
//                           title!,
//                           style: GoogleFonts.notoKufiArabic(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           textAlign: Directionality.of(context) == TextDirection.rtl
//                               ? TextAlign.right
//                               : TextAlign.left,
//                         ),
//                       if (subtitle != null) ...[
//                         const SizedBox(height: 4),
//                         CustomTextSolveIssue(
//                           subtitle!,
//                           style: GoogleFonts.notoKufiArabic(
//                             fontSize: 14,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                           textAlign: Directionality.of(context) == TextDirection.rtl
//                               ? TextAlign.right
//                               : TextAlign.left,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class ProductCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String price;
//   final double rating;
//   final int reviewCount;
//   final VoidCallback? onTap;
//   final VoidCallback? onFavoriteTap; // Optional favorite action
//
//   const ProductCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.price,
//     required this.rating,
//     required this.reviewCount,
//     this.onTap,
//     this.onFavoriteTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 2.0, // Subtle shadow
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         clipBehavior: Clip.antiAlias, // Clip image to rounded corners
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded( // Image takes available space
//               child: Stack(
//                 alignment: AlignmentDirectional.topEnd, // Position favorite icon top-right (handles RTL)
//                 children: [
//                   Image.network( // Or AssetImage for local
//                     imageUrl,
//                     fit: BoxFit.cover, // Cover the area
//                     width: double.infinity, // Take full width
//                     // Add loading/error builders for better UX
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return const Center(child: CircularProgressIndicator());
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(child: Icon(Icons.broken_image, color: AppColors.grey));
//                     },
//                   ),
//                   if (onFavoriteTap != null) // Show favorite icon if callback is provided
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: InkWell(
//                         onTap: onFavoriteTap,
//                         child: CircleAvatar(
//                           radius: 14,
//                           backgroundColor: Colors.white.withOpacity(0.7),
//                           child: const Icon(Icons.favorite_border, size: 18, color: AppColors.grey),
//                           // Add logic here to show Icons.favorite if it IS favorited
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomTextSolveIssue(
//                     title,
//                     style: GoogleFonts.notoKufiArabic( // Or your app's font
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   CustomTextSolveIssue(
//                     price, // Format this properly (e.g., "$price EGP")
//                     style: GoogleFonts.lato( // Use a suitable font for price
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrice,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: AppColors.starColor, size: 16),
//                       const SizedBox(width: 4),
//                       CustomTextSolveIssue(
//                         rating.toStringAsFixed(1), // e.g., "4.5"
//                         style: GoogleFonts.lato(
//                           fontSize: 12,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       CustomTextSolveIssue(
//                         '($reviewCount)', // e.g., "(120)"
//                         style: GoogleFonts.lato(
//                           fontSize: 12,
//                           color: AppColors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SquareCategoryItem extends StatelessWidget {
//   final String label;
//   final String iconPath; // Assuming SVG path
//   final Color backgroundColor;
//   final Color iconColor;
//   final VoidCallback? onTap;
//
//   const SquareCategoryItem({
//     super.key,
//     required this.label,
//     required this.iconPath,
//     this.backgroundColor = AppColors.lightGrey, // Light background from image
//     this.iconColor = Colors.blue, // Example color
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 80, // Adjust size as needed
//         margin: const EdgeInsets.symmetric(horizontal: 6.0), // Spacing
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300, width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: backgroundColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: SvgPicture.asset(
//                 iconPath,
//                 width: 24,
//                 height: 24,
//                 colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
//               ),
//             ),
//
//             const SizedBox(height: 8),
//             CustomTextSolveIssue(
//               label,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.notoKufiArabic( // Or your app's font
//                 fontSize: 11, // Smaller font size
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.w500,
//               ),
//               maxLines: 2, // Allow two lines maybe
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class CircularCategoryItem extends StatelessWidget {
//   final String label;
//   final String imageUrl; // Or IconData if using icons
//   final Color backgroundColor;
//   final VoidCallback? onTap;
//
//   const CircularCategoryItem({
//     super.key,
//     required this.label,
//     required this.imageUrl, // Replace with icon if needed
//     this.backgroundColor = Colors.black, // Default from image
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0), // Spacing between items
//         child: Container(
//           decoration: BoxDecoration(
//               color: AppColors.lightBlueBackgroundContiner,
//               borderRadius: BorderRadius.circular(15)
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(left: 20,right: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(imageUrl),
//                 const SizedBox(height: 6),
//                 CustomTextSolveIssue(
//                 label,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.tajawal( // Or your app's font
//                     fontSize: 16,
//                     color: AppColors.textPrimary,
//                     fontWeight: FontWeight.w800,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class SectionHeader extends StatelessWidget {
//   final String title;
//   final String? actionText; // e.g., "مشاهدة الكل" (See All)
//   final VoidCallback? onActionPressed;
//
//   const SectionHeader({
//     super.key,
//     required this.title,
//     this.actionText,
//     this.onActionPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Use Directionality to handle text alignment based on locale (important for RTL)
//     final TextDirection currentDirection = Directionality.of(context);
//     final TextAlign titleAlign = currentDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left;
//     final TextAlign actionAlign = currentDirection == TextDirection.rtl ? TextAlign.left : TextAlign.right;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded( // Allow title to take available space
//             child: CustomTextSolveIssue(
//               title,
//               textAlign: titleAlign,
//               style: GoogleFonts.notoKufiArabic( // Or your app's font
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           if (actionText != null && onActionPressed != null)
//             InkWell(
//               onTap: onActionPressed,
//               child: CustomTextSolveIssue(
//                 actionText!,
//                 textAlign: actionAlign,
//                 style: GoogleFonts.notoKufiArabic( // Or your app's font
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.textSecondary, // Or your primary color
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// // ... existing code ...
//
// // --- NEW: Store Showcase Carousel ---
// class StoreShowcaseCarousel extends StatelessWidget {
//   final List<Store> stores;
//   final double height;
//   final double borderRadius;
//   final String buttonText;
//   final Function(Store)? onButtonPressed;
//
//   const StoreShowcaseCarousel({
//     Key? key,
//     required this.stores,
//     this.height = 160.0,
//     this.borderRadius = 15.0,
//     this.buttonText = 'تسوق الآن',
//     this.onButtonPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: CarouselSlider(
//         options: CarouselOptions(
//           height: height,
//           autoPlay: true,
//           autoPlayInterval: const Duration(seconds: 4),
//           autoPlayAnimationDuration: const Duration(milliseconds: 800),
//           viewportFraction: 0.9,
//           enlargeCenterPage: false,
//           enableInfiniteScroll: true,
//         ),
//         items: stores.map((store) {
//           return StoreShowcaseItem(
//             store: store,
//             buttonText: buttonText,
//             height: height,
//             borderRadius: borderRadius,
//             onButtonPressed: onButtonPressed != null
//                 ? () => onButtonPressed!(store)
//                 : null,
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
// class StoreShowcaseItem extends StatelessWidget {
//   final Store store;
//   final String buttonText;
//   final VoidCallback? onButtonPressed;
//   final double height;
//   final double borderRadius;
//
//   const StoreShowcaseItem({
//     Key? key,
//     required this.store,
//     required this.buttonText,
//     this.onButtonPressed,
//     this.height = 160.0,
//     this.borderRadius = 15.0,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(borderRadius),
//           child: Container(
//             height: height,
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               image: DecorationImage(
//                 image: AssetImage('assets/images/Rectangle 6.png'), // Background image
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                     Colors.black.withOpacity(0.1),
//                     BlendMode.darken
//                 ),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Store Image and Name (Right side in RTL)
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircleAvatar(
//                         radius: 15,
//                         backgroundImage: AssetImage(store.imageUrl),
//                       ),
//                       const SizedBox(width: 8),
//                       CustomTextSolveIssue(
//                         store.name,
//                         style: GoogleFonts.notoKufiArabic(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   Row(
//                       mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                       children:[
//
//                         CustomTextSolveIssue('test'),
//                         ElevatedButton(
//                           onPressed: onButtonPressed,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: CustomTextSolveIssue(
//                             buttonText,
//                             style: GoogleFonts.notoKufiArabic(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//
//                       ]
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ... existing code ...
//
// // ... existing code ...
//
// class CouponCard extends StatelessWidget {
//   final Coupon coupon;
//   final VoidCallback? onTap;
//   final VoidCallback? onCopyCode;
//
//   const CouponCard({
//     Key? key,
//     required this.coupon,
//     this.onTap,
//     this.onCopyCode,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 100,
//         margin: const EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             children: [
//               // Main content
//               Column(
//                 mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // // Top image section
//                   // Container(
//                   //   height: 100,
//                   //   decoration: BoxDecoration(
//                   //     image: DecorationImage(
//                   //       image: AssetImage(coupon.imageUrl),
//                   //       fit: BoxFit.cover,
//                   //     ),
//                   //   ),
//                   // ),
//
//                   // Bottom content section with dashed line separator
//                   Container(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Coupon description
//                         CustomTextSolveIssue(
//                           'Noon',
//                           style: GoogleFonts.notoKufiArabic(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 8),
//
//                         // Coupon code and copy button
//                         Row(
//                           children: [
//                             // Code display
//                             Container(
//
//                               child: CustomTextSolveIssue(
//                                 coupon.code,
//                                 style: GoogleFonts.notoKufiArabic(
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 8,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//
//                             // Copy button
//                             GestureDetector(
//                               onTap: onCopyCode,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.primary,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Icon(
//                                       Icons.copy,
//                                       color: Colors.white,
//                                       size: 12,
//                                     ),
//
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               // Dashed line separator
//               Positioned(
//                 top: 100,
//                 left: 0,
//                 right: 0,
//                 child: CustomPaint(
//                   painter: DashedLinePainter(),
//                   size: const Size(double.infinity, 1),
//                 ),
//               ),
//
//               // Left circle cutout
//               Positioned(
//                 top: 95,
//                 left: -5,
//                 child: Container(
//                   width: 10,
//                   height: 10,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//
//               // Right circle cutout
//               Positioned(
//                 top: 95,
//                 right: -5,
//                 child: Container(
//                   width: 10,
//                   height: 10,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     shape: BoxShape.circle,
//                   ),
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
// // Custom painter for dashed line
// class DashedLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.grey[300]!
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//
//     const dashWidth = 5;
//     const dashSpace = 3;
//     double startX = 0;
//
//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(startX, 0),
//         Offset(startX + dashWidth, 0),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
//
// // ... existing code ...
//
// // ... existing code ...