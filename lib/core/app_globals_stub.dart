import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final appNavigatorKey = GlobalKey<NavigatorState>();

Future<http.Response> interceptWithAliceIfAvailable(
  Future<http.Response> request, {
  String? body,
}) {
  return request;
}
