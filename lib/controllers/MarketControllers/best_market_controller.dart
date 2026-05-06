import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/best_market_model.dart';

class BestMarketsController extends GetxController {
  var markets = <Market>[].obs;
  var pagination = Pagination(currentPage: 1, lastPage: 1, perPage: 10, total: 0).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch markets initially with default parameters
    fetchBestMarkets();
  }
  Future<void> fetchBestMarkets({
    int page = 1,
    String? categoryId,
    String? keyword,
  }) async {
    await Future.microtask(() async {
      try {
        if (isLoading.value) return; // Skip if already fetching
        isLoading.value = true;
        errorMessage.value = '';

        // Build query parameters
        final queryParameters = {
          'page': page.toString(),
          if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        };
        final uri = Uri.parse(ApiConstants.bestMarkets)
            .replace(queryParameters: queryParameters);

        final response = await HttpService.instance.get(uri);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          if (jsonData['status'] == true) {
            List<dynamic> marketsData = jsonData['data']['markets'] ?? [];
            markets.value = marketsData.map((json) => Market.fromJson(json)).toList();
            pagination.value = Pagination.fromJson(jsonData['data']['pagination'] ?? {});
          } else {
            errorMessage.value = jsonData['message'] ?? 'Failed to load best markets';
          }
        } else {
          errorMessage.value = 'Server error: ${response.statusCode}';
        }
      } catch (e) {
          print('Error==========>${e.toString()}');

        if(e is TypeError){
          print(e.stackTrace);
        }
        errorMessage.value = 'Error: $e';
      } finally {
        isLoading.value = false;
      }
    });
  }
}

class MostViewedMarketsController extends GetxController {
  var markets = <Market>[].obs;
  var pagination = Pagination(currentPage: 1, lastPage: 1, perPage: 10, total: 0).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var httpService = HttpService.instance;


  @override
  void onInit() {
    super.onInit();
    // Fetch markets initially with default parameters
    fetchMostViewedMarkets();
  }

  Future<void> fetchMostViewedMarkets({
    int page = 1,
    String? categoryId,
    String? keyword,
  }) async {
    await Future.microtask(() async {
      try {
        if (isLoading.value) return; // Skip if already fetching
        isLoading.value = true;
        errorMessage.value = '';

        // Build query parameters
        final queryParameters = {
          'page': page.toString(),
          if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        };
        final uri = Uri.parse(ApiConstants.mostViewsMarkets)
            .replace(queryParameters: queryParameters);

        final response = await httpService.get(uri);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          if (jsonData['status'] == true) {
            List<dynamic> marketsData = jsonData['data']['markets'] ?? [];
            markets.value = marketsData.map((json) => Market.fromJson(json)).toList();
            pagination.value = Pagination.fromJson(jsonData['data']['pagination'] ?? {});
          } else {
            errorMessage.value = jsonData['message'] ?? 'Failed to load most viewed markets';
          }
        } else {
          errorMessage.value = 'Server error: ${response.statusCode}';
        }
      } catch (e) {
        errorMessage.value = 'Error: $e';
      } finally {
        isLoading.value = false;
      }
    });
  }
}