class Song {
  final String id;
  final String name;
  final String year;
  final String duration;
  final String primaryArtists;
  final String language;
  final String url;
  final Album album;
  final List<Thumbnail> images;
  final List<DownloadUrl> downloadUrls;

  Song(
      {required this.id,
      required this.name,
      required this.year,
      required this.duration,
      required this.primaryArtists,
      required this.language,
      required this.url,
      required this.album,
      required this.images,
      required this.downloadUrls});

  factory Song.fromJson(Map<String, dynamic> json) {
    // if poresent then only parse album other wise null
    Album album =
        Album.fromJson(json['album'] ?? {'id': '', 'name': '', 'url': ''});

    List<Thumbnail> images = [];
    for (var imageData in json['image']) {
      images.add(Thumbnail.fromJson(imageData));
    }

    List<DownloadUrl> downloadUrls = [];
    for (var downloadUrlData in json['downloadUrl']) {
      downloadUrls.add(DownloadUrl.fromJson(downloadUrlData));
    }

    return Song(
        id: json['id'],
        name: json['name'],
        year: json['year'],
        duration: json['duration'],
        primaryArtists: json['primaryArtists'],
        language: json['language'],
        url: json['url'],
        album: album,
        images: images,
        downloadUrls: downloadUrls);
  }
}

class Album {
  final String id;
  final String name;
  final String url;

  Album({required this.id, required this.name, required this.url});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], name: json['name'], url: json['url']);
  }
}

class Thumbnail {
  final String quality;
  final String link;

  Thumbnail({
    required this.quality,
    required this.link,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      quality: json['quality'],
      link: json['link'],
    );
  }
}

class DownloadUrl {
  final String quality;
  final String link;

  DownloadUrl({
    required this.quality,
    required this.link,
  });

  factory DownloadUrl.fromJson(Map<String, dynamic> json) {
    return DownloadUrl(
      quality: json['quality'],
      link: json['link'],
    );
  }
}
