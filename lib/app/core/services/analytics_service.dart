import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class AnalyticsService extends GetxService {
  static AnalyticsService get to => Get.find<AnalyticsService>();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  Future<void> logPlayMusic({
    required int musicId,
    required String title,
    required String artist,
  }) async {
    await _analytics.logEvent(
      name: 'play_music',
      parameters: {
        'music_id': musicId,
        'music_title': title,
        'music_artist': artist,
      },
    );
  }

  Future<void> logCompleteMusic({
    required int musicId,
    required String title,
    required String artist,
  }) async {
    await _analytics.logEvent(
      name: 'complete_music',
      parameters: {
        'music_id': musicId,
        'music_title': title,
        'music_artist': artist,
      },
    );
  }
}
