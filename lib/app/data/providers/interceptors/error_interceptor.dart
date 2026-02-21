import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:flutter_music_clean_getx/app/core/constants/api_endpoints.dart';
import 'package:flutter_music_clean_getx/app/core/services/auth_service.dart';

class ErrorInterceptor {
  static Future<Response> responseInterceptor({
    required Request request,
    required Response response,
    required Future<String?> Function() onRefreshToken,
  }) async {
    // ถ้าไม่ใช่ 401 หรือเป็นคำขอ refresh token เอง หรือ login ให้ปล่อยผ่าน
    if (response.statusCode != 401 ||
        request.url.path.endsWith(ApiEndpoints.refreshToken) ||
        request.url.path.endsWith(ApiEndpoints.login)) {
      return response;
    }

    // ถ้าเป็น 401 แสดงว่า token หมดอายุ -> ทำการ refresh
    final newToken = await onRefreshToken();

    // ถ้า refresh ไม่สำเร็จ (เช่น refresh token หมดอายุ) -> logout
    if (newToken == null || newToken.isEmpty) {
      await AuthService.to.logout();
      return response;
    }

    // ถ้า refresh สำเร็จ -> แนบ token ใหม่แล้วยิง request เดิมซ้ำ
    final retryClient = GetConnect();

    // Ensure new request has the updated token
    final newHeaders = Map<String, String>.from(request.headers);
    newHeaders['Authorization'] = 'Bearer $newToken';

    // Re-issue the request using the retryClient
    final bodyBytes = await request.bodyBytes.toList();
    final bodyList = bodyBytes.expand((x) => x).toList();

    final retryResponse = await retryClient.request(
      request.url.toString(),
      request.method,
      headers: newHeaders,
      body: bodyList.isEmpty ? null : bodyList,
    );

    return retryResponse;
  }
}
