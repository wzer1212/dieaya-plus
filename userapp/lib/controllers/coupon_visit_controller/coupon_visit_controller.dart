import 'dart:convert';

import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/app_sharedprefs_contants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class CouponVisitsController extends GetxController{


  Future<void> callCouponVisit(int couponID) async {
    final token = SharedPrefsConstants.getToken();

    try{
      var uri = Uri.parse('${ApiConstants.couponVisit}?coupon_id=$couponID');

      var response = await HttpService.instance.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': "application/json"
      });

      print('coupon visit status code ======>${(response.statusCode)}');
      print('coupon visit response ======>${jsonDecode(response.body)}');
    }catch (e){
      print('coupon visit error ======>$e');
    }
  }
}