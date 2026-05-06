import 'dart:convert';
import 'package:dieaya_user/controllers/NotificationController/notification_controller.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/dev_runtime_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Utils/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var requiresVerification = false.obs;
  var httpService = HttpService.instance;

  Future<bool> login(String phone, String password) async {
    isLoading(true);
    errorMessage('');
    requiresVerification(false);

    try {
      String? fcmToken;
      if (DevRuntimeConfig.canUseFcm) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      print('Using FCM Token for OTP verification: $fcmToken');
      final response = await httpService.post(
        Uri.parse(ApiConstants.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'password': password,
          'fcm_token': fcmToken?.isEmpty == false ? fcmToken : null,
        }),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      // Log response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check if response is JSON
      if (response.headers['content-type']?.contains('application/json') != true) {
        errorMessage('Server returned non-JSON response. Please check the API endpoint.');
        return false;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && (data['status'] == true || data['data']?['token'] != null)) {
        // Save token to shared preferences
        await SharedPrefsConstants.saveToken(data['data']['token']);
        return true;
      } else if (response.statusCode == 401 && data['data']?['verified'] == 0) {
        // Handle unverified account
        requiresVerification(true);
        errorMessage(data['message'] ?? 'حسابك غير مُفعّل، تم إرسال رمز التحقق');
        return false;
      } else if (response.statusCode == 401 && data['message'] == 'بيانات الاعتماد غير صالحة') {
        // Handle invalid credentials
        errorMessage('Invalid credentials');
        return false;
      } else if (response.statusCode == 422 && data['errors']?['password'] != null) {
        // Handle password validation error
        errorMessage('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
        return false;
      } else {
        // Handle specific error formats
        if (data['errors'] != null && data['errors']['phone'] != null) {
          errorMessage(data['errors']['phone'][0]); // e.g., "The selected phone is invalid."
        } else if (data['message'] == 'Invalid credentials') {
          errorMessage('Invalid credentials');
        } else {
          errorMessage(data['message'] ?? 'An error occurred');
        }
        return false;
      }
    } on FormatException catch (e) {
      errorMessage('Invalid response format: ${e.message}. Server may have returned HTML.');
      return false;
    } catch (e) {
      errorMessage('Network error: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
