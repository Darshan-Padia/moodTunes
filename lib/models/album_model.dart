class AlbumModel {
  String category;
  String resultType;
  String title;
  String type;
  // String duration;
  String year;
  List<Map<String, dynamic>> artists;
  String browseId;
  bool isExplicit;
  List<Map<String, dynamic>> thumbnails;

  AlbumModel({
    required this.category,
    required this.resultType,
    required this.title,
    required this.type,
    // required this.duration,
    required this.year,
    required this.artists,
    required this.browseId,
    required this.isExplicit,
    required this.thumbnails,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      category: json['category'],
      resultType: json['resultType'],
      title: json['title'],
      type: json['type'],
      // duration: json['duration'],
      year: json['year'],
      artists: List<Map<String, dynamic>>.from(json['artists']),
      browseId: json['browseId'],
      isExplicit: json['isExplicit'],
      thumbnails: List<Map<String, dynamic>>.from(json['thumbnails']),
    );
  }
}
