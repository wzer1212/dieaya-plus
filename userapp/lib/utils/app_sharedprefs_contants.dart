import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsConstants {
  static const String tokenKey = 'auth_token';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _whatsappHintShownKey = 'whatsapp_hint_shown';
  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Remove token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Check if user has seen onboarding
  static Future<bool> hasSeenOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  // Set onboarding as seen
  static Future<bool> setHasSeenOnboarding(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_hasSeenOnboardingKey, value);
  }

  static Future<bool> hasShownWhatsappHint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_whatsappHintShownKey) ?? false; // Default to false if not found
  }

  static Future<void> setWhatsappHintShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_whatsappHintShownKey, true);
  }

}
