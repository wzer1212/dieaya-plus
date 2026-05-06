import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';
import 'package:flutter_alice/core/alice_http_extensions.dart';
import 'package:http/http.dart' as http;

final appNavigatorKey = GlobalKey<NavigatorState>();
final alice = Alice(navigatorKey: appNavigatorKey);

Future<http.Response> interceptWithAliceIfAvailable(
  Future<http.Response> request, {
  String? body,
}) {
  return request.interceptWithAlice(alice, body: body);
}
