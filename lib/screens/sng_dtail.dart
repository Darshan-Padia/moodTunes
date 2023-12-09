import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/firebase_firestore_db.dart';
import 'package:mood_tunes/models/savn_search.dart';
import 'package:mood_tunes/screens/main2_savn.dart';
import 'package:mood_tunes/screens/savn_music.dart';

class SongDetailsScreen extends StatelessWidget {
  final List<Songg> songs; // Assuming you have a list of Song objects

  SongDetailsScreen({required this.songs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Song Details',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          Songg song = songs[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  song.image[0]['link']), // Assuming image is a list of maps
            ),
            title: Text(
              song.name,
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            subtitle: Text(
              '${song.primaryArtists}',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            // trailing: InkWell(
            //   child: IconButton(
            //     onPressed: () {
            //       _showOptionsDialog(song);
            //     },
            //     icon: Icon(
            //       Icons.more_vert_outlined,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // trailing: Text(
            //     '${(song.duration / 60).floor()}:${(song.duration % 60).toInt()}'),
            onTap: () {
              // Handle song tap if needed
              Get.to(MainSongScreen2(
                songurl: song.downloadUrl,
                songthumb: song.image[2]['link'],
                songname: song.name,
                // songalbum: 'so',
              ));
            },
          );
        },
      ),
    );
  }

  // void _showOptionsDialog(Song songModel) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Options'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               leading: Icon(Icons.playlist_add),
  //               title: Text('Add to Playlist'),
  //               onTap: () {
  //                 Navigator.pop(context); // Close the dialog
  //                 _addToPlaylist(songModel);
  //               },
  //             ),
  //             ListTile(
  //               leading: Icon(Icons.download),
  //               title: Text('Download Song'),
  //               onTap: () {
  //                 Navigator.pop(context); // Close the dialog
  //                 showDialog(
  //                     context: context,
  //                     builder: (context) => DownloadingDialog(
  //                           url: songModel.downloadUrls[2].link,
  //                           fileName: songModel.name,
  //                         ));
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showSnackbar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }

  // Future<String?> _showCreatePlaylistDialog() async {
  //   TextEditingController playlistNameController = TextEditingController();

  //   return showDialog<String>(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Create New Playlist'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Enter the name for the new playlist:'),
  //             SizedBox(height: 8.0),
  //             TextField(
  //               controller: playlistNameController,
  //               decoration: InputDecoration(
  //                 border: OutlineInputBorder(),
  //                 hintText: 'Playlist Name',
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () =>
  //                 Navigator.pop(context, playlistNameController.text),
  //             child: Text('Create'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _addToPlaylist(Song songModel) async {
  //   // Fetch and store the current user ID
  //   User user = FirebaseAuth.instance.currentUser!;
  //   String userId = user.uid;

  //   // Fetch existing playlists using the stream
  //   List<Map<String, String>> playlists =
  //       await FirebaseDb().getPlaylistsStream(userId).first;

  //   // Show a dialog to choose or create a playlist
  //   String? chosenPlaylistId = await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Add to Playlist'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Choose a playlist or create a new one:'),
  //             SizedBox(height: 16.0),
  //             ...playlists.map((playlist) {
  //               return ListTile(
  //                 title: Text(playlist['name'] ?? ''),
  //                 onTap: () {
  //                   Navigator.pop(
  //                       context, playlist['id']); // Return chosen playlist ID
  //                 },
  //               );
  //             }).toList(),
  //             SizedBox(height: 16.0),
  //             ListTile(
  //               title: Text('Create New Playlist'),
  //               onTap: () {
  //                 Navigator.pop(
  //                     context, ''); // Return an empty string for a new playlist
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );

  //   if (chosenPlaylistId != null && chosenPlaylistId.isNotEmpty) {
  //     // Add to the chosen playlist

  //     FirebaseDb().addToPlaylist(userId, chosenPlaylistId, songModel);
  //     _showSnackbar(
  //         'Added to playlist: ${playlists.firstWhere((p) => p['id'] == chosenPlaylistId)['name']}');
  //     // _sendPushNotification(
  //     //   playlists.firstWhere((p) => p['id'] == chosenPlaylistId)['name'],
  //     //   songModel.name,
  //     // );
  //   } else {
  //     // Handle creating a new playlist (prompt the user for a new playlist name)
  //     String? newPlaylistName = await _showCreatePlaylistDialog();
  //     if (newPlaylistName != null && newPlaylistName.isNotEmpty) {
  //       String newPlaylistId =
  //           await FirebaseDb().createPlaylist(userId, newPlaylistName);
  //       FirebaseDb().addToPlaylist(userId, newPlaylistId, songModel);
  //       _showSnackbar('Added to new playlist: $newPlaylistName');
  //       // _sendPushNotification(
  //       //   newPlaylistName!,
  //       //   songModel.name,
  //       // );
  //     }
  //   }
  // }
}

class Songg {
  final String id;
  final String name;
  final String duration;
  final List<dynamic> image;
  final String primaryArtists;
  final List<dynamic> downloadUrl;

  // final int year;

  Songg(
      {required this.id,
      required this.name,
      required this.duration,
      required this.image,
      required this.primaryArtists,
      required this.downloadUrl
      // required this.year,
      });

  // You may need a fromJson method for mapping JSON to Song objects
  factory Songg.fromJson(Map<String, dynamic> json) {
    // Implement your logic here
    return Songg(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      image: json['image'],

      primaryArtists: json['primaryArtists'],
      downloadUrl: json['downloadUrl'],
      // year: json['year'],
    );
  }
}
