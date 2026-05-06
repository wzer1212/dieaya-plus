import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Utils/app_sharedprefs_contants.dart';
import '../../models/best_market_model.dart';
import '../../models/coupons_model.dart';
import '../../models/offer_model.dart';
import '../../models/product_model.dart';

class MarketDetailsController extends GetxController {
  var market = Rxn<Market>();
  var products = <Product>[].obs;
  var offers = <MarketOffer>[].obs;
  var coupons = <MarketCoupon>[].obs;
  var pagination =
      Pagination(currentPage: 1, lastPage: 1, perPage: 10, total: 0).obs;
  var isLoading = false.obs;
  var isGrid = true.obs;
  var errorMessage = ''.obs;

  Future<void> fetchMarketDetails({
    required int marketId,
    int productsPerPage = 10,
    int offersPerPage = 10,
    int couponsPerPage = 10,
    int productsPage = 1,
    int offersPage = 1,
    int couponsPage = 1,
  }) async {
    try {
      isLoading(true);
      final token = await SharedPrefsConstants.getToken();
      print('=============>url>>>>>>>>>>${Uri.parse(
        '${ApiConstants.marketData}'
            '?market_id=$marketId'
            '&products_per_page=$productsPerPage'
            '&offers_per_page=$offersPerPage'
            '&coupons_per_page=$couponsPerPage'
            '&products_page=$productsPage'
            '&offers_page=$offersPage'
            '&coupons_page=$couponsPage',
      )}');

      final response = await HttpService.instance.get(
          Uri.parse(
            '${ApiConstants.marketData}'
            '?market_id=$marketId'
            '&products_per_page=$productsPerPage'
            '&offers_per_page=$offersPerPage'
            '&coupons_per_page=$couponsPerPage'
            '&products_page=$productsPage'
            '&offers_page=$offersPage'
            '&coupons_page=$couponsPage',
          ),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('=-======================>jsonData=>$jsonData');
        print('get_all_markets : $jsonData');
        if (jsonData['status'] == true) {
          final marketsData = jsonData['data']['markets'] as List<dynamic>;
          if (marketsData.isNotEmpty) {
            final marketData = marketsData[0];
            market.value = Market.fromJson(marketData);
            products.value = (marketData['products'] as List<dynamic>?)
                    ?.map((json) => Product.fromJson(json))
                    .toList() ??
                [];
            print('=========products.value=products.value===products.value=products.valueproducts.value=products.value${products.value.length}');

            offers.value = (marketData['offers'] as List<dynamic>?)
                    ?.map((json) => MarketOffer.fromJson(json))
                    .toList() ??
                [];
            coupons.value = (marketData['coupons'] as List<dynamic>?)
                    ?.map((json) => MarketCoupon.fromJson(json))
                    .toList() ??
                [];
            pagination.value =
                Pagination.fromJson(jsonData['data']['pagination'] ?? {});
          } else {
            errorMessage.value = 'No market data found';
          }
        } else {
          errorMessage.value =
              jsonData['message'] ?? 'Failed to load market data';
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error==========>${e.toString()}');
      if(e is TypeError){
        print(e.stackTrace);
      }
      print('*******************fetchMarketDetails Error*************>$e');
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}
