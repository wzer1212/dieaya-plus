import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dieaya_user/utils/dev_runtime_config.dart';

class NotificationController extends GetxController {
  // Observable for FCM token
  var fcmToken = ''.obs;

  // GetStorage instance
  final box = GetStorage();

  @override
  void onInit() async{
    super.onInit();

    getFcmToken();
  }

  // Retrieve and store FCM token
  Future<void> getFcmToken() async {
    if (!DevRuntimeConfig.canUseFcm) {
      print('FCM disabled for this runtime.');
      return;
    }

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        fcmToken.value = token;
        box.write('fcm_token', token);
        print('FCM Token: $token');
      } else {
        print('FCM Token: null');
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  // Refresh FCM token on token refresh
  void setupTokenRefresh() {
    if (!DevRuntimeConfig.canUseFcm) return;

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken.value = newToken;
      box.write('fcm_token', newToken);
      print('FCM Token Refreshed: $newToken');
    });
  }
}
