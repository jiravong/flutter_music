import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'dart:developer' as developer;

class LoggingInterceptor {
  static Future<Request> requestInterceptor(Request request) async {
    if (kDebugMode) {
      developer.log('---------------- REQUEST ----------------', name: 'API_REQUEST');
      developer.log('Method: ${request.method}', name: 'API_REQUEST');
      developer.log('URL: ${request.url}', name: 'API_REQUEST');
      developer.log('Headers: ${request.headers}', name: 'API_REQUEST');
    }
    return request;
  }

  static Future<Response> responseInterceptor(Request request, Response response) async {
    if (kDebugMode) {
      developer.log('---------------- RESPONSE ----------------', name: 'API_RESPONSE');
      developer.log('Status: ${response.statusCode}', name: 'API_RESPONSE');
      developer.log('URL: ${request.url}', name: 'API_RESPONSE');
      developer.log('Body: ${response.bodyString}', name: 'API_RESPONSE');
    }
    return response;
  }
}
