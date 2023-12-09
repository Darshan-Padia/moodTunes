class PlaylistModel {
  final String id;
  final String name;

  PlaylistModel({
    required this.id,
    required this.name,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }
}
