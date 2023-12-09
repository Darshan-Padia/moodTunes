class SaavnApiResponse {
  String status;
  // String message;
  SaavnApiData data;

  SaavnApiResponse({required this.status, required this.data});

  factory SaavnApiResponse.fromJson(Map<String, dynamic> json) {
    return SaavnApiResponse(
      status: json['status'],
      // message: json['message'],
      data: SaavnApiData.fromJson(json['data']),
    );
  }
}

class SaavnApiData {
  List<SaavnAlbum> albums;

  SaavnApiData({required this.albums});

  factory SaavnApiData.fromJson(Map<String, dynamic> json) {
    var albumList = json['albums'] as List;
    List<SaavnAlbum> albumsList =
        albumList.map((album) => SaavnAlbum.fromJson(album)).toList();

    return SaavnApiData(albums: albumsList);
  }
}

class SaavnAlbum {
  String id;
  String name;
  String year;
  String type;
  String playCount;
  String language;
  String explicitContent;
  // String songCount;
  String url;
  List<SaavnArtist> artists;
  List<SaavnImage> images;

  SaavnAlbum({
    required this.id,
    required this.name,
    required this.year,
    required this.type,
    required this.playCount,
    required this.language,
    required this.explicitContent,
    // required this.songCount,
    required this.url,
    required this.artists,
    required this.images,
  });

  factory SaavnAlbum.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List;
    List<SaavnArtist> artistsList =
        artistList.map((artist) => SaavnArtist.fromJson(artist)).toList();

    var imageList = json['image'] as List;
    List<SaavnImage> imagesList =
        imageList.map((image) => SaavnImage.fromJson(image)).toList();

    return SaavnAlbum(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      type: json['type'],
      playCount: json['playCount'],
      language: json['language'],
      explicitContent: json['explicitContent'],
      // songCount: json['songCount'],
      url: json['url'],
      artists: artistsList,
      images: imagesList,
    );
  }
}

class SaavnArtist {
  String id;
  String name;
  String url;
  // bool image;
  String type;
  String role;

  SaavnArtist({
    required this.id,
    required this.name,
    required this.url,
    // required this.image,
    required this.type,
    required this.role,
  });

  factory SaavnArtist.fromJson(Map<String, dynamic> json) {
    return SaavnArtist(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      // image: json['image'],
      type: json['type'],
      role: json['role'],
    );
  }
}

class SaavnImage {
  String quality;
  String link;

  SaavnImage({required this.quality, required this.link});

  factory SaavnImage.fromJson(Map<String, dynamic> json) {
    return SaavnImage(
      quality: json['quality'],
      link: json['link'],
    );
  }
}
