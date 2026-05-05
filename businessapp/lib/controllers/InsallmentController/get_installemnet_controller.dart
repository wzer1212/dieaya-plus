import 'package:get/get.dart';
import 'dart:convert';

import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../models/installment_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';

class InstallmentWayController extends GetxController {
  final isLoading = false.obs;
  final installmentWays = <InstallmentWay>[].obs;
  final errorMessage = ''.obs;

  Future<bool> fetchInstallmentWays() async {
    print('Fetching installment ways');
    isLoading(true);
    errorMessage.value = '';

    try {
      final token = await SharedPrefsConstants.getToken();
      if (token == null) {
        print('No token found');
        errorMessage.value = 'unauthenticated'.tr;
        isLoading(false);
        return false;
      }

      final httpService = HttpService.instance;
      final response = await httpService.get(
        Uri.parse(ApiConstants.getInstallmentWays),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && jsonResponse['status'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        installmentWays.assignAll(data.map((item) => InstallmentWay.fromJson(item)).toList());
        print('Installment ways fetched: ${installmentWays.length}');
        isLoading(false);
        return true;
      } else {
        errorMessage.value = jsonResponse['message'] ?? 'failed_to_fetch_installment_ways'.tr;
        print('Error: ${errorMessage.value}');
        isLoading(false);
        return false;
      }
    } catch (e) {
      print('Exception in fetchInstallmentWays: $e');
      errorMessage.value = 'unexpected_error'.tr;
      isLoading(false);
      return false;
    }
  }
}