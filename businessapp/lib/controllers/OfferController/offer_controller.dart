import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/offer_model.dart';
import '../../models/product_model.dart';
import '../../utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';
import 'package:intl/intl.dart'; // Add this import

class OfferController extends GetxController {
  RxString showOfferTitleInOfferCardGrid  = ''.obs;
  RxString showOfferDescriptionInOfferCardGrid  = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var validationErrors = <String, List<String>>{}.obs;
  var offers = <Offer>[].obs;
  var pagination = Rxn<Pagination>();
  var sortOrder = 'new_to_old'.obs;
  RxString selectedValueDiscountType = 'percentage'.obs;
  String? DiscountTypeInfo;

  // Helper method to get the token.
  Future<String?> _getToken() async {
    return await SharedPrefsConstants.getToken();
  }

  void sortOffers(String order) {
    sortOrder.value = order;
    offers.sort((a, b) {
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

  // Add a new offer
  Future<bool> addOffer({
    required String discountType,
    required String discountTypeInfo,
    // required File image,
    required String descriptionAr,
    required String descriptionEn,
    required String link,
    required int categoryId,
    required String titleAr,
    String? titleEn,
    String? terms,
    String? couponCode,
    int status = 1,
  }) async {
    isLoading(true);
    errorMessage('');
    successMessage('');
    validationErrors.clear();
    print('creating offer ...');
    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.storeOffer),
      );

      // Add text fields
      request.fields['description_ar'] = descriptionAr;
      request.fields['type'] = discountType;
      request.fields['title_ar'] = titleAr;
      request.fields['description_en'] = descriptionEn;
      request.fields['link'] = link;
      request.fields['category_id'] = categoryId.toString();
      // request.fields['title_ar'] = titleAr;
      if (titleEn != null) request.fields['title_en'] = titleEn;
      if (terms != null) request.fields['terms'] = terms;
      if (couponCode != null) request.fields['coupon_code'] = couponCode;
      request.fields['status'] = status.toString();

      // Add image
      // request.files.add(await http.MultipartFile.fromPath('image', image.path));

      // Set headers with token
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);

      print('Add Offer Response: $responseBody');

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Offer added successfully');
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to add offer');
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
        }
        return false;
      }
    } catch (e) {
      errorMessage('Error adding offer: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Update an existing offer
  Future<bool> updateOffer({
    required String discountType,
    required String discountTypeInfo,
    required int offerId,
    File? image,
    required String descriptionAr,
    required String descriptionEn,
    required String link,
    required int categoryId,
    required String titleAr,
    String? titleEn,
    String? terms,
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
        Uri.parse(ApiConstants.updateOffer),
      );
      // Add text fields
      request.fields['id'] = offerId.toString();
      request.fields['description_ar'] = descriptionAr;
      // ====== added discount type and info ---- info passed in title_ar
      request.fields['type'] = discountType;
      request.fields['title_ar'] = discountTypeInfo;

      request.fields['description_en'] = descriptionEn;
      request.fields['link'] = link;
      request.fields['category_id'] = categoryId.toString();
      // request.fields['title_ar'] = titleAr;
      if (titleEn != null) request.fields['title_en'] = titleEn;
      if (terms != null) request.fields['terms'] = terms;
      if (couponCode != null) request.fields['coupon_code'] = couponCode;
      request.fields['status'] = status.toString();

      // Add image if provided
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
      }

      // Set headers with token
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      print(Uri.parse(ApiConstants.updateOffer));
      print(request.fields);
      print(request.headers);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);

      print('Update Offer Response: $responseBody');

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Offer updated successfully');
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to update offer');
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
        }
        return false;
      }
    } catch (e) {
      errorMessage('Error updating offer: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Delete an offer
  Future<bool> deleteOffer({required int id}) async {
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
        Uri.parse(ApiConstants.destroyOffer),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      print('Delete Offer Response: ${response.body}');

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Offer deleted successfully');
        offers.removeWhere((offer) => offer.id == id);
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to delete offer');
        return false;
      }
    } catch (e) {
      errorMessage('Error deleting offer: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Fetch offers
  Future<bool> fetchOffers({int page = 1, String? keyword}) async {
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
      var uri =
          Uri.parse(ApiConstants.getOfferBanners)
              .replace(queryParameters: queryParams);

      print('Fetching offers: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Fetch Offers Response: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final offerResponse = OfferResponse.fromJson(jsonData);

        if (offerResponse.status) {
          if (page == 1) {
            offers.clear();
          }
          offers.addAll(offerResponse.data.offers);
          pagination.value = offerResponse.data.pagination;
          sortOffers(sortOrder.value);
          return true;
        } else {
          errorMessage(offerResponse.message);
          return false;
        }
      } else {
        errorMessage('Failed to fetch offers: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      if (e is TypeError) {
        print(e.stackTrace);
      }
      errorMessage('Error fetching offers: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
