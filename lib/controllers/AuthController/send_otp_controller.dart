import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendOtpController extends GetxController {
  var isLoading = false.obs;
  var isBlock = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  // API endpoint is provided by ApiConstants.sendOTP.

  Future<bool> sendOtp(String phone) async {
    try {
      isLoading(true);
      errorMessage('');
      successMessage('');

      final Map<String, dynamic> body = {'phone': phone};

      final response = await HttpService.instance.post(
        Uri.parse(ApiConstants.sendOTP),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        successMessage('OTP sent successfully');
        return true;
      } else {
        final responseData = jsonDecode(response.body);

        print(" responseData['data']['is_blocked']v");
        isBlock.value = responseData['data']['is_blocked']??false;
        errorMessage(responseData['data']['message'] ?? 'Failed to send OTP');
        return false;
      }
    } catch (e) {
      print(e.runtimeType);
      errorMessage('An error occurred: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
