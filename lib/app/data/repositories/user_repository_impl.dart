import 'package:music_roop/app/core/constants/api_endpoints.dart';
import 'package:music_roop/app/data/models/user_model.dart';
import 'package:music_roop/app/data/providers/api_client.dart';
import 'package:music_roop/app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._client);

  final ApiClient _client;
  
  @override
  Future<UserModel> getUser() async {
    try {
      final response = await _client.get(ApiEndpoints.getUser);

      if (!response.isOk) {
        final body = response.body;
        final message = (body is Map<String, dynamic>)
            ? body['error'] ?? body['message'] ?? body['msg']
            : null;
        throw Exception(
          (message is String && message.isNotEmpty)
              ? message
              : response.statusText ?? 'Failed to fetch user',
        );
      }

      final body = response.body;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid user response: expected JSON object');
      }

      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }

      // Support flat response shape (no 'data' wrapper)
      return UserModel.fromJson(body);
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error fetching user: $e');
    }
  }
}