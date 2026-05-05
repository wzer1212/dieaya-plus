import 'package:dieaya_market/controllers/ProfileController/profile_controller.dart';
import 'package:dieaya_market/ui/widgets/custom_verify_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../Controllers/LanguageController/language_controller.dart';
import '../../Utils/app_colors.dart';
import '../../controllers/ThemeController/theme_controller.dart';
import '../pages/HomePage/home_screen.dart';
import '../pages/ProfileScreens/profile_screen.dart';
import 'custom_sheets.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final iconSize = 24.0;
  bool _isMenuOpen = false;

  static const List<String> _navIcons = [
    'assets/svg/profile/Home 4.svg',
    'assets/svg/profile/Profile 1.svg',
  ];

  // Updated menu options to store translation keys
  final List<Map<String, dynamic>> _menuOptions = [
    {'icon': Icons.shopping_bag, 'key': 'addProduct', 'color': AppColors.blue},
    {'icon': Icons.discount, 'key': 'addOffer', 'color': AppColors.blue},
    {'icon': Icons.local_offer, 'key': 'addCoupon', 'color': AppColors.blue},
    {'icon': Icons.add_photo_alternate, 'key': 'addBanner', 'color': AppColors.blue},
  ];

  final List<Widget> _pages = [
    const HomeScreen(),
    ProfileScreen(),
  ];

  final ProfileController profileControllerController = Get.put(ProfileController())..fetchProfile();
  final LanguageController languageController = Get.find<LanguageController>(); // Use Get.find for existing controller
  final ThemeController themeController =
  Get.put(ThemeController()); // Access ThemeController
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // This getter will now be reactive as it's inside a GetBuilder or accessed dynamically
  List<String> get _currentPageTitles {
    return [
      'Shopping'.tr,
      'Products'.tr,
    ];
  }

  // Helper method to build SVG icons for the bottom navigation
  Widget _buildIcon(String path, bool isActive) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(
        isActive ? AppColors.blue : AppColors.grey.withOpacity(0.8),
        BlendMode.srcIn,
      ),
      width: iconSize,
      height: iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access _currentPageTitles within the build method or an Obx/GetBuilder
    // to ensure it reacts to language changes.
    final currentTitles = _currentPageTitles; // This will re-evaluate on locale change when the builder rebuilds.

    if (currentTitles.length != _navIcons.length) {
      return Scaffold(body: Center(child: Text("navigation_error".tr)));
    }


    return Obx(() {
      // Wrap Scaffold in Obx to react to theme changes
      return Scaffold(
        body: Stack(
          children: [
            _pages[_currentIndex],
            if (_isMenuOpen) _buildMenuOverlay(),
          ],
        ),
        bottomNavigationBar: GetBuilder<LanguageController>(
          builder: (controller) => _buildAnimatedBottomNavBar(currentTitles),
        ),
        floatingActionButton: _buildCenterFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }

  Widget _buildCenterFAB() {
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationZ(_isMenuOpen ? math.pi / 4 : 0),
      child: FloatingActionButton(
        backgroundColor: _isMenuOpen
            ? AppColors.primary
            : (isDark ? AppColors.darkBlueBackground : AppColors.white),        elevation: 10,
        shape: const CircleBorder(),
        child: Icon(
          _isMenuOpen ? Icons.close : Icons.add,
          color: _isMenuOpen ? AppColors.white : AppColors.primary,
          size: 30,
        ),
        onPressed: _toggleMenu,
      ),
    );
  }

  Widget _buildMenuOverlay() {
    return GestureDetector(
      onTap: _toggleMenu,
      child: Container(
        color: Colors.black12,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            // Wrap the Column with GetBuilder so it rebuilds when language changes
            child: GetBuilder<LanguageController>(
              builder: (_) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(_menuOptions.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: _buildMenuButton(index),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(int index) {
    final option = _menuOptions[index];
    final String translationKey = option['key']; // Get the translation key
    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: 270,
            height: 55,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {

                  _toggleMenu();
                  // Use the translation key for logic
                  if (translationKey == 'addProduct') {
                    CustomSheets.showAddProductSheet(context);
                  } else if (translationKey == 'addCoupon') {
                    CustomSheets.showAddCouponSheet(context);
                  } else if (translationKey == 'addOffer') {
                    CustomSheets.showAddOfferSheet(context);
                  } else if (translationKey == 'addBanner') {
                    CustomSheets.showAddBannerSheet(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${translationKey.tr} selected'),
                        // Show translated text
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }


              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark? AppColors.darkBlueBackground:Colors.white,
                foregroundColor: AppColors.blue,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translationKey.tr, // Use .tr directly on the translation key
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      color: isDark? Colors.white:Color(0xff666565),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBottomNavBar(List<String> titles) {
    // Create a list of icon builders
    final iconList = _navIcons.map((path) =>
        (int index) => _buildIcon(path, _currentIndex == index)
    ).toList();

    bool isDark = themeController.themeMode.value == ThemeMode.dark;
    return AnimatedBottomNavigationBar.builder(
      height: 90,
      itemCount: _navIcons.length,
      tabBuilder: (int index, bool isActive) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconList[index](index),
            const SizedBox(height: 4),
            if (isActive)
              Container(
                height: 5,
                width: 5,
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        );
      },
      activeIndex: _currentIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.smoothEdge,
      leftCornerRadius: 30,
      rightCornerRadius: 30,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      shadow: BoxShadow(
        color: AppColors.primary.withOpacity(0.2), // Adjust shadow color for better visibility
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
      backgroundColor: isDark? AppColors.darkBlueBackground:Colors.white,
      splashColor: AppColors.lightBlueBackground,
      splashRadius: 24,
    );
  }
}