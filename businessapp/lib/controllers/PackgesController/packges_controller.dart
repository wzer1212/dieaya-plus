import 'dart:convert';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import 'package:get/get.dart';

import '../../models/packges_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';



class PackageController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final packages = <Package>[].obs;

  Future<void> fetchPackages() async {
    final token = await SharedPrefsConstants.getToken();
    print('================>token:$token');

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final httpService = HttpService.instance;
      final response = await httpService.get(
        Uri.parse(ApiConstants.packages),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final packageResponse = PackageResponse.fromJson(jsonData);
        if (packageResponse.status == true && packageResponse.data != null) {
          packages.assignAll(packageResponse.data!);
        } else {
          errorMessage.value = packageResponse.message ?? 'Failed to load packages';
        }
      } else {
        errorMessage.value = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching packages: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }
}