import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Utils/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';

class DeleteAccountController extends GetxController {
  // Observable for loading state
  var isLoading = false.obs;

  // Observable for error message
  var errorMessage = ''.obs;

  // Observable for success message
  var successMessage = ''.obs;

  // Method to delete customer account
  Future<bool> deleteAccount() async {
    try {
      // Set loading state to true
      final token = await SharedPrefsConstants.getToken();
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      // Make DELETE request with token in header
      final response = await HttpService.instance.get(
        Uri.parse(ApiConstants.deleteAccount),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Parse response
      final responseData = jsonDecode(response.body);

      // Handle response
      if (response.statusCode == 200 && responseData['status'] == true) {
        successMessage.value = responseData['message'] ?? 'Account deleted successfully';
        return true;
      } else {
        // Handle error response
        errorMessage.value = responseData['message'] ?? 'Failed to delete account';
        if (responseData['errors'] != null) {
          // Combine all error messages
          final errors = responseData['errors'] as Map<String, dynamic>;
          final errorMessages = errors.values
              .expand((errorList) => errorList as List<dynamic>)
              .join('; ');
          errorMessage.value = errorMessages.isNotEmpty ? errorMessages : errorMessage.value;
        }
        return false;
      }
    } catch (e) {
      // Handle network or other errors
      errorMessage.value = 'An error occurred: $e';
      return false;
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}