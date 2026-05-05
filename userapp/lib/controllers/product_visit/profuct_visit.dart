import 'dart:convert';

import 'package:dieaya_user/Utils/app_sharedprefs_contants.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductVisit extends GetxController {
  Future<void> callProductVisit(productID) async {
    var token = SharedPrefsConstants.getToken();
    try {
      var uri = Uri.parse('${ApiConstants.productVisit}?product_id=$productID');

      var response = await HttpService.instance.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': "application/json"
      });

      print('product visit status code ======>${(response.statusCode)}');
      print('product visit response ======>${jsonDecode(response.body)}');
    } catch (e) {
      print('product visit error ======>$e');
    }
  }
}
