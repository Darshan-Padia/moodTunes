class MoodPlaylistModel {
  final String title;
  final String playlistId;
  final List<String> thumbnails;
  final String description;

  MoodPlaylistModel({
    required this.title,
    required this.playlistId,
    required this.thumbnails,
    required this.description,
  });

  factory MoodPlaylistModel.fromJson(Map<String, dynamic> json) {
    // Extract thumbnails from the first entry
    // List<String> thumbnails = json['thumbnails'][0]['url'];
    List<String> thumbnails = (json['thumbnails'] as List)
        .map((thumbnail) => thumbnail['url'].toString())
        .toList();

    return MoodPlaylistModel(
      title: json['title'],
      playlistId: json['playlistId'],
      thumbnails: thumbnails,
      description: json['description'],
    );
  }
}
