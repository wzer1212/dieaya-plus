import 'package:dieaya_user/ui/widgets/global_widgets/footer/footer.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/global_web_header.dart';
import 'package:dieaya_user/utils/responsive/adaptive_layout.dart';
import 'package:dieaya_user/utils/responsive/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../Routes/app_routes.dart';
import '../../../Utils/app_colors.dart'; // Assuming AppColors is here

import 'package:flutter_html/flutter_html.dart';

import '../../../controllers/AboutController/about_controller.dart';
import '../../../controllers/ThemeController/theme_controller.dart';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

class AboutApp extends StatelessWidget {
   AboutApp({super.key});

  // Static fallback content (original text)
  static const String _fallbackContent = '''
    <p>مرحبًا بك في تطبيق دعاية بلس، يقدم التطبيق خدمة عرض منتجات المتاجر والعروض المتاحة لمساعدة المستخدمين على اكتشاف أفضل الصفقات. يرجى قراءة سياسة الاستخدام هذه بعناية قبل استخدام التطبيق.</p>
    <h3>1. قبول الشروط</h3>
    <p>باستخدامك التطبيق، فإنك توافق على الالتزام بهذه السياسة والشروط والأحكام ذات الصلة. إذا كنت لا توافق على أي بند من هذه السياسة، يرجى عدم استخدام التطبيق.</p>
    <h3>2. وصف الخدمة</h3>
    <ul>
      <li>يعرض التطبيق منتجات المتاجر والعروض المتاحة بناءً على المعلومات المقدمة من المتاجر والشركاء.</li>
      <li>لا يتحمل التطبيق مسؤولية دقة المعلومات أو التغييرات في الأسعار أو توفر المنتجات، حيث أن البيانات مقدمة من قبل المتاجر.</li>
      <li>قد يحتوي التطبيق على روابط لمواقع خارجية أو تطبيقات تابعة لأطراف ثالثة، ولا نتحمل مسؤولية محتواها أو ممارسات الخصوصية الخاصة بها.</li>
    </ul>
    <h3>3. مسؤوليات المستخدم</h3>
    <ul>
      <li>يجب استخدام التطبيق لأغراض شخصية وقانونية فقط.</li>
      <li>يمنع استخدام التطبيق في أنشطة غير قانونية أو مخالفة للآداب العامة.</li>
      <li>يجب عليك التأكد من صحة المعلومات المعروضة (مثل الأسعار والتوفر) مباشرة مع المتجر قبل إتمام أي عملية شراء.</li>
      <li>يحظر نسخ أو تعديل أو توزيع محتوى التطبيق دون إذن مسبق.</li>
    </ul>
    <h3>4. الحسابات والمعلومات الشخصية</h3>
    <ul>
      <li>قد يتطلب التطبيق إنشاء حساب أو تقديم بعض المعلومات الشخصية لتحسين تجربة المستخدم.</li>
      <li>نلتزم بحماية بياناتك وفقًا لـ [سياسة الخصوصية] الخاصة بنا.</li>
      <li>أنت مسؤول عن الحفاظ على سرية معلومات حسابك ونشاطك داخل التطبيق.</li>
    </ul>
  ''';
  ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    final AboutUsController controller = Get.put(AboutUsController());
    final screenWidth = MediaQuery.of(context).size.width;
    final ThemeController themeController = Get.put(ThemeController()); // Access ThemeController
    bool isDark = themeController.themeMode.value == ThemeMode.dark;

    return AdaptiveLayOut(mobile: Scaffold(
      backgroundColor: isDark? Colors.black:Colors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark?[
                    AppColors.primary,
                    AppColors.primary,
                    Colors.black,
                  ]:[
                    AppColors.primary,
                    AppColors.primary,
                    Colors.white,
                  ],
                  stops: [0.0, 0.0, 5.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        'assets/svg/backbutton.svg',
                        width: 40,
                        height: 40,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: CustomTextSolveIssue(
                        'about'.tr,
                        style: GoogleFonts.tajawal(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.notifications);
                        },
                        child: Stack(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/svg/notify.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  Colors.black54,
                                  BlendMode.srcIn,
                                ),
                              ),
                              onPressed: () {
                                print('Notifications Tapped');
                              },
                            ),
                            Positioned(
                              right: 11,
                              top: 14,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 8,
                                  minHeight: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 16),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final content = controller.aboutUsContent.isNotEmpty
                      ? controller.aboutUsContent.value
                      : _fallbackContent;
                  return Html(
                    data: content,
                    style: {
                      'p': Style(
                        fontSize: FontSize(15),
                        // color: Colors.black87,
                        lineHeight: const LineHeight(1.5),
                        textAlign: TextAlign.right,
                        direction: TextDirection.rtl,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                      'h3': Style(
                        fontSize: FontSize(17),
                        fontWeight: FontWeight.bold,
                        // color: Colors.black,
                        textAlign: TextAlign.right,
                        direction: TextDirection.rtl,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                      ),
                      'li': Style(
                        fontSize: FontSize(15),
                        // color: Colors.black87,
                        lineHeight: const LineHeight(1.5),
                        textAlign: TextAlign.right,
                        direction: TextDirection.rtl,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        margin: Margins(bottom: Margin(8)),
                      ),
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    ), desktop: Scaffold(
      backgroundColor: isDark? Colors.black:Colors.white,
      body: Column(
        children: [
          GlobalWebHeader(scrollController: _scrollController),

          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
            
              child: Column(
                children: [
            
                  // Content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 55.w, vertical: 55.h),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        final content = controller.aboutUsContent.isNotEmpty
                            ? controller.aboutUsContent.value
                            : _fallbackContent;
                        return Html(
                          data: content,
                          style: {
                            'p': Style(
                              fontSize: FontSize(15),
                              // color: Colors.black87,
                              lineHeight: const LineHeight(1.5),
                              textAlign: TextAlign.right,
                              direction: TextDirection.rtl,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                            ),
                            'h3': Style(
                              fontSize: FontSize(17),
                              fontWeight: FontWeight.bold,
                              // color: Colors.black,
                              textAlign: TextAlign.right,
                              direction: TextDirection.rtl,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                            ),
                            'li': Style(
                              fontSize: FontSize(15),
                              // color: Colors.black87,
                              lineHeight: const LineHeight(1.5),
                              textAlign: TextAlign.right,
                              direction: TextDirection.rtl,
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              margin: Margins(bottom: Margin(8)),
                            ),
                          },
                        );
                      }
                    }),
                  ),
                  SizedBox(height: 30.h,),
                  FooterWidget()
                ],
              ),
            ),
          ),

        ],
      ),
    ));
  }
}