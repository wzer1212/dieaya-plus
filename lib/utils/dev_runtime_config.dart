import 'package:flutter/foundation.dart';
import 'package:dieaya_user/config/environment.dart';

class DevRuntimeConfig {
  static const bool disableFcm = bool.fromEnvironment(
    'DISABLE_FCM',
    defaultValue: false,
  );

  static bool get canUseFcm => !kIsWeb && !disableFcm;

  static const String devApiBaseUrl = Environment.DEV_BASE_URL;
  static const String devShareBaseUrl = Environment.DEV_SHARE_BASE_URL;
}
