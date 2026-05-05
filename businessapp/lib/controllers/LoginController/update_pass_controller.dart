import 'package:get/get.dart';
import 'dart:convert';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';


import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOtpController extends GetxController {
  var isLoading = false.obs;
  var isBlocked = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  final String apiUrl = ApiConstants.verifyOTP;

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      isLoading(true);
      errorMessage('');
      successMessage('');

      final Map<String, dynamic> body = {
        'phone': phone,
        'otp': otp,
      };

      final httpService = HttpService.instance;
      final response = await httpService.post(
        Uri.parse(apiUrl),
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        final token = responseData['data']?['token'] ?? '';
        isBlocked.value =  responseData['data']['is_blocked'];
        print("is block =====================>"+
            responseData['data']['is_blocked']);
        if (token.isNotEmpty) {
          await SharedPrefsConstants.saveToken(token);
          successMessage('OTP verified successfully');
          return true;
        } else {
          errorMessage('No token received');
          return false;
        }
      } else {
        // Get a detailed error message
        final msg = responseData['data']['message'] ?? 'Failed to verify OTP';
        isBlocked.value=  responseData['data']['is_blocked'];
        errorMessage(msg);
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

  final String apiUrl = ApiConstants.updateProfile;

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

      final httpService = HttpService.instance;
      final response = await httpService.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: body,
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