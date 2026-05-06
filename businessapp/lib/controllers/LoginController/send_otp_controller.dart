import 'package:dieaya_market/utils/api_constant.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../utils/API/http_service.dart';

class SendOtpController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;



  Future<bool> sendOtp(String phone) async {
    try {
      isLoading(true);
      errorMessage('');
      successMessage('');

      final Map<String, dynamic> body = {'phone': phone};

      final httpService = HttpService.instance;
      final response = await httpService.post(
        Uri.parse(ApiConstants.sendOTP),
        body: body,
      );

      if (response.statusCode == 200) {
        successMessage('OTP sent successfully');
        print(response.body);
        return true;
      } else {
        final responseData = jsonDecode(response.body);
        errorMessage(responseData['message'] ?? 'Failed to send OTP');
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