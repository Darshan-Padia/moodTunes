import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/firebase_firestore_db.dart';
import 'package:mood_tunes/models/song_detail_model.dart';
import 'package:mood_tunes/models/song_model.dart';

class SongItemCard extends StatelessWidget {
  final String userId;
  final String playlistId;
  final String playlistName;
  final SongDetail song;
  final Function()?
      onOptionsPressed; // Add an optional function for more options
  final Function()? onTap; // Add an optional function for more options

  SongItemCard({
    required this.userId,
    required this.playlistId,
    required this.playlistName,
    required this.song,
    this.onOptionsPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          song.image.isNotEmpty ? song.image[0].link : 'placeholder_url',
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        song.name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        song.primaryArtists.isNotEmpty ? song.primaryArtists : 'Unknown Artist',
        style: TextStyle(color: Colors.white70),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // GestureDetector(
          //   onTap: () {
          //     // Handle like button tap
          //     if (song.isLiked.value == true) {
          //       FirebaseDb().removeLikedSong(userId, song.videoId);
          //       FirebaseDb()
          //           .updateIsLiked(userId, playlistId, song.videoId, false);
          //       FirebaseDb().removeLikedSongVideoIds(userId, song.videoId);
          //     } else {
          //       FirebaseDb().addOrUpdateLikedSong(userId, song);
          //       FirebaseDb()
          //           .updateIsLiked(userId, playlistId, song.videoId, true);
          //       FirebaseDb().addOrUpdateLikedSongVideoIds(userId, song);
          //     }
          //   },
          //   child: Obx(
          //     () => Icon(
          //       song.isLiked.value ? Icons.favorite : Icons.favorite_border,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          SizedBox(width: 16.0),
          if (onOptionsPressed != null)
            GestureDetector(
              onTap: onOptionsPressed,
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
