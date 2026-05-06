import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/aboutapp_model.dart';
import '../../utils/api_constant.dart';


class SettingsService {

  Future<SettingsResponse?> fetchAboutUs() async {
    try {
      final response = await HttpService.instance.get(Uri.parse(ApiConstants.aboutUs));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SettingsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load about us: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching about us: $e');
      return null;
    }
  }

  Future<SettingsResponse?> fetchPrivacyPolicy() async {
    try {
      final response = await HttpService.instance.get(Uri.parse(ApiConstants.privacyPolicy));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SettingsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load privacy policy: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching privacy policy: $e');
      return null;
    }
  }
  Future<SettingsResponse?> fetchTerms() async {
    try {
      final response = await HttpService.instance.get(Uri.parse(ApiConstants.termsConditions));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SettingsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load privacy policy: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching privacy policy: $e');
      return null;
    }
  }
}
class PrivacyPolicyController extends GetxController {
  var isLoading = false.obs;
  var privacyPolicyContent = ''.obs;
  var errorMessage = ''.obs;

  final SettingsService _settingsService = SettingsService();

  @override
  void onInit() {
    fetchPrivacyPolicy();
    super.onInit();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await _settingsService.fetchPrivacyPolicy();

      if (response != null && response.status == true) {
        privacyPolicyContent(response.data ?? '');
      } else {
        errorMessage('Failed to retrieve privacy policy content');
      }
    } catch (e) {
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
class AboutUsController extends GetxController {
  var isLoading = false.obs;
  var aboutUsContent = ''.obs;
  var errorMessage = ''.obs;

  final SettingsService _settingsService = SettingsService();

  @override
  void onInit() {
    fetchAboutUs();
    super.onInit();
  }

  Future<void> fetchAboutUs() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await _settingsService.fetchAboutUs();

      if (response != null && response.status == true) {
        aboutUsContent(response.data ?? '');
      } else {
        errorMessage('Failed to retrieve about us content');
      }
    } catch (e) {
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
class TermsController extends GetxController {
  var isLoading = false.obs;
  var termsContent = ''.obs;
  var errorMessage = ''.obs;

  final SettingsService _settingsService = SettingsService();

  @override
  void onInit() {
    fetchTerms();
    super.onInit();
  }

  Future<void> fetchTerms() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await _settingsService.fetchTerms();

      if (response != null && response.status == true) {
        termsContent(response.data ?? '');
      } else {
        errorMessage('Failed to retrieve about us content');
      }
    } catch (e) {
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}