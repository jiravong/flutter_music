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

## Running

1. Start your backend API (make sure `baseUrl` is reachable from emulator/device).
2. Run the app:

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