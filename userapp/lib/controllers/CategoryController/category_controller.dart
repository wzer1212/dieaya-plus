import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/categories_model.dart';

class CategoryController extends GetxController {
  var categories = <kCategory>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final response = await HttpService.instance.get(
        Uri.parse(ApiConstants.getCategories),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          // Extract the nested list and convert to Category objects
          List<dynamic> data = jsonData['data'][0];
          categories.value = data.map((json) => kCategory.fromJson(json)).toList();
        } else {
          errorMessage.value = jsonData['message'] ?? 'Failed to load categories';
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}