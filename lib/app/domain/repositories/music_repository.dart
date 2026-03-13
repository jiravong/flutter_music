import '../../core/network/result.dart';
import '../entities/music.dart';
import '../entities/music_page.dart';

// Domain contract for music-related operations.
//
// Data layer implements this interface and handles API/DB specifics.
abstract class MusicRepository {
  // Fetch list of music tracks.
  Future<Result<List<Music>>> getAll();

  // Fetch a paginated page of music tracks.
  Future<Result<MusicPage>> getPage({int page = 1, int limit = 10});

  // Fetch a paginated page of music tracks from cache.
  Result<MusicPage>? getCachedPage({int page = 1, int limit = 10});

  // Fetch a single track by id.
  Future<Result<Music>> getById(int id);
}
