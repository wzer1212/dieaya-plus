import 'dart:convert';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../models/onboarding_model.dart';


class SplashController extends GetxController {
  var isLoading = false.obs;
  var splashData = <SplashData>[].obs;
  var errorMessage = ''.obs;

  final SplashService _splashService = SplashService();

  @override
  void onInit() {
    fetchSplashSettings();
    super.onInit();
  }

  Future<void> fetchSplashSettings() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await _splashService.fetchSplashSettings();

      if (response != null && response.status == true) {
        splashData.assignAll(response.data ?? []);
      } else {
        errorMessage('Failed to retrieve splash settings');
      }
    } catch (e) {
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
class SplashService {
  // API endpoint is provided by ApiConstants.onBoarding.

  Future<SplashResponse?> fetchSplashSettings() async {
    try {
      final response = await HttpService.instance.get(Uri.parse(ApiConstants.onBoarding));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SplashResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load splash settings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching splash settings: $e');
      return null;
    }
  }
}
