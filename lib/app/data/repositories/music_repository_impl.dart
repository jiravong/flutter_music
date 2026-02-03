import '../../core/constants/api_endpoints.dart';
import '../../domain/entities/music.dart';
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
    // GET /api/v1/music/
    final response = await _client.get(ApiEndpoints.music);

    if (!response.isOk) {
      throw Exception(response.statusText ?? 'Failed to fetch music list');
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
  }

  @override
  Future<Music> getById(int id) async {
    // GET /api/v1/music/:id
    final response = await _client.get('${ApiEndpoints.music}$id');

    if (!response.isOk) {
      throw Exception(response.statusText ?? 'Failed to fetch music detail');
    }

    final body = response.body;

    if (body is Map<String, dynamic>) {
      // Support response shapes:
      // - { id: ..., title: ..., ... }
      // - { data: { id: ..., title: ..., ... } }
      final data = (body['data'] is Map<String, dynamic>)
          ? body['data'] as Map<String, dynamic>
          : body;
      return MusicModel.fromJson(data);
    }

    throw Exception('Invalid response');
  }
}
