import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Utils/app_sharedprefs_contants.dart';
import '../../models/product_model.dart';

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  var pagination =
      PaginationProduct(currentPage: 1, lastPage: 1, perPage: 10, total: 0).obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var httpService = HttpService.instance;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts({int page = 1}) async {
    try {
      final token = await SharedPrefsConstants.getToken();
      isLoading(true);
      print('*******************************products***********'
          '${Uri.parse('${ApiConstants.getProducts}?page=$page')}');



      final response =


      await httpService.get(
          Uri.parse('${ApiConstants.getProducts}?page=$page'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          List<dynamic> productsData = jsonData['data']['products'] ?? [];
          products.value =
              productsData.map((json) => Product.fromJson(json)).toList();
          pagination.value =
              PaginationProduct.fromJson(jsonData['data']['pagination'] ?? {});
        } else {
          errorMessage.value = jsonData['message'] ?? 'Failed to load products';
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
