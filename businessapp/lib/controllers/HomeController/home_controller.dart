import 'dart:convert';
import 'package:get/get.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../models/home_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';


class HomeController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final homeData = Rxn<HomeResponse>();
  Future<String?> _getToken() async {
    return await SharedPrefsConstants.getToken();
  }
  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final token = await _getToken();
      final httpService = HttpService.instance;
      final response = await httpService.get(
        Uri.parse(ApiConstants.home),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {

        final jsonData = json.decode(response.body);
        final homeResponse = HomeResponse.fromJson(jsonData);
        print('======================HomeResponseData==============>');
        print(homeResponse.message!.favorites!.percentage);
        if (homeResponse.status == true && homeResponse.message != null) {
          homeData.value = homeResponse;
        } else {
          errorMessage.value = homeResponse.message?.toString() ?? 'Failed to load home data';
        }
      } else {
        errorMessage.value = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching home data: $e';
    } finally {
      isLoading.value = false;
    }
  }
}