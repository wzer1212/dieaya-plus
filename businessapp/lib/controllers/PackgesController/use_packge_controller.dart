import 'dart:convert';
import 'package:get/get.dart';
import '../../models/use_packge_model.dart';
import '../../utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';

class PackageUsageController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var packageUsages = <PackageUsage>[].obs;

  Future<bool> fetchPackageUsage() async {
    isLoading(true);
    errorMessage('');
    packageUsages.clear();

    try {
      final token = await SharedPrefsConstants.getToken();
      if (token == null || token.isEmpty) {
        errorMessage('No authentication token found. Please log in.');
        return false;
      }

      final httpService = HttpService.instance;
      final response = await httpService.get(
        Uri.parse(ApiConstants.subscriptionUsage),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print('Package Usage API Response status: ${response.statusCode}');
      print('Package Usage API Response body: ${response.body}');

      if (response.headers['content-type']?.contains('application/json') != true) {
        errorMessage('Server returned non-JSON response. Please check the API endpoint.');
        return false;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        print("===============ccccccc--------->$data");
        final packageUsageResponse = PackageUsageResponse.fromJson(data);
        packageUsages.assignAll(packageUsageResponse.data);
        return true;
      } else if (response.statusCode == 422 && data['errors'] != null) {
        final errors = data['errors'] as Map<String, dynamic>;
        errors.forEach((field, errorList) {
          if (errorList is List && errorList.isNotEmpty) {
            errorMessage(errorList[0].toString());
          }
        });
        return false;
      } else {
        errorMessage(data['message'] ?? 'Failed to fetch package usage');
        return false;
      }
    } on FormatException catch (e) {
      errorMessage('Invalid response format: ${e.message}. Server may have returned HTML.');
      return false;
    } catch (e) {
      if(e is TypeError){
        print(e.stackTrace);
      }
      errorMessage('Network error: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}