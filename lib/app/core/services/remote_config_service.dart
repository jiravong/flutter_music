import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class RemoteConfigService extends GetxService {
  static RemoteConfigService get to => Get.find<RemoteConfigService>();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: kDebugMode
          ? Duration.zero
          : const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults(_defaults);
    await _remoteConfig.fetchAndActivate();
  }

  // Default values — ใช้เป็น fallback เมื่อ fetch ไม่ได้
  static const Map<String, dynamic> _defaults = {
    RemoteConfigKeys.maintenanceMode: false,
    RemoteConfigKeys.minimumAppVersion: '1.0.0',
    RemoteConfigKeys.musicPageSize: 10,
  };

  bool get maintenanceMode =>
      _remoteConfig.getBool(RemoteConfigKeys.maintenanceMode);

  String get minimumAppVersion =>
      _remoteConfig.getString(RemoteConfigKeys.minimumAppVersion);

  int get musicPageSize =>
      _remoteConfig.getInt(RemoteConfigKeys.musicPageSize);
}

class RemoteConfigKeys {
  static const String maintenanceMode = 'maintenance_mode';
  static const String minimumAppVersion = 'minimum_app_version';
  static const String musicPageSize = 'music_page_size';
}
