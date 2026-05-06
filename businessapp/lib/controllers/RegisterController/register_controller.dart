import 'package:dieaya_market/utils/api_constant.dart';
import 'package:dieaya_market/utils/caching_sevice/shared_preferences.dart';
import 'package:dieaya_market/utils/constants/cache_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';


class RegisterController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var validationErrors = <String, List<String>>{}.obs;
  var categories = <Map<String, dynamic>>[].obs;
  var selectedCategories = <int>[].obs;

  Future<Map<String, dynamic>?> register({
    required String name,
    String? email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required XFile? logo,
    required String link,
    required String description,
    required List<int> categories,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';
      validationErrors.clear();
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print('Using FCM Token for OTP verification: $fcmToken');

      var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.register));

      // Ensure JSON response is expected
      request.headers['Accept'] = 'application/json';

      request.fields['name'] = name;
      if (email != null && email.isNotEmpty) {
        request.fields['email'] = email;
      }
      request.fields['phone'] = phone;
      request.fields['fcm_token'] = fcmToken ?? '';
      request.fields['password'] = password;
      request.fields['password_confirmation'] = passwordConfirmation;
      request.fields['link'] = link;
      request.fields['description'] = description;

      for (int i = 0; i < categories.length; i++) {
        request.fields['categories[$i]'] = categories[i].toString();
      }


      if (logo != null) {
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'logo',
              await logo.readAsBytes(),
              filename: logo.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'logo',
              logo.path,
              filename: logo.name,
            ),
          );
        }
      }

      print('Sending request to: ${ApiConstants.register}'); // Debug log
      print('Request headers: ${request.headers}'); // Debug log
      print('Request fields: ${request.fields}'); // Debug log

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response headers: ${response.headers}'); // Debug log
      print('Response body: ${responseBody.length > 500 ? responseBody.substring(0, 500) + '...' : responseBody}'); // Debug log

      // Handle 302 redirect
      if (response.statusCode == 302) {
        errorMessage.value = 'Request was redirected. Please check the API endpoint or authentication requirements.';
        print('302 Redirect detected to: ${response.headers['location']}'); // Debug log
        return null;
      }

      // Check if response is JSON
      if (!responseBody.trim().startsWith('{')) {
        errorMessage.value = 'Server returned an unexpected response. Please try again later.';
        print('Non-JSON response detected'); // Debug log
        return null;
      }

      final responseData = jsonDecode(responseBody);

      if ((response.statusCode == 201||response.statusCode == 200 )&& responseData['status'] == true) {
        successMessage.value = responseData['message'] ?? 'Market registered successfully';
        await MySharedPreference.putData(key: CacheConstants.userId, value: responseData['data']['market']['id']);

        return responseData;
      } else {
        errorMessage.value = responseData['message'] ?? 'Failed to register market';
        print('Error Message: ${errorMessage.value}'); // Debug log
        if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
          print('Validation Errors: ${validationErrors.value}'); // Debug log
        }
        return null;
      }

      // Mock error response for testing (uncomment to test error display)
      /*
      errorMessage.value = 'Email already exists (and 3 more errors)';
      validationErrors.value = {
        'email': ['Email already exists'],
        'password': ['Password must be at least 8 characters'],
        'phone': ['Phone number already exists'],
        'link': ['The link field must be a valid URL.']
      };
      isLoading.value = false;
      return null;
      */
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print('Exception: $e'); // Debug log
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}