import 'package:dieaya_user/UI/widgets/buttons.dart';
import 'package:dieaya_user/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/OnboardingController/onboarding_controller.dart';
import '../../../utils/app_sharedprefs_contants.dart';
import '../../../routes/app_routes.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Initialize the SplashController
  final SplashController _splashController = Get.put(SplashController());

  // Static onboarding data as fallback
  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding.png',
      'title': 'مرحبا بك',
      'subtitle': '',
    },
    {
      'image': 'assets/images/splash1.png',
      'title': 'دعاية بلس بين افضل المتاجر',
      'subtitle': 'يجمع دعاية بلس بين افضل المتاجر والمنتجات عالية الجوده كما',
    },
    {
      'image': 'assets/images/splash2.png',
      'title': 'التسوق بالاسعار المخفضة',
      'subtitle': 'يتيح لكم التسوق بالاسعار المخفضة وخيارات الدفع المتنوعة باستخدام بطاقات الائتمان والدفع نقدا عند الاستلام',
    },
    {
      'image': 'assets/images/splash3.png',
      'title': 'خدمات سريعة وموثوقة',
      'subtitle': 'بالاضافة الى الخدمات السريعة والموثوقة كل ما عليكم زيارة الموقع وستجدون كل من قائمة رغباتكم وعناوينكم المسجلة وطرق دفعكم المفضلة',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Navigate after marking onboarding as seen
  Future<void> _completeOnboarding() async {
    await SharedPrefsConstants.setHasSeenOnboarding(true);
    bool isLoggedIn = await SharedPrefsConstants.isLoggedIn();
    if (isLoggedIn) {
      Get.offNamed(AppRoutes.navbar);
    } else {
      Get.offNamed(AppRoutes.navbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              // Show loading state
              if (_splashController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Determine whether to use API data or static data
              final bool useStaticData = _splashController.errorMessage.isNotEmpty ||
                  _splashController.splashData.isEmpty;
              final itemCount = useStaticData
                  ? onboardingData.length
                  : _splashController.splashData.length;

              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                        _animationController.reset();
                        _animationController.forward();
                      },
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (useStaticData) {
                          // Use static data
                          final data = onboardingData[index];
                          return OnboardingPage(
                            image: data['image'] ?? 'assets/images/placeholder.png',
                            title: data['title'] ?? '',
                            subtitle: data['subtitle'] ?? '',
                            fadeAnimation: _fadeAnimation,
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            isNetworkImage: false,
                          );
                        } else {
                          // Use API data
                          final splash = _splashController.splashData[index];
                          return OnboardingPage(
                            image: splash.image ?? 'https://via.placeholder.com/150',
                            title: splash.titleAr ?? splash.titleEn ?? '',
                            subtitle: splash.descriptionAr ??
                                splash.descriptionEn ??
                                '',
                            fadeAnimation: _fadeAnimation,
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            isNetworkImage: true,
                          );
                        }
                      },
                    ),
                  ),
                  // Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      itemCount,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                        width: _currentPage == index ? screenWidth * 0.1 : screenWidth * 0.02,
                        height: screenHeight * 0.01,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary : Colors.grey[300],
                          borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Continue/Start Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: CustomButton(
                      textSize: screenWidth * 0.05,
                      textFontWeight: FontWeight.bold,
                      onPressed: () async {
                        if (_currentPage == itemCount - 1) {
                          await _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
                      text: _currentPage == itemCount - 1 ? 'ابدأ الآن' : 'متابعة',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _completeOnboarding();
                    },
                    child: CustomTextSolveIssue(
                      'تخطى',
                      style: GoogleFonts.tajawal(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              );
            }),
            // Logo in Top-Right
            Positioned(
              top: screenHeight * 0.02,
              right: screenWidth * 0.05,
              child: Image.asset(
                'assets/images/logo.png',
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Animation<double> fadeAnimation;
  final double screenHeight;
  final double screenWidth;
  final bool isNetworkImage;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.fadeAnimation,
    required this.screenHeight,
    required this.screenWidth,
    required this.isNetworkImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          isNetworkImage
              ? Image.network(
            image,
            height: screenHeight * 0.35,
            width: screenWidth * 0.7,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/placeholder.png',
              height: screenHeight * 0.35,
              width: screenWidth * 0.7,
              fit: BoxFit.contain,
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                height: screenHeight * 0.35,
                width: screenWidth * 0.7,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          )
              : Image.asset(
            image,
            height: screenHeight * 0.35,
            width: screenWidth * 0.7,
            fit: BoxFit.contain,
          ),
          SizedBox(height: screenHeight * 0.05),
          // Main Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: CustomTextSolveIssue(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.tajawal(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          // Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: CustomTextSolveIssue(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.tajawal(
                fontSize: screenWidth * 0.045,
                color: Colors.grey[600],
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}