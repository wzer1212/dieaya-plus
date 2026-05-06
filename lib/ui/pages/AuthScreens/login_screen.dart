// import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart'; // For SystemUiOverlayStyle
//
// // --- Constants (Customize Colors and Styles) ---
// const Color primaryColor = Color(0xFF00A9E0); // Bright blue from image
// const Color lightBlueBackground = Color(0xFFE0F7FF); // Lighter blue for inputs/keypad
// const Color greyTextColor = Colors.grey;
// const double defaultPadding = 16.0;
// const double inputHeight = 55.0;
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginScreen> {
//   String _enteredPhoneNumber = '';
//
//   // --- Keypad Button Press Logic ---
//   void _onKeyPressed(String value) {
//     setState(() {
//       if (value == 'backspace') {
//         if (_enteredPhoneNumber.isNotEmpty) {
//           _enteredPhoneNumber =
//               _enteredPhoneNumber.substring(0, _enteredPhoneNumber.length - 1);
//         }
//       } else {
//         // Add basic validation if needed (e.g., max length)
//         _enteredPhoneNumber += value;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Set status bar style (optional, matches iOS style)
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//       statusBarColor: Colors.white, // Or Colors.transparent
//     ));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // Wrap with Directionality for explicit RTL if needed for testing
//       // Usually handled by MaterialApp's locale
//       body: SafeArea( // Ensures content isn't hidden by notches/system UI
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 1.5),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(height: 40), // Space from top
//
//               // --- Logo ---
//               SizedBox(
//                 height: 80, // Adjust size as needed
//                 child: Image.asset(
//                   'assets/images/logo.png', // Replace with your logo path
//                   fit: BoxFit.cover,
//                   // Optional: Provide a placeholder color if image fails
//                   // errorBuilder: (context, error, stackTrace) => Container(color: primaryColor, height: 80, width: 80),
//                 ),
//               ),
//
//               const SizedBox(height: 50),
//
//               // --- Title ---
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    CustomTextSolveIssue(
//                     'ادخل رقم الجوال',
//                     style: GoogleFonts.tajawal(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                                  ),
//                  ],
//                ),
//
//               const SizedBox(height: 25),
//
//               // --- Phone Input Row ---
//               Row(
//                 textDirection: TextDirection.rtl, // Ensure row elements are RTL
//                 children: [
//                   // Country Code Selector (Simplified)
//                   _buildCountryCodeSelector(),
//
//                   const SizedBox(width: 10),
//
//                   // Phone Number Display
//                   Expanded(child: _buildPhoneNumberDisplay()),
//                 ],
//               ),
//
//               const SizedBox(height: 15),
//
//               // --- Helper Text ---
//               const CustomTextSolveIssue(
//                 'سيصلك رمز تفعيل لتستطيع الدخول لحسابك او انشاء حساب جديد',
//                 textAlign: TextAlign.center,
//                 textDirection: TextDirection.rtl,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: greyTextColor,
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               // --- Continue Button ---
//               _buildContinueButton(),
//
//               // Spacer to push keypad down, or use Expanded if keypad should fill remaining space
//               const Spacer(),
//
//               // --- Numeric Keypad ---
//               _buildNumpad(),
//
//               const SizedBox(height: 20), // Space at bottom
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- Widget Builder Methods ---
//
//   Widget _buildCountryCodeSelector() {
//     return Container(
//       height: inputHeight,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: lightBlueBackground,
//         borderRadius: BorderRadius.circular(inputHeight / 2),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min, // Take minimum space needed
//         textDirection: TextDirection.rtl,
//         children: const [
//           // Placeholder for flag - use Image.asset('assets/saudi_flag.png')
//           Icon(Icons.flag_circle, color: Colors.green, size: 24), // Simple placeholder
//           SizedBox(width: 8),
//           CustomTextSolveIssue(
//             "+966",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           Icon(Icons.arrow_drop_down, color: Colors.black54),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPhoneNumberDisplay() {
//     return Container(
//       height: inputHeight,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       alignment: Alignment.centerRight, // Align text to the right (start in RTL)
//       decoration: BoxDecoration(
//         color: lightBlueBackground,
//         borderRadius: BorderRadius.circular(inputHeight / 2),
//       ),
//       child: CustomTextSolveIssue(
//         _enteredPhoneNumber.isEmpty ? 'phone_number'.tr : _enteredPhoneNumber, // Placeholder / Actual
//         textDirection: TextDirection.ltr, // Phone numbers are usually LTR
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//           letterSpacing: 1.5, // Add spacing between digits
//           color: _enteredPhoneNumber.isEmpty ? greyTextColor.withOpacity(0.7) : Colors.black87,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContinueButton() {
//     return SizedBox(
//       width: double.infinity, // Make button take full width
//       height: inputHeight,
//       child: ElevatedButton(
//         onPressed: _enteredPhoneNumber.isNotEmpty ? () {
//           // --- TODO: Add login logic here ---
//           print('Continue pressed. Phone: $_enteredPhoneNumber');
//           // Example: Navigator.push(...) or call API
//         } : null, // Disable button if no number entered
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           foregroundColor: Colors.white, // Text color
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(inputHeight / 2),
//           ),
//           elevation: 2, // Subtle shadow
//         ),
//         child: const CustomTextSolveIssue(
//           'متابعة',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildNumpad() {
//     // Define the layout of the keypad buttons
//     final List<String> keys = [
//       '1', '2', '3',
//       '4', '5', '6',
//       '7', '8', '9',
//       '.', '0', 'backspace', // Use 'backspace' as a special key
//     ];
//
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 1.8, // Adjust aspect ratio for button shape
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemCount: keys.length,
//       shrinkWrap: true, // Important to prevent infinite height error in Column
//       physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
//       itemBuilder: (context, index) {
//         final key = keys[index];
//         return _buildNumpadButton(key);
//       },
//     );
//   }
//
//   Widget _buildNumpadButton(String value) {
//     return Material(
//       color: lightBlueBackground,
//       borderRadius: BorderRadius.circular(30), // Circular buttons
//       child: InkWell(
//         borderRadius: BorderRadius.circular(30),
//         onTap: () => _onKeyPressed(value),
//         child: Center(
//           child: value == 'backspace'
//               ? const Icon(Icons.backspace_outlined, color: Colors.black54, size: 24,)
//               : CustomTextSolveIssue(
//             value,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }