import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_music_clean_getx/app/domain/entities/music.dart';
import 'package:flutter_music_clean_getx/app/domain/repositories/music_repository.dart';
import 'package:flutter_music_clean_getx/app/domain/usecases/get_music_detail_usecase.dart';
import 'package:flutter_music_clean_getx/app/domain/usecases/get_music_list_usecase.dart';
import 'package:flutter_music_clean_getx/app/features/music_detail/controllers/music_detail_controller.dart';
import 'package:flutter_music_clean_getx/app/features/music_detail/presentation/music_detail_page.dart';
import 'package:flutter_music_clean_getx/app/features/music_list/controllers/music_list_controller.dart';
import 'package:flutter_music_clean_getx/app/features/music_list/presentation/music_list_page.dart';
import 'package:flutter_music_clean_getx/app/features/player/controllers/player_controller.dart';

import 'fakes.dart';

class FakeMusicRepository implements MusicRepository {
  FakeMusicRepository(this.items);

  final List<Music> items;

  @override
  Future<List<Music>> getAll() async => items;

  @override
  Future<Music> getById(int id) async => items.firstWhere((e) => e.id == id);
}

void main() {
  setUp(() {
    Get.reset();
    Get.testMode = true;
    Get.put<PlayerController>(FakePlayerController());
  });

  testWidgets('MusicListPage renders list keys', (tester) async {
    final repo = FakeMusicRepository([
      const Music(
        id: 1,
        title: 'Song 1',
        artist: 'Artist',
        lyrics: 'Lyrics',
        mp3Url: 'https://example.com/1.mp3',
        mp4Url: 'https://example.com/1.mp4',
        imageUrl: 'https://example.com/1.jpg',
      ),
    ]);

    final useCase = GetMusicListUseCase(repo);
    Get.put<MusicListController>(MusicListController(getMusicListUseCase: useCase));

    await tester.pumpWidget(const GetMaterialApp(home: MusicListPage()));
    await tester.pump();

    expect(find.byKey(const ValueKey('musicList.refresh')), findsOneWidget);
    expect(find.byKey(const ValueKey('musicList.listView')), findsOneWidget);
    expect(find.byKey(const ValueKey('musicList.tile.1')), findsOneWidget);
    expect(find.byKey(const ValueKey('musicList.playButton.1')), findsOneWidget);
  });

  testWidgets('MusicDetailPage renders detail keys', (tester) async {
    final repo = FakeMusicRepository([
      const Music(
        id: 1,
        title: 'Song 1',
        artist: 'Artist',
        lyrics: 'Lyrics',
        mp3Url: 'https://example.com/1.mp3',
        mp4Url: 'https://example.com/1.mp4',
        imageUrl: 'https://example.com/1.jpg',
      ),
    ]);

    final useCase = GetMusicDetailUseCase(repo);
    Get.put<MusicDetailController>(
      MusicDetailController(getMusicDetailUseCase: useCase),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        getPages: [
          GetPage(
            name: '/music/:id',
            page: () => const MusicDetailPage(),
          ),
        ],
        initialRoute: '/music/1',
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.byKey(const ValueKey('musicDetail.title')), findsOneWidget);
    expect(find.byKey(const ValueKey('musicDetail.artist')), findsOneWidget);
    expect(find.byKey(const ValueKey('musicDetail.lyricsScroll')), findsOneWidget);
    expect(find.byKey(const ValueKey('musicDetail.playButton')), findsOneWidget);
    expect(find.byKey(const ValueKey('musicDetail.stopButton')), findsOneWidget);
  });
}
