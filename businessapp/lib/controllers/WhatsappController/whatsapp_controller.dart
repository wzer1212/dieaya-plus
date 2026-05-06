import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../utils/api_constant.dart';

import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WhatsAppCampaignController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var validationErrors = <String, String>{}.obs;

  Future<bool> addWhatsAppCampaign({
    required String description,
    File? advertise_image,
    File? numbers_file,
    required String start_date,
    String? note,
    required String market_link,
  }) async {
    isLoading(true);
    errorMessage('');
    validationErrors.clear();

    try {
      final token = await SharedPrefsConstants.getToken();
      if (token == null || token.isEmpty) {
        errorMessage('No authentication token found. Please log in.');
        return false;
      }

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.addWhatsappCampaign),
      );

      // Set headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add text fields to the request
      request.fields['description'] = description;
      request.fields['start_date'] = start_date;
      request.fields['market_link'] = market_link.contains('https://')?market_link:'https://${market_link}';
      if (note != null) request.fields['note'] = note;

      // Add file fields if provided
      if (advertise_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'advertise_image',
          advertise_image.path,
          filename: advertise_image.path.split('/').last,
        ));
      }

      if (numbers_file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'numbers_file',
          numbers_file.path,
          filename: numbers_file.path.split('/').last,
        ));
      }

      // Send the request
      final response = await request.send().timeout(const Duration(seconds: 30));

      // Get the response body
      final responseBody = await response.stream.bytesToString();

      print('Add WhatsApp Campaign API Request fields: ${request.fields}');
      print('Add WhatsApp Campaign API Request files: ${request.files.map((file) => file.filename).toList()}');
      print('Add WhatsApp Campaign API Response status: ${response.statusCode}');
      print('Add WhatsApp Campaign API Response body: $responseBody');

      if (response.headers['content-type']?.contains('application/json') != true) {
        errorMessage('Server returned non-JSON response. Please check the API endpoint.');
        return false;
      }

      final data = jsonDecode(responseBody);
      print('data ================+++===========++++++======+>$data');


      if (response.statusCode == 200 && data['status'] == true || response.statusCode == 201 && data['status'] == true) {
        return true;
      } else if (response.statusCode == 422 && data['errors'] != null) {
        final errors = data['errors'] as Map<String, dynamic>;
        errors.forEach((field, errorList) {
          if (errorList is List && errorList.isNotEmpty) {
            validationErrors[field] = errorList[0].toString();
          }
        });
        return false;
      } else {
        errorMessage(data['message'] ?? 'Failed to create WhatsApp campaign');
        return false;
      }
    } on FormatException catch (e) {
      errorMessage('Invalid response format: ${e.message}. Server may have returned HTML.');
      return false;
    } catch (e) {
      errorMessage('Network error: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }
}