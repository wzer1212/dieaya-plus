import 'package:dieaya_user/Utils/app_sharedprefs_contants.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpVerifyController extends GetxController {
  // Observable for loading state
  var isLoading = false.obs;
  var isBlock = false.obs;

  // Observable for error message
  var errorMessage = ''.obs;

  // Observable for success message
  var successMessage = ''.obs;

  // Observable for token
  var token = ''.obs;

  // Observable for customer data
  var customerData = {}.obs;

  // Method to verify OTP
  Future<void> verifyOtp({required String phone, required String otp}) async {
    try {
      // Set loading state to true
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';
      token.value = '';
      customerData.value = {};

      // API endpoint
      // API endpoint is provided by ApiConstants.verifyOTP.

      // Request body
      final Map<String, dynamic> body = {
        'phone': phone,
        'otp': otp,
      };

      // Make POST request
      final response = await HttpService.instance.post(
        Uri.parse(ApiConstants.verifyOTP),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Parse response
      final responseData = jsonDecode(response.body);

      // Handle response
      if (response.statusCode == 200 && responseData['status'] == true) {
        successMessage.value = responseData['message'] ?? 'OTP verified successfully';
        token.value = responseData['data']['token'] ?? '';
        customerData.value = responseData['data']['customer'] ?? {};
        SharedPrefsConstants.saveToken(token.value);
      } else {
        // Handle error response
        print("error runtime type =====>none");

        isBlock.value = responseData['data']['is_blocked']??false;
        errorMessage.value = responseData['data']['message'] ?? 'Failed to verify OTP';
        if (responseData['errors'] != null && responseData['errors']['otp'] != null) {
          errorMessage.value = responseData['errors']['otp'][0] ?? errorMessage.value;
        }
      }
    } catch (e) {
      // Handle network or other errors


      errorMessage.value = 'An error occurred: $e';
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
