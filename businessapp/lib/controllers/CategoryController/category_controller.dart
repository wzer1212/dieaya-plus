import 'package:get/get.dart';
import 'dart:convert';

import '../../models/product_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading(true);
    errorMessage('');

    try {
      final httpService = HttpService.instance;
      final response = await httpService.get(
        Uri.parse(ApiConstants.customerCategories),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          final List<dynamic> categoryList = jsonData['data'][0];
          categories.value = categoryList
              .map((json) => Category.fromJson(json))
              .where((category) => category.id != 1)
              .toList();
        } else {
          errorMessage.value = jsonData['message'] ?? 'Failed to fetch categories';
        }
      } else {
        errorMessage.value = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching categories: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }
}