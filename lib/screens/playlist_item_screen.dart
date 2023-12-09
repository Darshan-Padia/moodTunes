import 'package:flutter/material.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/models/playlist_item_model.dart';

class PlaylistItemScreen extends StatefulWidget {
  final String playlistId;

  PlaylistItemScreen({required this.playlistId});

  @override
  _PlaylistItemScreenState createState() => _PlaylistItemScreenState();
}

class _PlaylistItemScreenState extends State<PlaylistItemScreen> {
  late Future<PlaylistItemModel> playlistItems;

  @override
  void initState() {
    super.initState();
    playlistItems = SongApi().fetchPlaylistItems(widget.playlistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist Items'),
      ),
      body: Center(
        child: FutureBuilder<PlaylistItemModel>(
          future: playlistItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.tracks.isEmpty) {
              return Text('No playlist items available.');
            }

            // Display your playlist items here
            return ListView.builder(
              itemCount: snapshot.data!.tracks.length,
              itemBuilder: (context, index) {
                final track = snapshot.data!.tracks[index];
                final thumbnails = track['thumbnails'];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 40, // Adjust the radius for the image size
                    backgroundImage: thumbnails != null && thumbnails.isNotEmpty
                        ? NetworkImage(thumbnails[0]['url'].toString() ?? '')
                        : null,
                    backgroundColor: Colors.transparent,
                    child: thumbnails == null || thumbnails.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                              ),
                            ),
                          )
                        : null,
                  ),
                  title: Text(
                    track['title'] ?? 'Unknown Title',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                  subtitle: Text(
                    track['artists'][0]['name'] ?? 'Unknown Artist',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                  trailing: Text(
                    track['duration'] ?? 'Unknown Duration',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
