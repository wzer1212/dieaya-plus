import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'best_market_model.dart';

class MarketBanner {
  final int id;
  final int marketId;
  final Market market;
  final String image;
  final String link;
  final String descriptionAr;
  final String descriptionEn;
  final String location;

  MarketBanner({
    required this.id,
    required this.marketId,
    required this.market,
    required this.image,
    required this.link,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.location,
  });

  factory MarketBanner.fromJson(Map<String, dynamic> json) {
    return MarketBanner(
      id: json['id'] ?? 0,
      marketId: json['market_id'] ?? 0,
      market: Market.fromJson(json['market'] ?? {}),
      image: json['image'] ?? '',
      link: json['link'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'market_id': marketId,
      'market': market.toJson(),
      'image': image,
      'link': link,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'location': location,
    };
  }
}

class MarketBannersController extends GetxController {
  var banners = <MarketBanner>[].obs;
  var pagination = Pagination(currentPage: 1, lastPage: 1, perPage: 15, total: 0).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;



  Future<void> fetchMarketBanners({
    required String location,
    int perPage = 15,
    int page = 1,
  }) async {
    if (!['top', 'middle', 'bottom'].contains(location)) {
      errorMessage.value = 'Invalid location. Must be top, middle, or bottom.';
      return;
    }

    try {
      isLoading(true);
      final response = await HttpService.instance.get(
        Uri.parse(
          '${ApiConstants.marketBanners}'
              '?location=$location'
              '&per_page=$perPage'
              '&page=$page',
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          banners.value = (jsonData['data']['market_banner'] as List<dynamic>?)
              ?.map((json) => MarketBanner.fromJson(json))
              .toList() ??
              [];
          pagination.value = Pagination.fromJson(jsonData['data']['pagination'] ?? {});
        } else {
          errorMessage.value = jsonData['message'] ?? 'Failed to load banners';
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
}