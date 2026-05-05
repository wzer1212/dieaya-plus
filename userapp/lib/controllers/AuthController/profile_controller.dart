import 'dart:convert';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Models/profile_model.dart';
import '../../Routes/app_routes.dart';
import '../../Utils/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var validationErrors = <String, String>{}.obs; // Observable for field-specific errors
  var profile = Rxn<CustomerProfile>(); // Observable for profile data, nullable
  var httpService = HttpService.instance;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  Future<bool> fetchProfile() async {
    isLoading(true);
    errorMessage('');
    validationErrors.clear();
    profile.value = null;

    try {
      final token = await SharedPrefsConstants.getToken();
      if (token == null || token.isEmpty) {
        errorMessage('No authentication token found. Please log in.');
        return false;
      }

      final response = await httpService.get(
        Uri.parse(ApiConstants.profile),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print('Profile API Response status: ${response.statusCode}');
      print('Profile API Response body: ${response.body}');

      if (response.headers['content-type']?.contains('application/json') != true) {
        errorMessage('Server returned non-JSON response. Please check the API endpoint.');
        return false;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final profileResponse = ProfileResponse.fromJson(data);
        profile.value = profileResponse.data;
        return true;
      } else {
        errorMessage(data['message'] ?? 'Failed to fetch profile');
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

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    int? whatsappNotification,
  }) async {
    isLoading(true);
    errorMessage('');
    validationErrors.clear();

    try {
      final token = await SharedPrefsConstants.getToken();
      if (token == null || token.isEmpty) {
        errorMessage('No authentication token found. Please log in.');
        return false;
      }

      // Build request body with all provided fields
      final Map<String, dynamic> body = {};
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (phone != null) body['phone'] = phone;
      if (password != null) body['password'] = password;
      if (whatsappNotification != null) body['whatsapp_notification'] = whatsappNotification; // No toString() here

      // Check if at least one field is provided
      if (body.isEmpty) {
        errorMessage('No fields provided for update.');
        return false;
      }

      final response = await httpService.post(
        Uri.parse(ApiConstants.updateProfile),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print('Update Profile API Response status: ${response.statusCode}');
      print('Update Profile API Response body: ${response.body}');

      if (response.headers['content-type']?.contains('application/json') != true) {
        errorMessage('Server returned non-JSON response. Please check the API endpoint.');
        return false;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        // Update profile with new data (except for password, as it's not returned)
        final profileResponse = ProfileResponse.fromJson(data);
        profile.value = profileResponse.data;
        return true;
      } else if (response.statusCode == 422 && data['data'] != null) {
        // Handle validation errors
        final errors = data['data'] as Map<String, dynamic>;
        errors.forEach((field, errorList) {
          if (errorList is List && errorList.isNotEmpty) {
            validationErrors[field] = errorList[0];
          }
        });
        return false;
      } else {
        errorMessage(data['message'] ?? 'Failed to update profile');
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

  Future<bool> logout() async {
    isLoading(true);
    errorMessage('');
    validationErrors.clear();

    try {
      final token = await SharedPrefsConstants.getToken();
      if (token == null || token.isEmpty) {
        errorMessage('No authentication token found.');
        return false;
      }

      final response = await httpService.post(
        Uri.parse(ApiConstants.logout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print('Logout API Response status: ${response.statusCode}');
      print('Logout API Response body: ${response.body}');

      if (response.headers['content-type']?.contains('application/json') != true) {
        errorMessage('Server returned non-JSON response. Please check the API endpoint.');
        return false;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        await SharedPrefsConstants.removeToken();
        profile.value = null;
        Get.offAllNamed(AppRoutes.login);
        return true;
      } else {
        errorMessage(data['message'] ?? 'Failed to log out');
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