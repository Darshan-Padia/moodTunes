class AlbumSongModel {
  final String title;
  final String type;
  final List<Map<String, dynamic>> thumbnails;
  final String description;
  final List<Map<String, dynamic>> artists;
  final String year;
  final int trackCount;
  final String duration;
  final String audioPlaylistId;
  final List<Map<String, dynamic>> tracks;
  final List<Map<String, dynamic>> otherVersions;
  final int durationSeconds;

  AlbumSongModel({
    required this.title,
    required this.type,
    required this.thumbnails,
    required this.description,
    required this.artists,
    required this.year,
    required this.trackCount,
    required this.duration,
    required this.audioPlaylistId,
    required this.tracks,
    required this.otherVersions,
    required this.durationSeconds,
  });

  factory AlbumSongModel.fromJson(Map<String, dynamic> json) {
    return AlbumSongModel(
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      thumbnails: List<Map<String, dynamic>>.from(json['thumbnails'] ?? []),
      description: json['description'] ?? '',
      artists: List<Map<String, dynamic>>.from(json['artists'] ?? []),
      year: json['year'] ?? '',
      trackCount: json['trackCount'] ?? 0,
      duration: json['duration'] ?? '',
      audioPlaylistId: json['audioPlaylistId'] ?? '',
      tracks: List<Map<String, dynamic>>.from(json['tracks'] ?? []),
      otherVersions:
          List<Map<String, dynamic>>.from(json['otherVersions'] ?? []),
      durationSeconds: json['duration_seconds'] ?? 0,
    );
  }
}
