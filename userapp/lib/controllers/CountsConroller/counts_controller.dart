import 'dart:convert';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Utils/app_sharedprefs_contants.dart';

class ViewCountController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Base URL for API
  static final  String _baseUrl = '${ApiConstants.baseUrl}/customer/increase_views_count';

  // Increment market view count
  Future<bool> incrementMarketViews(int marketId) async {
    print('Calling incrementMarketViews with marketId: $marketId');
    return await _incrementViewCount('market', 'market_id', marketId);
  }

  // Increment product view count
  Future<bool> incrementProductViews(int productId) async {
    print('Calling incrementProductViews with productId: $productId');
    return await _incrementViewCount('product', 'product_id', productId);
  }

  // Increment offer view count
  Future<bool> incrementOfferViews(int offerId) async {
    print('Calling incrementOfferViews with offerId: $offerId');
    return await _incrementViewCount('market_offer', 'offer_id', offerId);
  }

  // Increment coupon view count
  Future<bool> incrementCouponViews(int couponId) async {
    print('Calling incrementCouponViews with couponId: $couponId');
    return await _incrementViewCount('market_coupon', 'coupon_id', couponId);
  }

  Future<bool> incrementMarketBannerViews(int marketBannerId) async {
    print('Calling incrementMarketBannerViews with marketBannerId: $marketBannerId');
    return await _incrementViewCount('market_banner', 'market_banner_id', marketBannerId);
  }

  // Generic method to handle view count increment
  Future<bool> _incrementViewCount(String endpoint, String idKey, int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Retrieve token
      // final token = await SharedPrefsConstants.getToken();
      // print('Retrieved token: ${token != null ? 'Valid token' : 'Null or empty token'}');
      // if (token == null || token.isEmpty) {
      //   errorMessage.value = 'No authentication token available';
      //   print('Error: $errorMessage');
      //   return false;
      // }

      // Construct URL
      final url = Uri.parse('$_baseUrl/$endpoint?$idKey=$id');
      print('Request URL: $url');
      print('Headers: Accept: application/json, Authorization: Bearer [hidden]');

      // Make GET request
      final response = await HttpService.instance.get(
        url,
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer $token',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final status = jsonData['status'] as bool?;
        final message = jsonData['message'] as String?;

        print('Parsed JSON - Status: $status, Message: $message');

        if (status == true) {
          print('View count incremented successfully for $endpoint with $idKey=$id');
          return true;
        } else {
          errorMessage.value = message ?? 'Failed to increment view count';
          print('Error: $errorMessage');
          return false;
        }
      } else {
        errorMessage.value = 'Error: ${response.statusCode}';
        print('Error: $errorMessage');
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error incrementing view count: $e';
      print('Exception: $errorMessage');
      return false;
    } finally {
      isLoading.value = false;
      print('isLoading set to: ${isLoading.value}');
    }
  }
}