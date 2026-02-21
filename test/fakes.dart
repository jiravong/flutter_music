import 'package:music_roop/app/core/mixins/error_handler_mixin.dart';
import 'package:music_roop/app/core/storage/token_storage.dart';
import 'package:music_roop/app/domain/entities/auth_tokens.dart';
import 'package:music_roop/app/domain/entities/music.dart';
import 'package:music_roop/app/domain/repositories/auth_repository.dart';
import 'package:music_roop/app/domain/usecases/login_usecase.dart';
import 'package:music_roop/app/features/auth/controllers/auth_controller.dart';
import 'package:music_roop/app/features/player/controllers/player_controller.dart';

class FakeTokenStorage implements TokenStorage {
  String? _token;
  String? _refreshToken;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> writeToken(String token) async {
    _token = token;
  }

  @override
  Future<String?> readRefreshToken() async => _refreshToken;

  @override
  Future<void> writeRefreshToken(String token) async {
    _refreshToken = token;
  }

  @override
  Future<void> clearToken() async {
    _token = null;
    _refreshToken = null;
  }
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthTokens> login({required String email, required String password}) async {
    return const AuthTokens(accessToken: 'fake_access', refreshToken: 'fake_refresh');
  }
}

class TestAuthController extends AuthController {
  TestAuthController(TokenStorage tokenStorage)
      : super(
          loginUseCase: LoginUseCase(FakeAuthRepository()),
          tokenStorage: tokenStorage,
        );
}

class FakeCrashlyticsService implements ErrorRecorder {
  final List<({Object error, String reason})> recorded = [];

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    recorded.add((error: exception as Object, reason: reason ?? ''));
  }
}

class FakePlayerController extends PlayerController {
  @override
  bool isPlayingUrl(String url) {
    return playingUrl.value == url && isPlaying.value;
  }

  @override
  bool isPlayingMusic(Music music) {
    return isPlayingUrl(music.mp3Url);
  }

  @override
  Future<void> playMusic(Music music) async {
    currentMusic.value = music;
    await playUrl(music.mp3Url);
  }

  @override
  Future<void> playUrl(String url) async {
    if (playingUrl.value == url) {
      isPlaying.value = !isPlaying.value;
    } else {
      playingUrl.value = url;
      isPlaying.value = true;
    }
  }

  @override
  Future<void> stop() async {
    isPlaying.value = false;
  }

  @override
  void onInit() {
    // intentionally skip AudioPlayer setup by not calling super.onInit()
    // ignore: invalid_use_of_protected_member
    super.onInit();
  }

  @override
  void onClose() {
    // ignore: invalid_use_of_protected_member
    super.onClose();
  }
}
