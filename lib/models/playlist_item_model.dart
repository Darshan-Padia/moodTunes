class PlaylistItemModel {
  final String id;
  final String privacy;
  final String title;
  final List<Map<String, dynamic>> thumbnails;
  final String description;
  final Map<String, dynamic> author;
  final String year;
  final String duration;
  final int trackCount;
  final List<Map<String, dynamic>> tracks;

  PlaylistItemModel({
    required this.id,
    required this.privacy,
    required this.title,
    required this.thumbnails,
    required this.description,
    required this.author,
    required this.year,
    required this.duration,
    required this.trackCount,
    required this.tracks,
  });

  factory PlaylistItemModel.fromJson(Map<String, dynamic> json) {
    return PlaylistItemModel(
      id: json['id'],
      privacy: json['privacy'],
      title: json['title'],
      thumbnails: List<Map<String, dynamic>>.from(json['thumbnails']),
      description: json['description'],
      author: json['author'],
      year: json['year'],
      duration: json['duration'],
      trackCount: json['trackCount'],
      tracks: List<Map<String, dynamic>>.from(json['tracks']),
    );
  }
}
