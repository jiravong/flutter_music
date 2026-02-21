import 'package:get/get.dart';
import 'dart:async';

import '../../core/constants/api_endpoints.dart';
import '../../core/storage/token_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

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
      final refreshToken = await _tokenStorage.readRefreshToken();
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

    // 1. ส่วนของการ Log
    httpClient.addRequestModifier<dynamic>((request) => LoggingInterceptor.requestInterceptor(request));
    httpClient.addResponseModifier((request, response) => LoggingInterceptor.responseInterceptor(request, response));

    // 2. ตรวจสอบ connectivity และแนบ Token
    httpClient.addRequestModifier<dynamic>((request) => AuthInterceptor.requestInterceptor(request, _tokenStorage));

    // 3. Interceptor สำหรับจับ 401 และ Refresh Token
    httpClient.addResponseModifier((request, response) {
      return ErrorInterceptor.responseInterceptor(
        request: request,
        response: response,
        onRefreshToken: _refreshAccessToken,
      );
    });

    super.onInit();
  }
}