import 'dart:async';

import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Utils/app_sharedprefs_contants.dart';
import '../../models/offer_model.dart';

class MarketOffersController extends GetxController {
  var marketOffers = <MarketOffer>[].obs;
  var pagination =
      PaginationOffer(currentPage: 1, lastPage: 1, perPage: 10, total: 0).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs; // Track the current search query
  Timer? _debounceTimer; // Timer for debouncing search
  var offer = Rxn<MarketOffer>();

  @override
  void onInit() {
    fetchMarketOffers();
    super.onInit();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel the timer when the controller is closed
    super.onClose();
  }

  Future<void> fetchMarketOffers(
      {int page = 1, String? keyword, bool? isFromPaginationUi = false}) async {
    try {
      final token = await SharedPrefsConstants.getToken();
      if (!isFromPaginationUi!) {
        isLoading(true);
      }
      errorMessage('');

      // Build the URL with optional keyword
      String url = '${ApiConstants.marketOffers}?page=$page';
      if (keyword != null && keyword.isNotEmpty) {
        marketOffers.clear();
        url += '&keyword=$keyword';
      }

      final response = await HttpService.instance.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          List<dynamic> offersData = jsonData['data']['market_offers'] ?? [];
          marketOffers.value.addAll(
              offersData.map((json) => MarketOffer.fromJson(json)).toList());
          pagination.value =
              PaginationOffer.fromJson(jsonData['data']['pagination'] ?? {});
        } else {
          errorMessage.value =
              jsonData['message'] ?? 'Failed to load market offers';
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
  void searchMarketOffers(String keyword) {
    // Cancel any existing debounce timer
    _debounceTimer?.cancel();

    searchQuery.value = keyword.trim();

    // Start a new timer to debounce the search
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (keyword.isNotEmpty) {
        fetchMarketOffers(page: 1, keyword: keyword);
      } else {
        fetchMarketOffers(page: 1); // Fetch all offers if keyword is empty
      }
    });
  }

  // Method to clear search
  void clearSearch() {
    _debounceTimer?.cancel();
    searchQuery.value = '';
    fetchMarketOffers(page: 1);
  }

  Future<void> getOfferDetails(String id) async {
    isLoading(true);
    final token = await SharedPrefsConstants.getToken();
    try {
      String url = '${ApiConstants.offerDetails}/$id';

      var response = await HttpService.instance.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        offer.value = MarketOffer.fromJson((jsonDecode(response.body))['data']);
        isLoading(false);
      } else {
        errorMessage.value = jsonDecode(response.body)['message'] ??
            'Failed to load market offers';
        isLoading(false);
      }
    } catch (e) {
      if (e is TypeError) {
        print(e.stackTrace);
      }
      errorMessage(e.toString());
      isLoading(false);
    }
  }
}
