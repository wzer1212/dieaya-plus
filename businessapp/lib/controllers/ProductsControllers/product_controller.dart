import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../models/product_model.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';
import 'package:intl/intl.dart'; // Add this import

class ProductController extends GetxController {
  var isLoading = false.obs;
  var addProductModalSheetCardTitle = ''.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var validationErrors =
      <String, List<String>>{}.obs; // Add for field-specific errors
  var products = <Product>[].obs;
  var pagination = Rxn<Pagination>();
  var sortOrder = 'new_to_old'.obs; // Add sortOrder

  // Helper method to get the token
  Future<String?> _getToken() async {
    return await SharedPrefsConstants.getToken();
  }

  void sortProducts(String order) {
    print(products.map(
      (element) {
        print(element.createdAt);
      },
    ));
    sortOrder.value = order;
    products.sort((a, b) {
      final dateA = _parseDate(a.createdAt) ??
          DateTime(1970); // Fallback to epoch for invalid dates
      final dateB = _parseDate(b.createdAt) ?? DateTime(1970);
      return order == 'new_to_old'
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });
  }

  DateTime? _parseDate(String? createdAt) {
    if (createdAt == null) return null;
    try {
      // Try parsing DD-MM-YYYY format
      final format = DateFormat('dd-MM-yyyy');
      return format.parse(createdAt);
    } catch (e) {
      try {
        // Fallback to ISO 8601 or other standard formats
        return DateTime.parse(createdAt);
      } catch (e2) {
        debugPrint('Error parsing createdAt: $e2, value: $createdAt');
        return null;
      }
    }
  }

  // Add a new product
  Future<bool> addProduct({
    required String nameAr,
    String? nameEn,
    required int categoryId,
    required String descriptionAr,
    String? descriptionEn,
    required String price,
    String? priceOffer,
    required String link,
    required List<File> images,
    List<int>? installmentIds,
    int status = 1,
  }) async {
    isLoading(true);
    errorMessage('');
    successMessage('');
    validationErrors.clear();

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.storeProduct),
      );

      // Add text fields
      request.fields['name_ar'] = nameAr;
      if (nameEn != null) request.fields['name_en'] = nameEn;
      request.fields['category_id'] = categoryId.toString();
      request.fields['description_ar'] = descriptionAr;
      if (descriptionEn != null)
        request.fields['description_en'] = descriptionEn;
      request.fields['price'] = price;
      if (priceOffer != null) request.fields['price_offer'] = priceOffer;
      request.fields['link'] = link;
      request.fields['status'] = status.toString();

      // Add images
      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images[]',
          image.path,
        ));
      }
      if (installmentIds != null && installmentIds.isNotEmpty) {
        for (var i = 0; i < installmentIds.length; i++) {
          request.fields['installment_ids[$i]'] = installmentIds[i].toString();
        }
      }
      // Set headers with token
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);

      print('Add Product Response: $responseBody');

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Product added successfully');
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to add product');
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
        }
        return false;
      }
    } catch (e) {
      errorMessage('Error adding product: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Update an existing product
  Future<bool> updateProduct({
    required int productId,
    required String nameAr,
    String? nameEn,
    required int categoryId,
    required String descriptionAr,
    String? descriptionEn,
    required String price,
    String? priceOffer,
    required String link,
    List<File>? images,
    List<int>? installmentIds,
    int status = 1,
  }) async {
    isLoading(true);
    errorMessage('');
    successMessage('');
    validationErrors.clear();

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.updateProduct),
      );

      // Add text fields
      request.fields['id'] = productId.toString();
      request.fields['name_ar'] = nameAr;
      if (nameEn != null) request.fields['name_en'] = nameEn;
      request.fields['category_id'] = categoryId.toString();
      request.fields['description_ar'] = descriptionAr;
      if (descriptionEn != null)
        request.fields['description_en'] = descriptionEn;
      request.fields['price'] = price;

      request.fields['price_offer'] = priceOffer != null ? priceOffer : "";

      request.fields['link'] = link;
      request.fields['status'] = status.toString();

      // Add images if provided
      if (images != null) {
        for (var image in images) {
          request.files
              .add(await http.MultipartFile.fromPath('images[]', image.path));
        }
      }
      if (installmentIds != null && installmentIds.isNotEmpty) {
        for (var i = 0; i < installmentIds.length; i++) {
          request.fields['installment_ids[$i]'] = installmentIds[i].toString();
        }
      }
      // Set headers with token
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);
      debugPrint('Update Product Request Fields: ${request.fields}');
      debugPrint(
          'Update Product Request Files: ${request.files.map((f) => f.field).toList()}');

      print('Update Product Response: $responseBody');

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('Product updated successfully');
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to update product');
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            validationErrors[key] = List<String>.from(value as List<dynamic>);
          });
        }
        return false;
      }
    } catch (e) {
      errorMessage('Error updating product: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Delete a product
  Future<bool> deleteProduct({required int id}) async {
    isLoading(true);
    errorMessage('');
    successMessage('');

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.destroyProduct),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      print('Delete Product Response: ${response.body}');

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage(jsonData['message'] ?? 'Product deleted successfully');
        products.removeWhere((product) => product.id == id);
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to delete product');
        return false;
      }
    } catch (e) {
      errorMessage('Error deleting product: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Delete a product image
  Future<bool> deleteProductImage({
    required int productId,
    required int imageId,
  }) async {
    isLoading(true);
    errorMessage('');
    successMessage('');

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.deleteProductImage),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'product_id': productId,
          'image_id': imageId,
        }),
      );

      print('Delete Product Image Response: ${response.body}');

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == true) {
        successMessage('delete_image_success'.tr);
        final productIndex =
            products.indexWhere((product) => product.id == productId);
        if (productIndex != -1) {
          final updatedImages = products[productIndex]
              .images
              .where((image) => image.id != imageId)
              .toList();
          products[productIndex] = Product(
            id: products[productIndex].id,
            nameAr: products[productIndex].nameAr,
            nameEn: products[productIndex].nameEn,
            descriptionAr: products[productIndex].descriptionAr,
            descriptionEn: products[productIndex].descriptionEn,
            price: products[productIndex].price,
            priceOffer: products[productIndex].priceOffer,
            link: products[productIndex].link,
            isFeatured: products[productIndex].isFeatured,
            isFavorite: products[productIndex].isFavorite,
            categoryId: products[productIndex].categoryId,
            createdAt: products[productIndex].createdAt,
            updatedAt: products[productIndex].updatedAt,
            category: products[productIndex].category,
            images: updatedImages,
            status: products[productIndex].status,
            viewCount: products[productIndex].viewCount,
            installmentWays: [],
          );
        }
        return true;
      } else {
        errorMessage(jsonData['message'] ?? 'Failed to delete image');
        return false;
      }
    } catch (e) {
      errorMessage('Error deleting image: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Fetch products (GET request)
  Future<bool> fetchProducts({int page = 1, String? keyword}) async {
    isLoading(true);
    errorMessage('');
    successMessage('');

    try {
      final token = await _getToken();
      if (token == null) {
        errorMessage('No token found. Please log in again.');
        return false;
      }

      var queryParams = {
        'page': page.toString(),
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      };
      var uri = Uri.parse(ApiConstants.getProductsList)
          .replace(queryParameters: queryParams);

      print('Fetching products: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Fetch Products Response: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final productResponse = ProductResponse.fromJson(jsonData);

        if (productResponse.status) {
          if (page == 1) {
            products.clear();
          }
          products.addAll(productResponse.data.products);
          pagination.value = productResponse.data.pagination;
          sortProducts(sortOrder.value);
          return true;
        } else {
          errorMessage(productResponse.message);
          return false;
        }
      } else {
        errorMessage('Failed to fetch products: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      errorMessage('Error fetching products: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

// Future<File> _compressImage(File file) async {
//   final dir = await getTemporaryDirectory();
//   final targetPath =
//       path.join(dir.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");
//
//   var result = await FlutterImageCompress.compressAndGetFile(
//     file.absolute.path,
//     targetPath,
//     quality: 70, // 60–80 is a good range
//   );
//
//   return result ?? file; // fallback to original if compression fails
// }
}
