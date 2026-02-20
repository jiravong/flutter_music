import '../../core/constants/api_endpoints.dart';
import '../../domain/entities/music.dart';
import '../../domain/entities/music_page.dart';
import '../../domain/repositories/music_repository.dart';
import '../models/music_model.dart';
import '../providers/api_client.dart';

// Data-layer implementation of MusicRepository.
//
// Responsibility:
// - Fetch data from remote API.
// - Convert raw JSON into domain entities.
class MusicRepositoryImpl implements MusicRepository {
  MusicRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<Music>> getAll() async {
    try {
      // GET /api/v1/music/
      final response = await _client.get(ApiEndpoints.music);

      if (!response.isOk) {
        throw Exception(_errorMessage(response.body, response.statusText) ?? 'Failed to fetch music list');
      }

      final body = response.body;

      // Support response shapes:
      // - [ {...}, {...} ]
      // - { data: [ {...}, {...} ] }
      final list = body is List
          ? body
          : (body is Map<String, dynamic> && body['data'] is List)
              ? body['data'] as List
              : null;

      if (list == null) return <Music>[];

      // Convert each JSON map to MusicModel.
      return list
          .whereType<Map>()
          .map((e) => MusicModel.fromJson(e.cast<String, dynamic>()))
          .toList(growable: false);
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error fetching music list: $e');
    }
  }

  @override
  Future<MusicPage> getPage({int page = 1, int limit = 10}) async {
    try {
      final response = await _client.get(
        '${ApiEndpoints.music}?page=$page&limit=$limit',
      );

      if (!response.isOk) {
        throw Exception(_errorMessage(response.body, response.statusText) ?? 'Failed to fetch music list');
      }

      final body = response.body;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid response: expected JSON object');
      }

      final list = body['data'] is List ? body['data'] as List : <dynamic>[];
      final pagination = body['pagination'] is Map<String, dynamic>
          ? body['pagination'] as Map<String, dynamic>
          : <String, dynamic>{};

      final items = list
          .whereType<Map>()
          .map((e) => MusicModel.fromJson(e.cast<String, dynamic>()))
          .toList(growable: false);

      return MusicPage(
        items: items,
        page: (pagination['page'] as num?)?.toInt() ?? page,
        limit: (pagination['limit'] as num?)?.toInt() ?? limit,
        total: (pagination['total'] as num?)?.toInt() ?? items.length,
      );
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error fetching music page: $e');
    }
  }

  @override
  Future<Music> getById(int id) async {
    try {
      // GET /api/v1/music/:id
      final response = await _client.get('${ApiEndpoints.music}$id');

      if (!response.isOk) {
        throw Exception(_errorMessage(response.body, response.statusText) ?? 'Failed to fetch music detail');
      }

      final body = response.body;
      if (body is! Map<String, dynamic>) {
        throw Exception('Invalid response: expected JSON object');
      }

      // Support response shapes:
      // - { id: ..., title: ..., ... }
      // - { data: { id: ..., title: ..., ... } }
      final data = (body['data'] is Map<String, dynamic>)
          ? body['data'] as Map<String, dynamic>
          : body;
      return MusicModel.fromJson(data);
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error fetching music detail id=$id: $e');
    }
  }

  String? _errorMessage(dynamic body, String? fallback) {
    if (body is Map<String, dynamic>) {
      final message = body['error'] ?? body['message'] ?? body['msg'];
      if (message is String && message.isNotEmpty) return message;
    }
    return fallback;
  }
}
