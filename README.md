# music_roop

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
3. ใส่ package name: `com.example.music.roop`
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
  --android-package-name=com.example.music.roop \
  --yes'

# Android + iOS
bash -c 'source ~/.nvm/nvm.sh && nvm use 20 && flutterfire configure \
  --project=<your-firebase-project-id> \
  --platforms=android,ios \
  --android-package-name=com.example.music.roop \
  --ios-bundle-id=com.example.flutterMusicCleanGetx \
  --yes'
```
คำสั่ง `flutterfire configure` จะ generate `lib/firebase_options.dart` ให้อัตโนมัติ

> **หมายเหตุ:** อย่า commit `google-services.json` และ `GoogleService-Info.plist` ลง git สาธารณะ

## Firebase Crashlytics Setup

Firebase Crashlytics ถูก integrate ไว้แล้วใน `CrashlyticsService` ต้องทำขั้นตอนเพิ่มเติมดังนี้:

### เปิดใช้งานใน Firebase Console

1. Firebase Console → เลือก project → Crashlytics
2. กด **Enable Crashlytics**

### Android

Gradle plugin ถูก configure ไว้แล้วใน:
- `android/build.gradle.kts` — classpath `firebase-crashlytics-gradle`
- `android/app/build.gradle.kts` — plugin `com.google.firebase.crashlytics`

ไม่ต้องทำอะไรเพิ่ม

### iOS

หลังจาก `flutterfire configure` แล้ว รัน pod install:

```bash
cd ios
pod install
cd ..
```

> **หมายเหตุ:** Crashlytics จะ **ไม่ collect crashes ใน debug mode** (`kDebugMode = true`) โดย default  
> ต้อง build release เพื่อให้ crash reports ส่งขึ้น Firebase Console:
> ```bash
> flutter run --release
> # หรือ
> flutter build apk --release
> ```

## Firebase Remote Config Setup

Firebase Remote Config ถูก integrate ไว้แล้วใน `RemoteConfigService` สามารถปรับค่าได้จาก Firebase Console โดยไม่ต้อง release app ใหม่

### เปิดใช้งานใน Firebase Console

1. Firebase Console → เลือก project → Remote Config
2. กด **Create configuration**
3. เพิ่ม parameters ตามตารางด้านล่าง แล้วกด **Publish changes**

### Parameters ที่ใช้ในแอป

| Parameter key | Type | Default | คำอธิบาย |
|---|---|---|---|
| `maintenance_mode` | Boolean | `false` | ปิดแอปชั่วคราวเพื่อ maintenance |
| `minimum_app_version` | String | `1.0.0` | เวอร์ชันต่ำสุดที่รองรับ (force update) |
| `music_page_size` | Number | `10` | จำนวนเพลงต่อหน้าใน pagination |

### การใช้งานในโค้ด

เรียกผ่าน `RemoteConfigService.to`:

```dart
// ตรวจสอบ maintenance mode
if (RemoteConfigService.to.maintenanceMode) { ... }

// ดึง page size
final pageSize = RemoteConfigService.to.musicPageSize;
```

> **หมายเหตุ:** ใน debug mode จะ fetch config ทุกครั้งที่เปิดแอป (`minimumFetchInterval: Duration.zero`)  
> ใน release mode จะ fetch ทุก 1 ชั่วโมง

## Running

1. ทำขั้นตอน Firebase Setup ด้านบนให้เสร็จก่อน
2. Start your backend API (make sure `baseUrl` is reachable from emulator/device).
3. Run the app:

```
flutter pub get
flutter run
```

## Update icon app

- flutter pub run flutter_launcher_icons:main

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