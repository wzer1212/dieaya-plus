import 'package:get/get.dart';
import 'dart:convert';

import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../NotificationController/notification_controller.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';

class OtpVerifyController extends GetxController {
  // Observable for loading state
  var isLoading = false.obs;

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

      // final NotificationController notificationController = Get.find();
      // final String fcmToken = notificationController.fcmToken.value;
      // print('Using FCM Token for OTP verification: $fcmToken');
      // API endpoint
      final String apiUrl = ApiConstants.verifyOTP;

      // Request body
      final Map<String, dynamic> body = {
        'phone': phone,
        'otp': otp,
        // 'fcm_token': fcmToken.isEmpty ? null : fcmToken,
      };

      // Make POST request
      final httpService = HttpService.instance;
      final response = await httpService.post(
        Uri.parse(apiUrl),
        body: body,
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
        errorMessage.value = responseData['message'] ?? 'Failed to verify OTP';
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