# flutter_music_clean_getx

Flutter sample app using **GetX** + a simple **Clean Architecture** split (core/data/domain) and **feature modules** for presentation.

## Features

- **Auth**
  - Login
  - Persist access token with `GetStorage`
  - Auto refresh access token on `401` via `/api/v1/auth/refresh-token`
- **Music**
  - Music list
  - Music detail
- **Player (shared module)**
  - Single `AudioPlayer` instance shared across the app
  - Play / pause / stop

## Project Structure

High level:

```
lib/
  main.dart
  app/
    core/
    data/
    domain/
    routes/
    features/
      auth/
      music_list/
      music_detail/
      player/
```

Feature modules (presentation-layer modules):

```
lib/app/features/
  auth/
    bindings/
    controllers/
    presentation/
  music_list/
    bindings/
    controllers/
    presentation/
  music_detail/
    bindings/
    controllers/
    presentation/
  player/
    bindings/
    controllers/
    presentation/
```

## Routing

Routes are defined in:

- `lib/app/routes/app_routes.dart`
- `lib/app/routes/app_pages.dart`

Key routes:

- `/login`
- `/music`
- `/music/:id`

## API Configuration

Edit these values in `lib/app/core/constants/api_endpoints.dart`:

- `ApiEndpoints.baseUrl`
- `ApiEndpoints.login`
- `ApiEndpoints.refreshToken`
- `ApiEndpoints.music`

## Auth + Refresh Token Behavior

`ApiClient` (`lib/app/data/providers/api_client.dart`) attaches the access token to every request.

When the backend returns `401 Unauthorized`:

1. App calls `POST /api/v1/auth/refresh-token`
2. If successful, it stores the new access token and **retries the original request**
3. If refresh fails, it clears token and navigates back to `/login`

Notes:

- The refresh request currently posts an empty body `{}`.
  If your backend requires a refresh token (cookie/header/body), update `_refreshAccessToken()` accordingly.
- There is a concurrency lock so multiple `401` responses will trigger only **one** refresh request.

## Firebase Analytics Setup

Firebase Analytics ถูก integrate ไว้แล้ว แต่ต้องทำขั้นตอนต่อไปนี้ก่อน build:

### Android

1. ไปที่ [Firebase Console](https://console.firebase.google.com/) → เลือก project
2. Project Settings → Add app → Android
3. ใส่ package name: `com.example.flutter_music_clean_getx`
4. Download `google-services.json` → วางที่ `android/app/google-services.json`

### iOS (optional)

1. Firebase Console → Add app → iOS
2. ใส่ Bundle ID: `com.example.flutterMusicCleanGetx`
3. Download `GoogleService-Info.plist` → วางที่ `ios/Runner/GoogleService-Info.plist`

### Generate `firebase_options.dart`

ต้องมี [Firebase CLI](https://firebase.google.com/docs/cli) และ [FlutterFire CLI](https://pub.dev/packages/flutterfire_cli) ติดตั้งไว้ก่อน

```bash
# ติดตั้ง Node.js >= 20 (ถ้าใช้ nvm)
nvm install 20
nvm use 20

# ติดตั้ง Firebase CLI
npm install -g firebase-tools

# ติดตั้ง FlutterFire CLI
dart pub global activate flutterfire_cli

# Login Firebase
firebase login

# Generate firebase_options.dart (รันจาก root project)
# Android only
bash -c 'source ~/.nvm/nvm.sh && nvm use 20 && flutterfire configure \
  --project=<your-firebase-project-id> \
  --platforms=android \
  --android-package-name=com.example.flutter_music_clean_getx \
  --yes'

# Android + iOS
bash -c 'source ~/.nvm/nvm.sh && nvm use 20 && flutterfire configure \
  --project=<your-firebase-project-id> \
  --platforms=android,ios \
  --android-package-name=com.example.flutter_music_clean_getx \
  --ios-bundle-id=com.example.flutterMusicCleanGetx \
  --yes'
```
คำสั่ง `flutterfire configure` จะ generate `lib/firebase_options.dart` ให้อัตโนมัติ

> **หมายเหตุ:** อย่า commit `google-services.json` และ `GoogleService-Info.plist` ลง git สาธารณะ

## Running

1. ทำขั้นตอน Firebase Setup ด้านบนให้เสร็จก่อน
2. Start your backend API (make sure `baseUrl` is reachable from emulator/device).
3. Run the app:

```
flutter pub get
flutter run
```

## Development Notes

- `ApiClient` has request/response logging enabled only in debug mode.
- `features/player` registers `PlayerController` as a permanent singleton to share playback across screens.


## Test
LoginPage
    auth.emailTextField
    auth.passwordTextField
    auth.errorText
    auth.loginButton
    auth.loginLoading
MusicListPage
    musicList.refresh
    musicList.listView
    musicList.tile.<id>
    musicList.playButton.<id>
MusicDetailPage
    musicDetail.title
    musicDetail.artist
    musicDetail.lyricsScroll
    musicDetail.lyrics
    musicDetail.playButton
    musicDetail.stopButton