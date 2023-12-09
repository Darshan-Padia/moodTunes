class SaavnAlbum {
  final String status;
  final String message;
  final SaavnData data;

  SaavnAlbum({required this.status, required this.message, required this.data});

  factory SaavnAlbum.fromJson(Map<String, dynamic> json) {
    return SaavnAlbum(
      status: json['status'],
      message: json['message'],
      data: SaavnData.fromJson(json['data']),
    );
  }
}

class SaavnData {
  final String id;
  final String name;
  final String year;
  final String releaseDate;
  final String songCount;
  final String url;
  final String primaryArtistsId;
  final String primaryArtists;
  final List<SaavnImage> image;
  final List<SaavnSong> songs;

  SaavnData({
    required this.id,
    required this.name,
    required this.year,
    required this.releaseDate,
    required this.songCount,
    required this.url,
    required this.primaryArtistsId,
    required this.primaryArtists,
    required this.image,
    required this.songs,
  });

  factory SaavnData.fromJson(Map<String, dynamic> json) {
    return SaavnData(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      releaseDate: json['releaseDate'],
      songCount: json['songCount'],
      url: json['url'],
      primaryArtistsId: json['primaryArtistsId'],
      primaryArtists: json['primaryArtists'],
      image: List<SaavnImage>.from(
          json['image'].map((x) => SaavnImage.fromJson(x))),
      songs:
          List<SaavnSong>.from(json['songs'].map((x) => SaavnSong.fromJson(x))),
    );
  }
}

class SaavnImage {
  final String quality;
  final String link;

  SaavnImage({required this.quality, required this.link});

  factory SaavnImage.fromJson(Map<String, dynamic> json) {
    return SaavnImage(
      quality: json['quality'],
      link: json['link'],
    );
  }
}

class SaavnSong {
  final String id;
  final String name;
  final SaavnAlbum album;
  final String year;
  final String releaseDate;
  final String duration;
  final String label;
  final String primaryArtists;
  final String primaryArtistsId;
  final String explicitContent;
  final String playCount;
  final String language;
  final bool hasLyrics;
  final String url;
  final String copyright;
  final List<SaavnImage> image;
  final List<SaavnDownloadUrl> downloadUrl;

  SaavnSong({
    required this.id,
    required this.name,
    required this.album,
    required this.year,
    required this.releaseDate,
    required this.duration,
    required this.label,
    required this.primaryArtists,
    required this.primaryArtistsId,
    required this.explicitContent,
    required this.playCount,
    required this.language,
    required this.hasLyrics,
    required this.url,
    required this.copyright,
    required this.image,
    required this.downloadUrl,
  });

  factory SaavnSong.fromJson(Map<String, dynamic> json) {
    return SaavnSong(
      id: json['id'],
      name: json['name'],
      album: SaavnAlbum.fromJson(json['album']),
      year: json['year'],
      releaseDate: json['releaseDate'],
      duration: json['duration'],
      label: json['label'],
      primaryArtists: json['primaryArtists'],
      primaryArtistsId: json['primaryArtistsId'],
      explicitContent: json['explicitContent'],
      playCount: json['playCount'],
      language: json['language'],
      hasLyrics: json['hasLyrics'],
      url: json['url'],
      copyright: json['copyright'],
      image: List<SaavnImage>.from(
          json['image'].map((x) => SaavnImage.fromJson(x))),
      downloadUrl: List<SaavnDownloadUrl>.from(
          json['downloadUrl'].map((x) => SaavnDownloadUrl.fromJson(x))),
    );
  }
}

class SaavnDownloadUrl {
  final String quality;
  final String link;

  SaavnDownloadUrl({required this.quality, required this.link});

  factory SaavnDownloadUrl.fromJson(Map<String, dynamic> json) {
    return SaavnDownloadUrl(
      quality: json['quality'],
      link: json['link'],
    );
  }
}
