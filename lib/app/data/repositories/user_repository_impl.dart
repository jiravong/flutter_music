import 'package:flutter_music_clean_getx/app/core/constants/api_endpoints.dart';
import 'package:flutter_music_clean_getx/app/data/models/user_model.dart';
import 'package:flutter_music_clean_getx/app/data/providers/api_client.dart';
import 'package:flutter_music_clean_getx/app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._client);

  final ApiClient _client;
  
  @override
  Future<UserModel> getUser() async {
    final response = await _client.get(ApiEndpoints.getUser);
    if (!response.isOk) {
      throw Exception(response.statusText ?? 'Failed to fetch user');
    }
    final body = response.body['data'];
    if (body is Map<String, dynamic>) {
      return UserModel.fromJson(body);
    }
    throw Exception('Invalid user response');
  }
}