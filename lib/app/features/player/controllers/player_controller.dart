import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_music_clean_getx/app/core/services/analytics_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../domain/entities/music.dart';

class PlayerController extends GetxController with WidgetsBindingObserver {
  final isPlaying = false.obs;
  final playingUrl = ''.obs;
  final errorMessage = ''.obs;

  final currentMusic = Rxn<Music>();

  late final AudioPlayer _player;
  StreamSubscription<PlayerState>? _playerStateSub;

  bool isPlayingUrl(String url) {
    return playingUrl.value == url && isPlaying.value;
  }

  bool isPlayingMusic(Music music) {
    return isPlayingUrl(music.mp3Url);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    _player = AudioPlayer();
    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        playingUrl.value = '';
        if (currentMusic.value != null) {
          AnalyticsService.to.logCompleteMusic(
            musicId: currentMusic.value!.id,
            title: currentMusic.value!.title,
            artist: currentMusic.value!.artist,
          );
        }
      } else {
        isPlaying.value = state.playing;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause playing if app goes to background or is detached.
    // Calling stop() during lifecycle changes can cause platform channel deadlocks on some devices.
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      if (_player.playing) {
        _player.pause();
        isPlaying.value = false;
      }
    }
  }

  Future<void> playMusic(Music music) async {
    currentMusic.value = music;
    await AnalyticsService.to.logPlayMusic(
      musicId: music.id,
      title: music.title,
      artist: music.artist,
    );
    await playUrl(music.mp3Url);
  }

  Future<void> playUrl(String url) async {
    try {
      errorMessage.value = '';
      if (url.isEmpty) {
        throw Exception('Empty url');
      }

      if (playingUrl.value == url) {
        if (_player.playing) {
          await _player.pause();
          isPlaying.value = false;
        } else {
          await _player.play();
          isPlaying.value = true;
        }
        return;
      }

      playingUrl.value = url;
      await _player.setUrl(url).timeout(const Duration(seconds: 20));

      // Start playback. We set `isPlaying` optimistically; the stream listener
      // will correct it based on the real player state.
      _player.play();
      isPlaying.value = true;
    } catch (e) {
      errorMessage.value = e.toString();
      isPlaying.value = false;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    isPlaying.value = false;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerStateSub?.cancel();
    _player.dispose();
    super.onClose();
  }
}
