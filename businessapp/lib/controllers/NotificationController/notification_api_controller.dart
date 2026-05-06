import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import '../../models/notification_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/API/http_service.dart';

class NotificationListController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var notifications = <NotificationItem>[].obs;
  var isUnauthorized = false.obs; // New flag for unauthorized state

  Future<String?> _getToken() async {
    return await SharedPrefsConstants.getToken();
  }

  Future<void> fetchNotifications() async {
    try {
      final token = await _getToken();
      isLoading.value = true;
      errorMessage.value = '';
      notifications.clear();
      isUnauthorized.value = false;

      final String apiUrl = ApiConstants.notification;

      final httpService = HttpService.instance;
      final response = await httpService.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        final notificationResponse =
            NotificationResponse.fromJson(responseData);
        notifications.assignAll(notificationResponse.data);
      } else if (response.statusCode == 401) {
        isUnauthorized.value = true;
        errorMessage.value = 'Unauthorized access. Please log in.';
        notifications.clear(); // Ensure empty list for unauthorized
      } else {
        errorMessage.value =
            responseData['message'] ?? 'Failed to fetch notifications';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<NotificationItem?> getNotification(int notificationId) async {
    try {
      final token = await _getToken();
      isLoading.value = true;
      errorMessage.value = '';
      isUnauthorized.value = false;

      final String apiUrl =
          '${ApiConstants.notification}/$notificationId';

      final httpService = HttpService.instance;
      final response = await httpService.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      print('====================>$responseData');

      if (response.statusCode == 200 && responseData['status'] == true) {
        final notificationResponse =
            NotificationResponse.fromJson(responseData);
        if (notificationResponse.data.isNotEmpty) {
          return notificationResponse.data.first;
        }
      } else if (response.statusCode == 401) {
        isUnauthorized.value = true;
        errorMessage.value = 'Unauthorized access. Please log in.';
      } else {
        errorMessage.value =
            responseData['message'] ?? 'Failed to fetch notification';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      final token = await _getToken();
      isLoading.value = true;
      errorMessage.value = '';
      isUnauthorized.value = false;

      final String apiUrl =
          '${ApiConstants.deleteNotification}/$notificationId';

      final httpService = HttpService.instance;
      final response = await httpService.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        notifications.removeWhere((item) => item.id == notificationId);
        notifications.refresh();
      } else if (response.statusCode == 401) {
        isUnauthorized.value = true;
        errorMessage.value = 'Unauthorized access. Please log in.';
      } else {
        errorMessage.value =
            responseData['message'] ?? 'Failed to delete notification';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final token = await _getToken();
      isLoading.value = true;
      errorMessage.value = '';
      isUnauthorized.value = false;

      final String apiUrl = ApiConstants.deleteAllNotification;

      final httpService = HttpService.instance;
      final response = await httpService.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        notifications.clear();
        notifications.refresh();
      } else if (response.statusCode == 401) {
        isUnauthorized.value = true;
        errorMessage.value = 'Unauthorized access. Please log in.';
      } else {
        errorMessage.value =
            responseData['message'] ?? 'Failed to delete all notifications';
      }
    } catch (e) {
      print(e);
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
