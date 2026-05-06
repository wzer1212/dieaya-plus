import 'dart:convert';
import 'dart:io';
import 'package:dieaya_market/Routes/app_routes.dart';
import 'package:dieaya_market/controllers/ProfileController/profile_controller.dart';
import 'package:dieaya_market/ui/pages/AuthScreens/success_register.dart';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import 'package:dieaya_market/utils/caching_sevice/shared_preferences.dart';
import 'package:dieaya_market/utils/constants/cache_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/api_constant.dart';

class BuyPackageController extends GetxController {

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var iosVerityIsLoading = false.obs;
  var iosVerityErrorMessage = ''.obs;
  var iosVeritySuccessMessage = ''.obs;

  Future<bool> verifyInAppPurchase(String transactionId,int packageId,String env) async {
    iosVerityIsLoading.value = true;
    iosVerityErrorMessage.value = '';
    iosVeritySuccessMessage.value = '';

    try {
      final token = await SharedPrefsConstants.getToken();
      debugPrint('verifyInAppPurchase Token: $token');
      if (token == null) {
        errorMessage.value = 'not_logged_in'.tr;
        debugPrint('verifyInAppPurchase Error: No token found');
      }

      final url =
          Uri.parse(ApiConstants.verifyIosReceipt);
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      print('=====================> transactionId Id =>$transactionId');
      print('=====================> userId Id =>${MySharedPreference.getData(key: CacheConstants.userId)}');
      var userId = MySharedPreference.getData(key: CacheConstants.userId);
      final body = jsonEncode({
        'transaction': transactionId,
        'user_id': userId,
        'env': env,
      });

      debugPrint('verifyInAppPurchase Request: URL=$url, Headers=$headers, Body=$body');

      final response =
          await http.post(url, headers: headers, body: body).timeout(
                const Duration(seconds: 30),
                onTimeout: () => throw SocketException('Request timed out'),
              );

      debugPrint(
          'verifyInAppPurchase Response: Status=${response.statusCode}, Body=${response.body}');

      if (response.statusCode == 200) {
        print('response.statusCode ---------->${response.statusCode}');
        // final responseData = jsonDecode(response.body);
        print('==================================');
        print('=====                        =====');
        print('=====                        =====');
        print('=====                        =====');
        print('=====                        =====');
        print('==================================');

       return true;
      } else if (response.statusCode == 401) {
        iosVerityErrorMessage.value = 'authentication_failed'.tr;
        debugPrint('verifyInAppPurchase Error: 401 Unauthorized');
        Get.offAllNamed('/login');
        return false;
      } else {
        iosVerityErrorMessage.value =
            'server_error'.trParams({'status': response.statusCode.toString()});
        debugPrint('verifyInAppPurchase Error: Status=${response.statusCode}');
        return false;

      }
    } catch (e) {
      iosVerityIsLoading.value=false;
      isLoading.value=false;
      if(e is TypeError){
        print(e.stackTrace);
      }
      iosVerityErrorMessage.value = 'network_error'.trParams({'error': e.toString()});
      debugPrint('verifyInAppPurchase Exception: $e');
      throw e;
    } finally {
      isLoading.value = false;
      iosVerityIsLoading.value=false;
    }
  }

  Future<bool> buyPackage(int packageId,
      {String? invoiceId, int retryCount = 0,required String env}) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';


    try {
      final token = await SharedPrefsConstants.getToken();
      debugPrint('BuyPackage Token: $token');
      if (token == null) {
        errorMessage.value = 'not_logged_in'.tr;
        debugPrint('BuyPackage Error: No token found');
        return false;
      }

      final url = Uri.parse(ApiConstants.buyPackage);
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      print('=====================> package Id =>$packageId');

      final body = jsonEncode({
        'package_id': packageId,
        "env":env,
        if (invoiceId != null) 'invoice_id': invoiceId,
      });

      debugPrint('BuyPackage Request: URL=$url, Headers=$headers, Body=$body');

      final response =
          await http.post(url, headers: headers, body: body).timeout(
                const Duration(seconds: 30),
                onTimeout: () => throw SocketException('Request timed out'),
              );

      debugPrint(
          'BuyPackage Response: Status=${response.statusCode}, Body=${response.body}');

      if (response.statusCode == 200) {
        print('response.statusCode ---------->${response.statusCode}');
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          successMessage.value = responseData['message'] ?? 'success'.tr;
          // Get.offAndToNamed(AppRoutes.home);
          return true;
        } else if (invoiceId != null &&
            (responseData['message'] == 'Payment not completed' ||
                responseData['message'] == 'فشل الدفع') &&
            retryCount < 5) {
          debugPrint(
              'Payment error (200), retrying... Attempt ${retryCount + 1}');
          await Future.delayed(const Duration(seconds: 5));
          final env = Platform.isIOS?'ios':'android';

          return await buyPackage(packageId,
              invoiceId: invoiceId, retryCount: retryCount + 1,env: env);
        } else {
          errorMessage.value =
              responseData['message'] ?? 'unexpected_response'.tr;
          debugPrint(
              'BuyPackage Error: Invalid response format or status=false');
          return false;
        }
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        if (invoiceId != null &&
            (responseData['message'] == 'Payment not completed' ||
                responseData['message'] == 'فشل الدفع') &&
            retryCount < 5) {
          debugPrint(
              'Payment error (400), retrying... Attempt ${retryCount + 1}');
          await Future.delayed(const Duration(seconds: 5));
          final env = Platform.isIOS?'ios':'android';

          return await buyPackage(packageId,
              invoiceId: invoiceId, retryCount: retryCount + 1,env: env);
        } else {
          errorMessage.value = responseData['data']?['error_message'] ??
              responseData['message'] ??
              'server_error'.trParams({'status': '400'});
          debugPrint(
              'BuyPackage Error: 400 Bad Request - ${responseData['message']}');
          return false;
        }
      } else if (response.statusCode == 401) {
        errorMessage.value = 'authentication_failed'.tr;
        debugPrint('BuyPackage Error: 401 Unauthorized');
        Get.offAllNamed('/login');
        return false;
      } else {

        errorMessage.value =
            'server_error'.trParams({'status': response.statusCode.toString()});
        debugPrint('BuyPackage Error: Status=${response.body.toString()}');
        return false;
      }
    } catch (e) {
      if(e is TypeError){
        print(e.stackTrace);
      }
      errorMessage.value = 'network_error'.trParams({'error': e.toString()});
      debugPrint('BuyPackage Exception: $e');
      return false;
    } finally {
      isLoading.value = false;
      iosVerityIsLoading.value=false;
    }
   }
} // class BuyPackageResponse {
//   final bool? status;
//   final int? code;
//   final String? message;
//   final dynamic data;
//
//   BuyPackageResponse({
//     this.status,
//     this.code,
//     this.message,
//     this.data,
//   });
//
//   factory BuyPackageResponse.fromJson(Map<String, dynamic>? json) {
//     if (json == null) {
//       return BuyPackageResponse();
//     }
//     return BuyPackageResponse(
//       status: json['status'] as bool?,
//       code: json['code'] as int?,
//       message: json['message'] as String?,
//       data: json['data'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       if (status != null) 'status': status,
//       if (code != null) 'code': code,
//       if (message != null) 'message': message,
//       if (data != null) 'data': data,
//     };
//   }
// }
