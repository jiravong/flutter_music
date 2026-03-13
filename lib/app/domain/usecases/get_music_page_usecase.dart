import '../../core/network/result.dart';
import '../entities/music_page.dart';
import '../repositories/music_repository.dart';

// Use case: fetch a paginated page of music tracks.
class GetMusicPageUseCase {
  GetMusicPageUseCase(this._repo);

  final MusicRepository _repo;

  Future<Result<MusicPage>> call({int page = 1, int limit = 10}) {
    return _repo.getPage(page: page, limit: limit);
  }

  Result<MusicPage>? cached({int page = 1, int limit = 10}) {
    return _repo.getCachedPage(page: page, limit: limit);
  }
}
