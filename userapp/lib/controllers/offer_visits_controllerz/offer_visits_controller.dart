import 'dart:convert';

import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/app_sharedprefs_contants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class OfferVisitsController extends GetxController{


  Future<void> callOfferVisit(int offerID) async {
    final token = SharedPrefsConstants.getToken();

    try{
      var uri = Uri.parse('${ApiConstants.offerVisit}?offer_id=$offerID');

      var response = await HttpService.instance.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': "application/json"
      });

      print('offer visit status code ======>${(response.statusCode)}');
      print('offer visit response ======>${jsonDecode(response.body)}');
    }catch (e){
      print('offer visit error ======>$e');
    }
  }
}