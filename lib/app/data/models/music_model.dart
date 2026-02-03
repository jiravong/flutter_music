import '../../domain/entities/music.dart';

// Data model for Music used to parse JSON responses.
//
// Extends the Domain entity to avoid duplicating fields, while keeping parsing
// logic in the Data layer.
class MusicModel extends Music {
  const MusicModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.lyrics,
    required super.mp3Url,
    required super.mp4Url,
  });

  // Convert API JSON payload into a strongly typed model.
  //
  // The backend might use different key styles, so we try a few common variants.
  factory MusicModel.fromJson(Map<String, dynamic> json) {
    // Defensive parsing helpers.
    String readString(dynamic v) => (v ?? '').toString();

    // Accept both int and string id values.
    int readInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse((v ?? '').toString()) ?? 0;
    }

    // Try multiple possible key names (snake_case / camelCase).
    final mp3 = json['mp3_url'] ?? json['mp3Url'] ?? json['mp3'] ?? '';
    final mp4 = json['mp4_url'] ?? json['mp4Url'] ?? json['mp4'] ?? '';

    return MusicModel(
      id: readInt(json['id']),
      title: readString(json['title']),
      artist: readString(json['artist']),
      lyrics: readString(json['lyrics']),
      mp3Url: readString(mp3),
      mp4Url: readString(mp4),
    );
  }
}
