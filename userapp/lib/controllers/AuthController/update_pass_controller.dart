import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Utils/app_sharedprefs_contants.dart';

class VerifyOtpController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // final String apiUrl = 'https://dieaya-plus.com/api/customer/verify_otp';

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      isLoading(true);
      errorMessage('');
      successMessage('');

      final Map<String, dynamic> body = {
        'phone': phone,
        'otp': otp,
      };

      final response = await HttpService.instance.post(
        Uri.parse(ApiConstants.verifyOTP),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['data']['token'] ?? '';
        if (token.isNotEmpty) {
          await SharedPrefsConstants.saveToken(token);
          successMessage('OTP verified successfully');
          return true;
        } else {
          errorMessage('No token received');
          return false;
        }
      } else {
        final responseData = jsonDecode(response.body);
        errorMessage(responseData['message'] ?? 'Failed to verify OTP');
        return false;
      }
    } catch (e) {
      errorMessage('An error occurred: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
class UpdatePasswordController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // final String apiUrl = 'https://dieaya-plus.com/api/customer/update_profile';

  Future<bool> updatePassword(String password) async {
    try {
      isLoading(true);
      errorMessage('');
      successMessage('');

      final token = await SharedPrefsConstants.getToken();
      if (token == null) {
        errorMessage('No token found. Please verify OTP again.');
        return false;
      }

      final Map<String, dynamic> body = {'password': password};

      final response = await HttpService.instance.post(
        Uri.parse(ApiConstants.updateProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        successMessage('Password updated successfully');
        await SharedPrefsConstants.removeToken(); // Clear token after use
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        errorMessage(responseData['message'] ?? 'Failed to update password');
        return false;
      }
    } catch (e) {
      errorMessage('An error occurred: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}