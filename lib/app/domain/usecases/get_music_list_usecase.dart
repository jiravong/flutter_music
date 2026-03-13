import '../../core/network/result.dart';
import '../entities/music.dart';
import '../repositories/music_repository.dart';

// Use case: fetch all music tracks.
class GetMusicListUseCase {
  GetMusicListUseCase(this._repo);

  final MusicRepository _repo;

  Future<Result<List<Music>>> call() {
    return _repo.getAll();
  }
}
