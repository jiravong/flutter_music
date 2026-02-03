import '../entities/music.dart';
import '../repositories/music_repository.dart';

// Use case: fetch a single music track detail.
class GetMusicDetailUseCase {
  GetMusicDetailUseCase(this._repo);

  final MusicRepository _repo;

  // Executes the action.
  Future<Music> call(int id) {
    return _repo.getById(id);
  }
}
