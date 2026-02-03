// Domain entity representing a music track in the business layer.
//
// This should be free of framework dependencies (no GetX/Flutter imports).
class Music {
  const Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.mp3Url,
    required this.mp4Url,
  });

  // Primary identifier from backend.
  final int id;

  // Display fields.
  final String title;
  final String artist;

  // Optional long text.
  final String lyrics;

  // Remote URLs used for streaming / playback.
  final String mp3Url;
  final String mp4Url;
}
