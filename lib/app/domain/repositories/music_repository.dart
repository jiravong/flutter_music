import '../entities/music.dart';
import '../entities/music_page.dart';

// Domain contract for music-related operations.
//
// Data layer implements this interface and handles API/DB specifics.
abstract class MusicRepository {
  // Fetch list of music tracks.
  Future<List<Music>> getAll();

  // Fetch a paginated page of music tracks.
  Future<MusicPage> getPage({int page = 1, int limit = 10});

  // Fetch a single track by id.
  Future<Music> getById(int id);
}
