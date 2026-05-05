import 'dart:convert';

import 'package:dieaya_market/models/subscription_models/usage_subscription_model.dart';
import 'package:dieaya_market/utils/API/http_request_handler.dart';
import 'package:dieaya_market/utils/API/http_service.dart';
import 'package:dieaya_market/utils/api_constant.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import 'package:dieaya_market/utils/caching_sevice/shared_preferences.dart';
import 'package:get/state_manager.dart';

enum Status { loading, success, failure }

class SubscriptionDetailsController extends GetxController {
  Rxn<UsageResponseModel> usageDetails = Rxn<UsageResponseModel>();
  RxBool isLoading = false.obs;
  Rx status = Status.loading.obs;

  RxString errorMessage = ''.obs;

  Future<void> getUsageDetails() async {
    final token = await SharedPrefsConstants.getToken();
    final  http = HttpService.instance;

    try {
      var response = await http.get(
        Uri.parse(ApiConstants.subscriptionUsage)
        ,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );
      if (response.statusCode == 200) {
        usageDetails.value =
            UsageResponseModel.fromJson(jsonDecode(response.body));
        status.value = Status.success;
      } else {
        errorMessage.value = response.statusCode.toString();
        status.value = Status.failure;
      }
    } catch (e) {
      if(e is TypeError){
        print(e.stackTrace);
      }
      errorMessage.value = e.toString();
      status.value = Status.failure;
      print(e);
    }
  }
}
