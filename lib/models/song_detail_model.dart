class SongDetail {
  String id;
  String name;
  Album_song_detail album;
  String year;
  String releaseDate;
  String duration;
  String label;
  String primaryArtists;
  String primaryArtistsId;
  String featuredArtists;
  String featuredArtistsId;
  int explicitContent;
  int playCount;
  String language;
  String hasLyrics;
  String url;
  String copyright;
  List<ImageDetail> image;
  List<DownloadUrl_song_detail> downloadUrl;

  SongDetail({
    required this.id,
    required this.name,
    required this.album,
    required this.year,
    required this.releaseDate,
    required this.duration,
    required this.label,
    required this.primaryArtists,
    required this.primaryArtistsId,
    required this.featuredArtists,
    required this.featuredArtistsId,
    required this.explicitContent,
    required this.playCount,
    required this.language,
    required this.hasLyrics,
    required this.url,
    required this.copyright,
    required this.image,
    required this.downloadUrl,
  });
}

class Album_song_detail {
  String id;
  String name;
  String url;

  Album_song_detail({
    required this.id,
    required this.name,
    required this.url,
  });
}

class ImageDetail {
  String quality;
  String link;

  ImageDetail({
    required this.quality,
    required this.link,
  });
}

class DownloadUrl_song_detail {
  String quality;
  String link;

  DownloadUrl_song_detail({
    required this.quality,
    required this.link,
  });
}
