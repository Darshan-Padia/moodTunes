import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mood_tunes/models/album_savn.dart';
import 'package:mood_tunes/models/homepage_savn.dart';
import 'package:mood_tunes/models/mood_playlist_model.dart';
import 'package:mood_tunes/models/playlist_item_model.dart';
import 'package:mood_tunes/models/savn_search.dart';
import 'package:mood_tunes/models/song_detail_model.dart';

class SongApi {
  List<dynamic> musicData = [];
  String baseUrl = 'http://192.168.116.35:5000';
  Future<List<dynamic>> fetchSearchResults(String searchString) async {
    String api_url = '${baseUrl}/get_music';
    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'search_term': searchString}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      musicData = json.decode(response.body);
      // print(musicData);
      return musicData;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  final String baseUrlapi = "https://saavn.me/search/songs";

  Future<List<Song>> searchSongs(String query, int page, int limit) async {
    final response = await http.get(
      Uri.parse('$baseUrlapi?query=$query&page=$page&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Song> songs = [];

      for (var songData in jsonData['data']['results']) {
        songs.add(Song.fromJson(songData));
      }

      return songs;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  // saavn
  // Future<List<Song>> fetchSaavnAlbumDetails(String albumId) async {
  //   final response =
  //       await http.get(Uri.parse('https://saavn.me/albums?id=$albumId'));

  //   if (response.statusCode == 200) {
  //     // If the server returns a 200 OK response, parse the JSON
  //     Map<String, dynamic> jsonData = json.decode(response.body);
  //     // getting data
  //     List<dynamic> dataField = jsonData['data']['songs'];
  //     // Map<String, dynamic> jsonDatas = json.decode(dataField['songs']);
  //     // print(jsonDatas);
  //     // Map<String, dynamic> song = jsonData['songs'];
  //     // print(song);

  //     print(dataField);
  //     // print(song);
  //     List<Map<String, dynamic>> jsonDataList =
  //         List<Map<String, dynamic>>.from(jsonDecode(dataField as String));

  //     // Map each JSON object to a Song object
  //     List<Song> songs =
  //         jsonDataList.map((json) => Song.fromJson(json)).toList();
  //     return songs;
  //   } else {
  //     // If the server did not return a 200 OK response, throw an exception.
  //     throw Exception('Failed to load album details');
  //   }
  // }
  Future<List<dynamic>> fetchSaavnAlbumDetails(String albumId) async {
    final response =
        await http.get(Uri.parse('https://saavn.me/albums?id=$albumId'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> jsonData = json.decode(response.body);
      // getting data
      List<dynamic> dataField = jsonData['data']['songs'];
      // Map<String, dynamic> jsonDatas = json.decode(dataField['songs']);
      // print(jsonDatas);
      // Map<String, dynamic> song = jsonData['songs'];
      // print(song);

      print(dataField);
      // print(song);
      // List<Map<String, dynamic>> jsonDataList =
      //     List<Map<String, dynamic>>.from(jsonDecode(dataField as String));

      // // Map each JSON object to a Song object
      // List<Song> songs =
      //     jsonDataList.map((json) => Song.fromJson(json)).toList();
      return dataField;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load album details');
    }
  }

  Future<SaavnApiResponse> fetchSaavnData() async {
    Uri uri = Uri.parse('https://saavn.me/modules?language=hindi,english');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return SaavnApiResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  // for albums
  Future<List<dynamic>> fetchAlbumResults(String searchString) async {
    String api_url = '${baseUrl}/get_albums';
    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'search_term': searchString}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      musicData = json.decode(response.body);
      // print(musicData);
      return musicData;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  Future<List<SongDetail>> fetchSongDetails(List<String> songIds) async {
    Uri uri = Uri.parse('https://saavn.me/songs?id=${songIds.join(',')}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> songsData = data['data'];

      List<SongDetail> songs = songsData
          .map((songData) => SongDetail(
                id: songData['id'],
                name: songData['name'],
                album: Album_song_detail(
                  id: songData['album']['id'],
                  name: songData['album']['name'],
                  url: songData['album']['url'],
                ),
                year: songData['year'],
                releaseDate: songData['releaseDate'],
                duration: songData['duration'],
                label: songData['label'],
                primaryArtists: songData['primaryArtists'],
                primaryArtistsId: songData['primaryArtistsId'],
                featuredArtists: songData['featuredArtists'],
                featuredArtistsId: songData['featuredArtistsId'],
                explicitContent: songData['explicitContent'],
                playCount: songData['playCount'],
                language: songData['language'],
                hasLyrics: songData['hasLyrics'],
                url: songData['url'],
                copyright: songData['copyright'],
                image: (songData['image'] as List<dynamic>)
                    .map((imageData) => ImageDetail(
                          quality: imageData['quality'],
                          link: imageData['link'],
                        ))
                    .toList(),
                downloadUrl: (songData['downloadUrl'] as List<dynamic>)
                    .map((downloadData) => DownloadUrl_song_detail(
                          quality: downloadData['quality'],
                          link: downloadData['link'],
                        ))
                    .toList(),
              ))
          .toList();

      return songs;
    } else {
      throw Exception('Failed to load song details');
    }
  }

  // get songs from album

  /*
  backend funtion :
  # get songs in an album
@app.route('/get_songs_from_album', methods=['POST'])
def get_songs_from_album():
    data = request.get_json()
    browse_id = data['browse_id']
    data = yt.get_album(browse_id)
    print(data)
    return jsonify(data)
  */

  /*
  // api response format recieved  from get_songs_from_album()
  {
  "title": "The Marshall Mathers LP",
  "type": "Album",
  "thumbnails": [
    {
      "url": "https://lh3.googleusercontent.com/O-SeXg61tYo15uWSBzWPVoUlBx2mQAioidlHq3y-AurmaQZI2Vso7BJoGeDNAm2g6HquAq1z4g-1EBI=w60-h60-l90-rj",
      "width": 60,
      "height": 60
    },
    {
      "url": "https://lh3.googleusercontent.com/O-SeXg61tYo15uWSBzWPVoUlBx2mQAioidlHq3y-AurmaQZI2Vso7BJoGeDNAm2g6HquAq1z4g-1EBI=w120-h120-l90-rj",
      "width": 120,
      "height": 120
    },
    {
      "url": "https://lh3.googleusercontent.com/O-SeXg61tYo15uWSBzWPVoUlBx2mQAioidlHq3y-AurmaQZI2Vso7BJoGeDNAm2g6HquAq1z4g-1EBI=w226-h226-l90-rj",
      "width": 226,
      "height": 226
    },
    {
      "url": "https://lh3.googleusercontent.com/O-SeXg61tYo15uWSBzWPVoUlBx2mQAioidlHq3y-AurmaQZI2Vso7BJoGeDNAm2g6HquAq1z4g-1EBI=w544-h544-l90-rj",
      "width": 544,
      "height": 544
    }
  ],
  "description": "The Marshall Mathers LP is the third studio album by American rapper Eminem, released on May 23, 2000, by Aftermath Entertainment and Interscope Records. The album was produced mostly by Dr. Dre and Eminem, along with the 45 King, the Bass Brothers, and Mel-Man. Recorded over a two-month period in several studios around Detroit, the album features more introspective lyricism, including Eminem's thoughts on his rise from rags to riches, the criticism of his music, and his estrangement from his family and wife. A transgressive work, it incorporates horrorcore and hardcore hip hop, while also featuring satirical songs. The album includes samples or appearances by Dido, RBX, Sticky Fingaz, Bizarre, Snoop Dogg, Xzibit, Nate Dogg, and D12.\nLike its predecessor, The Marshall Mathers LP was surrounded by significant controversy upon its release, while also propelling Eminem to the forefront of American pop culture. Criticism centered on lyrics that were considered violent, homophobic, and misogynistic, as well as a reference to the Columbine High School massacre.\n\nFrom Wikipedia (https://en.wikipedia.org/wiki/The_Marshall_Mathers_LP) under Creative Commons Attribution CC-BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/legalcode)",
  "artists": [
    {
      "name": "Eminem",
      "id": "UCedvOgsKFzcK3hA5taf3KoQ"
    }
  ],
  "year": "2000",
  "trackCount": 18,
  "duration": "1 hour, 12 minutes",
  "audioPlaylistId": "OLAK5uy_lD5szk37WYrgQwlKKDQt6FfYgP9T_bgEg",
  "tracks": [
    {
      "videoId": "0NmsogZClfM",
      "title": "Public Service Announcement 2000",
      "artists": [
        {
          "name": "Eminem",
          "id": "UCedvOgsKFzcK3hA5taf3KoQ"
        }
      ],
      "album": "The Marshall Mathers LP",
      "likeStatus": "INDIFFERENT",
      "inLibrary": false,
      "thumbnails": null,
      "isAvailable": true,
      "isExplicit": true,
      "videoType": "MUSIC_VIDEO_TYPE_ATV",
      "duration": "0:28",
      "duration_seconds": 28,
      "feedbackTokens": {
        "add": "AB9zfpL5I2BxhsP8L7GGlmaZnGr1WDh3xcoZJQ-ffSR3C2pC6iapg55gjeoKkofQycdMj6jOFTP67TbDM59ccssrBzWDBFTDVw",
        "remove": "AB9zfpIXAbqkRwtLKF03LyEMGq6zEIyu392bKQuqJp6RbrQ4OM45D1FpKfjWda1tsNiNB3cTCgO2jNtf0ZowM5sNYarOHlIaYw"
      }
    },
    // ... (repeat for other tracks)
  ],
  "other_versions": [
    {
      "title": "The Marshall Mathers",
      "year": "Eminem",
      "browseId": "MPREb_oEb8m0Q0dMp",
      "thumbnails": [
        {
          "url": "https://lh3.googleusercontent.com/6pcEou_MeEaXQaTBpENV1a-_va7DjxquZW4ZtNVvxvtgr3GkfjhBskFTb6-eCotYN2rPiQSu1726f_Yc=w226-h226-s-l90-rj",
          "width": 226,
          "height": 226
        },
        {
          "url": "https://lh3.googleusercontent.com/6pcEou_MeEaXQaTBpENV1a-_va7DjxquZW4ZtNVvxvtgr3GkfjhBskFTb6-eCotYN2rPiQSu1726f_Yc=w544-h544-s-l90-rj",
          "width": 544,
          "height": 544
        }
      ],
      "isExplicit": false
    }
  ],
  "duration_seconds": 4345
}


  */

  // chatgpt write me a function for getting songs from album
  // get songs from album
  Future<Map<String, dynamic>> fetchAlbumData(String browseId) async {
    String api_url = '${baseUrl}/get_songs_from_album';
    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'browse_id': browseId}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      Map<String, dynamic> albumData = json.decode(response.body);
      // List<dynamic> songs = albumData['tracks'] ?? [];
      print('\naaaaaaaaaaaaaaallllllllllllllll\n');
      print(albumData);
      return albumData;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  /*
 # getting mood categories playlists get_mood_playlists
@app.route('/get_mood_playlists', methods=['POST'])
def get_mood_playlists():
    data = request.get_json()
    mood_category = data['mood_category']
    data = yt.get_mood_playlists(mood_categories[mood_category])
    print(data)
    return jsonify(data)

  */
  // writing a function for getting mood categories playlists
  Future<List<MoodPlaylistModel>> fetchMoodPlaylists(
      String moodCategory) async {
    String api_url = '${baseUrl}/get_mood_playlists';

    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'mood_category': moodCategory}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      List<dynamic> moodPlaylistsData = json.decode(response.body);
      // List<dynamic> songs = albumData['tracks'] ?? [];
      print('\respbody\n');
      print(response.body);
      List<MoodPlaylistModel> moodPlaylists = moodPlaylistsData
          .map((playlistData) => MoodPlaylistModel.fromJson(playlistData))
          .toList();
      return moodPlaylists;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  /*
  # YTMusic.get_album_browse_id
@app.route('/get_album_browse_id', methods=['POST'])
def get_album_browse_id():
    data = request.get_json()
    search_term = data['search_term']
    data = yt.get_album_browse_id(search_term)
    print(data)
    return jsonify(data)


  */
  // writing a function for getting album browse id
  Future<String> fetchAlbumBrowseId(String albumName) async {
    String api_url = '${baseUrl}/get_album_browse_id';

    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'search_term': albumName}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      String albumBrowseId = json.decode(response.body);
      // List<dynamic> songs = albumData['tracks'] ?? [];
      print('\nalbumBrowseId\n');
      print(albumBrowseId);
      return albumBrowseId;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }
  /*# YTMusic.get_playlist(playlistId: str, limit: int = 100, related: bool = False, suggestions_limit: int = 0)→ Dict
@app.route('/get_playlist_items', methods=['POST'])
def get_playlist_items():
    data = request.get_json()
    playlist_id = data['playlist_id']
    data = yt.get_playlist(playlist_id)
    print(data)
    return jsonify(data) */

  // writing a function for getting playlist items
  Future<PlaylistItemModel> fetchPlaylistItems(String playlistId) async {
    String api_url = '${baseUrl}/get_playlist_items';
    final response = await http.post(
      Uri.parse(api_url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'playlist_id': playlistId}),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the data
      Map<String, dynamic> playlistItemsData = json.decode(response.body);
      PlaylistItemModel playlistItems =
          PlaylistItemModel.fromJson(playlistItemsData);
      print('\nPlaylist Items\n');
      print(playlistItems);
      return playlistItems;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }
}
