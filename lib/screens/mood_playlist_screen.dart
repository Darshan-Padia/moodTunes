import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/models/mood_playlist_model.dart';
import 'package:mood_tunes/screens/album_song_screen.dart';
import 'package:mood_tunes/screens/playlist_item_screen.dart';

class MoodPlaylistScreen extends StatefulWidget {
  final String moodTitle;

  MoodPlaylistScreen({required this.moodTitle});

  @override
  _MoodPlaylistScreenState createState() => _MoodPlaylistScreenState();
}

class _MoodPlaylistScreenState extends State<MoodPlaylistScreen> {
  late Future<List<MoodPlaylistModel>> _moodPlaylists;
  SongApi songApi = SongApi();

  @override
  void initState() {
    super.initState();
    _moodPlaylists = SongApi().fetchMoodPlaylists(widget.moodTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists for ${widget.moodTitle}'),
      ),
      body: FutureBuilder<List<MoodPlaylistModel>>(
        future: _moodPlaylists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            );
          } else {
            MoodPlaylistModel firstPlaylist = snapshot.data!.isNotEmpty
                ? snapshot.data![0]
                : MoodPlaylistModel(
                    title: '',
                    playlistId: '',
                    thumbnails: [],
                    description: '',
                  );

            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(firstPlaylist.thumbnails.isNotEmpty
                          ? firstPlaylist.thumbnails[0]
                          : ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Text(
                          widget.moodTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      MoodPlaylistModel playlist = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              playlist.thumbnails.isNotEmpty
                                  ? playlist.thumbnails[0]
                                  : ''),
                          radius: 25,
                        ),
                        title: Text(
                          playlist.title,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          playlist.description,
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          // Handle playlist item tap
                          // getting brwoseId from playlsitId
                          Get.to(() => PlaylistItemScreen(
                              playlistId: playlist.playlistId));
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
