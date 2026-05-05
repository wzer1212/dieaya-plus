import 'dart:convert';

import 'package:dieaya_user/models/home_screen/show_home_category_products.dart';
import 'package:dieaya_user/utils/api/api_util.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
enum Status {loading, success, error}
class ShowHomeCategoriesController extends GetxController {
  Rx<CategoriesResponse?> categoriesResponse = Rx<CategoriesResponse?>(null);
  HttpService httpService = HttpService.instance;

  Rx status = Status.loading.obs;
  RxString  errorMessage =''.obs;

  Future<void> getShowHomeCategoryProduct() async {
    try {
      var res = await httpService.get( Uri.parse(ApiConstants.showCategoryHomeScreen));
      if(res.statusCode ==200){

        categoriesResponse.value = CategoriesResponse.fromJson(jsonDecode(res.body));
        print('===========================>${categoriesResponse.value!.data.length}');

        status.value = Status.success;
      }else{
        // Handle unexpected status code
        errorMessage.value = 'Unexpected error: ${res.statusCode}';
        status.value = Status.error;
      }

    } catch (e) {
      print(e);
      if(e is DioException)
        {
          print("response:${e.response}");
          print("message:${e.message}");
          print("stackTrace${e.stackTrace}");
          print("stackTrace${e.type}");
        }
      errorMessage.value = e.toString();
      status.value = Status.error;
    }
  }
}
