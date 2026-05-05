import 'dart:convert';
import 'package:dieaya_market/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/coupon_model.dart';
import '../../utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';
import 'package:intl/intl.dart'; // Add this import
class CouponController extends GetxController {
  RxString discountAmountCopounCart = '0'.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var validationErrors = <String, List<String>>{}.obs;
  var coupons = <Coupon>[].obs;
  var pagination = Rxn<Pagination>();
  var sortOrder = 'new_to_old'.obs;

  // Helper method to get the token
  Future<String?> _getToken() async {
    return await SharedPrefsConstants.getToken();
  }

  void sortCoupons(String order) {
    sortOrder.value = order;
    coupons.sort((a, b) {
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
  // Add a new coupon
  Future<bool> addCoupon({
    required String couponCode,
    required String descriptionAr,
    required String descriptionEn,
    required String link,
    String? terms,
    required int categoryId,
    required String discount,
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

      final response = await http.post(
        Uri.parse(ApiConstants.storeCoupon),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'coupon_code': couponCode,
          'description_ar': descriptionAr,
          'description_en': descriptionEn,
          'link': link,
          if (terms != null) 'terms': terms,
          'category_id': categoryId,
          'discount': discount,
          'status': status,
        }),
      );

      print('Add Coupon Response: ${response.body}');

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Coupon added successfully');
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to add coupon');
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
        }
        return false;
      }
    } catch (e) {
      errorMessage('Error adding coupon: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Update an existing coupon
  Future<bool> updateCoupon({
    required int couponId,
    required String couponCode,
    required String descriptionAr,
    required String descriptionEn,
    required String link,
    String? terms,
    required int categoryId,
    required String discount,
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

      final response = await http.post(
        Uri.parse(ApiConstants.updateCoupon),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': couponId,
          'coupon_code': couponCode,
          'description_ar': descriptionAr,
          'description_en': descriptionEn,
          'link': link,
          if (terms != null) 'terms': terms,
          'category_id': categoryId,
          'discount': discount,
          'status': status,
        }),
      );

      print('Update Coupon Response: ${response.body}');

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Coupon updated successfully');
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to update coupon');
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
        }
        return false;
      }
    } catch (e) {
      errorMessage('Error updating coupon: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Delete a coupon
  Future<bool> deleteCoupon({required int id}) async {
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
        Uri.parse(ApiConstants.destroyCoupon),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      print('Delete Coupon Response: ${response.body}');

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Coupon deleted successfully');
        coupons.removeWhere((coupon) => coupon.id == id);
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to delete coupon');
        return false;
      }
    } catch (e) {
      errorMessage('Error deleting coupon: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Fetch coupons
  Future<bool> fetchCoupons({int page = 1, String? keyword}) async {
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
      var uri = Uri.parse(ApiConstants.getCoupon)
          .replace(queryParameters: queryParams);

      print('Fetching coupons: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Fetch Coupons Response: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final couponResponse = CouponResponse.fromJson(jsonData);

        if (couponResponse.status) {
          if (page == 1) {
            coupons.clear();
          }
          coupons.addAll(couponResponse.data.coupons);
          pagination.value = couponResponse.data.pagination;
          sortCoupons(sortOrder.value);
          return true;
        } else {
          errorMessage(couponResponse.message);
          return false;
        }
      } else {
        errorMessage('Failed to fetch coupons: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      if(e is TypeError){
        print(e.stackTrace);
      }
      errorMessage('Error fetching coupons: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}