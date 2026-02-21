import 'package:get/get_connect/http/src/request/request.dart';
import 'package:music_roop/app/core/services/connectivity_service.dart';
import 'package:music_roop/app/core/storage/token_storage.dart';

class AuthInterceptor {
  static Future<Request> requestInterceptor(Request request, TokenStorage tokenStorage) async {
    if (!ConnectivityService.to.isConnected.value) {
      throw Exception('ไม่มีการเชื่อมต่ออินเทอร์เน็ต');
    }

    final token = await tokenStorage.readToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    return request;
  }
}
