import '../entities/music.dart';

// Domain contract for music-related operations.
//
// Data layer implements this interface and handles API/DB specifics.
abstract class MusicRepository {
  // Fetch list of music tracks.
  Future<List<Music>> getAll();

  // Fetch a single track by id.
  Future<Music> getById(int id);
}
