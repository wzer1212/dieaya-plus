import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../models/banner_model.dart';
import '../../models/product_model.dart';
import '../../utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';

class BannerController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var validationErrors = <String, List<String>>{}.obs;
  var banners = <BannerMarket>[].obs;
  var pagination = Rxn<Pagination>();
  var sortOrder = 'new_to_old'.obs;

  // Helper method to get the token
  Future<String?> _getToken() async {
    return await SharedPrefsConstants.getToken();
  }

  void sortBanner(String order) {
    sortOrder.value = order;
    banners.sort((a, b) {
      final dateA = _parseDate(a.createdAt) ?? DateTime(1970);
      final dateB = _parseDate(b.createdAt) ?? DateTime(1970);
      return order == 'new_to_old'
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });
  }

  DateTime? _parseDate(String? createdAt) {
    if (createdAt == null) return null;
    try {
      final format = DateFormat('dd-MM-yyyy');
      return format.parse(createdAt);
    } catch (e) {
      try {
        return DateTime.parse(createdAt);
      } catch (e2) {
        debugPrint('Error parsing createdAt: $e2, value: $createdAt');
        return null;
      }
    }
  }
  // Add a new banner
  Future<bool> addBanner({
    required File image,
    required String descriptionAr,
    required String descriptionEn,
    required String link,
    required String location,
    String? couponCode,
    int status = 1,

  }) async {
    isLoading(true);
    errorMessage('');
    successMessage('');
    validationErrors.clear();

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.storeBanner),
      );

      // Add text fields
      request.fields['description_ar'] = descriptionAr;
      request.fields['description_en'] = descriptionEn;
      request.fields['link'] = link;
      request.fields['location'] = location;
      if (couponCode != null) request.fields['coupon_code'] = couponCode;

      // Add image
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.fields['status'] = status.toString();

      // Set headers with token
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);

      print('Add Banner Response: $responseBody');

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Banner added successfully');
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to add banner');
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
        }
        return false;
      }
    } catch (e) {
      errorMessage('Error adding banner: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Update an existing banner
  Future<bool> updateBanner({
    required int bannerId,
    File? image,
    required String descriptionAr,
    required String descriptionEn,
    required String link,
    required String location,
    String? couponCode,
    int status = 1,

  }) async {
    isLoading(true);
    errorMessage('');
    successMessage('');
    validationErrors.clear();

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.updateBanner),
      );

      // Add text fields
      request.fields['id'] = bannerId.toString();
      request.fields['description_ar'] = descriptionAr;
      request.fields['description_en'] = descriptionEn;
      request.fields['link'] = link;
      request.fields['location'] = location;
      if (couponCode != null) request.fields['coupon_code'] = couponCode;

      // Add image if provided
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }
      request.fields['status'] = status.toString();

      // Set headers with token
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);

      print('Update Banner Response: $responseBody');

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Banner updated successfully');
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to update banner');
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
        }
        return false;
      }
    } catch (e) {
      errorMessage('Error updating banner: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Delete a banner
  Future<bool> deleteBanner({required int id}) async {
    isLoading(true);
    errorMessage('');
    successMessage('');

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.destroyBanner),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      print('Delete Banner Response: ${response.body}');

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Banner deleted successfully');
        banners.removeWhere((banner) => banner.id == id);
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to delete banner');
        return false;
      }
    } catch (e) {
      errorMessage('Error deleting banner: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Fetch banners
  Future<bool> fetchBanners({int page = 1, String? keyword}) async {
    isLoading(true);
    errorMessage('');
    successMessage('');

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      var queryParams = {
        'page': page.toString(),
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      };
      var uri = Uri.parse(ApiConstants.getBannersList)
          .replace(queryParameters: queryParams);

      print('Fetching banners: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Fetch Banners Response: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final bannerResponse = BannerResponse.fromJson(jsonData);

        if (bannerResponse.status) {
          if (page == 1) {
            banners.clear();
          }
          banners.addAll(bannerResponse.data.banners);
          pagination.value = bannerResponse.data.pagination;
          sortBanner(sortOrder.value);
          return true;
        } else {
          errorMessage(bannerResponse.message);
          return false;
        }
      } else {
        errorMessage('Failed to fetch banners: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      errorMessage('Error fetching banners: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}