import 'package:flutter/foundation.dart'; // อย่าลืม import อันนี้เพื่อใช้ kDebugMode
import 'package:get/get.dart';
import 'dart:async';
import 'dart:developer' as developer; // ใช้สำหรับ log ยาวๆ ไม่ให้โดนตัด

import '../../core/constants/api_endpoints.dart';
import '../../core/storage/token_storage.dart';

class ApiClient extends GetConnect {
  ApiClient(this._tokenStorage);

  final TokenStorage _tokenStorage;
  Completer<String?>? _refreshCompleter;

  // ... (ฟังก์ชัน _refreshAccessToken เหมือนเดิม ไม่ต้องแก้) ...
  Future<String?> _refreshAccessToken() async {
    // ... code เดิมของคุณ ...
    if (_refreshCompleter != null) return _refreshCompleter!.future;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = _tokenStorage.readRefreshToken();
      final response = await post(
        ApiEndpoints.refreshToken,
        {
          if (refreshToken != null && refreshToken.isNotEmpty)
            'refresh_token': refreshToken,
        },
      );
      if (!response.isOk) {
        _refreshCompleter!.complete(null);
        return null;
      }
      final body = response.body;
      if (body is Map<String, dynamic>) {
        final token = body['access_token'] ??
            body['token'] ??
            (body['data'] is Map<String, dynamic>
                ? (body['data'] as Map<String, dynamic>)['access_token'] ??
                    (body['data'] as Map<String, dynamic>)['token']
                : null);

        if (token is String && token.isNotEmpty) {
          await _tokenStorage.writeToken(token);
          _refreshCompleter!.complete(token);
          return token;
        }
      }
      _refreshCompleter!.complete(null);
      return null;
    } catch (_) {
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }

  @override
  void onInit() {
    httpClient.baseUrl = ApiEndpoints.baseUrl;
    httpClient.timeout = const Duration(seconds: 60);

    // 1. ส่วนของการ Log (ใส่ไว้บนสุดของ onInit เลยก็ได้ หรือก่อน Authenticator)
    if (kDebugMode) {
      // Log ขา Request
      httpClient.addRequestModifier<dynamic>((request) {
        developer.log('---------------- REQUEST ----------------', name: 'API_REQUEST');
        developer.log('Method: ${request.method}', name: 'API_REQUEST');
        developer.log('URL: ${request.url}', name: 'API_REQUEST');
        developer.log('Headers: ${request.headers}', name: 'API_REQUEST');
        // ถ้าอยากดู Body ขาส่งด้วย (ระวังถ้ายาวมาก)
        // print('Body: ${request.bodyBytes}'); 
        return request;
      });

      // Log ขา Response
      httpClient.addResponseModifier((request, response) {
        developer.log('---------------- RESPONSE ----------------', name: 'API_RESPONSE');
        developer.log('Status: ${response.statusCode}', name: 'API_RESPONSE');
        developer.log('URL: ${request.url}', name: 'API_RESPONSE');
        
        // ใช้ developer.log เพื่อให้เห็น JSON เต็มๆ กรณี response ยาว
        developer.log('Body: ${response.bodyString}', name: 'API_RESPONSE');
        
        return response;
      });
    }

    // 2. ส่วนของการจัดการ Token (Code เดิมของคุณ)
    httpClient.addRequestModifier<dynamic>((request) {
      final token = _tokenStorage.readToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });

    // 3. ส่วนของ Refresh Token (Code เดิมของคุณ)
    httpClient.addAuthenticator<dynamic>((request) async {
      final path = request.url.path;
      if (path.endsWith(ApiEndpoints.refreshToken)) {
        return request;
      }
      final token = await _refreshAccessToken();
      if (token == null || token.isEmpty) {
        await _tokenStorage.clearToken();
        Get.offAllNamed('/login');
        return request;
      }
      request.headers['Authorization'] = 'Bearer $token';
      return request;
    });

    super.onInit();
  }
}