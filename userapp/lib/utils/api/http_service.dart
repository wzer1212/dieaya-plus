import 'dart:convert';
import 'dart:developer';
import 'package:dieaya_user/Utils/app_sharedprefs_contants.dart';
import 'package:dieaya_user/main.dart';
import 'package:dieaya_user/main_dev.dart';
import 'package:flutter_alice/core/alice_http_extensions.dart';
import 'package:http/http.dart' as http;

class HttpService {
  HttpService._internal();

  static final HttpService instance = HttpService._internal();

  // final Map<String, String>? defaultHeaders;

  // HttpService({
  //   this.defaultHeaders,
  // });

  /// GET request
  Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(
            queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
      }
    // Merge default headers with custom headers
      final Map<String, String> finalHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

      log('GET Request: $uri');
      log('Headers: $finalHeaders');

      final response = await http.get(uri, headers: finalHeaders).interceptWithAlice(alice);

      log('GET Response Status: ${response.statusCode}');
      log('GET Response Body: ${response.body}');

      return response;
    } catch (e) {
      log('GET Error: $e');
      rethrow;
    }
  }

  /// POST request
  Future<http.Response> post(
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(
            queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
      }

      // Merge default headers with custom headers
      final Map<String, String> finalHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

      // Encode body to JSON if it's a Map or List
      final String? encodedBody =
          body != null ? (body is String ? body : jsonEncode(body)) : null;

      log('POST Request: $uri');
      log('Headers: $finalHeaders');
      log('Body: $encodedBody');

      final response = await http.post(
        uri,
        headers: finalHeaders,
        body: encodedBody,
      ).interceptWithAlice(alice,body: encodedBody);

      log('POST Response Status: ${response.statusCode}');
      log('POST Response Body: ${response.body}');

      return response;
    } catch (e) {
      log('POST Error: $e');
      rethrow;
    }
  }

  /// UPDATE (PUT) request
  Future<http.Response> update(
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(
            queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
      }

      // Merge default headers with custom headers
      final Map<String, String> finalHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

      // Encode body to JSON if it's a Map or List
      final String? encodedBody =
          body != null ? (body is String ? body : jsonEncode(body)) : null;

      log('UPDATE Request: $uri');
      log('Headers: $finalHeaders');
      log('Body: $encodedBody');

      final response = await http.put(
        uri,
        headers: finalHeaders,
        body: encodedBody,
      ).interceptWithAlice(alice,body: encodedBody);

      log('UPDATE Response Status: ${response.statusCode}');
      log('UPDATE Response Body: ${response.body}');

      return response;
    } catch (e) {
      log('UPDATE Error: $e');
      rethrow;
    }
  }

  /// DELETE request
  Future<http.Response> delete(
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(
            queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
      }

      // Merge default headers with custom headers
      final Map<String, String> finalHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

      // Encode body to JSON if it's a Map or List
      final String? encodedBody =
          body != null ? (body is String ? body : jsonEncode(body)) : null;

      log('DELETE Request: $uri');
      log('Headers: $finalHeaders');
      log('Body: $encodedBody');

      final response = await http.delete(
        uri,
        headers: finalHeaders,
        body: encodedBody,
      ).interceptWithAlice(alice,body: encodedBody);

      log('DELETE Response Status: ${response.statusCode}');
      log('DELETE Response Body: ${response.body}');

      return response;
    } catch (e) {
      log('DELETE Error: $e');
      rethrow;
    }
  }
}
