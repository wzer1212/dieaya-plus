import 'dart:convert';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../Routes/app_routes.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../models/profile_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var validationErrors = <String, String>{}.obs;
  var profile = Rxn<CustomerProfile>();

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

      final response = await http.get(
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
      print('Parsed profile data: $data');

      if (response.statusCode == 200 && data['status'] == true) {
        final profileResponse = ProfileResponse.fromJson(data);
        if (profileResponse.data == null) {
          errorMessage('Profile data is null in response');
          return false;
        }
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
    String? description,
    String? link,
    XFile? logo,
    List<int>? categories,
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

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.updateProfile),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add text fields
      if (name != null) request.fields['name'] = name;
      if (email != null) request.fields['email'] = email;
      if (phone != null) request.fields['phone'] = phone;
      if (password != null) request.fields['password'] = password;
      if (description != null) request.fields['description'] = description;
      if (link != null) request.fields['link'] = link;
      if (whatsappNotification != null) request.fields['whatsapp_notification'] = whatsappNotification.toString(); // No toString() here

      if (categories != null && categories.isNotEmpty) {
        for (var i = 0; i < categories.length; i++) {
          request.fields['categories[$i]'] = categories[i].toString();
        }
      }

      // Add logo file if provided
      if (logo != null) {
        final file = await http.MultipartFile.fromPath(
          'logo',
          logo.path,
          contentType: MediaType('image', logo.path.split('.').last),
        );
        request.files.add(file);
      }

      if (request.fields.isEmpty && request.files.isEmpty) {
        errorMessage('No fields provided for update.');
        return false;
      }

      final response = await request.send().timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      final responseBody = await response.stream.bytesToString();
      print('Update Profile API Request fields: ${request.fields}');
      print('Update Profile API Response status: ${response.statusCode}');
      print('Update Profile API Response body: $responseBody');

      if (response.headers['content-type']?.contains('application/json') != true) {
        errorMessage('Server returned non-JSON response. Please check the API endpoint.');
        return false;
      }

      final data = jsonDecode(responseBody);

      if (response.statusCode == 200 && data['status'] == true) {
        final profileResponse = ProfileResponse.fromJson(data);
        profile.value = profileResponse.data;
        return true;
      } else if (response.statusCode == 422 && data['data'] != null) {
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

      final httpService = HttpService.instance;
      final response = await httpService.post(
        Uri.parse(ApiConstants.logout),
        headers: {
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
        Get.offAllNamed(AppRoutes.auth);
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