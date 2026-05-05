import 'dart:convert';

import 'package:dieaya_user/models/visits_models/market_visit_nodel.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/app_sharedprefs_contants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class MarketVisitControllers extends GetxController {
  Future<void> callMarketVisit(int marketID) async {
    final token = SharedPrefsConstants.getToken();

    try{
      var uri = Uri.parse('${ApiConstants.marketVisit}?market_id=$marketID');
 print('=======request --===========$uri');
      var response = await HttpService.instance.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': "application/json"
      });

      print('market visit status code ======>${(response.statusCode)}');
      print('market visit response ======>${jsonDecode(response.body)}');
    }catch (e){
      print('market visit error ======>$e');
    }
  }
  Future<void> callMarketSurfer(int marketID) async {
    final token = SharedPrefsConstants.getToken();

    try{
      var uri = Uri.parse('${ApiConstants.marketSurfer}?market_id=$marketID');
      print('=======request --===========$uri');

      var response = await HttpService.instance.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': "application/json"
      });

      print('market surfer status code ======>${(response.statusCode)}');
      print('market surfer response ======>${jsonDecode(response.body)}');
    }catch (e){
      print('market surfer error ======>$e');
    }
  }
  Future<void> callMarketShareCountIncrease(int marketID) async {
    final token = SharedPrefsConstants.getToken();

    try{
      var uri = Uri.parse('${ApiConstants.marketShareIncreaseCount}?market_id=$marketID');
      print('=======request --===========$uri');
      var response = await HttpService.instance.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': "application/json"
      });

      print('market share status code ======>${(response.statusCode)}');
      print('market share response ======>${jsonDecode(response.body)}');
    }catch (e){
      print('market share error ======>$e');
    }
  }
}
