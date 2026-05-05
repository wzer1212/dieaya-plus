import 'dart:convert';
import 'package:dieaya_market/utils/caching_sevice/app_sharedprefs_contants.dart';
import 'package:dieaya_market/utils/caching_sevice/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// this class handle calling API
/// it's should use in login API calling
// class HttpService {
//   static String baseUrl = 'https://dieaya-plus.com/api';
//
//   static Future<String?> getToken() async {
//
//     return await SharedPrefsConstants.getToken();
//   }
//
//   // GET
//   static Future<http.Response> get(String endpoint,
//       {Map<String, String>? headers}) async {
//     final url = Uri.parse('$endpoint');
//
//     final response = await http.get(url, headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer ${await getToken()}',
//     });
//     return (response);
//   }
//
//   // POST
//   static Future<dynamic> post(String endpoint, dynamic body,
//       {Map<String, String>? headers}) async {
//     final url = Uri.parse('$endpoint');
//     final response = await http.post(
//       url,
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer ${await getToken()}',
//       },
//       body: jsonEncode(body),
//     );
//     return (response);
//   }
//
//   // PUT (Update)
//   static Future<dynamic> put(String endpoint, dynamic body,
//       {Map<String, String>? headers}) async {
//     final url = Uri.parse('$endpoint');
//     final response = await http.put(
//       url,
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer ${await getToken()}',
//       },
//       body: jsonEncode(body),
//     );
//     return (response);
//   }
//
//   // DELETE
//   static Future<dynamic> delete(String endpoint,
//       {Map<String, String>? headers}) async {
//     final url = Uri.parse('$endpoint');
//     final response = await http.delete(url, headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer ${await getToken()}',
//     });
//     return (response);
//   }
//
//
//
// }

// class HttpException implements Exception {
//   final int statusCode;
//   final dynamic message;
//
//   HttpException(this.statusCode, this.message);
//
//   @override
//   String toString() => 'HttpException: $statusCode => $message';
// }
