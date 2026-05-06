import 'package:dieaya_user/controllers/NotificationController/notification_controller.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/dev_runtime_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RegisterController extends GetxController {
  // Observable for loading state
  var isLoading = false.obs;

  // Observable for error message
  var errorMessage = ''.obs;

  // Observable for success message
  var successMessage = ''.obs;

  // Observable for token (optional, as not provided in current response)
  var token = ''.obs;

  // Observable for customer data (optional, as not provided in current response)
  var customerData = {}.obs;

  // Observable for verification status (to handle unverified accounts)
  var requiresVerification = false.obs;

  // Method to register customer
  Future<void> register({
    required String name,
     String? email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      String? fcmToken;
      if (DevRuntimeConfig.canUseFcm) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      print('Using FCM Token for OTP verification: $fcmToken');
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';
      token.value = '';
      customerData.value = {};
      requiresVerification.value = false;

      // API endpoint
      // API endpoint is provided by ApiConstants.register.

      // Request body
      final Map<String, dynamic> body = {
        'name': name,
        // 'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'fcm_token': fcmToken?.isEmpty == false ? fcmToken : null,
      };

      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }

      // Make POST request
      final response = await HttpService.instance.post(
        Uri.parse(ApiConstants.register),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Parse response
      final responseData = jsonDecode(response.body);

      // Handle response
      if (response.statusCode == 201 && responseData['status'] == true) {
        successMessage.value = responseData['message'] ?? 'Customer registered successfully';
      } else {
        // Handle error response
        errorMessage.value = responseData['message'] ?? 'Failed to register customer';
        if (responseData['data'] != null && responseData['data']['verified'] == 0) {
          requiresVerification.value = true; // Flag for unverified account
        }
        if (responseData['errors'] != null) {
          // Combine all error messages with field prefixes
          final errors = responseData['errors'] as Map<String, dynamic>;
          final errorMessages = errors.entries.map((entry) {
            final field = entry.key;
            final messages = (entry.value as List<dynamic>).join(', ');
            return '$field: $messages';
          }).join('; ');
          errorMessage.value = errorMessages.isNotEmpty ? errorMessages : errorMessage.value;
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
