// Firebase options for PROD flavor.
// TODO: Replace placeholder values below with your production Firebase project config.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class ProdFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: Replace with production Firebase config values.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANtLzekcq9PWo6YbNKVYe5lPMwq4lAmfo',
    appId: '1:86806745433:android:8582d8b519f3eda77d7c48',
    messagingSenderId: '86806745433',
    projectId: 'music-roop',
    storageBucket: 'music-roop.firebasestorage.app',
  );

  // TODO: Replace with production Firebase config values.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTxSOonDSoyxSV_A-B8G6yUDTc4966F-k',
    appId: '1:86806745433:ios:0763d9c63c001e737d7c48',
    messagingSenderId: '86806745433',
    projectId: 'music-roop',
    storageBucket: 'music-roop.firebasestorage.app',
    iosBundleId: 'com.example.music.roop',
  );
}
