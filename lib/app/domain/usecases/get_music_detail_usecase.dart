import '../../core/network/result.dart';
import '../entities/music.dart';
import '../repositories/music_repository.dart';

// Use case: fetch music details by id.
class GetMusicDetailUseCase {
  GetMusicDetailUseCase(this._repo);

  final MusicRepository _repo;

  Future<Result<Music>> call(int id) {
    return _repo.getById(id);
  }
}
