import 'dart:convert';
import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:dieaya_user/utils/api_constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Utils/app_sharedprefs_contants.dart';
import '../../models/notification_model.dart';


class NotificationListController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var notifications = <NotificationItem>[].obs;
  var isUnauthorized = false.obs;

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


      final response = await HttpService.instance.get(
        Uri.parse(ApiConstants.notification),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        final notificationResponse = NotificationResponse.fromJson(responseData);
        notifications.assignAll(notificationResponse.data);
      } else if (response.statusCode == 401) {
        isUnauthorized.value = true;
        errorMessage.value = 'Unauthorized access. Please log in.';
        notifications.clear();
      } else {
        errorMessage.value = responseData['message'] ?? 'Failed to fetch notifications';
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


      final response = await HttpService.instance.get(
        Uri.parse('${ApiConstants.notification}/$notificationId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        final notificationResponse = NotificationResponse.fromJson(responseData);
        if (notificationResponse.data.isNotEmpty) {
          return notificationResponse.data.first;
        }
      } else if (response.statusCode == 401) {
        isUnauthorized.value = true;
        errorMessage.value = 'Unauthorized access. Please log in.';
      } else {
        errorMessage.value = responseData['message'] ?? 'Failed to fetch notification';
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


      final response = await HttpService.instance.delete(
        Uri.parse('${ApiConstants.deleteNotification}/$notificationId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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
        errorMessage.value = responseData['message'] ?? 'Failed to delete notification';
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


      final response = await HttpService.instance.delete(
        Uri.parse(ApiConstants.deleteAllNotification),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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
        errorMessage.value = responseData['message'] ?? 'Failed to delete all notifications';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

// class NotificationListController extends GetxController {
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   var notifications = <NotificationItem>[].obs;
//   var isUnauthorized = false.obs; // New flag for unauthorized state
//
//
//   Future<String?> _getToken() async {
//     return await SharedPrefsConstants.getToken();
//   }
//
//   Future<void> fetchNotifications() async {
//     try {
//       final token = await _getToken();
//       isLoading.value = true;
//       errorMessage.value = '';
//       notifications.clear();
//       isUnauthorized.value = false;
//
//       const String apiUrl = 'https://dieaya-plus.com/api/customer/notification';
//
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && responseData['status'] == true) {
//         final notificationResponse = NotificationResponse.fromJson(responseData);
//         notifications.assignAll(notificationResponse.data);
//       } else if (response.statusCode == 401) {
//         isUnauthorized.value = true;
//         errorMessage.value = 'Unauthorized access. Please log in.';
//         notifications.clear(); // Ensure empty list for unauthorized
//       } else {
//         errorMessage.value = responseData['message'] ?? 'Failed to fetch notifications';
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred: $e';
//       notifications.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
