import 'dart:convert';

import 'package:dieaya_user/Utils/app_sharedprefs_contants.dart';
import 'package:dieaya_user/models/market_product_model.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductDetailsController extends GetxController {
  Rx<Product> product = Rx<Product>(Product.empty());
  var loading = false.obs;
  var errorMessage = ''.obs;

  Future<void> getProductDetails(String id) async {
    print('==============================> product details start }');

    loading(true);
    try {
      var token = await SharedPrefsConstants.getToken();

      var response = await HttpService.instance.get(
          Uri.parse('${ApiConstants.productDetails}/$id'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {

        loading(false);
        Map<String,dynamic> data = jsonDecode(response.body);
        print('==============================> product details ${data['message']}');

        product.value = Product.fromJson(data['data']);

        // product.value
        print('==============================> product details ${jsonDecode(response.body)}');
        print('==============================> product details ${ product.value.nameEn}');

      } else {
        print('==============================> product details ${ jsonDecode(response.body)['message'] }');
        loading(false);

        errorMessage.value =
            jsonDecode(response.body)['message'] ?? 'Failed to load products';
      }
    } catch (e) {
      print('==============================> product details error ${e.toString()}');

      errorMessage.value = e.toString();
    }
  }
}
