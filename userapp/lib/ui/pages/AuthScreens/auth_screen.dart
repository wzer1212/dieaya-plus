// import 'package:dieaya_user/UI/widgets/navbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import '../../../Controllers/AuthController/login_controller.dart';
// import '../../../Controllers/AuthController/register_controller.dart';
// import '../../../Controllers/AuthController/send_otp_controller.dart';
// import '../../../Controllers/AuthController/verify_controller.dart';
// import '../../../Utils/app_colors.dart';
// import '../../../Utils/app_text_field.dart';
// import '../../widgets/buttons.dart';
//
//
// const double defaultPadding = 16.0;
// const double inputHeight = 60.0;
// const double bottomSheetHeight = 850.0;
//
//
// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 showLoginBottomSheet(context);
//               },
//               child: const CustomTextSolveIssue('Show Login Bottom Sheet'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 showRegisterBottomSheet(context);
//               },
//               child: const CustomTextSolveIssue('Show Register Bottom Sheet'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 showOTPBottomSheet(context, phoneNumber: '');
//               },
//               child: const CustomTextSolveIssue('Show OTP Bottom Sheet'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 showForgotPasswordBottomSheet(context);
//               },
//               child: const CustomTextSolveIssue('Show Forgot Password Bottom Sheet'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 showSetNewPasswordBottomSheet(context);
//               },
//               child: const CustomTextSolveIssue('Show Set New Password Bottom Sheet'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                Get.to(Navbar());
//               },
//               child: const CustomTextSolveIssue('guest'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Login Bottom Sheet
//   void showLoginBottomSheet(BuildContext context) {
//     final TextEditingController phoneController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();
//     final LoginController loginController = Get.put(LoginController());
//     var phoneError = ''.obs;
//     var passwordError = ''.obs;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           height: bottomSheetHeight,
//           padding: EdgeInsets.only(
//             left: defaultPadding,
//             right: defaultPadding,
//             top: defaultPadding,
//             bottom: 10,
//           ),
//           child: Obx(() => Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             width: 40,
//                             height: 5,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(Icons.close, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextSolveIssue(
//                     'تسجيل الدخول',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           label: 'رقم الهاتف',
//                           hintText: '123886712',
//                           controller: phoneController,
//                           keyboardType: TextInputType.phone,
//                           errorText: phoneError.value.isNotEmpty ? phoneError.value : null,
//                           onChanged: (value) => phoneError.value = '',
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 CustomTextSolveIssue(
//                                   '',
//                                   style: GoogleFonts.tajawal(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color(0xff5D5C5C),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           _buildCountryCodeSelector(),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     label: 'كلمة المرور',
//                     hintText: 'ادخل كلمة المرور',
//                     controller: passwordController,
//                     keyboardType: TextInputType.visiblePassword,
//                     obscureText: true,
//                     errorText: passwordError.value.isNotEmpty ? passwordError.value : null,
//                     onChanged: (value) => passwordError.value = '',
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           showForgotPasswordBottomSheet(context);
//                         },
//                         child: CustomTextSolveIssue(
//                           'هل نسيت كلمة المرور',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 12,
//                             color: primaryColor,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           showRegisterBottomSheet(context);
//                         },
//                         child: CustomTextSolveIssue(
//                           'قم بإنشاء حساب جديد',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 12,
//                             color: primaryColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//               CustomButton(
//                 text: loginController.isLoading.value ? 'جاري الدخول...' : 'دخول',
//                 textSize: 18,
//                 onPressed: loginController.isLoading.value
//                     ? null
//                     : () async {
//                   phoneError.value = '';
//                   passwordError.value = '';
//
//                   // Basic validation
//                   if (phoneController.text.isEmpty) {
//                     phoneError.value = 'رقم الهاتف مطلوب';
//                     return;
//                   }
//                   if (passwordController.text.isEmpty) {
//                     passwordError.value = 'كلمة المرور مطلوبة';
//                     return;
//                   }
//
//                   bool success = await loginController.login(
//                     '966${phoneController.text}', // Include country code
//                     passwordController.text,
//                   );
//
//                   if (success) {
//                     Navigator.pop(context); // Close the bottom sheet
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => const Navbar()),
//                     ); // Navigate to home_screen page
//                   } else {
//                     // Assign errors to specific fields
//                     if (loginController.errorMessage.value.contains('phone') ||
//                         loginController.errorMessage.value.contains('The selected phone is invalid')) {
//                       phoneError.value = loginController.errorMessage.value;
//                     } else if (loginController.errorMessage.value.contains('Invalid credentials')) {
//                       passwordError.value = 'رقم الهاتف أو كلمة المرور غير صحيحة';
//                     } else {
//                       passwordError.value = loginController.errorMessage.value;
//                     }
//                     Get.snackbar('خطأ', loginController.errorMessage.value);
//                   }
//                 },
//               ),
//             ],
//           )),
//         );
//       },
//     );
//   }
//
//   void showRegisterBottomSheet(BuildContext context) {
//     final RegisterController registerController = Get.put(RegisterController(), tag: 'register');
//     final TextEditingController usernameController = TextEditingController();
//     final TextEditingController emailController = TextEditingController();
//     final TextEditingController phoneController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();
//     final TextEditingController confirmPasswordController = TextEditingController();
//
//     var nameError = ''.obs;
//     var emailError = ''.obs;
//     var phoneError = ''.obs;
//     var passwordError = ''.obs;
//     var confirmPasswordError = ''.obs;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           height: bottomSheetHeight,
//           padding: EdgeInsets.only(
//             left: defaultPadding,
//             right: defaultPadding,
//             top: defaultPadding,
//             bottom: 10,
//           ),
//           child: Obx(() => Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             width: 40,
//                             height: 5,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(Icons.close, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextSolveIssue(
//                     'إنشاء حساب',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     label: 'اسم المستخدم',
//                     hintText: 'ادخل اسم المستخدم',
//                     controller: usernameController,
//                     errorText: nameError.value.isNotEmpty ? nameError.value : null,
//                     onChanged: (value) => nameError.value = '',
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           label: 'رقم الهاتف',
//                           hintText: 'ادخل رقم الجوال',
//                           controller: phoneController,
//                           keyboardType: TextInputType.phone,
//                           errorText: phoneError.value.isNotEmpty ? phoneError.value : null,
//                           onChanged: (value) => phoneError.value = '',
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       _buildCountryCodeSelector(),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     label: 'البريد الإلكتروني',
//                     hintText: 'ادخل البريد الالكتروني',
//                     controller: emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     errorText: emailError.value.isNotEmpty ? emailError.value : null,
//                     onChanged: (value) => emailError.value = '',
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     label: 'كلمة المرور',
//                     hintText: 'ادخل كلمة المرور',
//                     controller: passwordController,
//                     keyboardType: TextInputType.visiblePassword,
//                     obscureText: true,
//                     errorText: passwordError.value.isNotEmpty ? passwordError.value : null,
//                     onChanged: (value) => passwordError.value = '',
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     label: 'تأكيد كلمة المرور',
//                     hintText: 'تأكيد كلمة المرور',
//                     controller: confirmPasswordController,
//                     keyboardType: TextInputType.visiblePassword,
//                     obscureText: true,
//                     errorText: confirmPasswordError.value.isNotEmpty ? confirmPasswordError.value : null,
//                     onChanged: (value) => confirmPasswordError.value = '',
//                   ),
//                   const SizedBox(height: 10),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                         showLoginBottomSheet(context);
//                       },
//                       child: CustomTextSolveIssue(
//                         'هل لديك حساب بالفعل؟ قم بتسجيل الدخول',
//                         style: GoogleFonts.tajawal(
//                           fontSize: 12,
//                           color: primaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//               CustomButton(
//                 text: registerController.isLoading.value ? 'جاري الإنشاء...' : 'إنشاء',
//                 textSize: 18,
//                 onPressed: registerController.isLoading.value
//                     ? null
//                     : () async {
//                   nameError.value = '';
//                   emailError.value = '';
//                   phoneError.value = '';
//                   passwordError.value = '';
//                   confirmPasswordError.value = '';
//
//                   if (usernameController.text.isEmpty) {
//                     nameError.value = 'اسم المستخدم مطلوب';
//                     return;
//                   }
//                   if (emailController.text.isEmpty) {
//                     emailError.value = 'البريد الإلكتروني مطلوب';
//                     return;
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
//                     emailError.value = 'البريد الإلكتروني غير صالح';
//                     return;
//                   }
//                   if (phoneController.text.isEmpty) {
//                     phoneError.value = 'رقم الهاتف مطلوب';
//                     return;
//                   }
//                   if (!RegExp(r'^\d{9}$').hasMatch(phoneController.text)) {
//                     phoneError.value = 'رقم الهاتف يجب أن يتكون من 9 أرقام';
//                     return;
//                   }
//                   if (passwordController.text.isEmpty) {
//                     passwordError.value = 'كلمة المرور مطلوبة';
//                     return;
//                   }
//                   if (confirmPasswordController.text.isEmpty) {
//                     confirmPasswordError.value = 'تأكيد كلمة المرور مطلوب';
//                     return;
//                   }
//                   if (passwordController.text != confirmPasswordController.text) {
//                     confirmPasswordError.value = 'كلمة المرور غير متطابقة';
//                     return;
//                   }
//
//                   await registerController.register(
//                     name: usernameController.text,
//                     email: emailController.text,
//                     phone: '966${phoneController.text}',
//                     password: passwordController.text,
//                     passwordConfirmation: confirmPasswordController.text,
//                   );
//
//                   if (registerController.errorMessage.isNotEmpty) {
//                     if (registerController.errorMessage.value.contains('phone')) {
//                       phoneError.value = 'رقم الهاتف موجود بالفعل';
//                     } else if (registerController.errorMessage.value.contains('email')) {
//                       emailError.value = 'البريد الإلكتروني موجود بالفعل';
//                     } else {
//                       Get.snackbar('خطأ', registerController.errorMessage.value);
//                       Navigator.pop(context);
//                       // Delay opening the OTP sheet to avoid overlay conflicts
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         showOTPBottomSheet(
//                           context,
//                           phoneNumber: '966${phoneController.text}',
//                         );
//                       });
//                     }
//                   } else if (registerController.successMessage.isNotEmpty) {
//                     Get.snackbar('نجاح', registerController.successMessage.value);
//                     Navigator.pop(context);
//                     // Delay opening the OTP sheet to avoid overlay conflicts
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       showOTPBottomSheet(
//                         context,
//                         phoneNumber: '966${phoneController.text}',
//                       );
//                     });
//                   }
//                 },
//               ),
//             ],
//           )),
//         );
//       },
//     );
//   }
//
//   // OTP Bottom Sheet
//   void showOTPBottomSheet(BuildContext context, {required String phoneNumber}) {
//     final OtpVerifyController otpVerifyController = Get.put(OtpVerifyController(), tag: 'otp_verify');
//     final TextEditingController otpController = TextEditingController();
//     var otpError = ''.obs;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           height: bottomSheetHeight,
//           padding: EdgeInsets.only(
//             left: defaultPadding,
//             right: defaultPadding,
//             top: defaultPadding,
//             bottom: 10,
//           ),
//           child: Obx(() => Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             width: 40,
//                             height: 5,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(Icons.close, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextSolveIssue(
//                     'تحقق من الرقم المسجل',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   CustomTextSolveIssue(
//                     'أرسلنا رسالة نصية تتضمن رمز التحقق الى الرقم',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 14,
//                       color: greyTextColor,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   CustomTextSolveIssue(
//                     phoneNumber,
//                     style: GoogleFonts.tajawal(
//                       fontSize: 14,
//                       color: greyTextColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   Pinput(
//                     length: 4,
//                     textInputAction: TextInputAction.next,
//                     keyboardType: TextInputType.number,
//                     controller: otpController,
//                     defaultPinTheme: PinTheme(
//                       width: 60,
//                       height: 60,
//                       textStyle: GoogleFonts.tajawal(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Color(0xff9C9C9C).withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.transparent),
//                       ),
//                     ),
//                     focusedPinTheme: PinTheme(
//                       width: 60,
//                       height: 60,
//                       textStyle: GoogleFonts.tajawal(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.lightGreyBackground,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: primaryColor),
//                       ),
//                     ),
//                     submittedPinTheme: PinTheme(
//                       width: 60,
//                       height: 60,
//                       textStyle: GoogleFonts.tajawal(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.lightGreyBackground,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       otpError.value = '';
//                     },
//                   ),
//                   if (otpError.value.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: CustomTextSolveIssue(
//                         otpError.value,
//                         style: GoogleFonts.tajawal(
//                           color: Colors.red,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                         },
//                         child: CustomTextSolveIssue(
//                           'ارسال رمز جديد',
//                           style: GoogleFonts.tajawal(
//                             fontSize: 14,
//                             color: primaryColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 5),
//                       CustomTextSolveIssue(
//                         '(0:25)',
//                         style: GoogleFonts.tajawal(
//                           fontSize: 14,
//                           color: primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                       showRegisterBottomSheet(context);
//                     },
//                     child: CustomTextSolveIssue(
//                       'تغيير الرقم',
//                       style: GoogleFonts.tajawal(
//                         fontSize: 14,
//                         color: greyTextColor,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//               CustomButton(
//                 text: otpVerifyController.isLoading.value ? 'جاري التحقق...' : 'متابعة',
//                 textSize: 18,
//                 onPressed: otpVerifyController.isLoading.value
//                     ? null
//                     : () async {
//                   if (otpController.text.isEmpty) {
//                     otpError.value = 'رمز التحقق مطلوب';
//                     return;
//                   }
//
//                   await otpVerifyController.verifyOtp(
//                     phone: phoneNumber,
//                     otp: otpController.text,
//                   );
//
//                   if (otpVerifyController.errorMessage.isNotEmpty) {
//                     otpError.value = otpVerifyController.errorMessage.value;
//                     Get.snackbar('خطأ', otpVerifyController.errorMessage.value);
//                   } else if (otpVerifyController.successMessage.isNotEmpty) {
//                     Get.snackbar('نجاح', otpVerifyController.successMessage.value);
//                     Navigator.pop(context);
//                     // Delay navigation to avoid overlay conflicts
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => const Navbar()),
//                       );
//                     });
//                   }
//                 },
//               ),
//             ],
//           )),
//         );
//       },
//     );
//   }
//   // Forgot Password Bottom Sheet
//   void showForgotPasswordBottomSheet(BuildContext context) {
//     final TextEditingController phoneController = TextEditingController();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           height: bottomSheetHeight,
//           padding: EdgeInsets.only(
//             left: defaultPadding,
//             right: defaultPadding,
//             top: defaultPadding,
//             bottom: 10,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             width: 40,
//                             height: 5,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const Icon(Icons.close, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextSolveIssue(
//                     'نسيت كلمة المرور',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           label: 'رقم الهاتف',
//                           hintText: 'ادخل رقم الجوال',
//                           controller: phoneController,
//                           keyboardType: TextInputType.phone,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 CustomTextSolveIssue(
//                                   '',
//                                   style: GoogleFonts.tajawal(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color(0xff5D5C5C),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           _buildCountryCodeSelector(),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   CustomTextSolveIssue(
//                     'سيتم ارسال رمز التحقق الى الرقم',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 14,
//                       color: greyTextColor,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   CustomTextSolveIssue(
//                     '+966594108734',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 14,
//                       color: greyTextColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//               CustomButton(
//                 text: 'متابعة',
//                 textSize: 18,
//                 onPressed: () {
//                   Navigator.pop(context);
//                   showOTPBottomSheet(context, phoneNumber: "+966${phoneController.text}");
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Set New Password Bottom Sheet
//   void showSetNewPasswordBottomSheet(BuildContext context) {
//     final TextEditingController newPasswordController = TextEditingController();
//     final TextEditingController confirmPasswordController = TextEditingController();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         bool obscureNewPassword = true;
//         bool obscureConfirmPassword = true;
//         bool showError = false;
//
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             return Container(
//               height: bottomSheetHeight,
//               padding: EdgeInsets.only(
//                 left: defaultPadding,
//                 right: defaultPadding,
//                 top: defaultPadding,
//                 bottom: 10,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Container(
//                                 width: 40,
//                                 height: 5,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[300],
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => Navigator.pop(context),
//                             child: const Icon(Icons.close, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextSolveIssue(
//                         'تعيين كلمة مرور',
//                         style: GoogleFonts.tajawal(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         label: 'كلمة المرور الجديدة',
//                         hintText: 'ادخل كلمة المرور الجديدة',
//                         controller: newPasswordController,
//                         keyboardType: TextInputType.visiblePassword,
//                         obscureText: obscureNewPassword,
//                         prefixIcon: obscureNewPassword ? Icons.visibility_off : Icons.visibility,
//                         onPrefixIconTap: () {
//                           setModalState(() {
//                             obscureNewPassword = !obscureNewPassword;
//                           });
//                         },
//                         onChanged: (value) {
//                           if (showError) {
//                             setModalState(() {
//                               showError = false;
//                             });
//                           }
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         label: 'تأكيد كلمة المرور',
//                         hintText: 'تأكيد كلمة المرور',
//                         controller: confirmPasswordController,
//                         keyboardType: TextInputType.visiblePassword,
//                         obscureText: obscureConfirmPassword,
//                         prefixIcon: obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                         onPrefixIconTap: () {
//                           setModalState(() {
//                             obscureConfirmPassword = !obscureConfirmPassword;
//                           });
//                         },
//                         borderColor: showError ? Colors.red : null,
//                         onChanged: (value) {
//                           if (showError) {
//                             setModalState(() {
//                               showError = false;
//                             });
//                           }
//                         },
//                       ),
//                       if (showError)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0, right: 5.0),
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: CustomTextSolveIssue(
//                               'كلمة المرور غير مطابقة',
//                               style: GoogleFonts.tajawal(
//                                 color: Colors.red,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 30),
//                     ],
//                   ),
//                   CustomButton(
//                     text: 'تعيين',
//                     textSize: 18,
//                     onPressed: () {
//                       if (newPasswordController.text == confirmPasswordController.text &&
//                           newPasswordController.text.isNotEmpty) {
//                         setModalState(() {
//                           showError = false;
//                         });
//                         print('New Password Set!');
//                         Navigator.pop(context);
//                         showLoginBottomSheet(context);
//                       } else {
//                         setModalState(() {
//                           showError = true;
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // Country Code Selector Widget
//   Widget _buildCountryCodeSelector() {
//     return Container(
//       height: inputHeight,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Color(0xff9C9C9C).withOpacity(0.15),
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: "+966",
//           icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
//           items: <String>['+966', '+971', '+965', '+20']
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.flag_circle, color: Colors.green, size: 24),
//                   const SizedBox(width: 8),
//                   CustomTextSolveIssue(
//                     value,
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             // Handle country code change - requires StatefulWidget
//           },
//         ),
//       ),
//     );
//   }
// }
