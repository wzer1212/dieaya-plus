import 'dart:async';

import 'package:dieaya_user/models/best_market_model.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/coupons_model.dart';


class MarketCouponController extends GetxController {
  var coupons = <MarketCoupon>[].obs;
  var pagination = Pagination(currentPage: 1, lastPage: 1, perPage: 10, total: 0).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs; // Track the current search query
  Timer? _debounceTimer; // Timer for debouncing search

  @override
  void onInit() {
    fetchCoupons();
    super.onInit();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel the timer when the controller is closed
    super.onClose();
  }

  Future<void> fetchCoupons({int page = 1, String? keyword,  bool? isFromPaginationUi= false}) async {
    try {
      if(!isFromPaginationUi!){
        isLoading(true);
      }
      errorMessage('');

      // Build the URL with optional keyword
      String url = '${ApiConstants.getMarketCoupons}?page=$page';
      if (keyword != null && keyword.isNotEmpty) {
        coupons.clear();
        url += '&keyword=$keyword';
      }

      final response = await HttpService.instance.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          // Extract coupons and pagination data
          List<dynamic> couponData = jsonData['data']['coupons'] ?? [];
          coupons.value.addAll(couponData.map((json) => MarketCoupon.fromJson(json)).toList());
          pagination.value = Pagination.fromJson(jsonData['data']['pagination'] ?? {});
          // Update pagination
          print('==========================>>>>>>>>>>>> products length ${coupons.length}');

        } else {
          errorMessage.value = jsonData['message'] ?? 'Failed to load coupons';
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }

  // Method to handle real-time search with debouncing
  void searchCoupons(String keyword) {
    // Cancel any existing debounce timer
    _debounceTimer?.cancel();

    searchQuery.value = keyword.trim();

    // Start a new timer to debounce the search
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (keyword.isNotEmpty) {
        fetchCoupons(page: 1, keyword: keyword);
      } else {
        fetchCoupons(page: 1); // Fetch all coupons if keyword is empty
      }
    });
  }

  // Method to clear search
  void clearSearch() {
    _debounceTimer?.cancel();
    searchQuery.value = '';
    fetchCoupons(page: 1);
  }
}
