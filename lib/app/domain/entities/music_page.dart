import 'music.dart';

// Domain entity representing a paginated music response.
class MusicPage {
  const MusicPage({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<Music> items;
  final int page;
  final int limit;
  final int total;

  bool get hasMore => (page * limit) < total;
}
