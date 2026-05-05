// import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
//
//
//
// // --- The Content Widget for the Bottom Sheet ---
// class RegisterBottomSheetContent extends StatefulWidget {
//   const RegisterBottomSheetContent({super.key});
//
//   @override
//   State<RegisterBottomSheetContent> createState() =>
//       _RegisterBottomSheetContentState();
// }
//
// class _RegisterBottomSheetContentState extends State<RegisterBottomSheetContent> {
//   // Add TextEditingControllers if needed for form handling
//   // final _usernameController = TextEditingController();
//   // ... other controllers
//
//   // Add FocusNodes if needed
//   // final _passwordFocusNode = FocusNode();
//
//   // Add Form Key for validation
//   final _formKey = GlobalKey<FormState>();
//
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   @override
//   Widget build(BuildContext context) {
//     // Define colors
//     const Color validationRed = Colors.red;
//     const Color labelColor = Colors.black54;
//     const Color titleColor = Colors.black87;
//     final Color buttonColor = Colors.grey.shade500; // Button color from image
//     final Color hintColor = Colors.grey.shade500;
//
//
//     // Padding that adjusts when keyboard is visible
//     final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
//
//     return Directionality(
//       textDirection: TextDirection.rtl, // Set text direction to Right-to-Left
//       child: SingleChildScrollView(
//         physics: ClampingScrollPhysics(),
//
//         // Ensures content scrolls if keyboard appears or content is long
//         padding: EdgeInsets.only(
//             bottom: bottomPadding > 0 ? bottomPadding : 20, // Adjust padding based on keyboard
//             top: 20,
//             left: 20,
//             right: 20
//         ),
//         child: Container(
//           // This container is mostly for structure within the scroll view
//           // The background color and shape are handled by showModalBottomSheet's properties now
//           child: Form( // Wrap content in a Form for validation
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min, // Take minimum necessary height
//               crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
//               children: [
//                 // --- Header ---
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     const CustomTextSolveIssue(
//                       'انشاء حساب',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: titleColor,
//                       ),
//                     ),
//                     Positioned(
//                       // Position close button to the left (visual right in LTR, actual left)
//                       left: -10, // Adjust positioning as needed
//                       top: -5,
//                       child: IconButton(
//                         icon: const Icon(Icons.close, color: Colors.grey),
//                         onPressed: () => Navigator.pop(context), // Close the sheet
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 25),
//
//                 // --- Username ---
//                 _buildLabel('ادخل اسم المستخدم'),
//                 TextFormField(
//                   // controller: _usernameController,
//                   decoration: InputDecoration(hintText: 'هاني & سليمة', hintStyle: TextStyle(color: hintColor)),
//                   textAlign: TextAlign.right,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'اسم المستخدم مطلوب'; // Example validation
//                     }
//                     // Add more specific validation if needed (e.g., no symbols)
//                     return null; // Return null if valid
//                   },
//                   // Optional: Add keyboard type, textInputAction etc.
//                 ),
//                 _buildValidationMessage('اسم المستخدم لا يحتوي على رموز'), // Placeholder validation
//                 const SizedBox(height: 15),
//
//                 // --- Mobile Number ---
//                 _buildLabel('ادخل رقم الجوال'),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
//                   children: [
//                     // Country Code Picker (Visual Placeholder)
//                     Expanded(
//                       flex: 2, // Adjust flex ratio as needed
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(25.0),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Replace with actual logo if available
//                             Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Stc_logo.svg/100px-Stc_logo.svg.png', height: 20), // Example STC logo
//                             const SizedBox(width: 5),
//                             const CustomTextSolveIssue('+966', style: TextStyle(fontSize: 14, color: Colors.black87)),
//                             const Icon(Icons.arrow_drop_down, color: Colors.grey),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     // Phone Number Input
//                     Expanded(
//                       flex: 3, // Adjust flex ratio as needed
//                       child: TextFormField(
//                         decoration: InputDecoration(hintText: '1238712', hintStyle: TextStyle(color: hintColor)),
//                         keyboardType: TextInputType.phone,
//                         textAlign: TextAlign.right,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'رقم الجوال مطلوب';
//                           }
//                           // Add specific phone number validation
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 _buildValidationMessage('رقم الهاتف غير صحيح'), // Placeholder validation
//                 const SizedBox(height: 15),
//
//                 // --- Email ---
//                 _buildLabel('ادخل البريد الالكتروني'),
//                 TextFormField(
//                   decoration: InputDecoration(hintText: 'honda23om', hintStyle: TextStyle(color: hintColor)),
//                   keyboardType: TextInputType.emailAddress,
//                   textAlign: TextAlign.right,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'البريد الالكتروني مطلوب';
//                     }
//                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) { // Basic email format check
//                       return 'صيغة البريد غير صحيحة';
//                     }
//                     return null;
//                   },
//                 ),
//                 _buildValidationMessage('البريد الالكتروني غير صحيح'), // Placeholder validation
//                 const SizedBox(height: 15),
//
//                 // --- Password ---
//                 _buildLabel('ادخل كلمة المرور'),
//                 TextFormField(
//                   obscureText: _obscurePassword,
//                   // focusNode: _passwordFocusNode,
//                   textAlign: TextAlign.right,
//                   decoration: InputDecoration(
//                     hintText: '••••••••',
//                     hintStyle: TextStyle(color: hintColor, letterSpacing: 2.0), // Simulate dots
//                     // Suffix icon appears on the left in RTL
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                     // Use prefixIcon if you want icon on the right in RTL
//                     // prefixIcon: Icon(Icons.lock_outline),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'كلمة المرور مطلوبة';
//                     }
//                     if (value.length < 8) { // Example length check
//                       return 'كلمة المرور قصيرة جدا';
//                     }
//                     // Add more complex validation (symbols, numbers, etc.)
//                     return null;
//                   },
//                 ),
//                 _buildValidationMessage('يجب ان تحتوي كلمة المرور على رموز وحروف وارقام'), // Placeholder validation
//                 const SizedBox(height: 15),
//
//                 // --- Confirm Password ---
//                 _buildLabel('تأكيد كلمة المرور'),
//                 TextFormField(
//                   obscureText: _obscureConfirmPassword,
//                   textAlign: TextAlign.right,
//                   decoration: InputDecoration(
//                     hintText: '••••••••',
//                     hintStyle: TextStyle(color: hintColor, letterSpacing: 2.0), // Simulate dots
//                     // Suffix icon appears on the left in RTL
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscureConfirmPassword = !_obscureConfirmPassword;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: (value) {
//                     // Add validation to check if it matches the password field
//                     // if (value != _passwordController.text) { // Assuming you have controllers
//                     //   return 'كلمة المرور غير مطابقة';
//                     // }
//                     if (value == null || value.isEmpty) {
//                       return 'تأكيد كلمة المرور مطلوب';
//                     }
//                     return null;
//                   },
//                 ),
//                 _buildValidationMessage('كلمة المرور غير مطابقة'), // Placeholder validation
//                 const SizedBox(height: 20),
//
//                 // --- Login Link ---
//                 Center(
//                   child: Text.rich(
//                     TextSpan(
//                       text: 'هل لديك حساب بالفعل؟ ',
//                       style: const TextStyle(color: labelColor, fontSize: 14),
//                       children: [
//                         TextSpan(
//                           text: 'قم بتسجيل الدخول',
//                           style: const TextStyle(
//                               color: Colors.blue, // Or your primary color
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                               fontSize: 14
//                           ),
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                               // TODO: Implement navigation to Login
//                               print('Navigate to Login');
//                               Navigator.pop(context); // Close sheet before navigating maybe?
//                             },
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//
//                 // --- Submit Button ---
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: buttonColor, // Grey background
//                     foregroundColor: Colors.white, // White text
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   onPressed: () {
//                     // TODO: Implement registration logic
//                     if (_formKey.currentState!.validate()) {
//                       // Form is valid, proceed with registration
//                       print('Registration form is valid');
//                       Navigator.pop(context); // Close the sheet on success maybe
//                     } else {
//                       // Form is invalid, validation messages will appear
//                       print('Registration form is invalid');
//                     }
//                   },
//                   child: const CustomTextSolveIssue(
//                     'انشاء',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 // SizedBox(height: 10), // Optional extra padding at the bottom
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper widget for labels
//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0, right: 5.0), // Add padding below and slightly to the right
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: text,
//                 style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//               const TextSpan(
//                 text: ' *',
//                 style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper widget for validation messages (placeholder)
//   Widget _buildValidationMessage(String text) {
//     // TODO: Add logic here to only show this when validation fails
//     bool showError = true; // Replace with actual validation state check
//
//     return Visibility( // Use Visibility to show/hide easily
//       visible: showError, // Control visibility based on validation state
//       maintainState: true, // Keeps widget state even when hidden
//       maintainAnimation: true,
//       maintainSize: true, // Keeps space even when hidden (set to false if you want it to collapse)
//       child: Padding(
//         padding: const EdgeInsets.only(top: 4.0, right: 5.0),
//         child: Align(
//           alignment: Alignment.centerRight,
//           child: CustomTextSolveIssue(
//             text,
//             style: const TextStyle(color: Colors.red, fontSize: 12),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Remember to dispose controllers and focus nodes if you use them
//   @override
//   void dispose() {
//     // _usernameController.dispose();
//     // _passwordFocusNode.dispose();
//     super.dispose();
//   }
// }