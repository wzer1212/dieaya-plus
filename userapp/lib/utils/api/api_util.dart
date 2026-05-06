import 'dart:developer';

import 'package:dieaya_user/utils/api_constant.dart';
import 'package:dieaya_user/utils/app_sharedprefs_contants.dart';
import 'package:dieaya_user/utils/caching_sevice/shared_preferences.dart';
import 'package:dio/dio.dart';
class ApiUtil {
  static final Dio _dio =Dio();

  ApiUtil() {
    init();
  }

  void init() {
    _dio
      ..options.baseUrl = ApiConstants.baseUrl
      ..options.headers = {
        "Accept": "application/json",
      };
  }


  static Future<Response<dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? extraHeader,
    Map<String, dynamic>? parameters,
  }) async {
    var token = MySharedPreference.getData(key: SharedPrefsConstants.tokenKey);
    var userPanel = MySharedPreference.getData(key: SharedPrefsConstants.tokenKey);
    _dio.options.headers.addAll({'Authorization': 'Bearer $token', 'user_panel': userPanel});
    if (extraHeader != null) {
      _dio.options.headers.addAll(extraHeader);
    }
    log('ApiUtil: get: endpoint: $endpoint');
    log('ApiUtil: get: header: ${_dio.options.headers}');
    var response = await _dio.get(
      endpoint,
      data: body,
      queryParameters: parameters,
    );
    return response;
  }

  static Future<Response<dynamic>> post(
      {required String endpoint,
      required dynamic body,
      Map<String, dynamic>? parameters,
      Map<String, dynamic>? extraHeader}) async {
    var token = MySharedPreference.getData(key: SharedPrefsConstants.tokenKey);
    log('ApiUtil: post: endpoint: $endpoint');
    _dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    if (extraHeader != null) {
      _dio.options.headers.addAll(extraHeader);
    }
    return await _dio.post(endpoint, data: body, queryParameters: parameters);
  }

  static Future<Response<dynamic>> put(
      {required String endpoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? parameters}) async {
    var token = MySharedPreference.getData(key: SharedPrefsConstants.tokenKey);
    _dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    return await _dio.put(endpoint, data: body, queryParameters: parameters);
  }

  static Future<Response<dynamic>> delete(
      {required String endpoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? parameters}) async {
    var token = MySharedPreference.getData(key: SharedPrefsConstants.tokenKey);
    _dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    return await _dio.delete(endpoint, data: body, queryParameters: parameters);
  }

}
